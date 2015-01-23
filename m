Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbbAWI3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 03:29:52 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:60258 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbbAWI3t convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 23 Jan 2015 03:29:49 -0500
Message-Id: <54C2148E02000078000588FB@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 23 Jan 2015 08:29:50 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <james.t.kukunas@linux.intel.com>, <neilb@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/raid6: correctly check for assembler capabilities
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like for AVX2 (which simply needs an #if -> #ifdef conversion),
SSSE3 assembler support should be checked for before using it.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: Neil Brown <neilb@suse.de>
---
 arch/x86/Makefile       |    1 +
 lib/raid6/algos.c       |    2 +-
 lib/raid6/recov_avx2.c  |    2 +-
 lib/raid6/recov_ssse3.c |    6 ++++++
 4 files changed, 9 insertions(+), 2 deletions(-)

--- 3.19-rc5/arch/x86/Makefile
+++ 3.19-rc5-raid6-SSSE3/arch/x86/Makefile
@@ -148,6 +148,7 @@ cfi-sections := $(call as-instr,.cfi_sec
 
 # does binutils support specific instructions?
 asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
+asinstr += $(call as-instr,pshufb %xmm0$(comma)%xmm0,-DCONFIG_AS_SSSE3=1)
 asinstr += $(call as-instr,crc32l %eax$(comma)%eax,-DCONFIG_AS_CRC32=1)
 avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
 avx2_instr :=$(call as-instr,vpbroadcastb %xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
--- 3.19-rc5/lib/raid6/algos.c
+++ 3.19-rc5-raid6-SSSE3/lib/raid6/algos.c
@@ -89,10 +89,10 @@ void (*raid6_datap_recov)(int, size_t, i
 EXPORT_SYMBOL_GPL(raid6_datap_recov);
 
 const struct raid6_recov_calls *const raid6_recov_algos[] = {
-#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
 #ifdef CONFIG_AS_AVX2
 	&raid6_recov_avx2,
 #endif
+#ifdef CONFIG_AS_SSSE3
 	&raid6_recov_ssse3,
 #endif
 	&raid6_recov_intx1,
--- 3.19-rc5/lib/raid6/recov_avx2.c
+++ 3.19-rc5-raid6-SSSE3/lib/raid6/recov_avx2.c
@@ -8,7 +8,7 @@
  * of the License.
  */
 
-#if CONFIG_AS_AVX2
+#ifdef CONFIG_AS_AVX2
 
 #include <linux/raid/pq.h>
 #include "x86.h"
--- 3.19-rc5/lib/raid6/recov_ssse3.c
+++ 3.19-rc5-raid6-SSSE3/lib/raid6/recov_ssse3.c
@@ -7,6 +7,8 @@
  * of the License.
  */
 
+#ifdef CONFIG_AS_SSSE3
+
 #include <linux/raid/pq.h>
 #include "x86.h"
 
@@ -330,3 +332,7 @@ const struct raid6_recov_calls raid6_rec
 #endif
 	.priority = 1,
 };
+
+#else
+#warning "your version of binutils lacks SSSE3 support"
+#endif



