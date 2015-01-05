Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbbAERLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:11:08 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:58794 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbbAERLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:11:05 -0500
Date: Mon, 5 Jan 2015 18:11:41 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] fuse update for 3.19
Message-ID: <20150105171141.GA19011@tucsk>
References: <CAB9dFdty+3JXgJqhMNNHuDXivx9_paK2=zd7Vb_D4-suU6OGBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB9dFdty+3JXgJqhMNNHuDXivx9_paK2=zd7Vb_D4-suU6OGBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 12:53:13PM -0400, Marc Dionne wrote:

> Commit 7078187a795f ("fuse: introduce fuse_simple_request() helper")
> from the above pull request triggers some EIO errors for me in some
> tests that rely on fuse.
> 
> Looking at the code changes and a bit of debugging info I think
> there's a general problem here that fuse_get_req checks and possibly
> waits for fc->initialized, and this was always called first.  But this
> commit changes the ordering and in many places fc->minor is now
> possibly used before fuse_get_req, and we can't be sure that fc has
> been initialized.  In my case fuse_lookup_init sets
> req->out.args[0].size to the wrong size because fc->minor at that
> point is still 0, leading to the EIO error.
> 
> Assuming the analysis makes sense, it wasn't obvious what the best fix
> should be.

Here's a patch to fix this.  Could you please give it a try?

Thanks,
Miklos

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index ba1107977f2e..ed19a7d622fa 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -131,6 +131,13 @@ static void fuse_req_init_context(struct fuse_req *req)
 	req->in.h.pid = current->pid;
 }
 
+void fuse_set_initialized(struct fuse_conn *fc)
+{
+	/* Make sure stores before this are seen on another CPU */
+	smp_wmb();
+	fc->initialized = 1;
+}
+
 static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
 {
 	return !fc->initialized || (for_background && fc->blocked);
@@ -155,6 +162,8 @@ static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
 		if (intr)
 			goto out;
 	}
+	/* Matches smp_wmb() in fuse_set_initialized() */
+	smp_rmb();
 
 	err = -ENOTCONN;
 	if (!fc->connected)
@@ -253,6 +262,8 @@ struct fuse_req *fuse_get_req_nofail_nopages(struct fuse_conn *fc,
 
 	atomic_inc(&fc->num_waiting);
 	wait_event(fc->blocked_waitq, fc->initialized);
+	/* Matches smp_wmb() in fuse_set_initialized() */
+	smp_rmb();
 	req = fuse_request_alloc(0);
 	if (!req)
 		req = get_reserved_req(fc, file);
@@ -511,6 +522,39 @@ void fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 }
 EXPORT_SYMBOL_GPL(fuse_request_send);
 
+static void fuse_adjust_compat(struct fuse_conn *fc, struct fuse_args *args)
+{
+	if (fc->minor < 4 && args->in.h.opcode == FUSE_STATFS)
+		args->out.args[0].size = FUSE_COMPAT_STATFS_SIZE;
+
+	if (fc->minor < 9) {
+		switch (args->in.h.opcode) {
+		case FUSE_LOOKUP:
+		case FUSE_CREATE:
+		case FUSE_MKNOD:
+		case FUSE_MKDIR:
+		case FUSE_SYMLINK:
+		case FUSE_LINK:
+			args->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
+			break;
+		case FUSE_GETATTR:
+		case FUSE_SETATTR:
+			args->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
+			break;
+		}
+	}
+	if (fc->minor < 12) {
+		switch (args->in.h.opcode) {
+		case FUSE_CREATE:
+			args->in.args[0].size = sizeof(struct fuse_open_in);
+			break;
+		case FUSE_MKNOD:
+			args->in.args[0].size = FUSE_COMPAT_MKNOD_IN_SIZE;
+			break;
+		}
+	}
+}
+
 ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 {
 	struct fuse_req *req;
@@ -520,6 +564,9 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
+	/* Needs to be done after fuse_get_req() so that fc->minor is valid */
+	fuse_adjust_compat(fc, args);
+
 	req->in.h.opcode = args->in.h.opcode;
 	req->in.h.nodeid = args->in.h.nodeid;
 	req->in.numargs = args->in.numargs;
@@ -2127,7 +2174,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 	if (fc->connected) {
 		fc->connected = 0;
 		fc->blocked = 0;
-		fc->initialized = 1;
+		fuse_set_initialized(fc);
 		end_io_requests(fc);
 		end_queued_requests(fc);
 		end_polls(fc);
@@ -2146,7 +2193,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
 		spin_lock(&fc->lock);
 		fc->connected = 0;
 		fc->blocked = 0;
-		fc->initialized = 1;
+		fuse_set_initialized(fc);
 		end_queued_requests(fc);
 		end_polls(fc);
 		wake_up_all(&fc->blocked_waitq);
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 252b8a5de8b5..08e7b1a9d5d0 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -156,10 +156,7 @@ static void fuse_lookup_init(struct fuse_conn *fc, struct fuse_args *args,
 	args->in.args[0].size = name->len + 1;
 	args->in.args[0].value = name->name;
 	args->out.numargs = 1;
-	if (fc->minor < 9)
-		args->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
-	else
-		args->out.args[0].size = sizeof(struct fuse_entry_out);
+	args->out.args[0].size = sizeof(struct fuse_entry_out);
 	args->out.args[0].value = outarg;
 }
 
@@ -422,16 +419,12 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	args.in.h.opcode = FUSE_CREATE;
 	args.in.h.nodeid = get_node_id(dir);
 	args.in.numargs = 2;
-	args.in.args[0].size = fc->minor < 12 ? sizeof(struct fuse_open_in) :
-						sizeof(inarg);
+	args.in.args[0].size = sizeof(inarg);
 	args.in.args[0].value = &inarg;
 	args.in.args[1].size = entry->d_name.len + 1;
 	args.in.args[1].value = entry->d_name.name;
 	args.out.numargs = 2;
-	if (fc->minor < 9)
-		args.out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
-	else
-		args.out.args[0].size = sizeof(outentry);
+	args.out.args[0].size = sizeof(outentry);
 	args.out.args[0].value = &outentry;
 	args.out.args[1].size = sizeof(outopen);
 	args.out.args[1].value = &outopen;
@@ -539,10 +532,7 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
 	memset(&outarg, 0, sizeof(outarg));
 	args->in.h.nodeid = get_node_id(dir);
 	args->out.numargs = 1;
-	if (fc->minor < 9)
-		args->out.args[0].size = FUSE_COMPAT_ENTRY_OUT_SIZE;
-	else
-		args->out.args[0].size = sizeof(outarg);
+	args->out.args[0].size = sizeof(outarg);
 	args->out.args[0].value = &outarg;
 	err = fuse_simple_request(fc, args);
 	if (err)
@@ -592,8 +582,7 @@ static int fuse_mknod(struct inode *dir, struct dentry *entry, umode_t mode,
 	inarg.umask = current_umask();
 	args.in.h.opcode = FUSE_MKNOD;
 	args.in.numargs = 2;
-	args.in.args[0].size = fc->minor < 12 ? FUSE_COMPAT_MKNOD_IN_SIZE :
-						sizeof(inarg);
+	args.in.args[0].size = sizeof(inarg);
 	args.in.args[0].value = &inarg;
 	args.in.args[1].size = entry->d_name.len + 1;
 	args.in.args[1].value = entry->d_name.name;
@@ -899,10 +888,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	args.in.args[0].size = sizeof(inarg);
 	args.in.args[0].value = &inarg;
 	args.out.numargs = 1;
-	if (fc->minor < 9)
-		args.out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
-	else
-		args.out.args[0].size = sizeof(outarg);
+	args.out.args[0].size = sizeof(outarg);
 	args.out.args[0].value = &outarg;
 	err = fuse_simple_request(fc, &args);
 	if (!err) {
@@ -1574,10 +1560,7 @@ static void fuse_setattr_fill(struct fuse_conn *fc, struct fuse_args *args,
 	args->in.args[0].size = sizeof(*inarg_p);
 	args->in.args[0].value = inarg_p;
 	args->out.numargs = 1;
-	if (fc->minor < 9)
-		args->out.args[0].size = FUSE_COMPAT_ATTR_OUT_SIZE;
-	else
-		args->out.args[0].size = sizeof(*outarg_p);
+	args->out.args[0].size = sizeof(*outarg_p);
 	args->out.args[0].value = outarg_p;
 }
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e0fc6725d1d0..1cdfb07c1376 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -906,4 +906,6 @@ int fuse_write_inode(struct inode *inode, struct writeback_control *wbc);
 int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 		    struct file *file);
 
+void fuse_set_initialized(struct fuse_conn *fc);
+
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 6749109f255d..f38256e4476e 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -424,8 +424,7 @@ static int fuse_statfs(struct dentry *dentry, struct kstatfs *buf)
 	args.in.h.opcode = FUSE_STATFS;
 	args.in.h.nodeid = get_node_id(dentry->d_inode);
 	args.out.numargs = 1;
-	args.out.args[0].size =
-		fc->minor < 4 ? FUSE_COMPAT_STATFS_SIZE : sizeof(outarg);
+	args.out.args[0].size = sizeof(outarg);
 	args.out.args[0].value = &outarg;
 	err = fuse_simple_request(fc, &args);
 	if (!err)
@@ -898,7 +897,7 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 		fc->max_write = max_t(unsigned, 4096, fc->max_write);
 		fc->conn_init = 1;
 	}
-	fc->initialized = 1;
+	fuse_set_initialized(fc);
 	wake_up_all(&fc->blocked_waitq);
 }
 

