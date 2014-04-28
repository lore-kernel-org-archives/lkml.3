Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaD1A1t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 20:27:49 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:55328 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaD1A1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 20:27:48 -0400
From: Matt Porter <mporter@linaro.org>
To: Russell King <linux@arm.linux.org.uk>, Barry Song <baohua@kernel.org>
Cc: Kevin Hilman <khilman@linaro.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: l2c: prima2: only call l2x0_of_init() on matching nodes
Date: Sun, 27 Apr 2014 20:27:40 -0400
Message-Id: <1398644860-22973-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

l2x0_of_init() is executed unconditionally within the sirfsoc_l2x0_init()
early initcall. In a multi v7 kernel this causes bcm281xx and bcm21664
platform to fail boot since they have their own pre l2x0 init sequence
that is required. Fix this by checking that a matching OF ID is present
before calling l2x0_of_init().

Reported-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Matt Porter <mporter@linaro.org>
---
Applies against next-20140424 to fix the issue introduced in
50655e6 ARM: l2c: prima2: remove cache size override

 arch/arm/mach-prima2/l2x0.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-prima2/l2x0.c b/arch/arm/mach-prima2/l2x0.c
index 09f68f0..1c2ed15 100644
--- a/arch/arm/mach-prima2/l2x0.c
+++ b/arch/arm/mach-prima2/l2x0.c
@@ -8,10 +8,24 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/of.h>
 #include <asm/hardware/cache-l2x0.h>
 
+static const struct of_device_id sirf_l2x0_ids[] __initconst = {
+	{ .compatible = "sirf,prima2-pl310-cache" },
+	{ .compatible = "sirf,marco-pl310-cache" },
+	{},
+};
+
 static int __init sirfsoc_l2x0_init(void)
 {
-	return l2x0_of_init(0, ~0);
+	struct device_node *np;
+	int ret = -EINVAL;
+
+	np = of_find_matching_node(NULL, sirf_l2x0_ids);
+	if (np)
+		ret = l2x0_of_init(0, ~0);
+
+	return ret;
 }
 early_initcall(sirfsoc_l2x0_init);
-- 
1.8.3.2

