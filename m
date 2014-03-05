Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbaCEDvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:51:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49134 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756752AbaCEDvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:51:48 -0500
Date: Wed, 5 Mar 2014 03:51:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stephen Tweedie <sct@redhat.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: [PATCH 4/5][RFC][CFT] reduce m_start() cost...
Message-ID: <20140305035147.GD26528@ZenIV.linux.org.uk>
References: <20140305034751.GW18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305034751.GW18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't rescan the mount list in m_start() if there hadn't been
any changes and we are right at the needed place of just before
it (that's the only occuring ones on sequential read() without
seeks).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/mount.h          |    5 ++++-
 fs/namespace.c      |   21 ++++++++++++++++++---
 fs/proc_namespace.c |    1 +
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/mount.h b/fs/mount.h
index a17458c..61e1c05 100644
--- a/fs/mount.h
+++ b/fs/mount.h
@@ -10,7 +10,7 @@ struct mnt_namespace {
 	struct user_namespace	*user_ns;
 	u64			seq;	/* Sequence number to prevent loops */
 	wait_queue_head_t poll;
-	int event;
+	u64 event;
 };
 
 struct mnt_pcp {
@@ -104,6 +104,9 @@ struct proc_mounts {
 	struct mnt_namespace *ns;
 	struct path root;
 	int (*show)(struct seq_file *, struct vfsmount *);
+	void *cached_mount;
+	u64 cached_event;
+	loff_t cached_index;
 };
 
 #define proc_mounts(p) (container_of((p), struct proc_mounts, m))
diff --git a/fs/namespace.c b/fs/namespace.c
index f28c4fd..00f12af 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -29,7 +29,7 @@
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
 
-static int event;
+static u64 event;
 static DEFINE_IDA(mnt_id_ida);
 static DEFINE_IDA(mnt_group_ida);
 static DEFINE_SPINLOCK(mnt_id_lock);
@@ -1064,14 +1064,29 @@ static void *m_start(struct seq_file *m, loff_t *pos)
 	struct proc_mounts *p = proc_mounts(m);
 
 	down_read(&namespace_sem);
-	return seq_list_start(&p->ns->list, *pos);
+	if (p->cached_event == p->ns->event) {
+		void *v = p->cached_mount;
+		if (*pos == p->cached_index)
+			return v;
+		if (*pos == p->cached_index + 1) {
+			v = seq_list_next(v, &p->ns->list, &p->cached_index);
+			return p->cached_mount = v;
+		}
+	}
+
+	p->cached_event = p->ns->event;
+	p->cached_mount = seq_list_start(&p->ns->list, *pos);
+	p->cached_index = *pos;
+	return p->cached_mount;
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct proc_mounts *p = proc_mounts(m);
 
-	return seq_list_next(v, &p->ns->list, pos);
+	p->cached_mount = seq_list_next(v, &p->ns->list, pos);
+	p->cached_index = *pos;
+	return p->cached_mount;
 }
 
 static void m_stop(struct seq_file *m, void *v)
diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 7be26f0..1a81373 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -267,6 +267,7 @@ static int mounts_open_common(struct inode *inode, struct file *file,
 	p->root = root;
 	p->m.poll_event = ns->event;
 	p->show = show;
+	p->cached_event = ~0ULL;
 
 	return 0;
 
-- 
1.7.10.4

