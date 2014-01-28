Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaA1BDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:03:05 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44096 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaA1BDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:03:03 -0500
Message-ID: <52E701BF.9040306@gmail.com>
Date: Tue, 28 Jan 2014 12:02:55 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Olof Johansson <olof@lixom.net>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] vsprintf: ignore arguments to %n
References: <20140128003927.GA27319@www.outflux.net>
In-Reply-To: <20140128003927.GA27319@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/14 11:39, Kees Cook wrote:
> If arguments are consumed without output when encountering %n, it
> could be used to benefit or improve information leak attacks that were
> exposed via a limited size buffer. Since %n is not used by the kernel,
> there is no reason to make an info leak attack any easier.

I was thinking more like the following. Print the warning if %n is
detected in format_decode(), but otherwise just remove the handling of
%n outright and treat it like any other invalid format specifier.
Something like this completely untested patch. Thoughts?

~Ryan

---
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 10909c5..4e24009 100644
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
+		 * it as an invalid format specifier. Warn about it use, so
+		 * new instances don't get added.
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
 

