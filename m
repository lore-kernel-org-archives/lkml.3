Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3HURZD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:25:03 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56376 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688Ab3HURZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:25:01 -0400
From: Will Deacon <will.deacon@arm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] fs/9p: avoid accessing utsname after namespace has been torn down
Date: Wed, 21 Aug 2013 18:24:47 +0100
Message-Id: <1377105887-7737-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During trinity fuzzing in a kvmtool guest, I stumbled across the
following:

Unable to handle kernel NULL pointer dereference at virtual address 00000004
PC is at v9fs_file_do_lock+0xc8/0x1a0
LR is at v9fs_file_do_lock+0x48/0x1a0
[<c01e2ed0>] (v9fs_file_do_lock+0xc8/0x1a0) from [<c0119154>] (locks_remove_flock+0x8c/0x124)
[<c0119154>] (locks_remove_flock+0x8c/0x124) from [<c00d9bf0>] (__fput+0x58/0x1e4)
[<c00d9bf0>] (__fput+0x58/0x1e4) from [<c0044340>] (task_work_run+0xac/0xe8)
[<c0044340>] (task_work_run+0xac/0xe8) from [<c002e36c>] (do_exit+0x6bc/0x8d8)
[<c002e36c>] (do_exit+0x6bc/0x8d8) from [<c002e674>] (do_group_exit+0x3c/0xb0)
[<c002e674>] (do_group_exit+0x3c/0xb0) from [<c002e6f8>] (__wake_up_parent+0x0/0x18)

I believe this is due to an attempt to access utsname()->nodename, after
exit_task_namespaces() has been called, leaving current->nsproxy->uts_ns
as NULL and causing the above dereference.

A similar issue was fixed for lockd in 9a1b6bf818e7 ("LOCKD: Don't call
utsname()->nodename from nlmclnt_setlockargs"), so this patch attempts
something similar for 9pfs.

Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 fs/9p/vfs_file.c        | 4 ++--
 include/net/9p/client.h | 5 +++++
 net/9p/client.c         | 5 +++++
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index d384a8b..aa5ecf4 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -183,7 +183,7 @@ static int v9fs_file_do_lock(struct file *filp, int cmd, struct file_lock *fl)
 	else
 		flock.length = fl->fl_end - fl->fl_start + 1;
 	flock.proc_id = fl->fl_pid;
-	flock.client_id = utsname()->nodename;
+	flock.client_id = fid->clnt->name;
 	if (IS_SETLKW(cmd))
 		flock.flags = P9_LOCK_FLAGS_BLOCK;
 
@@ -260,7 +260,7 @@ static int v9fs_file_getlock(struct file *filp, struct file_lock *fl)
 	else
 		glock.length = fl->fl_end - fl->fl_start + 1;
 	glock.proc_id = fl->fl_pid;
-	glock.client_id = utsname()->nodename;
+	glock.client_id = fid->clnt->name;
 
 	res = p9_client_getlock_dotl(fid, &glock);
 	if (res < 0)
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 4c7c01a..c38a005 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -26,6 +26,8 @@
 #ifndef NET_9P_CLIENT_H
 #define NET_9P_CLIENT_H
 
+#include <linux/utsname.h>
+
 /* Number of requests per row */
 #define P9_ROW_MAXTAG 255
 
@@ -134,6 +136,7 @@ struct p9_req_t {
  * @tagpool - transaction id accounting for session
  * @reqs - 2D array of requests
  * @max_tag - current maximum tag id allocated
+ * @name - node name used as client id
  *
  * The client structure is used to keep track of various per-client
  * state that has been instantiated.
@@ -164,6 +167,8 @@ struct p9_client {
 	struct p9_idpool *tagpool;
 	struct p9_req_t *reqs[P9_ROW_MAXTAG];
 	int max_tag;
+
+	char name[__NEW_UTS_LEN + 1];
 };
 
 /**
diff --git a/net/9p/client.c b/net/9p/client.c
index 8b93cae..0e49b28 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -992,6 +992,7 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 {
 	int err;
 	struct p9_client *clnt;
+	char *client_id;
 
 	err = 0;
 	clnt = kmalloc(sizeof(struct p9_client), GFP_KERNEL);
@@ -1000,6 +1001,10 @@ struct p9_client *p9_client_create(const char *dev_name, char *options)
 
 	clnt->trans_mod = NULL;
 	clnt->trans = NULL;
+
+	client_id = utsname()->nodename;
+	memcpy(clnt->name, client_id, strlen(client_id) + 1);
+
 	spin_lock_init(&clnt->lock);
 	INIT_LIST_HEAD(&clnt->fidlist);
 
-- 
1.8.2.2

