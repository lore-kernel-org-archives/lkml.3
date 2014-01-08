Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbaAHMx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:53:29 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:56413 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664AbaAHMx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:53:27 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] driver-core: platform: Resolve DT interrupt references late
Date: Wed,  8 Jan 2014 13:51:17 +0100
Message-Id: <1389185477-507-1-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <20140108011957.GK5074@atomide.com>
References: <20140108011957.GK5074@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When devices are probed from the device tree, any interrupts that they
reference are resolved at device creation time. This causes problems if
the interrupt provider hasn't been registered yet at that time, which
results in the interrupt being set to 0.

This is especially bad for platform devices because they are created at
a very early stage during boot when the majority of interrupt providers
haven't had a chance to be probed yet. One of the platform where this
causes major issues is OMAP.

Note that this patch is the easy way out to fix a large part of the
problems for now. A more proper solution for the long term would be to
transition drivers to an API that always resolves resources of any kind
(not only interrupts) at probe time.

For some background and discussion on possible solutions, see:

	https://lkml.org/lkml/2013/11/22/520

Acked-by: Rob Herring <robherring2@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Note that this is somewhat urgent and should if at all possible go into
v3.13 before the release.

 drivers/base/platform.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 3a94b799f166..c894d1af3a5e 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -13,6 +13,7 @@
 #include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
@@ -87,7 +88,12 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
 		return -ENXIO;
 	return dev->archdata.irqs[num];
 #else
-	struct resource *r = platform_get_resource(dev, IORESOURCE_IRQ, num);
+	struct resource *r;
+
+	if (IS_ENABLED(CONFIG_OF) && dev->dev.of_node)
+		return irq_of_parse_and_map(dev->dev.of_node, num);
+
+	r = platform_get_resource(dev, IORESOURCE_IRQ, num);
 
 	return r ? r->start : -ENXIO;
 #endif
-- 
1.8.4.2

