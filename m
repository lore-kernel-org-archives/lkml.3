Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaGBNUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:20:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:15862 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbaGBNUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:20:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,588,1400050800"; 
   d="scan'208";a="537740202"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/6] lib / string_helpers: clean up test suite
Date: Wed,  2 Jul 2014 16:20:24 +0300
Message-Id: <1404307229-19186-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares test suite for a following update. It introduces
test_string_check_buf() helper which checks the result and dumps an error.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/test-string_helpers.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/lib/test-string_helpers.c b/lib/test-string_helpers.c
index 6ac48de..ea86e02 100644
--- a/lib/test-string_helpers.c
+++ b/lib/test-string_helpers.c
@@ -10,6 +10,26 @@
 #include <linux/string.h>
 #include <linux/string_helpers.h>
 
+static __init bool test_string_check_buf(const char *name, unsigned int flags,
+					 char *in, size_t p,
+					 char *out_real, size_t q_real,
+					 char *out_test, size_t q_test)
+{
+	if (q_real == q_test && !memcmp(out_test, out_real, q_test))
+		return true;
+
+	pr_err("Test '%s' failed: flags = %u\n", name, flags);
+
+	print_hex_dump(KERN_WARNING, "Input: ", DUMP_PREFIX_NONE, 16, 1,
+		       in, p, true);
+	print_hex_dump(KERN_WARNING, "Expected: ", DUMP_PREFIX_NONE, 16, 1,
+		       out_test, q_test, true);
+	print_hex_dump(KERN_WARNING, "Got: ", DUMP_PREFIX_NONE, 16, 1,
+		       out_real, q_real, true);
+
+	return false;
+}
+
 struct test_string {
 	const char *in;
 	const char *out;
@@ -39,7 +59,8 @@ static const struct test_string strings[] __initconst = {
 	},
 };
 
-static void __init test_string_unescape(unsigned int flags, bool inplace)
+static void __init test_string_unescape(const char *name, unsigned int flags,
+					bool inplace)
 {
 	char in[256];
 	char out_test[256];
@@ -77,15 +98,8 @@ static void __init test_string_unescape(unsigned int flags, bool inplace)
 		q_real = string_unescape(in, out_real, q_real, flags);
 	}
 
-	if (q_real != q_test || memcmp(out_test, out_real, q_test)) {
-		pr_warn("Test failed: flags = %u\n", flags);
-		print_hex_dump(KERN_WARNING, "Input: ",
-			       DUMP_PREFIX_NONE, 16, 1, in, p - 1, true);
-		print_hex_dump(KERN_WARNING, "Expected: ",
-			       DUMP_PREFIX_NONE, 16, 1, out_test, q_test, true);
-		print_hex_dump(KERN_WARNING, "Got: ",
-			       DUMP_PREFIX_NONE, 16, 1, out_real, q_real, true);
-	}
+	test_string_check_buf(name, flags, in, p - 1, out_real, q_real,
+			      out_test, q_test);
 }
 
 static int __init test_string_helpers_init(void)
@@ -94,8 +108,9 @@ static int __init test_string_helpers_init(void)
 
 	pr_info("Running tests...\n");
 	for (i = 0; i < UNESCAPE_ANY + 1; i++)
-		test_string_unescape(i, false);
-	test_string_unescape(get_random_int() % (UNESCAPE_ANY + 1), true);
+		test_string_unescape("unescape", i, false);
+	test_string_unescape("unescape inplace",
+			     get_random_int() % (UNESCAPE_ANY + 1), true);
 
 	return -EINVAL;
 }
-- 
2.0.0

