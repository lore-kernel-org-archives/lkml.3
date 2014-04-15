Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaDOLdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 07:33:08 -0400
Received: from relay.parallels.com ([195.214.232.42]:55112 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbaDOLdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 07:33:05 -0400
Subject: [PATCH 7/7] fuse: flush ctime in FUSE_FORGET requests
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Tue, 15 Apr 2014 15:33:04 +0400
Message-ID: <20140415113223.11860.66322.stgit@dhcp-10-30-30-94.sw.ru>
In-Reply-To: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
References: <20140415112413.11860.1451.stgit@dhcp-10-30-30-94.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some inode operations (e.g., rename) operate directly on inodes and dentries
without opened files involved. This means that even though fuse set
inode->i_ctime and FUSE_I_CTIME_DIRTY properly, a corresponding flush operation
will never happen (i.e. no fsync or close to call fuse_flush_cmtime()).

The patch solves the problem by passing local ctime to the userspace server
inside forget requests.

Signed-off-by: Maxim Patlasov <MPatlasov@parallels.com>
---
 fs/fuse/dev.c             |   30 +++++++++++++++++++++++-------
 fs/fuse/fuse_i.h          |    2 +-
 fs/fuse/inode.c           |    6 ++++++
 include/uapi/linux/fuse.h |   18 ++++++++++++++++++
 4 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index aac71ce..97c7749 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -578,17 +578,25 @@ void fuse_request_send_background_locked(struct fuse_conn *fc,
 void fuse_force_forget(struct file *file, u64 nodeid)
 {
 	struct inode *inode = file_inode(file);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_req *req;
-	struct fuse_forget_in inarg;
+	struct fuse_forget_in_ext inarg;
+	int inarg_size = fc->minor >= 24 ?
+		sizeof(inarg) : sizeof(struct fuse_forget_in);
 
 	memset(&inarg, 0, sizeof(inarg));
 	inarg.nlookup = 1;
+	if (test_bit(FUSE_I_CTIME_DIRTY, &fi->state)) {
+		inarg.forget_flags = FUSE_FORGET_CTIME_SET;
+		inarg.ctime = inode->i_ctime.tv_sec;
+		inarg.ctimensec = inode->i_ctime.tv_nsec;
+	}
 	req = fuse_get_req_nofail_nopages(fc, file);
 	req->in.h.opcode = FUSE_FORGET;
 	req->in.h.nodeid = nodeid;
 	req->in.numargs = 1;
-	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].size = inarg_size;
 	req->in.args[0].value = &inarg;
 	req->isreply = 0;
 	__fuse_request_send(fc, req);
@@ -1102,14 +1110,19 @@ __releases(fc->lock)
 {
 	int err;
 	struct fuse_forget_link *forget = dequeue_forget(fc, 1, NULL);
-	struct fuse_forget_in arg = {
+	struct fuse_forget_in_ext arg = {
 		.nlookup = forget->forget_one.nlookup,
+		.ctime = forget->forget_one.ctime,
+		.ctimensec = forget->forget_one.ctimensec,
+		.forget_flags = forget->forget_one.forget_flags,
 	};
+	int arg_size = fc->minor >= 24 ?
+		sizeof(arg) : sizeof(struct fuse_forget_in);
 	struct fuse_in_header ih = {
 		.opcode = FUSE_FORGET,
 		.nodeid = forget->forget_one.nodeid,
 		.unique = fuse_get_unique(fc),
-		.len = sizeof(ih) + sizeof(arg),
+		.len = sizeof(ih) + arg_size,
 	};
 
 	spin_unlock(&fc->lock);
@@ -1142,18 +1155,21 @@ __releases(fc->lock)
 		.unique = fuse_get_unique(fc),
 		.len = sizeof(ih) + sizeof(arg),
 	};
+	int forget_one_size = fc->minor >= 24 ?
+		sizeof(struct fuse_forget_one_ext) :
+		sizeof(struct fuse_forget_one);
 
 	if (nbytes < ih.len) {
 		spin_unlock(&fc->lock);
 		return -EINVAL;
 	}
 
-	max_forgets = (nbytes - ih.len) / sizeof(struct fuse_forget_one);
+	max_forgets = (nbytes - ih.len) / forget_one_size;
 	head = dequeue_forget(fc, max_forgets, &count);
 	spin_unlock(&fc->lock);
 
 	arg.count = count;
-	ih.len += count * sizeof(struct fuse_forget_one);
+	ih.len += count * forget_one_size;
 	err = fuse_copy_one(cs, &ih, sizeof(ih));
 	if (!err)
 		err = fuse_copy_one(cs, &arg, sizeof(arg));
@@ -1163,7 +1179,7 @@ __releases(fc->lock)
 
 		if (!err) {
 			err = fuse_copy_one(cs, &forget->forget_one,
-					    sizeof(forget->forget_one));
+					    forget_one_size);
 		}
 		head = forget->next;
 		kfree(forget);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 781a01d..d5172fa 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -59,7 +59,7 @@ extern unsigned max_user_congthresh;
 
 /* One forget request */
 struct fuse_forget_link {
-	struct fuse_forget_one forget_one;
+	struct fuse_forget_one_ext forget_one;
 	struct fuse_forget_link *next;
 };
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 8b9a1d1..932e04a 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -128,6 +128,12 @@ static void fuse_evict_inode(struct inode *inode)
 	if (inode->i_sb->s_flags & MS_ACTIVE) {
 		struct fuse_conn *fc = get_fuse_conn(inode);
 		struct fuse_inode *fi = get_fuse_inode(inode);
+		if (test_bit(FUSE_I_CTIME_DIRTY, &fi->state)) {
+			struct fuse_forget_link *fl = fi->forget;
+			fl->forget_one.forget_flags = FUSE_FORGET_CTIME_SET;
+			fl->forget_one.ctime = inode->i_ctime.tv_sec;
+			fl->forget_one.ctimensec = inode->i_ctime.tv_nsec;
+		}
 		fuse_queue_forget(fc, fi->forget, fi->nodeid, fi->nlookup);
 		fi->forget = NULL;
 	}
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 8af06cc..5354a8c 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -388,6 +388,24 @@ struct fuse_forget_in {
 	uint64_t	nlookup;
 };
 
+struct fuse_forget_in_ext {
+	uint64_t	nlookup;
+	uint64_t	ctime;
+	uint32_t	ctimensec;
+	uint32_t	forget_flags;
+};
+
+/* forget_flags */
+#define FUSE_FORGET_CTIME_SET	(1 << 0)
+
+struct fuse_forget_one_ext {
+	uint64_t	nodeid;
+	uint64_t	nlookup;
+	uint64_t	ctime;
+	uint32_t	ctimensec;
+	uint32_t	forget_flags;
+};
+
 struct fuse_forget_one {
 	uint64_t	nodeid;
 	uint64_t	nlookup;

