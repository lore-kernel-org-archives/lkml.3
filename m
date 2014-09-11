Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaIKVoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:44:54 -0400
Received: from mail-ee0-f73.google.com ([74.125.83.73]:36277 "EHLO
	mail-ee0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaIKVow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:44:52 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2014 17:44:52 EDT
From: Michal Nazarewicz <mina86@mina86.com>
To: Mark Rustad <mark.d.rustad@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 2/2] kernel.h: use __COUNTER__ in min and max macros to avoid -Wshadow warnings
Date: Thu, 11 Sep 2014 23:39:36 +0200
Message-Id: <1410471576-12053-2-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410471576-12053-1-git-send-email-mina86@mina86.com>
References: <1410471576-12053-1-git-send-email-mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because min and max macros use the same variable names no matter
how many times they are called (or how deep the nesting of their
calls), each time min or max calls are nested, the same variables
are declared.  This is especially noisy after min3 and max3 have
been changed to nest min/max calls.

Using __COUNTER__ solves the problem since each variable will get
a unique number aadded to it.  The code will still work even if
the compiler does not support __COUNTER__, but then the protection
from shadow warning won't work.

The same applies to min_t and max_t macros.

Reported-by: Rustad, Mark D <mark.d.rustad@intel.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/linux/kernel.h | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

On Thu, Sep 04 2014, "Rustad, Mark D" <mark.d.rustad@intel.com> wrote:
> W=2 builds get warnings when a min/max macro is used as a parameter to
> min3/max3. If you move to the min3/max3 that makes nested calls to
> min/max, every reference to min3/max3 will generate a warning in W=2
> builds no matter what.

This gets rid of sparse warnings.  Compile tested only.

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8e24054..b7e4d6f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -695,15 +695,27 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #endif /* CONFIG_TRACING */
 
 /*
+ * Preprocessor magic generating unique identifiers to avoid -Wshadow warnings
+ * used by min, max, min_t and max_t macros.  cnt is __COUNTER__, op is the
+ * comparison operator; tx (ty) is type of the first (second) argument,
+ * xx (yy) is name of a temporary variable to hold the first (second) argument,
+ * and x (y) is the first (second) argument.
+ */
+#define _min_max_var(cnt, base) _mm_ ## cnt ## base
+#define _min_max__(op, tx, xx, x, ty, yy, y) ({		\
+	tx xx = (x);					\
+	ty yy = (y);					\
+	(void) (&xx == &yy);				\
+	xx op yy ? xx : yy; })
+#define _min_max_(cnt, op, tx, x, ty, y)		\
+	_min_max__(op, tx, _min_max_var(cnt, a), x, ty, _min_max_var(cnt, b), y)
+#define _min_max(...) _min_max_(__COUNTER__, __VA_ARGS__)
+
+/*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.
  */
-#define _min_max(op, tx, x, ty, y) ({	\
-	tx _xx = (x);			\
-	ty _yy = (y);			\
-	(void) (&_xx == &_yy);		\
-	_xx op _yy ? _xx : _yy; })
 
 #define min(x, y) _min_max(<, typeof(x), x, typeof(y), y)
 #define max(x, y) _min_max(>, typeof(x), x, typeof(y), y)
-- 
2.1.0.rc2.206.gedb03e5

