Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab3CDEuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:50:10 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45256 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3CDEuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 23:50:08 -0500
X-AuditID: 9c93016f-b7c56ae00000569b-07-513427fe3d84
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC PATCH] ARM: mm: disable kmap_high_get() for SMP
Date: Mon,  4 Mar 2013 13:51:07 +0900
Message-Id: <1362372667-953-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With SMP and enabling kmap_high_get(), it makes users of kmap_atomic()
sequential ordered, because kmap_high_get() use global kmap_lock().
It is not welcome situation, so turn off this optimization for SMP.

Cc: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
index 8c5e828..82fea0f 100644
--- a/arch/arm/include/asm/highmem.h
+++ b/arch/arm/include/asm/highmem.h
@@ -26,15 +26,13 @@ extern void kunmap_high(struct page *page);
  * The reason for kmap_high_get() is to ensure that the currently kmap'd
  * page usage count does not decrease to zero while we're using its
  * existing virtual mapping in an atomic context.  With a VIVT cache this
- * is essential to do, but with a VIPT cache this is only an optimization
- * so not to pay the price of establishing a second mapping if an existing
- * one can be used.  However, on platforms without hardware TLB maintenance
- * broadcast, we simply cannot use ARCH_NEEDS_KMAP_HIGH_GET at all since
- * the locking involved must also disable IRQs which is incompatible with
- * the IPI mechanism used by global TLB operations.
+ * is essential to do, but with a VIPT cache this is only an optimization.
+ * With SMP and enabling kmap_high_get(), it makes users of kmap_atomic()
+ * sequential ordered, because kmap_high_get() use global kmap_lock().
+ * It is not welcome situation, so turn off this optimization for SMP.
  */
 #define ARCH_NEEDS_KMAP_HIGH_GET
-#if defined(CONFIG_SMP) && defined(CONFIG_CPU_TLB_V6)
+#if defined(CONFIG_SMP)
 #undef ARCH_NEEDS_KMAP_HIGH_GET
 #if defined(CONFIG_HIGHMEM) && defined(CONFIG_CPU_CACHE_VIVT)
 #error "The sum of features in your kernel config cannot be supported together"
-- 
1.7.9.5

