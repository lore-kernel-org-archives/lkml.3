Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaABEuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 23:50:16 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61011 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaABEuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 23:50:15 -0500
X-Nat-Received: from [202.181.97.72]:54829 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388638159.23519
To: joe@perches.com
Cc: akpm@linux-foundation.org, geert@linux-m68k.org, jkosina@suse.cz,
        viro@zeniv.linux.org.uk, davem@davemloft.net, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1388507067.2259.24.camel@joe-AO722>
	<201401011434.GAF34360.FFQOVtFOHJSMLO@I-love.SAKURA.ne.jp>
	<1388555362.2259.38.camel@joe-AO722>
	<201401011902.JEF43770.FSOVFFOHOtQLJM@I-love.SAKURA.ne.jp>
	<1388626389.2259.57.camel@joe-AO722>
In-Reply-To: <1388626389.2259.57.camel@joe-AO722>
Message-Id: <201401021349.JGJ78109.OOFtFFHJMLSOQV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 2 Jan 2014 13:49:17 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 02012014 #7222383, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2014-01-01 at 19:02 +0900, Tetsuo Handa wrote:
> > Joe Perches wrote:
> > > > This choice (i.e. reserve only '\xFF') is more resource economy than my
> > > > previous choice (i.e. reserve '\x7F' to '\xFF') at the cost of wasting only
> > > > one byte compared to my previous choice.
> > > 
> > > I supposed that's better.
> > > 
> > > Is there a particularly utility/reason to use 0xff
> > > vs ascii SUB/PU1/PU2?
> > > 
> > Nothing. Is 0x1A preferable to 0xFF?
> 
> ASCII SUB seems to me to fit better for the purpose.
> The "Private Use" PU1/PU2 also seemed appropriate,
> but I suppose any non-printable character might be OK.

OK. I changed to 0x1A.

Joe Perches wrote:
> btw: Those -6.6 field width uses really are just for debugging
> and I think should be removed.  I didn't notice any other uses of
> field widths and current-><value>.  Are there any?

I don't know. I'm keeping field widths support in case somebody uses field
widths and tsk-><value> (where tsk = current is done prior to reading) and
in the future somebody might want to print other globally accessible variables
(e.g. current time) with field widths. We can consider removing field widths
support after conversion is done.

I think this version is ready for testing.

Regards.
----------
>From 0fdc186b2c8eef8acff74705391eea69632f3d4a Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 2 Jan 2014 13:37:14 +0900
Subject: [PATCH v3] lib/vsprintf: support built-in tokens

The vast majority of ->comm accesses are accessing current->comm, for
debug reasons. I'm counting 350-odd sites. At all these sites it's
pointless passing `current' to the printk function at all!

This patch introduces a set of vsprintf tokens for embedding globally visible
arguments into the format string, so that we can reduce text size a bit (and
in the future make reading of task_struct->comm consistent) by stop generating
the code to pass an argument which the callee already has access to, with an
assumption that currently we are not using the 0x1A byte within the format
string.

Some examples are shown below.

  pr_info("comm=%s\n", current->comm);
          => pr_info("comm=" EMBED_CURRENT_COMM "\n");

  pr_info("pid=%d\n", current->pid);
          => pr_info("pid=" EMBED_CURRENT_PID "\n");

  pr_info("%s(%d)\n", current->comm, current->pid);
          => pr_info(EMBED_CURRENT_COMM "(" EMBED_CURRENT_PID ")\n");

  pr_info("[%-6.6s]\n", current->comm);
          => pr_info(EMBED_FORMAT "-6.6" EMBED_CURRENT_COMM "\n");

Since this patch does not use get_task_comm(), you should not convert from
get_task_comm(current) to built-in tokens if you want constsistent reading.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/kernel.h |   17 ++++++++
 lib/vsprintf.c         |  101 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index ecb8754..8efd2dc 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -353,6 +353,23 @@ extern int num_to_str(char *buf, int size, unsigned long long num);
 
 /* lib/printf utilities */
 
+/*
+ * Built-in tokens for __printf() functions.
+ *
+ * The __printf() functions interpret special bytes starting from a \x1A byte
+ * inside the format string as built-in tokens. The built-in tokens are used
+ * for saving text size (and centralizing pointer dereferences) by omitting
+ * arguments which are visible from __printf() functions. This means that
+ * the format string must not contain the \x1A byte. If the format string
+ * contains the \x1A byte which do not mean to be built-in tokens, you need to
+ * change from pr_info("\x1A\n") to pr_info("%c\n", '0x1A').
+ *
+ * See builtin_token() in lib/vsprintf.c for more information.
+ */
+#define EMBED_FORMAT           "\x1A"
+#define EMBED_CURRENT_COMM     "\x1A\xFF"
+#define EMBED_CURRENT_PID      "\x1A\xFE"
+
 extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
 extern __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
 extern __printf(3, 4)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 10909c5..b05217d 100644
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
@@ -1375,6 +1376,94 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	return number(buf, end, (unsigned long) ptr, spec);
 }
 
+static inline const char *format_decode_builtin(const char *fmt,
+						struct printf_spec *spec)
+{
+	u8 flags = 0;
+	u8 base;
+	s16 field_width = -1;
+	s16 precision = -1;
+	/* Check custom flags, field width and precision. */
+	if (*fmt == '-') {
+		fmt++;
+		flags = LEFT;
+	}
+	if (isdigit(*fmt))
+		field_width = skip_atoi(&fmt);
+	if (*fmt == '.') {
+		fmt++;
+		if (isdigit(*fmt)) {
+			precision = skip_atoi(&fmt);
+			if (precision < 0)
+				precision = 0;
+		}
+	}
+	/*
+	 * Skip redundant byte if custom flags, field width or precision are
+	 * specified.
+	 */
+	if (*fmt == 0x1A)
+		fmt++;
+	/* Check whether this token byte is valid. */
+	base = *fmt;
+	if (base > 0xFD) {
+		fmt++;
+		spec->type = FORMAT_TYPE_BUILTIN_TOKEN;
+		spec->flags = flags;
+		spec->field_width = field_width;
+		spec->precision = precision;
+		spec->base = base; /* Borrow base field for passing token. */
+	}
+	return fmt;
+}
+
+/*
+ * Examples of using built-in tokens:
+ *
+ *   pr_info("%s\n", current->comm) => pr_info(EMBED_CURRENT_COMM "\n");
+ *
+ *   pr_info("%s(%d)\n", current->comm, current->pid);
+ *      => pr_info(EMBED_CURRENT_COMM "(" EMBED_CURRENT_PID ")\n");
+ *
+ *   pr_info("[%-6.6s]\n", current->comm);
+ *      => pr_info(EMBED_FORMAT "-6.6" EMBED_CURRENT_COMM "\n");
+ *
+ * You can define other tokens using "\x1A\x??" format where ?? is a two hex
+ * digits other than 00 ('\0'), 1A ('\x1A'), 25 ('%'), 2D ('-'), 2E ('.') and
+ * 30 ('0') to 39 ('9').
+ */
+static noinline_for_stack
+char *builtin_token(char *buf, char *end, struct printf_spec spec)
+{
+	struct task_struct *const tsk = current;
+	union {
+		char str[TASK_COMM_LEN];
+		int num;
+	} arg;
+
+	switch (spec.base) {
+	case 0xFF: /* current->comm */
+		/* Not using get_task_comm() in case I'm in IRQ context. */
+		memcpy(arg.str, tsk->comm, sizeof(arg.str));
+		/*
+		 * Intentionally copied 16 bytes for compiler optimization.
+		 * Make sure that str is '\0'-terminated in case ->comm was
+		 * by error not '\0'-terminated.
+		 */
+		arg.str[sizeof(arg.str) - 1] = '\0';
+		goto print_string;
+	case 0xFE: /* task_pid_nr(current) or current->pid */
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
@@ -1423,7 +1512,7 @@ int format_decode(const char *fmt, struct printf_spec *spec)
 	spec->type = FORMAT_TYPE_NONE;
 
 	for (; *fmt ; ++fmt) {
-		if (*fmt == '%')
+		if (*fmt == '%' || *fmt == 0x1A)
 			break;
 	}
 
@@ -1431,6 +1520,10 @@ int format_decode(const char *fmt, struct printf_spec *spec)
 	if (fmt != start || !*fmt)
 		return fmt - start;
 
+	/* Process built-in tokens. */
+	if (*fmt == 0x1A)
+		return format_decode_builtin(fmt + 1, spec) - start;
+
 	/* Process flags */
 	spec->flags = 0;
 
@@ -1725,6 +1818,10 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
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
