Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaGNHdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:33:49 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:50335 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaGNHda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:33:30 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-6b-53c387c72b2d
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
Subject: [PATCH v2 2/4] drivers: of: initialize and assign reserved memory to
 newly created devices
Date: Mon, 14 Jul 2014 09:12:44 +0200
Message-id: <1405321966-28184-3-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com>
References: <1405321966-28184-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xq7rH2w8HG0x4ZGgxZ/0aNovHr+ex
	WPyddIzd4kNTK7PF+2U9jBbzj5xjtTjwZwejxcruZjaLneveMVqcbXrDbrG9cwa7xZcrD5ks
	Nj2+xmpxedccNou1R+6yW2x4eZDJYsHxFlaLP9PlLNYcWcxu8Xf7JhaL9TNes1gsnH+f3eLl
	xxMsDuIea+atYfT4/WsSo8flvl4mj52z7rJ79LxpYfXoenuFyePOtT1sHidm/GbxeHBoM4vH
	5iX1Hrf/PWb2WPfnFZNH/18Dj7m7+hg9+rasYvT4vEkuQCCKyyYlNSezLLVI3y6BK+PFxkbW
	gqN8Fas3/mdrYJzO08XIySEhYCJxY2srG4QtJnHh3nogm4tDSGApo8SyBc2MIAkhgT4miffH
	JEFsNgFDia63XWANIgJuEv/WHQJrYBZYwCZx9P8PsAZhgVSJC2+2sYDYLAKqEk1/bzOD2LwC
	HhK/XhxmgtgmJ/H/5Qowm1PAU2Lj5G+sEMs8JA7v28M4gZF3ASPDKkbR1NLkguKk9FwjveLE
	3OLSvHS95PzcTYyQ+Pq6g3HpMatDjAIcjEo8vAX8h4OFWBPLiitzDzFKcDArifCGuwGFeFMS
	K6tSi/Lji0pzUosPMTJxcEo1MG4JiWRh6265Jdrjkf3n2uar6x/+Ovj+3rsXAjsiz/GkbD3z
	7VGoVXqrkb5v/EMvfs1TeR4rIoMzKox5163S3mb7NCY8Qax15cw7h32W50w6HuAgzJuvufdT
	A+vpvGNrd15t9zjD5jrRxbM/7ztzcPHPiH55rR41o3ufo+T7/kbv8OW8/qH1ihJLcUaioRZz
	UXEiAIrYSJKNAgAA
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
index 6c48d73a7fd7..a7f967866f13 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -21,6 +21,7 @@
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/platform_device.h>
 
 const struct of_device_id of_default_bus_match_table[] = {
@@ -237,12 +238,15 @@ static struct platform_device *of_platform_device_create_pdata(
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
@@ -304,6 +308,8 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	else
 		of_device_make_bus_id(&dev->dev);
 
+	of_reserved_mem_device_init(&dev->dev);
+
 	/* Allow the HW Peripheral ID to be overridden */
 	prop = of_get_property(node, "arm,primecell-periphid", NULL);
 	if (prop)
@@ -330,6 +336,7 @@ static struct amba_device *of_amba_device_create(struct device_node *node,
 	return dev;
 
 err_free:
+	of_reserved_mem_device_release(&dev->dev);
 	amba_device_put(dev);
 err_clear_flag:
 	of_node_clear_flag(node, OF_POPULATED);
-- 
1.9.2

