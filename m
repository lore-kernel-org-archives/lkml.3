Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaEILOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:14:15 -0400
Received: from top.free-electrons.com ([176.31.233.9]:44763 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755521AbaEILL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:11:59 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 2/7] reset: sunxi: allow MFD subdevices probe
Date: Fri,  9 May 2014 13:11:46 +0200
Message-Id: <1399633911-7094-3-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1399633911-7094-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation uses sunxi_reset_init function for both early
init and platform device probe.

The sunxi_reset_init function uses DT to retrieve device resources, which
will be an issue if reset controllers are registered from an MFD device
that define resources from mfd_cell definition.

Moreover, we can make of devm functions when we're in the probe context.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/reset/reset-sunxi.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/reset/reset-sunxi.c b/drivers/reset/reset-sunxi.c
index 695bd34..a94e7a7 100644
--- a/drivers/reset/reset-sunxi.c
+++ b/drivers/reset/reset-sunxi.c
@@ -145,7 +145,24 @@ MODULE_DEVICE_TABLE(of, sunxi_reset_dt_ids);
 
 static int sunxi_reset_probe(struct platform_device *pdev)
 {
-	return sunxi_reset_init(pdev->dev.of_node);
+	struct sunxi_reset_data *data;
+	struct resource *res;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	data->membase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(data->membase))
+		return PTR_ERR(data->membase);
+
+	data->rcdev.owner = THIS_MODULE;
+	data->rcdev.nr_resets = resource_size(res) * 32;
+	data->rcdev.ops = &sunxi_reset_ops;
+	data->rcdev.of_node = pdev->dev.of_node;
+
+	return reset_controller_register(&data->rcdev);
 }
 
 static int sunxi_reset_remove(struct platform_device *pdev)
@@ -153,8 +170,6 @@ static int sunxi_reset_remove(struct platform_device *pdev)
 	struct sunxi_reset_data *data = platform_get_drvdata(pdev);
 
 	reset_controller_unregister(&data->rcdev);
-	iounmap(data->membase);
-	kfree(data);
 
 	return 0;
 }
-- 
1.8.3.2

