Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaDNLuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:50:04 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30074 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbaDNLty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:49:54 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-24-534bcb56cce2
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 11/13] extcon: extcon-adc-jack: add devicetree support
Date: Mon, 14 Apr 2014 13:46:22 +0200
Message-id: <1397475984-28001-12-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
References: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRWUhUURjA8c7cVWngNm4HtYgBIU0tW+BAGj5k3VDCEKIkslEvajlLc11S
	kBQZbSR1HAu1xlLT3MYEF3Ss3CVKM2WoeTCXcFxzwVxGcilH6e3//b7vPB0aE7XiznSMLI5T
	yiSxYtIW79+dZLxu9AeGnJ7t90H6WX/U1eyOusYfIdPaDIG05mUMveodJFBedT6GchdKCZTb
	dAl1brcClP66nkSD89UAqb+YMTQ09YREFe21OCrNKMeRsU1HohfluTgqe6PCkLl0QIDqekcp
	VGEaFqCRtCoSVS7+JZGmoA5HEz0GCr2dK8CR6kMvhdqHtglUX/gL9z/G6l/qAWvMyRawbQYd
	wWpyfwPW8HyUYqsr10i2Z70UZxurPNiGGjXJztcWEeyP7+9JtqNYT7HZ6UskO5e3RbIGSyrF
	5jTVgGC7UFvfSC42JoFTnrp41zZ6WtUCFE9dHm5oPlOpINMxC9jQkDkHh8vU4KAd4dBYPZkF
	bGkRUwagfn0FHAyZAqjLn6CsVyTjCZssmv0X9gwGS5593W+MmSJgy6afte2Yq/DT2sye0zTO
	uEH10m0rC5nL0PSzk7QyZI5DndbXyjZ73FW0g1lbxATAzvQRTAOEJeBQDXDgFBEKPjxK6uPN
	S6R8vCzKO0IubQD7/znt3AqqU1E3YGggPix8rAsMERGSBD5J2g0gjYnthQHNeySMlCQlc0p5
	mDI+luO7gQuNi52EnaoL10VMlCSOu89xCk75fyugbZxTQdKV+JteiSvJMn60WbWYBfudbp0Q
	BK2Gha7C/Dsp9zJStF0LJcLNRFejh7u28cy1IwRmFiqo8+/8jdHB0o0tT3W4qcBuEBel1WZ8
	XA9yKYodm5TzE24DHQ7GhcLuHeN4nJ/r0fZdi3x5rPikFv/jmLf5DfQVF1senO1bJrzFOB8t
	8fHAlLzkH0kYumjLAgAA
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies extcon-adc-jack driver to use initialization data from
devicetree, when platform data is not available. It allows to define cable list
with ADC value ranges for each of them in devicetree bindings.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c |   81 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index d65915e..f1a1399 100644
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
@@ -92,12 +93,85 @@ static irqreturn_t adc_jack_irq_thread(int irq, void *_data)
 	return IRQ_HANDLED;
 }
 
+#ifdef CONFIG_OF
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
+#else
+static struct adc_jack_pdata *get_pdata_from_dt(struct device *dev)
+{
+	return NULL;
+}
+#endif /* CONFIG_OF */
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
@@ -188,11 +262,18 @@ static int adc_jack_remove(struct platform_device *pdev)
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

