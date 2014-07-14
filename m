Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaGNTTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:19:22 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62744 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896AbaGNTTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:19:14 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
        lxc-devel@lists.linuxcontainers.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@WittsEnd.com>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 2/3] fuse: Translate pid making a request into the server's pid namespace
Date: Mon, 14 Jul 2014 14:18:15 -0500
Message-Id: <1405365496-58404-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
References: <1405365496-58404-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the server is executing in a pid namespace then then giving it
the global pid of the process making the request is useless.
Translate the pid into the server's pid namespace.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/fuse/dev.c    | 9 +++++----
 fs/fuse/fuse_i.h | 4 ++++
 fs/fuse/inode.c  | 2 ++
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 219d1e685183..db781ff6392b 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -20,6 +20,7 @@
 #include <linux/swap.h>
 #include <linux/splice.h>
 #include <linux/aio.h>
+#include <linux/sched.h>
 
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
@@ -124,11 +125,11 @@ static void __fuse_put_request(struct fuse_req *req)
 	atomic_dec(&req->count);
 }
 
-static void fuse_req_init_context(struct fuse_req *req)
+static void fuse_req_init_context(struct fuse_conn *fc, struct fuse_req *req)
 {
 	req->in.h.uid = from_kuid_munged(&init_user_ns, current_fsuid());
 	req->in.h.gid = from_kgid_munged(&init_user_ns, current_fsgid());
-	req->in.h.pid = current->pid;
+	req->in.h.pid = pid_nr_ns(task_pid(current), fc->pid_ns);
 }
 
 static bool fuse_block_alloc(struct fuse_conn *fc, bool for_background)
@@ -168,7 +169,7 @@ static struct fuse_req *__fuse_get_req(struct fuse_conn *fc, unsigned npages,
 		goto out;
 	}
 
-	fuse_req_init_context(req);
+	fuse_req_init_context(fc, req);
 	req->waiting = 1;
 	req->background = for_background;
 	return req;
@@ -257,7 +258,7 @@ struct fuse_req *fuse_get_req_nofail_nopages(struct fuse_conn *fc,
 	if (!req)
 		req = get_reserved_req(fc, file);
 
-	fuse_req_init_context(req);
+	fuse_req_init_context(fc, req);
 	req->waiting = 1;
 	req->background = 0;
 	return req;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index e8e47a6ab518..a3ded071e2c6 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -22,6 +22,7 @@
 #include <linux/rbtree.h>
 #include <linux/poll.h>
 #include <linux/workqueue.h>
+#include <linux/pid_namespace.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -386,6 +387,9 @@ struct fuse_conn {
 	/** The group id for this mount */
 	kgid_t group_id;
 
+	/** The pid namespace for this mount */
+	struct pid_namespace *pid_ns;
+
 	/** The fuse mount flags for this mount */
 	unsigned flags;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 754dcf23de8a..3655152f770d 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -604,6 +604,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->initialized = 0;
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
+	fc->pid_ns = get_pid_ns(task_active_pid_ns(current));
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
@@ -944,6 +945,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 
 static void fuse_free_conn(struct fuse_conn *fc)
 {
+	put_pid_ns(fc->pid_ns);
 	kfree_rcu(fc, rcu);
 }
 
-- 
1.9.1

