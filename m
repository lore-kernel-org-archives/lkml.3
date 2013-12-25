Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3LYMhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 07:37:55 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:58990 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3LYMhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 07:37:53 -0500
X-Nat-Received: from [202.181.97.72]:58699 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1387975057.22235
To: akpm@linux-foundation.org, jkosina@suse.cz, joe@perches.com,
        viro@zeniv.linux.org.uk, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 25 Dec 2013 21:37:33 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 25122013 #7194695, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 545dae06c6690a0c937e082ed984f828a2ea7aa2 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Wed, 25 Dec 2013 18:16:17 +0900
Subject: [PATCH] lib/vsprintf: add %pT[C012] format specifier

Since task_struct->comm can be modified by other threads while the current
thread is reading it, it is recommended to use get_task_comm() for reading it.

However, since get_task_comm() holds task_struct->alloc_lock spinlock,
some users cannot use get_task_comm(). Also, a lot of users are directly
reading from task_struct->comm even if they can use get_task_comm().
Such users might obtain inconsistent comm name.

This patch introduces %pTC format specifier for reading task_struct->comm
and %pT0 %pT1 %pT2 format specifiers for reading task_struct->comm and
task_struct->pid.

Currently %pT does not hold task_struct->alloc_lock spinlock. This is because
I'm expecting that we will change to update task_struct->comm using RCU.

By using RCU, the comm name read from task_struct->comm will be guaranteed to
be consistent. But before modifying set_task_comm() to use RCU, we need to kill
direct ->comm users who do not use get_task_comm().

Although there might be arguments that whether to modify set_task_comm() to
use RCU, this patch will anyway serve as a cleanup.

Some examples for converting direct ->comm users are shown below.

  pr_info("comm=%s\n", p->comm);                => pr_info("comm=%pTC\n", p);
  pr_info("%s[%u]\n", p->comm, p->pid);         => pr_info("%pT0\n", p);
  pr_info("%s[%u]\n", p->comm, task_pid_nr(p)); => pr_info("%pT0\n", p);
  pr_info("%s/%u\n", p->comm, p->pid);          => pr_info("%pT1\n", p);
  pr_info("%s,%u\n", p->comm, p->pid);          => pr_info("%pT2\n", p);

Since many debug printings use p == current, you can pass NULL instead of p
if p == current. That is, you can simplify like examples shown below.

  pr_info("comm=%s\n", current->comm); => pr_info("comm=%pTC\n", NULL);
  pr_info("(%s/%u)", current->comm, current->pid); => pr_info("(%pT1)", NULL);

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 Documentation/printk-formats.txt |   12 ++++++++++
 lib/vsprintf.c                   |   44 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 445ad74..c950c04 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -177,6 +177,18 @@ dentry names:
 	equivalent of %s dentry->d_name.name we used to use, %pd<n> prints
 	n last components.  %pD does the same thing for struct file.
 
+task_struct comm name:
+
+        format:  meaning:       example:
+        %pTC     commname       init
+        %pT0     commname[pid]  init[1]
+        %pT1     commname/pid   init/1
+        %pT2     commname,pid   init,1
+
+        For printing task_struct->comm and optionally task_struct->pid.
+        Currently task_struct->alloc_lock is not held; might be replaced
+        by RCU in the future.
+
 struct va_format:
 
 	%pV
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 10909c5..4968f57 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1155,6 +1155,38 @@ char *netdev_feature_string(char *buf, char *end, const u8 *addr,
 	return number(buf, end, *(const netdev_features_t *)addr, spec);
 }
 
+static noinline_for_stack
+char *comm_name(char *buf, char *end, struct task_struct *tsk,
+		struct printf_spec spec, const char *fmt)
+{
+	char name[TASK_COMM_LEN + 20] = { };
+	const char c = *fmt;
+
+	/* Caller can pass NULL instead of current. */
+	if (!tsk)
+		tsk = current;
+	/* Not using get_task_comm() in case I'm in IRQ context. */
+	strncpy(name, tsk->comm, TASK_COMM_LEN - 1);
+	/* Optionally print pid value. */
+	if (c != 'C') {
+		struct printf_spec ps = {
+			.type = FORMAT_TYPE_UINT,
+			.base = 10,
+		};
+		char *p = name + strlen(name);
+		if (c == '0')
+			*p++ = '['; /* comm[pid] */
+		else if (c == '1')
+			*p++ = '/'; /* comm/pid  */
+		else
+			*p++ = ','; /* comm,pid */
+		p = number(p, name + sizeof(name) - 2, task_pid_nr(tsk), ps);
+		if (c == '0' && p < name + sizeof(name) - 2)
+			*p++ = ']';
+	}
+	return string(buf, end, name, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1221,6 +1253,7 @@ int kptr_restrict __read_mostly;
  * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
+ * - 'T[C012]' task_struct->comm and optionally task_struct->pid
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1232,7 +1265,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 {
 	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
 
-	if (!ptr && *fmt != 'K') {
+	if (!ptr && *fmt != 'K' && *fmt != 'T') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
@@ -1364,6 +1397,15 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'T':
+		switch (fmt[1]) {
+		case 'C':
+		case '0':
+		case '1':
+		case '2':
+			return comm_name(buf, end, ptr, spec, fmt + 1);
+		}
+		break;
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-- 
1.7.1
