Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3K2AAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:00:52 -0500
Received: from top.free-electrons.com ([176.31.233.9]:39635 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751410Ab3K2AAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:00:50 -0500
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        David Heidelberger <david.heidelberger@ixit.cz>
Subject: [PATCH v2] ARM: pxa: Move iotable mapping inside vmalloc region
Date: Thu, 28 Nov 2013 21:00:43 -0300
Message-Id: <1385683243-6688-1-git-send-email-ezequiel.garcia@free-electrons.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to remove the following ugly message:

  BUG: mapping for 0x00000000 at 0xff000000 out of vmalloc space

the iotable mappings should be re-located inside the vmalloc
region. Such move was introduced at commit:

commit 0536bdf33faff4d940ac094c77998cfac368cfff
Author: Nicolas Pitre <nicolas.pitre@linaro.org>
Date:   Thu Aug 25 00:35:59 2011 -0400

    ARM: move iotable mappings within the vmalloc region

While at it, condition the mapping to PXA25x and PXA27x, which
are the only platforms where it's used.

Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Heidelberger <david.heidelberger@ixit.cz>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
David,

Is it possible for you to give this a try on your board?

 arch/arm/mach-pxa/generic.c               | 6 ++++--
 arch/arm/mach-pxa/include/mach/hardware.h | 5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 4225417..3c1b4fa 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -83,11 +83,13 @@ static struct map_desc common_io_desc[] __initdata = {
 		.pfn		= __phys_to_pfn(0x40000000),
 		.length		= 0x02000000,
 		.type		= MT_DEVICE
+#if defined(CONFIG_PXA25x) || defined(CONFIG_PXA27x)
 	}, {	/* UNCACHED_PHYS_0 */
-		.virtual	= 0xff000000,
+		.virtual	= UNCACHED_PHYS_0,
 		.pfn		= __phys_to_pfn(0x00000000),
-		.length		= 0x00100000,
+		.length		= UNCACHED_SIZE,
 		.type		= MT_DEVICE
+#endif
 	}
 };
 
diff --git a/arch/arm/mach-pxa/include/mach/hardware.h b/arch/arm/mach-pxa/include/mach/hardware.h
index ccb06e4..b365a72 100644
--- a/arch/arm/mach-pxa/include/mach/hardware.h
+++ b/arch/arm/mach-pxa/include/mach/hardware.h
@@ -14,13 +14,14 @@
 #define __ASM_ARCH_HARDWARE_H
 
 #include <mach/addr-map.h>
+#include <asm/pgtable.h>
 
 /*
  * Workarounds for at least 2 errata so far require this.
  * The mapping is set in mach-pxa/generic.c.
  */
-#define UNCACHED_PHYS_0		0xff000000
-#define UNCACHED_ADDR		UNCACHED_PHYS_0
+#define UNCACHED_PHYS_0		(VMALLOC_END - UNCACHED_SIZE)
+#define UNCACHED_SIZE		SZ_1M
 
 /*
  * Intel PXA2xx internal register mapping:
-- 
1.8.1.5

