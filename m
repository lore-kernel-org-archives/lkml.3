Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaKKBaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 20:30:04 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:47322 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbaKKBaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 20:30:01 -0500
X-Sasl-enc: nWLklnN3QU3tkeQSL/p+SrngOcszAjljufhiYMOqdqsl 1415669397
Subject: [PATCH 1/3] autofs - fix log print messages
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        autofs mailing list <autofs@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 11 Nov 2014 09:29:54 +0800
Message-ID: <20141111012954.25773.4002.stgit@perseus.themaw.net>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some inconsistencies in log print output and ensure that
the module name is included in all log prints.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Joe Perches <joe@perches.com>
---
 fs/autofs/autofs_i.h  |    6 +++---
 fs/autofs/dev-ioctl.c |    2 +-
 fs/autofs/inode.c     |   10 +++++-----
 fs/autofs/waitq.c     |    4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/autofs/autofs_i.h b/fs/autofs/autofs_i.h
index e99a675..fd93fdc 100644
--- a/fs/autofs/autofs_i.h
+++ b/fs/autofs/autofs_i.h
@@ -37,15 +37,15 @@
 /* #define DEBUG */
 
 #define DPRINTK(fmt, ...)				\
-	pr_debug("pid %d: %s: " fmt "\n",		\
+	pr_debug(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",\
 		current->pid, __func__, ##__VA_ARGS__)
 
 #define AUTOFS_WARN(fmt, ...)				\
-	pr_warn("pid %d: %s: " fmt "\n",	\
+	pr_warn(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",	\
 		current->pid, __func__, ##__VA_ARGS__)
 
 #define AUTOFS_ERROR(fmt, ...)				\
-	pr_err("pid %d: %s: " fmt "\n",	\
+	pr_err(KBUILD_MODNAME ":pid:%d:%s: " fmt "\n",	\
 		current->pid, __func__, ##__VA_ARGS__)
 
 /*
diff --git a/fs/autofs/dev-ioctl.c b/fs/autofs/dev-ioctl.c
index 34e515b..eb16fe4 100644
--- a/fs/autofs/dev-ioctl.c
+++ b/fs/autofs/dev-ioctl.c
@@ -369,7 +369,7 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
 		new_pid = get_task_pid(current, PIDTYPE_PGID);
 
 		if (ns_of_pid(new_pid) != ns_of_pid(sbi->oz_pgrp)) {
-			AUTOFS_WARN("Not allowed to change PID namespace");
+			AUTOFS_WARN("not allowed to change PID namespace");
 			err = -EINVAL;
 			goto out;
 		}
diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index 01788cc..5012f21 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -266,14 +266,14 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	if (parse_options(data, &pipefd, &root_inode->i_uid, &root_inode->i_gid,
 			  &pgrp, &pgrp_set, &sbi->type, &sbi->min_proto,
 			  &sbi->max_proto)) {
-		AUTOFS_ERROR("autofs: called with bogus options");
+		AUTOFS_ERROR("called with bogus options");
 		goto fail_dput;
 	}
 
 	if (pgrp_set) {
 		sbi->oz_pgrp = find_get_pid(pgrp);
 		if (!sbi->oz_pgrp) {
-			AUTOFS_ERROR("autofs: could not find process group %d",
+			AUTOFS_ERROR("could not find process group %d",
 				pgrp);
 			goto fail_dput;
 		}
@@ -290,7 +290,7 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	/* Couldn't this be tested earlier? */
 	if (sbi->max_proto < AUTOFS_MIN_PROTO_VERSION ||
 	    sbi->min_proto > AUTOFS_MAX_PROTO_VERSION) {
-		AUTOFS_ERROR("autofs: kernel does not match daemon version "
+		AUTOFS_ERROR("kernel does not match daemon version "
 			     "daemon (%d, %d) kernel (%d, %d)",
 			sbi->min_proto, sbi->max_proto,
 			AUTOFS_MIN_PROTO_VERSION, AUTOFS_MAX_PROTO_VERSION);
@@ -308,7 +308,7 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	pipe = fget(pipefd);
 
 	if (!pipe) {
-		AUTOFS_ERROR("autofs: could not open pipe file descriptor");
+		AUTOFS_ERROR("could not open pipe file descriptor");
 		goto fail_dput;
 	}
 	ret = autofs_prepare_pipe(pipe);
@@ -329,7 +329,7 @@ int autofs_fill_super(struct super_block *s, void *data, int silent)
 	 */
 fail_fput:
 	AUTOFS_ERROR(
-		"autofs: pipe file descriptor does not contain proper ops");
+		"pipe file descriptor does not contain proper ops");
 	fput(pipe);
 	/* fall through */
 fail_dput:
diff --git a/fs/autofs/waitq.c b/fs/autofs/waitq.c
index ec0c60f..0fb2791 100644
--- a/fs/autofs/waitq.c
+++ b/fs/autofs/waitq.c
@@ -162,7 +162,7 @@ static void autofs_notify_daemon(struct autofs_sb_info *sbi,
 		break;
 	}
 	default:
-		AUTOFS_WARN("autofs_notify_daemon: bad type %d!", type);
+		AUTOFS_WARN("bad type %d!", type);
 		mutex_unlock(&sbi->wq_mutex);
 		return;
 	}
@@ -450,7 +450,7 @@ int autofs_wait(struct autofs_sb_info *sbi,
 					autofs_ptype_expire_indirect;
 		}
 
-		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
+		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d",
 			(unsigned long) wq->wait_queue_token, wq->name.len,
 			wq->name.name, notify);
 

