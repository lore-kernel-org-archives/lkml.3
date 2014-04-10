Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161235AbaDJNVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:21:01 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9063 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030700AbaDJNU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:20:56 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-8d-53469ab616b5
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, aaro.koskinen@iki.fi,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 11/13] extcon: extcon-adc-jack: add devicetree support
Date: Thu, 10 Apr 2014 15:16:49 +0200
Message-id: <1397135811-12866-12-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRa0hTYRwGcN+dc94dpcHhpHWYGbGKUstahb6giETKQYiKQUaUtvSgps61
	o6KBufJSSjYvDVFnOfPuzGmGF7xtEyM0nRpKVCbkJS0r8vYhyzxG3348D8//y5/EaDMuJaNV
	CZxGpYyVQSd88M8n6mhbSZDi+EQXQKbPAcjywh1ZPqahyZV5AhXMfMfQk/5hAuXXFWJI99VI
	IF3rGdS30Q5Q+tMmiIYX6wDKfj2DIfvsA4iqehpwZMyqxNF4pwGi0kodjiqqMzE0YxwSoarJ
	URF6d6cWopqlTYjyihpxNG3rEKNnC0U4yuzuF6Me+waBet8EB7ixpscmwK6tFuDs+MNcEdvZ
	YSDYPN1PwHaUfBCzdTUrkLWtGnH2ea0H21KfDdnFhmKCfT/RBdneMpOYzU3/BtmF/F+Q7VjX
	is87X3byi+Bio5M4zTH/a05Rhp+VUJ0uTe56aYFaoHPJAY4kQ51iir+M4v+8i7FPNcEc4ETS
	VAVg7uqatguauidi2qs8BUPqCNO6ngcEO1MYU64fAcIAo14RTL2lFxOKnVQQY2gvIATj1EGm
	aVq3dYgkJVu5eeiqQIbaxxgK/AQ6bqXd4/sF0lQgo2+U5QFJOXCoBy6cOlzNX4+Mk3vxyjg+
	URXpFR4f1wK2/zgnbQd1WmQFFAlkOyR91YEKmlAm8SlxVsCQmMxZ0qwPUtCSCGXKLU4TH6ZJ
	jOV4K3AlcdluSV+m7wWailQmcDEcp+Y0/1sR6SjVAs7m42BOjsSXCqsGypL2dNEDN/wOuc8v
	20qXL2byN2dj5Iv5VOUP6WlvMXliLTgkH9byo8bbDOY5FOgTE2oJox7J7ycfbraHlOxV/z45
	5p3VdkDeHeoxv5kxkvq2fCr1XFJqxiXXtEErUpxdChkz+3up4t04r1Db3BXfwhG9DOejlHIP
	TMMr/wIFSzTJwwIAAA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies extcon-adc-jack driver to use initialization data from
devicetree, when platform data is not available. It allows to define cable list
with ADC value ranges for each of them in devicetree bindings.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c |   74 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index d65915e..293871b1 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -21,6 +21,7 @@
 #include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
+#include <linux/of.h>
 #include <linux/iio/consumer.h>
 #include <linux/extcon/extcon-adc-jack.h>
 #include <linux/extcon.h>
@@ -92,12 +93,78 @@ static irqreturn_t adc_jack_irq_thread(int irq, void *_data)
 	return IRQ_HANDLED;
 }
 
+static struct adc_jack_pdata *get_pdata_from_dt(struct device *dev)
+{
+	int ret, cnt, i;
+	struct device_node *cables_np, *child;
+	struct adc_jack_pdata *pdata =
+			devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+
+	ret = of_property_read_string_index(dev->of_node,
+			"adc-name", 0, &pdata->name);
+	if (ret)
+		return NULL;
+
+	ret = of_property_read_string_index(dev->of_node,
+			"adc-consumer-channel", 0, &pdata->consumer_channel);
+	if (ret)
+		return NULL;
+
+	cables_np = of_find_node_by_name(dev->of_node, "cables");
+	if (!cables_np)
+		return NULL;
+
+	cnt = of_get_child_count(cables_np);
+	if (cnt <= 0)
+		return NULL;
+
+	pdata->cable_names = devm_kcalloc(dev, cnt+1,
+			sizeof(*pdata->cable_names), GFP_KERNEL);
+	if (!pdata->cable_names)
+		return NULL;
+
+	pdata->adc_conditions = devm_kcalloc(dev, cnt+1,
+			sizeof(*pdata->adc_conditions), GFP_KERNEL);
+	if (!pdata->adc_conditions)
+		return NULL;
+
+	i = 0;
+	for_each_child_of_node(cables_np, child) {
+		ret = of_property_read_string_index(child,
+				"cable-name", 0, &pdata->cable_names[i]);
+		if (ret)
+			return NULL;
+
+		pdata->adc_conditions[i].state = (1<<i);
+
+		ret = of_property_read_u32_array(child, "adc-min",
+				&pdata->adc_conditions[i].min_adc, 0);
+		if (ret)
+			return NULL;
+
+		ret = of_property_read_u32_array(child, "adc-max",
+				&pdata->adc_conditions[i].max_adc, 0);
+		if (ret)
+			return NULL;
+
+		i++;
+	}
+
+	return pdata;
+}
+
 static int adc_jack_probe(struct platform_device *pdev)
 {
 	struct adc_jack_data *data;
 	struct adc_jack_pdata *pdata = dev_get_platdata(&pdev->dev);
 	int i, err = 0;
 
+	if (!pdata) {
+		pdata = get_pdata_from_dt(&pdev->dev);
+		if (!pdata)
+			return -EINVAL;
+	}
+
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
@@ -188,11 +255,18 @@ static int adc_jack_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct of_device_id of_adc_jack_match_tbl[] = {
+	{ .compatible = "extcon-adc-jack", },
+	{ /* end */ },
+};
+
+
 static struct platform_driver adc_jack_driver = {
 	.probe          = adc_jack_probe,
 	.remove         = adc_jack_remove,
 	.driver         = {
 		.name   = "adc-jack",
+		.of_match_table = of_adc_jack_match_tbl,
 		.owner  = THIS_MODULE,
 	},
 };
-- 
1.7.9.5

