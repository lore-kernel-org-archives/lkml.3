Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503AbaHHVBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:01:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41419 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131AbaHHUyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 130/259] platform_get_irq: Revert to platform_get_resource if of_irq_get fails
Date: Fri,  8 Aug 2014 13:39:13 -0700
Message-Id: <1407530482-4483-131-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit aff008ad813c7cf3cfe7b532e7ba2c526c136f22 upstream.

Commits 9ec36ca (of/irq: do irq resolution in platform_get_irq)
and ad69674 (of/irq: do irq resolution in platform_get_irq_byname)
change the semantics of platform_get_irq and platform_get_irq_byname
to always rely on devicetree information if devicetree is enabled
and if a devicetree node is attached to the device. The functions
now return an error if the devicetree data does not include interrupt
information, even if the information is available as platform resource
data.

This causes mfd client drivers to fail if the interrupt number is
passed via platform resources. Therefore, if of_irq_get fails, try
platform_get_resource as method of last resort. This restores the
original functionality for drivers depending on platform resources
to get irq information.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/platform.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 0d13679..f081b81 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -89,8 +89,13 @@ int platform_get_irq(struct platform_device *dev, unsigned int num)
 	return dev->archdata.irqs[num];
 #else
 	struct resource *r;
-	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
-		return of_irq_get(dev->dev.of_node, num);
+	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node) {
+		int ret;
+
+		ret = of_irq_get(dev->dev.of_node, num);
+		if (ret >= 0 || ret == -EPROBE_DEFER)
+			return ret;
+	}
 
 	r = platform_get_resource(dev, IORESOURCE_IRQ, num);
 
@@ -133,8 +138,13 @@ int platform_get_irq_byname(struct platform_device *dev, const char *name)
 {
 	struct resource *r;
 
-	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node)
-		return of_irq_get_byname(dev->dev.of_node, name);
+	if (IS_ENABLED(CONFIG_OF_IRQ) && dev->dev.of_node) {
+		int ret;
+
+		ret = of_irq_get_byname(dev->dev.of_node, name);
+		if (ret >= 0 || ret == -EPROBE_DEFER)
+			return ret;
+	}
 
 	r = platform_get_resource_byname(dev, IORESOURCE_IRQ, name);
 	return r ? r->start : -ENXIO;
-- 
1.9.1

