Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3IQXIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:08:37 -0400
Received: from nm27-vm1.access.bullet.mail.gq1.yahoo.com ([216.39.63.25]:20187
	"EHLO nm27-vm1.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754287Ab3IQXIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:08:35 -0400
X-Yahoo-Newman-Id: 144451.3357.bm@smtp117.sbc.mail.gq1.yahoo.com
X-Rocket-Received: from localhost.localdomain (danielfsantos@99.70.244.137 with )
        by smtp117.sbc.mail.gq1.yahoo.com with SMTP; 17 Sep 2013 23:08:34 +0000 UTC
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: P2Fj1fEVM1lYNAtxAZFPEEJJ97xlJnSwBgi4N5sTFsx.Qzo
 gbVkIcFkFaQ2tFfmuRGknMT7RD3Hj8JixWnO49HCjW5BYeiAKtTqNO2lH5Sh
 r8xEtI2BJtI0mxgPBLUuj954HyFfuJxPQfbtQsliip4SZj_EgQ3v9w8WgDzM
 Q_rAzIGakdtdcoM8vO9ikE3.lGk6LjBWPYZew2IDMswHR4PoDqWKRRywHdMD
 IeMa9n1QHhLFy14YOysuoSgh1GdR67UGFY1bD5OzCxSMKDk9kHgzO7Ny31uy
 bFpu2qSuwCJr8cvivW7zVjOl_F.9NJD6ejwH01nQ6hVwtuluocjd6nmUb3JE
 MojG9RVbA1uc6kJF8Rq.4On8sAShxI9sqFFYzVkLTnXL.1q3m20TnoUs0lGr
 patUo_jrVYGxMZGZxOa5GrdXIWvShE1Z4J.BGj12UBgFSzTi5w80bmK.5l6u
 CAF23hdl9rlWWFkLwH4PB.Fuz3RjYZ_E9GMDE5f7OpRD_h3NHrEncfkV7FJH
 NKferxi6LXNzdawR1YNgqGwn5._p1JIjhtgImcA8-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH 5/5] lib: Add error string support to printks
Date: Tue, 17 Sep 2013 18:08:37 -0500
Message-Id: <1379459317-13046-6-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
References: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an extension for the integral format specifier suffix of 'e',
so that the format %[duxXo]e will result in printing an number (as
before) in addition to a name and descrption for an error code, if such
support is enabled and a name and descrption is found.

My initial thought was to use the glibc extension of '%m', but this
format specifier uses the value of libc's errno and adding a value
breaks gcc's printf parsing.  I'm not convinced that the 'e' extension
is optimal, although there are only four instances of this pattern in
the kernel that would need to be changed.

    git grep -E '".*%[#0\ +\-]*[0-9]*[hljzt]*[idoxXu]e'

Alternatively, 'E' was another thought for a suffix as well.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 lib/vsprintf.c | 92 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 26559bd..d96d675 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -345,6 +345,12 @@ int num_to_str(char *buf, int size, unsigned long long num)
 #define SMALL	32		/* use lowercase in hex (must be 32 == 0x20) */
 #define SPECIAL	64		/* prefix hex with "0x", octal with "0" */
 
+#if defined(CONFIG_PRINTK_ERROR_NAMES) || defined(CONFIG_PRINTK_ERROR_DESCS)
+# define ERROR	128		/* error name and/or descrption */
+#else
+# define ERROR	0
+#endif
+
 enum format_type {
 	FORMAT_TYPE_NONE, /* Just a string part */
 	FORMAT_TYPE_WIDTH,
@@ -1346,6 +1352,75 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	return number(buf, end, (unsigned long) ptr, spec);
 }
 
+/**
+ * error - format an error code into a descrption
+ *
+ * Basically, we print the number, name and descrption, but only if enabled.
+ * If there is no string for an error number, it's printed as if the option is
+ * disabled.  The format is basically equivalent to:
+ *
+ * printk("%d (%s: %s)", num, name, descrption);
+ *
+ * If there's no descrption, it would end up like:
+ *
+ * printk("%d (%s)", num, name);
+ *
+ * etc.
+ *
+ * Note that we ignore width and precision here, although they are applied to
+ * the numerical portion of the output in number().
+ *
+ * Since we're initializing desc to NULL and then only setting it based upon
+ * a pre-compiler constant value, all code expecting it to be non-zero should
+ * compile-out when CONFIG_PRINTK_ERROR_DESCS is not enabled.
+ */
+#if defined(CONFIG_PRINTK_ERROR_NAMES) || defined(CONFIG_PRINTK_ERROR_DESCS)
+static noinline_for_stack
+char *error(char *buf, char *end, int err, struct printf_spec spec)
+{
+	const char *name = strerror_name(err);
+	const char *desc = NULL;
+
+#if defined(CONFIG_PRINTK_ERROR_DESCS)
+	desc = strerror(err);
+#endif
+
+	if (!(name || desc))
+		return buf;
+
+	if (&buf[1] < end) {
+		*buf++ = ' ';
+		*buf++ = '(';
+	}
+
+	if (name)
+		while (buf < end && *name)
+			*buf++ = *name++;
+
+	if (desc) {
+		if (name && &buf[1] < end) {
+			*buf++ = ':';
+			*buf++ = ' ';
+		}
+
+		while (buf < end && *desc)
+			*buf++ = *desc++;
+	}
+
+	if (buf < end)
+		*buf++ = ')';
+
+	return buf;
+}
+#else
+static inline
+char *error(char *buf, char *end, int err, struct printf_spec spec)
+{
+	return buf;
+}
+#endif /* CONFIG_PRINTK_ERROR_NAMES || CONFIG_PRINTK_ERROR_DESCS */
+
+
 /*
  * Helper function to decode printf style format.
  * Each call decode a token from the format and return the
@@ -1501,12 +1576,20 @@ qualifier:
 
 	case 'X':
 		spec->base = 16;
+		if (fmt[1] == 'e') {
+			spec->flags |= ERROR;
+			++fmt;
+		}
 		break;
 
 	case 'd':
 	case 'i':
 		spec->flags |= SIGN;
 	case 'u':
+		if (fmt[1] == 'e') {
+			spec->flags |= ERROR;
+			++fmt;
+		}
 		break;
 
 	default:
@@ -1577,6 +1660,9 @@ qualifier:
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
  * %n is ignored
+ * %[idxXu]e will print the name of error code, if one exists.  If the number
+ *   doesn't match a known error code, it is printed as a normal signed int.
+ *   TODO: explain CONFIG_PRINTK_ERROR*
  *
  * ** Please update Documentation/printk-formats.txt when making changes **
  *
@@ -1738,6 +1824,9 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			}
 
 			str = number(str, end, num, spec);
+
+			if (spec.flags & ERROR)
+				str = error(str, end, num, spec);
 		}
 	}
 
@@ -2185,6 +2274,9 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			}
 
 			str = number(str, end, num, spec);
+
+			if (spec.flags & ERROR)
+				str = error(str, end, num, spec);
 		} /* default: */
 		} /* switch(spec.type) */
 	} /* while(*fmt) */
-- 
1.8.1.5

