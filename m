Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaGGPWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:22:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:54407 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbaGGPWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:22:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,618,1400050800"; 
   d="scan'208";a="566223805"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W . Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 04/10] lib/vsprintf: add %*pE[achnops] format specifier
Date: Mon,  7 Jul 2014 18:21:46 +0300
Message-Id: <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows user to print a given buffer as esaped string. The rules applied
accordingly to the mix of the flags provided by additional format letters.

For example, if the given buffer:

	1b 62 20 5c 43 07 22 90 0d 5d

The result strings could be:
	%*pE            "\eb \C\a"\220\r]"
	%*pEhp          "\x1bb \C\x07"\x90\x0d]"
	%*pEa           "\e\142\040\\\103\a\042\220\r\135"

Please, read Documentation/printk-formats.txt and lib/string_helpers.c kernel
documentation to get further information.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Suggested-by: Joe Perches <joe@perches.com>
---
 Documentation/printk-formats.txt | 28 ++++++++++++++++
 lib/vsprintf.c                   | 72 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 3b56a99..e2dc566 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -70,6 +70,34 @@ DMA addresses types dma_addr_t:
 	For printing a dma_addr_t type which can vary based on build options,
 	regardless of the width of the CPU data path. Passed by reference.
 
+Raw buffer as an escaped string:
+
+	%*pE[achnops]
+
+	For printing raw buffer as an escaped string. For the following buffer
+
+		1b 62 20 5c 43 07 22 90 0d 5d
+
+	few examples show how the conversion could be done (the result string
+	without embraced quotes):
+
+		%*pE		"\eb \C\a"\220\r]"
+		%*pEhp		"\x1bb \C\x07"\x90\x0d]"
+		%*pEa		"\e\142\040\\\103\a\042\220\r\135"
+
+	The converion rules are defined by combination of the following flags
+	(see string_escape_mem() kernel documentation for the details):
+		a - ESCAPE_ANY
+		c - ESCAPE_SPECIAL
+		h - ESCAPE_HEX
+		n - ESCAPE_NULL
+		o - ESCAPE_OCTAL
+		p - ESCAPE_NP
+		s - ESCAPE_SPACE
+	By default ESCAPE_ANY_NP is used.
+
+	If field width is ommited the 1 byte only will be escaped.
+
 Raw buffer as a hex string:
 	%*ph	00 01 02  ...  3f
 	%*phC	00:01:02: ... :3f
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 0eced40..6913046 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -33,6 +33,7 @@
 #include <asm/page.h>		/* for PAGE_SIZE */
 #include <asm/sections.h>	/* for dereference_function_descriptor() */
 
+#include <linux/string_helpers.h>
 #include "kstrtox.h"
 
 /**
@@ -1101,6 +1102,63 @@ char *ip4_addr_string_sa(char *buf, char *end, const struct sockaddr_in *sa,
 }
 
 static noinline_for_stack
+char *escaped_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
+		     const char *fmt)
+{
+	bool found = true;
+	int count = 1;
+	unsigned int flags = 0;
+	int len;
+
+	if (spec.field_width == 0)
+		/* nothing to print */
+		return buf;
+
+	if (ZERO_OR_NULL_PTR(addr))
+		/* NULL pointer */
+		return string(buf, end, NULL, spec);
+
+	do {
+		switch (fmt[count++]) {
+		case 'a':
+			flags |= ESCAPE_ANY;
+			break;
+		case 'c':
+			flags |= ESCAPE_SPECIAL;
+			break;
+		case 'h':
+			flags |= ESCAPE_HEX;
+			break;
+		case 'n':
+			flags |= ESCAPE_NULL;
+			break;
+		case 'o':
+			flags |= ESCAPE_OCTAL;
+			break;
+		case 'p':
+			flags |= ESCAPE_NP;
+			break;
+		case 's':
+			flags |= ESCAPE_SPACE;
+			break;
+		default:
+			found = false;
+			break;
+		}
+	} while (found);
+
+	if (!flags)
+		flags = ESCAPE_ANY_NP;
+
+	len = spec.field_width < 0 ? 1 : spec.field_width;
+
+	/* Ignore the error. We print as many characters as we can */
+	string_escape_mem(addr, len, &buf, end - buf, flags, NULL);
+
+	return buf;
+}
+
+static noinline_for_stack
 char *uuid_string(char *buf, char *end, const u8 *addr,
 		  struct printf_spec spec, const char *fmt)
 {
@@ -1236,6 +1294,17 @@ int kptr_restrict __read_mostly;
  * - '[Ii][4S][hnbl]' IPv4 addresses in host, network, big or little endian order
  * - 'I[6S]c' for IPv6 addresses printed as specified by
  *       http://tools.ietf.org/html/rfc5952
+ * - 'E[achnops]' For an escaped buffer, where rules are defined by combination
+ *                of the following flags (see string_escape_mem() for the
+ *                details):
+ *                  a - ESCAPE_ANY
+ *                  c - ESCAPE_SPECIAL
+ *                  h - ESCAPE_HEX
+ *                  n - ESCAPE_NULL
+ *                  o - ESCAPE_OCTAL
+ *                  p - ESCAPE_NP
+ *                  s - ESCAPE_SPACE
+ *                By default ESCAPE_ANY_NP is used.
  * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
  *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  *       Options for %pU are:
@@ -1337,6 +1406,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			}}
 		}
 		break;
+	case 'E':
+		return escaped_string(buf, end, ptr, spec, fmt);
 	case 'U':
 		return uuid_string(buf, end, ptr, spec, fmt);
 	case 'V':
@@ -1651,6 +1722,7 @@ qualifier:
  * %piS depending on sa_family of 'struct sockaddr *' print IPv4/IPv6 address
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
+ * %*pE[achnops] print an escaped buffer
  * %*ph[CDN] a variable-length hex string with a separator (supports up to 64
  *           bytes of the input)
  * %n is ignored
-- 
2.0.1

