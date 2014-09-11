Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaIKVpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 17:45:44 -0400
Received: from mail-we0-f202.google.com ([74.125.82.202]:45632 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaIKVpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 17:45:43 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Mark Rustad <mark.d.rustad@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 1/2] include: kernel.h: deduplicate code implementing min*, max* and clamp* macros
Date: Thu, 11 Sep 2014 23:39:35 +0200
Message-Id: <1410471576-12053-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <E40EB38B-3532-4856-AF83-4709D32F71D5@intel.com>
References: <E40EB38B-3532-4856-AF83-4709D32F71D5@intel.com>
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apart from temporary variable names, min and max macros have only one
difference -- the operator used to compare the arguments.  Furthermore,
min and min_t differ only in the type used for the temporary variables.
Same with max and max_t.  All of those macros can be trivially folded
into a single generic implementation which takes the operator used and
type of the arguments.

Furthermore, similarly to how clamp uses min(max(…), …) call, clamp_t
can be simplified to do the same but with min_t(max_t(…), …).  And
finally, clamp_val is just a special case of clamp_t where type is
typeof(val).

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/linux/kernel.h | 54 ++++++++++++++++----------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

This has been compile tested only.

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 0588802..8e24054 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -699,17 +699,14 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
  * strict type-checking.. See the
  * "unnecessary" pointer comparison.
  */
-#define min(x, y) ({				\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	(void) (&_min1 == &_min2);		\
-	_min1 < _min2 ? _min1 : _min2; })
-
-#define max(x, y) ({				\
-	typeof(x) _max1 = (x);			\
-	typeof(y) _max2 = (y);			\
-	(void) (&_max1 == &_max2);		\
-	_max1 > _max2 ? _max1 : _max2; })
+#define _min_max(op, tx, x, ty, y) ({	\
+	tx _xx = (x);			\
+	ty _yy = (y);			\
+	(void) (&_xx == &_yy);		\
+	_xx op _yy ? _xx : _yy; })
+
+#define min(x, y) _min_max(<, typeof(x), x, typeof(y), y)
+#define max(x, y) _min_max(>, typeof(x), x, typeof(y), y)
 
 #define min3(x, y, z) min((typeof(x))min(x, y), z)
 #define max3(x, y, z) max((typeof(x))max(x, y), z)
@@ -730,7 +727,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of min/max to make sure they are of the
+ * This macro does strict typechecking of lo/hi to make sure they are of the
  * same type as val.  See the unnecessary pointer comparisons.
  */
 #define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
@@ -741,50 +738,33 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
  *
  * Or not use min/max/clamp at all, of course.
  */
-#define min_t(type, x, y) ({			\
-	type __min1 = (x);			\
-	type __min2 = (y);			\
-	__min1 < __min2 ? __min1: __min2; })
-
-#define max_t(type, x, y) ({			\
-	type __max1 = (x);			\
-	type __max2 = (y);			\
-	__max1 > __max2 ? __max1: __max2; })
+#define min_t(type, x, y) _min_max(<, type, x, type, y)
+#define max_t(type, x, y) _min_max(>, type, x, type, y)
 
 /**
  * clamp_t - return a value clamped to a given range using a given type
  * @type: the type of variable to use
  * @val: current value
- * @min: minimum allowable value
- * @max: maximum allowable value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
  *
  * This macro does no typechecking and uses temporary variables of type
  * 'type' to make all the comparisons.
  */
-#define clamp_t(type, val, min, max) ({		\
-	type __val = (val);			\
-	type __min = (min);			\
-	type __max = (max);			\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+#define clamp_t(type, val, lo, hi) min_t(type, max_t(type, val, lo), hi)
 
 /**
  * clamp_val - return a value clamped to a given range using val's type
  * @val: current value
- * @min: minimum allowable value
- * @max: maximum allowable value
+ * @lo: minimum allowable value
+ * @hi: maximum allowable value
  *
  * This macro does no typechecking and uses temporary variables of whatever
  * type the input argument 'val' is.  This is useful when val is an unsigned
  * type and min and max are literals that will otherwise be assigned a signed
  * integer type.
  */
-#define clamp_val(val, min, max) ({		\
-	typeof(val) __val = (val);		\
-	typeof(val) __min = (min);		\
-	typeof(val) __max = (max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+#define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
 
 /*
-- 
2.1.0.rc2.206.gedb03e5

