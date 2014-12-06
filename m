Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaLFBSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 20:18:05 -0500
Received: from ns.horizon.com ([71.41.210.147]:47573 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751141AbaLFBSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 20:18:04 -0500
Date: 5 Dec 2014 20:18:02 -0500
Message-ID: <20141206011802.19570.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org
Subject: [PATCH] [PATCH] VERIFY_OCTAL_PERMISSIONS: Move to <linux/sysfs.h> where it belongs
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        rusty@rustcorp.com.au
In-Reply-To: <20141205161548.dfa3bc0648b2109ebed9b1ae@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> VERIFY_OCTAL_PERMISSIONS() sticks out like a sore thumb in kernel.h. 
> How about we move it into sysfs.h?

Something like this, you mean?

The <linux/types.h> in moduleparam.h is needed for one function
prototype that passes s16 parameters.  My first reaction is
to wonder if that can be gotten rid of, too.

-----
It's the only user of <linux/bug.h> in kernel.h, so that reduces
the compile-time cost of #include <linux/kernel.h>

One necessary consequent change in <linux/moduleparam.h>.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: George Spelvin <linux@horizon.com>
---
 include/linux/kernel.h      | 10 ----------
 include/linux/sysfs.h       | 11 +++++++++++
 include/linux/moduleparam.h |  4 ++--
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 3d770f55..07080aa2 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -804,14 +804,4 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
 #endif
 
-/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
-#define VERIFY_OCTAL_PERMISSIONS(perms)					\
-	(BUILD_BUG_ON_ZERO((perms) < 0) +				\
-	 BUILD_BUG_ON_ZERO((perms) > 0777) +				\
-	 /* User perms >= group perms >= other perms */			\
-	 BUILD_BUG_ON_ZERO(((perms) >> 6) < (((perms) >> 3) & 7)) +	\
-	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 7) < ((perms) & 7)) +	\
-	 /* Other writable?  Generally considered a bad idea. */	\
-	 BUILD_BUG_ON_ZERO((perms) & 2) +				\
-	 (perms))
 #endif
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f97d0dbb..9f213542 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -70,6 +70,17 @@ struct attribute_group {
  * for examples..
  */
 
+/* Permissions on a sysfs file: you didn't miss the 0 prefix did you? */
+#define VERIFY_OCTAL_PERMISSIONS(perms)					\
+	(BUILD_BUG_ON_ZERO((perms) < 0) +				\
+	 BUILD_BUG_ON_ZERO((perms) > 0777) +				\
+	 /* User perms >= group perms >= other perms */			\
+	 BUILD_BUG_ON_ZERO(((perms) >> 6) < (((perms) >> 3) & 7)) +	\
+	 BUILD_BUG_ON_ZERO((((perms) >> 3) & 7) < ((perms) & 7)) +	\
+	 /* Other writable?  Generally considered a bad idea. */	\
+	 BUILD_BUG_ON_ZERO((perms) & 2) +				\
+	 (perms))
+
 #define __ATTR(_name, _mode, _show, _store) {				\
 	.attr = {.name = __stringify(_name),				\
 		 .mode = VERIFY_OCTAL_PERMISSIONS(_mode) },		\
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 1c9effa2..974097df 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -1,9 +1,9 @@
 #ifndef _LINUX_MODULE_PARAMS_H
 #define _LINUX_MODULE_PARAMS_H
 /* (C) Copyright 2001, 2002 Rusty Russell IBM Corporation */
-#include <linux/init.h>
 #include <linux/stringify.h>
-#include <linux/kernel.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
 
 /* You can override this manually, but generally this should match the
    module name. */
-- 
2.1.3
