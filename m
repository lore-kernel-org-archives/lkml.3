Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbaFYLJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:09:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41106 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756178AbaFYLHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:07:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -repost 14/21] kgr: add procfs interface for per-process 'kgr_in_progress'
Date: Wed, 25 Jun 2014 13:07:08 +0200
Message-Id: <1403694435-3180-14-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

Instead of flooding dmesg with data about tasks which haven't yet been
migrated to the "new universe", create a 'kgr_in_progress' in
/proc/<pid>/ so that it's possible to easily script the checks/actions
in userspace.

js: use the kgr helper

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz> [simplification]
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 fs/proc/base.c  | 11 +++++++++++
 kernel/kgraft.c |  3 +--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0c93bf..60f7b1ce5d1c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -87,6 +87,7 @@
 #include <linux/slab.h>
 #include <linux/flex_array.h>
 #include <linux/posix-timers.h>
+#include <linux/kgraft.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
 #endif
@@ -2106,6 +2107,13 @@ static const struct file_operations proc_timers_operations = {
 };
 #endif /* CONFIG_CHECKPOINT_RESTORE */
 
+#if IS_ENABLED(CONFIG_KGRAFT)
+static int proc_pid_kgr_in_progress(struct task_struct *task, char *buffer)
+{
+	return sprintf(buffer, "%d\n", kgr_task_in_progress(task));
+}
+#endif /* IS_ENABLED(CONFIG_KGRAFT) */
+
 static int proc_pident_instantiate(struct inode *dir,
 	struct dentry *dentry, struct task_struct *task, const void *ptr)
 {
@@ -2638,6 +2646,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_CHECKPOINT_RESTORE
 	REG("timers",	  S_IRUGO, proc_timers_operations),
 #endif
+#if IS_ENABLED(CONFIG_KGRAFT)
+	INF("kgr_in_progress",	S_IRUSR, proc_pid_kgr_in_progress),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
diff --git a/kernel/kgraft.c b/kernel/kgraft.c
index fd0ded7ce725..d99171c6ea1d 100644
--- a/kernel/kgraft.c
+++ b/kernel/kgraft.c
@@ -77,9 +77,8 @@ static bool kgr_still_patching(void)
 	read_lock(&tasklist_lock);
 	for_each_process(p) {
 		if (kgr_task_in_progress(p)) {
-			pr_info("pid %d (%s) still in kernel after timeout\n",
-					p->pid, p->comm);
 			failed = true;
+			break;
 		}
 	}
 	read_unlock(&tasklist_lock);
-- 
2.0.0

