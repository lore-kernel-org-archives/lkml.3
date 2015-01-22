Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbbAVHSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:18:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:54481 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbAVHSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:18:07 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-fb-54c0a39a2f1f
From: Sergey Dyasly <s.dyasly@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Dyasly <s.dyasly@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        James Bottomley <JBottomley@parallels.com>,
        Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Safonov <d.safonov@partner.samsung.com>
Subject: [PATCH] ARM: use default ioremap alignment for SMP or LPAE
Date: Thu, 22 Jan 2015 10:17:55 +0300
Message-id: <1421911075-8814-1-git-send-email-s.dyasly@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xa7qzFh8IMXjRKmExZ/0aNouVPd4W
	75f1MFp8WvmUzeLgjW/sFpd6l7BabHp8jdXi8q45bBb31vxntbh9mdfi07N/7BaTZ0tZvPx4
	gsWB12PNvDWMHi3NPWwemz5NYve4c20Pm8eJGb9ZPDYvqfd4vNfS4+S8n2weB9/tYfLo27KK
	0ePzJrkA7igum5TUnMyy1CJ9uwSujAN7e1gLOnkqtp/YytTAuISri5GDQ0LAROLQDJcuRk4g
	U0ziwr31bCC2kMBSRolD5+W7GLmA7ElMEvu/zGQCSbAJaEmcXbydGcQWEdCQmNL1mB2kiFng
	NrPEnI+/WUASwgLOEv/OPQRrYBFQlXhwdQ9YnBcoPuHESRaIxQoScybZTGDkXsDIsIpRNLU0
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjJCC/7GBcfMzqEKMAB6MSD29F6P4QIdbEsuLK3EOMEhzM
	SiK8HhoHQoR4UxIrq1KL8uOLSnNSiw8xMnFwSjUwrrhQVMDSZslVfWBzOfN/sUnBNWav/6ho
	hAe6Lzvk7bdIfubmffLdYXwijtOe7f0QvHpp66psxXotty3pRus3PjyzTq3r2oEu0UPHWsvs
	XwpskezNUbo788W0OdvyDs1uslS2bxM6ZNyk1tZ64JfLq8oVz8tZ07SnHG0N4ZNb+1fVxXPz
	huP8SizFGYmGWsxFxYkAE6c2ySYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16MB alignment for ioremap mappings was added by commit a069c896d0d6 ("[ARM]
3705/1: add supersection support to ioremap()") in order to support supersection
mappings. But __arm_ioremap_pfn_caller uses section and supersection mappings
only in !SMP && !LPAE case. There is no need for such big alignment if either
SMP or LPAE is enabled.

After this change, ioremap will use default maximum alignment of 128 pages.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Safonov <d.safonov@partner.samsung.com>
Link: https://lkml.kernel.org/g/1419328813-2211-1-git-send-email-d.safonov@partner.samsung.com
Signed-off-by: Sergey Dyasly <s.dyasly@samsung.com>
---
 arch/arm/include/asm/memory.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 184def0..c3ef139 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -78,10 +78,12 @@
  */
 #define XIP_VIRT_ADDR(physaddr)  (MODULES_VADDR + ((physaddr) & 0x000fffff))
 
+#if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 /*
  * Allow 16MB-aligned ioremap pages
  */
 #define IOREMAP_MAX_ORDER	24
+#endif
 
 #else /* CONFIG_MMU */
 
-- 
1.7.9.5

