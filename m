Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaA1Vxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:53:37 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34019 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaA1Vxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:53:31 -0500
Message-ID: <52E826D4.8020008@gmail.com>
Date: Wed, 29 Jan 2014 08:53:24 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: kees Cook <keescook@chromium.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] vsprintf: Remove %n handling
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All in kernel users of %n in format strings have now been removed and
the %n directive is ignored. Remove the handling of %n so that it is
treated the same as any other invalid format string directive. Keep a
warning in place to deter new instances of %n in format strings.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
---

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 10909c5..7c4c207 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -364,7 +364,6 @@ enum format_type {
 	FORMAT_TYPE_SHORT,
 	FORMAT_TYPE_UINT,
 	FORMAT_TYPE_INT,
-	FORMAT_TYPE_NRCHARS,
 	FORMAT_TYPE_SIZE_T,
 	FORMAT_TYPE_PTRDIFF
 };
@@ -1512,10 +1511,6 @@ qualifier:
 		return fmt - start;
 		/* skip alnum */
 
-	case 'n':
-		spec->type = FORMAT_TYPE_NRCHARS;
-		return ++fmt - start;
-
 	case '%':
 		spec->type = FORMAT_TYPE_PERCENT_CHAR;
 		return ++fmt - start;
@@ -1538,6 +1533,15 @@ qualifier:
 	case 'u':
 		break;
 
+	case 'n':
+		/*
+		 * Since %n poses a greater security risk than utility, treat
+		 * it as an invalid format specifier. Warn about its use so
+		 * that new instances don't get added.
+		 */
+		WARN_ONCE(1, "Please remove ignored %%n in '%s'\n", fmt);
+		/* Fall-through */
+
 	default:
 		spec->type = FORMAT_TYPE_INVALID;
 		return fmt - start;
@@ -1711,20 +1715,6 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			++str;
 			break;
 
-		case FORMAT_TYPE_NRCHARS: {
-			/*
-			 * Since %n poses a greater security risk than
-			 * utility, ignore %n and skip its argument.
-			 */
-			void *skip_arg;
-
-			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
-					old_fmt);
-
-			skip_arg = va_arg(args, void *);
-			break;
-		}
-
 		default:
 			switch (spec.type) {
 			case FORMAT_TYPE_LONG_LONG:
@@ -1999,19 +1989,6 @@ do {									\
 				fmt++;
 			break;
 
-		case FORMAT_TYPE_NRCHARS: {
-			/* skip %n 's argument */
-			u8 qualifier = spec.qualifier;
-			void *skip_arg;
-			if (qualifier == 'l')
-				skip_arg = va_arg(args, long *);
-			else if (_tolower(qualifier) == 'z')
-				skip_arg = va_arg(args, size_t *);
-			else
-				skip_arg = va_arg(args, int *);
-			break;
-		}
-
 		default:
 			switch (spec.type) {
 
@@ -2170,10 +2147,6 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			++str;
 			break;
 
-		case FORMAT_TYPE_NRCHARS:
-			/* skip */
-			break;
-
 		default: {
 			unsigned long long num;
 

