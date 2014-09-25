Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaIYPuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:50:24 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:48976 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaIYPuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:50:22 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Rustad <mark.d.rustad@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] include: kernel.h: deduplicate code implementing clamp* macros
Date: Thu, 25 Sep 2014 17:50:11 +0200
Message-Id: <1411660211-8303-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1410471576-12053-1-git-send-email-mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding clamp_t macro min_t and max_t the way clamp
macro does and instead of open-coding clamp_val simply use clamp_t.
Furthermore, normalise argument naming in the macros to be lo and
hi.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 include/linux/kernel.h | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

This is an exceprt from the other bigger patch which had some
controversy I assume because of the way it reimplemented min and max.
This only contains refactoring of clamp which I believe should be
uncontroversial.

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index c39c69d..40728cf 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -731,7 +731,7 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of min/max to make sure they are of the
+ * This macro does strict typechecking of lo/hi to make sure they are of the
  * same type as val.  See the unnecessary pointer comparisons.
  */
 #define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
@@ -756,36 +756,26 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
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

