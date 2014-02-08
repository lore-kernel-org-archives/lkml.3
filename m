Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaBHICP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:02:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:2453 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbaBHICN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:02:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="471776735"
From: Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 02/17] x86, lto: Disable fancy hweight optimizations for LTO v2
Date: Sat,  8 Feb 2014 09:01:06 +0100
Message-Id: <1391846481-31491-2-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fancy x86 hweight uses different compiler options for the
hweight file. This does not work with LTO. Just disable the optimization
with LTO

v2: Simplify Kconfig checks (Jan Beulich)
Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig                    | 1 +
 arch/x86/include/asm/arch_hweight.h | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 940e50e..f125c5f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -255,6 +255,7 @@ config X86_32_LAZY_GS
 
 config ARCH_HWEIGHT_CFLAGS
 	string
+	default "" if LTO
 	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
 	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
 
diff --git a/arch/x86/include/asm/arch_hweight.h b/arch/x86/include/asm/arch_hweight.h
index 9686c3d..ca80549 100644
--- a/arch/x86/include/asm/arch_hweight.h
+++ b/arch/x86/include/asm/arch_hweight.h
@@ -25,9 +25,14 @@ static inline unsigned int __arch_hweight32(unsigned int w)
 {
 	unsigned int res = 0;
 
+#ifdef CONFIG_LTO
+	res  = __sw_hweight32(w);
+#else
+
 	asm (ALTERNATIVE("call __sw_hweight32", POPCNT32, X86_FEATURE_POPCNT)
 		     : "="REG_OUT (res)
 		     : REG_IN (w));
+#endif
 
 	return res;
 }
@@ -46,6 +51,9 @@ static inline unsigned long __arch_hweight64(__u64 w)
 {
 	unsigned long res = 0;
 
+#ifdef CONFIG_LTO
+	res = __sw_hweight64(w);
+#else
 #ifdef CONFIG_X86_32
 	return  __arch_hweight32((u32)w) +
 		__arch_hweight32((u32)(w >> 32));
@@ -54,6 +62,7 @@ static inline unsigned long __arch_hweight64(__u64 w)
 		     : "="REG_OUT (res)
 		     : REG_IN (w));
 #endif /* CONFIG_X86_32 */
+#endif
 
 	return res;
 }
-- 
1.8.5.2

