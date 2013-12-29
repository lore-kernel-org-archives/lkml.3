Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab3L2MOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 07:14:22 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:54527 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3L2MOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 07:14:20 -0500
X-Nat-Received: from [202.181.97.72]:50096 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388319203.27674
To: joe@perches.com, akpm@linux-foundation.org
Cc: geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1388260405.24123.18.camel@joe-AO722>
	<20131228120815.31f7d378.akpm@linux-foundation.org>
	<1388262293.24123.22.camel@joe-AO722>
	<201312290932.GGH35442.JFVFFHSOMOQOtL@I-love.SAKURA.ne.jp>
	<1388282837.24123.24.camel@joe-AO722>
In-Reply-To: <1388282837.24123.24.camel@joe-AO722>
Message-Id: <201312292113.FIJ60946.tFOVOJOHLQSFFM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sun, 29 Dec 2013 21:13:26 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 29122013 #7191324, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Joe Perches wrote:
> > On Sat, 2013-12-28 at 12:08 -0800, Andrew Morton wrote:
> > > On Sat, 28 Dec 2013 11:53:25 -0800 Joe Perches <joe@perches.com> wrote:
> > > 
> > > > > > #define PRINTK_PID      "\002"
> > > > > > #define PRINTK_TASK_ID  "\003"  /* "comm:pid" */
> > 
> > > > > >
> > > > > >         printk(PRINTK_TASK_ID ": hair on fire\n");
> > > > > >
> > > > > > It's certainly compact.  I doubt if there's any existing code which
> > > > > > deliberately prints control chars?
> 
> What about using bytes from \x7F to \xFF ?

Here is a draft patch. With this approach, we can embed whatever variables
vsnprintf() can access (not only current thread's attributes seen from init and
current namespace but also other variables like current time) into the format
string without passing corresponding argument.

Is this approach acceptable? (Of course, I'll add lines like

  #define PRINT_FORMAT    "\x7F"
  #define PRINT_TASK_COMM "\x80"
  #define PRINT_TASK_PID  "\x81"

for final version.) What variables (e.g. current->comm, current->pid,
task_tgid_vnr(current)) do we want to pass using builtin tokens?
----------
>From 1d891b935efeab46cb1947d72659187c8e47c93c Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sun, 29 Dec 2013 20:58:50 +0900
Subject: [PATCH] lib/vsprintf: support builtin tokens

The vast majority of ->comm accesses are accessing current->comm, for
debug reasons. I'm counting 350-odd sites. At all these sites it's
pointless passing `current' to the printk function at all!

This patch introduces a set of vsprintf tokens for embedding globally visible
arguments into the format string, so that we can reduce text size a bit (and
in the future make reading of task_struct->comm consistent) by stop generating
the code to pass an argument which the callee already has access to, with an
assumption that we can avoid using bytes >= 0x7F within the format string.

Some examples for converting direct ->comm users are shown below.

  pr_info("comm=%s\n", current->comm); => pr_info("comm=\x80\n");
  pr_info("pid=%d\n", current->pid);   => pr_info("pid=\x81\n");
  pr_info("%s(%d)\n", current->comm, current->pid); => pr_info("\x80(\x81)\n");
  pr_info("[%-6.6s]\n", current->comm); => pr_info("\x7F-6.6\x80\n");

Since this patch does not use get_task_comm(), you should not convert from
get_task_comm(current) to builtin tokens if you want constsistent reading.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 lib/vsprintf.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 10909c5..50cdb39 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -366,7 +366,8 @@ enum format_type {
 	FORMAT_TYPE_INT,
 	FORMAT_TYPE_NRCHARS,
 	FORMAT_TYPE_SIZE_T,
-	FORMAT_TYPE_PTRDIFF
+	FORMAT_TYPE_PTRDIFF,
+	FORMAT_TYPE_BUILTIN_TOKEN,
 };
 
 struct printf_spec {
@@ -1375,6 +1376,69 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	return number(buf, end, (unsigned long) ptr, spec);
 }
 
+static inline int format_decode_builtin(const char *fmt, const char *start,
+					struct printf_spec *spec)
+{
+	spec->type = FORMAT_TYPE_BUILTIN_TOKEN;
+	spec->flags = 0;
+	spec->field_width = -1;
+	spec->precision = -1;
+	if (*fmt == 0x7F) { /* Custom flags, field width and precision. */
+		if (*++fmt == '-') {
+			spec->flags = LEFT;
+			++fmt;
+		}
+		if (isdigit(*fmt))
+			spec->field_width = skip_atoi(&fmt);
+		if (*fmt == '.') {
+			++fmt;
+			if (isdigit(*fmt)) {
+				spec->precision = skip_atoi(&fmt);
+				if (spec->precision < 0)
+					spec->precision = 0;
+			}
+		}
+	}
+	if (*(unsigned char *) fmt & 0x80) {
+		spec->base = *fmt; /* Borrow base field for passing token. */
+		return ++fmt - start;
+	}
+	spec->type = FORMAT_TYPE_INVALID;
+	return fmt - start;
+}
+
+static noinline_for_stack
+char *builtin_token(char *buf, char *end, struct printf_spec spec)
+{
+	struct task_struct *const tsk = current;
+	union {
+		char str[TASK_COMM_LEN];
+		int num;
+	} arg;
+
+	switch (spec.base) { /* What the token is? */
+	case 0x80: /* current->comm */
+		/* Not using get_task_comm() in case I'm in IRQ context. */
+		memcpy(arg.str, tsk->comm, sizeof(arg.str));
+		/*
+		 * Intentionally copied 16 bytes for compiler optimization.
+		 * Make sure that str is '\0'-terminated in case ->comm was
+		 * by error not '\0'-terminated.
+		 */
+		arg.str[sizeof(arg.str) - 1] = '\0';
+		goto print_string;
+	case 0x81: /* task_pid_nr(current) or current->pid */
+		arg.num = task_pid_nr(tsk);
+		goto print_number;
+	}
+	memcpy(arg.str, "?", 2); /* This should not happen. */
+ print_string:
+	return string(buf, end, arg.str, spec);
+ print_number:
+	spec.base = 10; /* Assign base field. */
+	return number(buf, end, arg.num, spec);
+}
+
 /*
  * Helper function to decode printf style format.
  * Each call decode a token from the format and return the
@@ -1423,7 +1487,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
 	spec->type = FORMAT_TYPE_NONE;
 
 	for (; *fmt ; ++fmt) {
-		if (*fmt == '%')
+		if (*fmt == '%' || *(unsigned char *) fmt >= 0x7F)
 			break;
 	}
 
@@ -1431,6 +1495,10 @@ int format_decode(const char *fmt, struct printf_spec *spec)
 	if (fmt != start || !*fmt)
 		return fmt - start;
 
+	/* Process built-in tokens. */
+	if (*(unsigned char *) fmt >= 0x7F)
+		return format_decode_builtin(fmt, start, spec);
+
 	/* Process flags */
 	spec->flags = 0;
 
@@ -1725,6 +1793,10 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			break;
 		}
 
+		case FORMAT_TYPE_BUILTIN_TOKEN:
+			str = builtin_token(str, end, spec);
+			break;
+
 		default:
 			switch (spec.type) {
 			case FORMAT_TYPE_LONG_LONG:
-- 
1.7.1
