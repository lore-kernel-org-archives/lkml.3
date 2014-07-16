Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaGPVgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:36:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41425 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaGPVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:36:16 -0400
Date: Thu, 17 Jul 2014 00:36:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] proc: convert /proc/$PID/hardwall to seq_file interface
Message-ID: <20140716213612.GH21290@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/tile/include/asm/hardwall.h |    2 +-
 arch/tile/kernel/hardwall.c      |    6 +++---
 fs/proc/base.c                   |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/tile/include/asm/hardwall.h
+++ b/arch/tile/include/asm/hardwall.h
@@ -23,7 +23,7 @@
 struct proc_dir_entry;
 #ifdef CONFIG_HARDWALL
 void proc_tile_hardwall_init(struct proc_dir_entry *root);
-int proc_pid_hardwall(struct task_struct *task, char *buffer);
+int proc_pid_hardwall(struct seq_file *m, struct pid_namespace *ns, struct pid *pid, struct task_struct *task);
 #else
 static inline void proc_tile_hardwall_init(struct proc_dir_entry *root) {}
 #endif
--- a/arch/tile/kernel/hardwall.c
+++ b/arch/tile/kernel/hardwall.c
@@ -947,15 +947,15 @@ static void hardwall_remove_proc(struct hardwall_info *info)
 	remove_proc_entry(buf, info->type->proc_dir);
 }
 
-int proc_pid_hardwall(struct task_struct *task, char *buffer)
+int proc_pid_hardwall(struct seq_file *m, struct pid_namespace *ns,
+		      struct pid *pid, struct task_struct *task)
 {
 	int i;
 	int n = 0;
 	for (i = 0; i < HARDWALL_TYPES; ++i) {
 		struct hardwall_info *info = task->thread.hardwall[i].info;
 		if (info)
-			n += sprintf(&buffer[n], "%s: %d\n",
-				     info->type->name, info->id);
+			seq_printf(m, "%s: %d\n", info->type->name, info->id);
 	}
 	return n;
 }
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2637,7 +2637,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	ONE("io",	S_IRUSR, proc_tgid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
-	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
+	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
 #endif
 #ifdef CONFIG_USER_NS
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
@@ -2972,7 +2972,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	ONE("io",	S_IRUSR, proc_tid_io_accounting),
 #endif
 #ifdef CONFIG_HARDWALL
-	INF("hardwall",   S_IRUGO, proc_pid_hardwall),
+	ONE("hardwall",   S_IRUGO, proc_pid_hardwall),
 #endif
 #ifdef CONFIG_USER_NS
 	REG("uid_map",    S_IRUGO|S_IWUSR, proc_uid_map_operations),
