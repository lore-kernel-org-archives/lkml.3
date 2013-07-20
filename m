Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab3GTXIX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 19:08:23 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47189 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755238Ab3GTXHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 19:07:53 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Marko Katic <dromede@gmail.com>
Subject: [PATCH] pxa: sharpsl_param: fix invalid memory access in sharpsl_save_param()
Date: Sun, 21 Jul 2013 01:07:50 +0200
Message-Id: <1374361670-3214-1-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marko Katic <dromede@gmail.com>

Unbreak kernel boot (tested with kexecboot)

Patch was sent twice upstrream:
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-December/137284.html
Devices that call sharpsl_save_param() will hang on boot due to
a memcpy call that uses a physical address that is no longer * accessible. Fix
his by converting the physical address into a virtual one.

Signed-off-by: Marko Katic <dromede@gmail.com>
[andrea.adami@gmail.com: checkpatch.pl dislikes void * param_start]
Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 arch/arm/common/sharpsl_param.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/sharpsl_param.c b/arch/arm/common/sharpsl_param.c
index d56c932..b70b13a 100644
--- a/arch/arm/common/sharpsl_param.c
+++ b/arch/arm/common/sharpsl_param.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <asm/memory.h>
 #include <asm/mach/sharpsl_param.h>
 
 /*
@@ -41,7 +42,8 @@ EXPORT_SYMBOL(sharpsl_param);
 
 void sharpsl_save_param(void)
 {
-	memcpy(&sharpsl_param, (void *)PARAM_BASE, sizeof(struct sharpsl_param_info));
+	void *param_start = phys_to_virt(PARAM_BASE);
+	memcpy(&sharpsl_param, param_start, sizeof(struct sharpsl_param_info));
 
 	if (sharpsl_param.comadj_keyword != COMADJ_MAGIC)
 		sharpsl_param.comadj=-1;
-- 
1.8.1.5

