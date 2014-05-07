Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaEGAx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 20:53:56 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50805 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaEGAxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 20:53:54 -0400
Message-ID: <5369841F.5060805@gmail.com>
Date: Tue, 06 May 2014 17:53:51 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH 3/3] devicetree, qcomm PMIC: use new hook to make PMIC
 device names unique
References: <536982E3.10303@gmail.com>
In-Reply-To: <536982E3.10303@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@sonymobile.com>

The previous patch in the series does:

   Optionally push device naming into a function called dynamically by
   of_device_alloc().

This patch adds an example of using that capability.

Signed-off-by: Frank Rowand <frank.rowand@sonymobile.com>
---
 drivers/mfd/pm8x41.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

Index: b/drivers/mfd/pm8x41.c
===================================================================
--- a/drivers/mfd/pm8x41.c
+++ b/drivers/mfd/pm8x41.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/spmi.h>
 #include <linux/regmap.h>
+#include <linux/of_address.h>
 #include <linux/of_platform.h>
 
 static const struct regmap_config pm8x41_regmap_config = {
@@ -32,6 +33,43 @@ static void pm8x41_remove(struct spmi_de
 	device_for_each_child(&sdev->dev, NULL, pm8x41_remove_child);
 }
 
+static void spmi_of_device_make_bus_id(struct device *dev)
+{
+	struct device_node *node = dev->of_node;
+	const __be32 *reg;
+	u64 addr;
+	const __be32 *addrp;
+	struct spmi_device *sdev;
+
+	sdev = container_of(dev->parent, struct spmi_device, dev);
+
+	/*
+	 * For MMIO, get the physical address
+	 */
+	reg = of_get_property(node, "reg", NULL);
+	if (reg) {
+		if (of_can_translate_address(node)) {
+			addr = of_translate_address(node, reg);
+		} else {
+			addrp = of_get_address(node, 0, NULL, NULL);
+			if (addrp)
+				addr = of_read_number(addrp, 1);
+			else
+				addr = OF_BAD_ADDR;
+		}
+		if (addr != OF_BAD_ADDR) {
+			dev_set_name(dev, "%d-%02x:%llx.%s",
+				     sdev->ctrl->nr, sdev->usid,
+				     (unsigned long long)addr, node->name);
+			return;
+		}
+	}
+
+	dev_set_name(dev, "%d-%02x:%s",
+		     sdev->ctrl->nr, sdev->usid,
+		     node->name);
+}
+
 static int pm8x41_probe(struct spmi_device *sdev)
 {
 	struct regmap *regmap;
@@ -42,6 +80,7 @@ static int pm8x41_probe(struct spmi_devi
 		return PTR_ERR(regmap);
 	}
 
+	sdev->dev.of_node->of_device_make_bus_id = spmi_of_device_make_bus_id;
 	return of_platform_populate(sdev->dev.of_node, NULL, NULL, &sdev->dev);
 }
 
