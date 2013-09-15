Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3IOVrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 17:47:22 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:61334 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3IOVrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 17:47:21 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Marko Katic <dromede@gmail.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ARM: pxa: sharpsl_param.c: fix invalid memory access
Date: Sun, 15 Sep 2013 23:47:17 +0200
Message-Id: <1379281637-26854-1-git-send-email-andrea.adami@gmail.com>
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

Signed-off-by: Marko Katic <dromede@gmail.com>
Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 arch/arm/common/sharpsl_param.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm/common/sharpsl_param.c b/arch/arm/common/sharpsl_param.c
index d56c932..ac886f2 100644
--- a/arch/arm/common/sharpsl_param.c
+++ b/arch/arm/common/sharpsl_param.c
@@ -23,9 +23,17 @@
  * them early in the boot process, then pass them to the appropriate drivers.
  * Not all devices use all parameters but the format is common to all.
  */
+
+/* NOTE:
+ * Zaurus PXA devices call sharpsl_save_param() during fixup so we need
+ * to translate the physical address.
+ * Zaurus collie (SA1100) is unaffected (function is called in init_machine).
+ */
+
 #ifdef CONFIG_ARCH_SA1100
 #define PARAM_BASE	0xe8ffc000
 #else
+#include <asm/memory.h>
 #define PARAM_BASE	0xa0000a00
 #endif
 #define MAGIC_CHG(a,b,c,d) ( ( d << 24 ) | ( c << 16 )  | ( b << 8 ) | a )
@@ -41,7 +49,12 @@ EXPORT_SYMBOL(sharpsl_param);
 
 void sharpsl_save_param(void)
 {
-	memcpy(&sharpsl_param, (void *)PARAM_BASE, sizeof(struct sharpsl_param_info));
+#ifdef CONFIG_ARCH_SA1100
+	void *param_start = (void *)PARAM_BASE;
+#else
+	void *param_start = phys_to_virt(PARAM_BASE);
+#endif
+	memcpy(&sharpsl_param, param_start, sizeof(struct sharpsl_param_info));
 
 	if (sharpsl_param.comadj_keyword != COMADJ_MAGIC)
 		sharpsl_param.comadj=-1;
@@ -58,5 +71,3 @@ void sharpsl_save_param(void)
 	if (sharpsl_param.adadj_keyword != AD_MAGIC)
 		sharpsl_param.adadj=-1;
 }
-
-
-- 
1.8.1.5

