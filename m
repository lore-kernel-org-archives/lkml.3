Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaBNV1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:27:22 -0500
Received: from mga09.intel.com ([134.134.136.24]:40906 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbaBNVWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="483680336"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/19] lto, workaround: Add workaround for initcall reordering
Date: Fri, 14 Feb 2014 22:21:28 +0100
Message-Id: <1392412903-25733-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Work around a LTO gcc problem: when there is no reference to a variable
in a module it will be moved to the end of the program. This causes
reordering of initcalls which the kernel does not like.
Add a dummy reference function to avoid this. The function is
deleted by the linker.

This replaces a previous much slower workaround.

Thanks to Honza Hubicka for suggesting this technique.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/init.h | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index e168880..a3ba270 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -163,6 +163,23 @@ extern bool initcall_debug;
 
 #ifndef __ASSEMBLY__
 
+#ifdef CONFIG_LTO
+/* Work around a LTO gcc problem: when there is no reference to a variable
+ * in a module it will be moved to the end of the program. This causes
+ * reordering of initcalls which the kernel does not like.
+ * Add a dummy reference function to avoid this. The function is
+ * deleted by the linker.
+ */
+#define LTO_REFERENCE_INITCALL(x) \
+	; /* yes this is needed */			\
+	static __used __exit void *reference_##x(void)	\
+	{						\
+		return &x;				\
+	}
+#else
+#define LTO_REFERENCE_INITCALL(x)
+#endif
+
 /* initcalls are now grouped by functionality into separate 
  * subsections. Ordering inside the subsections is determined
  * by link order. 
@@ -175,7 +192,8 @@ extern bool initcall_debug;
 
 #define __define_initcall(fn, id) \
 	static initcall_t __initcall_##fn##id __used \
-	__attribute__((__section__(".initcall" #id ".init"))) = fn
+	__attribute__((__section__(".initcall" #id ".init"))) = fn; \
+	LTO_REFERENCE_INITCALL(__initcall_##fn##id)
 
 /*
  * Early initcalls run before initializing SMP.
-- 
1.8.5.2

