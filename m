Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaGNI3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:29:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21222 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaGNI2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:28:19 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-f3-53c3949f1d41
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>,
        Jon Medhurst <tixy@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Aneesh Kumar K.V." <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 RESEND 2/4] drivers: of: initialize and assign reserved
 memory to newly created devices
Date: Mon, 14 Jul 2014 10:28:05 +0200
Message-id: <1405326487-15346-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1405326487-15346-1-git-send-email-m.szyprowski@samsung.com>
References: <1405326487-15346-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t/xq7oLphwONvglbTFn/Ro2i8ev57FY
	/J10jN3i/bIeRov5R86xWhz4s4PRYmV3M5vFznXvGC3ONr1ht9jeOYPd4suVh0wWmx5fY7W4
	vGsOm8XaI3fZLTa8PMhkseB4C6vFn+lyFmuOLGa3+Lt9E4vF+hmvWSwWzr/PbvHy4wkWBzGP
	NfPWMHr8/jWJ0eNyXy+Tx85Zd9k9ut5eYfK4c20Pm8eJGb9ZPB4c2szisXlJvcftf4+ZPdb9
	ecXk0f/XwGPurj5Gj74tqxg9Pm+SC+CP4rJJSc3JLEst0rdL4Mr4dr6dveAoX8Xjpe9ZGxin
	83QxcnJICJhILD2xnRHCFpO4cG89WxcjF4eQwFJGiYutnSwgCSGBPiaJFafLQWw2AUOJrrdd
	bCC2iICbxL91h8AamAVes0qsePQZrEFYIEfi2scO1i5GDg4WAVWJKZ0VIGFeAQ+JCfsWs0Is
	k5P4/3IFE4jNKeApMePze3aIXR4S7y/3sk5g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85
	P3cTIySOvuxgXHzM6hCjAAejEg9vhdjhYCHWxLLiytxDjBIczEoivOFuQCHelMTKqtSi/Pii
	0pzU4kOMTBycUg2MXT72ZxddKVH68ErrocyfV3k2oWbXavPv+K6f3Pa7YPtai6e26bLnnqhy
	aD//EBr9Mevq0g86h4X/93exCdofeFNwxSnxDLveW7ES/48trL/OCT5Ryq805d7GdF7HxG3x
	0zmSJ7jYUi+2GkkYvf8tHrAwTjND5V7dFQGfvGDVF5ZiXw6HnLmoxFKckWioxVxUnAgAWqce
	JoECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use recently introduced of_reserved_mem_device_init() function to
automatically assign respective reserved memory region to the newly created
platform and amba device.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/platform.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 500436f9be7f..a9055d3da5c2 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -21,6 +21,7 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/platform_device.h>
 
 const struct of_device_id of_default_bus_match_table[] = {
@@ -233,12 +234,15 @@ static struct platform_device *of_platform_device_create_pdata(
 	dev->dev.bus = &platform_bus_type;
 	dev->dev.platform_data = platform_data;
 
+	of_reserved_mem_device_init(&dev->dev);
+
 	/* We do not fill the DMA ops for platform devices by default.
 	 * This is currently the responsibility of the platform code
 	 * to do such, possibly using a device notifier
 	 */
 
 	if (of_device_add(dev) != 0) {
+		of_reserved_mem_device_release(&dev->dev);
 		platform_device_put(dev);
 		goto err_clear_flag;
 	}
@@ -300,6 +304,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	else
 		of_device_make_bus_id(&dev->dev);
 
+	of_reserved_mem_device_init(&dev->dev);
+
 	/* Allow the HW Peripheral ID to be overridden */
 	prop = of_get_property(node, "arm,primecell-periphid", NULL);
 	if (prop)
@@ -326,6 +332,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	return dev;
 
 err_free:
+	of_reserved_mem_device_release(&dev->dev);
 	amba_device_put(dev);
 err_clear_flag:
 	of_node_clear_flag(node, OF_POPULATED);
-- 
1.9.2

