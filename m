Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbaAFOB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:01:59 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59603 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbaAFOB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:01:58 -0500
X-Nat-Received: from [202.181.97.72]:65342 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1389016856.22414
To: joe@perches.com
Cc: keescook@chromium.org, pavel@ucw.cz, akpm@linux-foundation.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1388770748.14334.19.camel@joe-AO722>
	<CAGXu5j+gHtgx9MVCaJ2ogJ0WGCeTDkphsH3gm7S=+mTssicABg@mail.gmail.com>
	<201401041126.BHJ81291.VOHLOtMFOJFQFS@I-love.SAKURA.ne.jp>
	<201401051215.ACJ30759.MJSHtFFFVOOOQL@I-love.SAKURA.ne.jp>
	<1388945392.5808.19.camel@joe-AO722>
In-Reply-To: <1388945392.5808.19.camel@joe-AO722>
Message-Id: <201401062300.GFE12908.FOQLFFJOSOMVHt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 6 Jan 2014 23:00:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 06012014 #7264628, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Sun, 2014-01-05 at 12:15 +0900, Tetsuo Handa wrote:
> > > Since my purpose is to make reading of task_struct->comm consistent, %pT-like
> > > extension is what I want for centralizing pointer dereferences.
> > 
> > If we have no objections for %pT[C012] patch,
> 
> I still believe emitting different output styles using
> %pT[012] is not ideal.
> 
> Is this really necessary?

No problem. %pT[012] are simply optimization (reducing number of function
arguments for saving text size) and therefore I can drop them.
What about below patch?
----------
>From f69a1db69a9ad6e14235edbb5a9b7d720530a2be Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 6 Jan 2014 22:22:00 +0900
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
---
 Documentation/printk-formats.txt |    6 ++++++
 lib/vsprintf.c                   |   20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 445ad74..bd96e34 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -177,6 +177,12 @@ dentry names:
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
index 10909c5..0300dae 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1155,6 +1155,21 @@ char *netdev_feature_string(char *buf, char *end, const u8 *addr,
 	return number(buf, end, *(const netdev_features_t *)addr, spec);
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
@@ -1221,6 +1236,7 @@ int kptr_restrict __read_mostly;
  * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
  * - 'd[234]' For a dentry name (optionally 2-4 last components)
  * - 'D[234]' Same as 'd' but for a struct file
+ * - 'T' task_struct->comm
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
  * function pointers are really function descriptors, which contain a
@@ -1232,7 +1248,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 {
 	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
 
-	if (!ptr && *fmt != 'K') {
+	if (!ptr && *fmt != 'K' && *fmt != 'T') {
 		/*
 		 * Print (null) with the same width as a pointer so it makes
 		 * tabular output look nice.
@@ -1364,6 +1380,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'T':
+		return comm_name(buf, end, ptr, spec, fmt);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {
-- 
1.7.9.5
