Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbaAIMxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:53:12 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:65403 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbaAIMw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:52:58 -0500
X-Nat-Received: from [202.181.97.72]:49161 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389271923.10086
To: akpm@linux-foundation.org
Cc: pavel@ucw.cz, joe@perches.com, keescook@chromium.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] lib/vsprintf: add %pT format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 9 Jan 2014 21:52:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 09012014 #7285211, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Since addition of %pT itself seems to be agreed, I refreshed this patch using
linux-next-20140109. Please pick up if this patch is OK for you; I will start
making patches for killing most of direct ->comm readers.

Regards.
----------------------------------------
>From 0d1f03d59a477459f3d3c190593d9e78f5d67de8 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 9 Jan 2014 21:32:22 +0900
Subject: [PATCH] lib/vsprintf: add %pT format specifier

Since task_struct->comm can be modified by other threads while the current
thread is reading it, it is recommended to use get_task_comm() for reading it.

However, since get_task_comm() holds task_struct->alloc_lock spinlock,
some users cannot use get_task_comm(). Also, a lot of users are directly
reading from task_struct->comm even if they can use get_task_comm().
Such users might obtain inconsistent result.

This patch introduces %pT format specifier for printing task_struct->comm.
Currently %pT does not provide consistency. I'm planning to change to use RCU
in the future. By using RCU, the comm name read from task_struct->comm will be
guaranteed to be consistent. But before modifying set_task_comm() to use RCU,
we need to kill direct ->comm users who do not use get_task_comm().

An example for converting direct ->comm users is shown below. Since many debug
printings use p == current, you can pass NULL instead of p if p == current.

  pr_info("comm=%s\n", p->comm);       => pr_info("comm=%pT\n", p);
  pr_info("comm=%s\n", current->comm); => pr_info("comm=%pT\n", NULL);

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
---
 Documentation/printk-formats.txt |    6 ++++++
 lib/vsprintf.c                   |   20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 6f4eb32..94459b4 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -184,6 +184,12 @@ dentry names:
 	equivalent of %s dentry->d_name.name we used to use, %pd<n> prints
 	n last components.  %pD does the same thing for struct file.
 
+task_struct comm name:
+
+        %pT
+
+        For printing task_struct->comm.
+
 struct va_format:
 
 	%pV
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 185b6d3..a97f18b 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1179,6 +1179,21 @@ char *address_val(char *buf, char *end, const void *addr,
 	return number(buf, end, num, spec);
 }
 
+static noinline_for_stack
+char *comm_name(char *buf, char *end, struct task_struct *tsk,
+		struct printf_spec spec, const char *fmt)
+{
+	char name[TASK_COMM_LEN];
+
+	/* Caller can pass NULL instead of current. */
+	if (!tsk)
+		tsk = current;
+	/* Not using get_task_comm() in case I'm in IRQ context. */
+	memcpy(name, tsk->comm, TASK_COMM_LEN);
+	name[sizeof(name) - 1] = '\0';
+	return string(buf, end, name, spec);
+}
+
 int kptr_restrict __read_mostly;
 
 /*
@@ -1246,6 +1261,7 @@ int kptr_restrict __read_mostly;
  *           (default assumed to be phys_addr_t, passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
+ * - 'T' task_struct->comm
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1257,7 +1273,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 {
 	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
 
-	if (!ptr && *fmt != 'K') {
+	if (!ptr && *fmt != 'K' && *fmt != 'T') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
@@ -1385,6 +1401,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'T':
+		return comm_name(buf, end, ptr, spec, fmt);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-- 
1.7.1
