Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3ITUfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:35:32 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:37054 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3ITUfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:35:30 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, Olof Johansson <olof@lixom.net>,
        Marko Katic <dromede@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] sharpsl_param.c: ARM: pxa: fix invalid memory access
Date: Fri, 20 Sep 2013 22:35:26 +0200
Message-Id: <1379709326-2988-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit 72662e01088394577be4a3f14da94cf87bea2591
ARM: head.S: only include __turn_mmu_on in the initial identity mapping

Zaurus PXA devices call sharpsl_save_param() during fixup and hang on
boot because memcpy refers to physical addresses no longer valid if the
MMU is setup.
Zaurus collie (SA1100) is unaffected (function is called in init_machine).

The code was making assumptions and for PXA the virtual address
should have been used before.

Signed-off-by: Marko Katic <dromede@gmail.com>
Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 arch/arm/common/sharpsl_param.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/sharpsl_param.c b/arch/arm/common/sharpsl_param.c
index d56c932..3490549 100644
--- a/arch/arm/common/sharpsl_param.c
+++ b/arch/arm/common/sharpsl_param.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <asm/mach/sharpsl_param.h>
+#include <asm/memory.h>
 
 /*
  * Certain hardware parameters determined at the time of device manufacture,
@@ -25,8 +26,10 @@
  */
 #ifdef CONFIG_ARCH_SA1100
 #define PARAM_BASE	0xe8ffc000
+#define param_start(x)	(void *)(x)
 #else
 #define PARAM_BASE	0xa0000a00
+#define param_start(x)	__va(x)
 #endif
 #define MAGIC_CHG(a,b,c,d) ( ( d << 24 ) | ( c << 16 )  | ( b << 8 ) | a )
 
@@ -41,7 +44,7 @@ EXPORT_SYMBOL(sharpsl_param);
 
 void sharpsl_save_param(void)
 {
-	memcpy(&sharpsl_param, (void *)PARAM_BASE, sizeof(struct sharpsl_param_info));
+	memcpy(&sharpsl_param, param_start(PARAM_BASE), sizeof(struct sharpsl_param_info));
 
 	if (sharpsl_param.comadj_keyword != COMADJ_MAGIC)
 		sharpsl_param.comadj=-1;
-- 
1.8.1.5

