Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031570Ab3HIXHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:07:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:10655 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031457Ab3HIXEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="378778933"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/13] x86: move __copy_*_nocache might fault check out of line
Date: Fri,  9 Aug 2013 16:04:19 -0700
Message-Id: <1376089460-5459-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Can as well do the normal conditional resched check out of line.
This saves one function call.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/uaccess_64.h   | 6 ++++--
 arch/x86/lib/copy_user_nocache_64.S | 7 +++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index b327057..831f4a3 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -243,12 +243,14 @@ __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 
 extern long __copy_user_nocache(void *dst, const void __user *src,
 				unsigned size, int zerorest);
+extern long __copy_user_nocache_might_fault(void *dst, const void __user *src,
+				unsigned size, int zerorest);
 
 static inline int
 __copy_from_user_nocache(void *dst, const void __user *src, unsigned size)
 {
-	might_fault();
-	return __copy_user_nocache(dst, src, size, 1);
+	might_fault_debug_only();
+	return __copy_user_nocache_might_fault(dst, src, size, 1);
 }
 
 static inline int
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index 6a4f43c..8e6b0bd 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -16,6 +16,7 @@
 #include <asm/thread_info.h>
 #include <asm/asm.h>
 #include <asm/smap.h>
+#include "user-common.h"
 
 	.macro ALIGN_DESTINATION
 #ifdef FIX_ALIGNMENT
@@ -43,6 +44,12 @@
 #endif
 	.endm
 
+ENTRY(__copy_user_nocache_might_fault)
+	CFI_STARTPROC
+	GET_THREAD_AND_SCHEDULE %rax
+	CFI_ENDPROC
+	/* fall through */
+
 /*
  * copy_user_nocache - Uncached memory copy with exception handling
  * This will force destination/source out of cache for more performance.
-- 
1.8.3.1

