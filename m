Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab3KXMgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 07:36:09 -0500
Received: from top.free-electrons.com ([176.31.233.9]:41342 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795Ab3KXMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 07:36:04 -0500
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: linux@arm.linux.org.uk, eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [PATCH] ARM: pxa: Move iotable mapping inside vmalloc region
Date: Sun, 24 Nov 2013 09:36:11 -0300
Message-Id: <1385296571-23599-1-git-send-email-ezequiel.garcia@free-electrons.com>
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

While at it, let's add some nicer defines to make the code
more readable.

Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 arch/arm/mach-pxa/generic.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 4225417..7c01095 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -24,6 +24,7 @@
 #include <mach/hardware.h>
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
+#include <asm/pgtable.h>
 
 #include <mach/reset.h>
 #include <mach/smemc.h>
@@ -77,6 +78,11 @@ EXPORT_SYMBOL(get_clk_frequency_khz);
  * Note: virtual 0xfffe0000-0xffffffff is reserved for the vector table
  *       and cache flush area.
  */
+
+#define UNCACHED_PHY	0x00000000
+#define UNCACHED_SIZE	SZ_1M
+#define UNCACHED_VIRT	(VMALLOC_END - UNCACHED_SIZE)
+
 static struct map_desc common_io_desc[] __initdata = {
   	{	/* Devs */
 		.virtual	=  0xf2000000,
@@ -84,9 +90,9 @@ static struct map_desc common_io_desc[] __initdata = {
 		.length		= 0x02000000,
 		.type		= MT_DEVICE
 	}, {	/* UNCACHED_PHYS_0 */
-		.virtual	= 0xff000000,
-		.pfn		= __phys_to_pfn(0x00000000),
-		.length		= 0x00100000,
+		.virtual	= UNCACHED_VIRT,
+		.pfn		= __phys_to_pfn(UNCACHED_PHY),
+		.length		= UNCACHED_SIZE,
 		.type		= MT_DEVICE
 	}
 };
-- 
1.8.1.5

