Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030950AbaDJNUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:20:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19659 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030700AbaDJNUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:20:36 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-6d-53469aa23307
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
Subject: [PATCH 10/13] extcon: extcon-gpio: add devicetree support
Date: Thu, 10 Apr 2014 15:16:48 +0200
Message-id: <1397135811-12866-11-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
References: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRW0iTYRjA8d7vtAOuvpbWhx2oSWRiS83ijUwk0l5K0NhN1EUt/fCQ07Gp
	aBfmoSWubNOwmZk5T/MwE0/kRJ3TkYXOFoa7UEvQLKWcmGbk0JzR3Y/n/8Bz8XBxYSvhzU1I
	TmUVydIkEcUnhjdm6BPVZRGSgDkzgMZvYdDSeRxaPt+DjpWvJCyedeLwpXWUhEUNT3Co+a4n
	oabjIux3dQGYV91CwdGFBgALbLM4tH95RMHaviYC6h/UEHCsu5yCz2s0BKyqU+FwVj+CwVrH
	BwxO5NRT0PBjk4JaXTMBpwdNHPhqXkdAVa+VA/vsLhKaP14OO4iMFUaAfq0WE2jscSGGuk3l
	JNJqlgEylU1xUINhhUKDq3oCtdf7obbGAgotND0j0eR4D4XML4wcVJi3SKH5onUKmdayOdGe
	1/khsWxSQjqrOBl6ix9v1Twk5IW+GaNTNiwblB5RAx6XoYOZFstv6p/3MvZPLdsW0lWAsVbI
	1IC/5XyMqdmwAHegaH+mY027bU8aZypL3gP3Ek6/I5lGixl3hz30Beanaglzm6CPMksuHcdt
	AR3BtNuGSDXgbl07zJQXh7jJ2xr3jvm4KaTDmZJmkRYIKsGORuDFymPkyttxskCxUipTpiXH
	iWNSZG1g+5Fz3l2gIRsOAJoLRB6C/rpwiZCUpiszZQOA4eIiT0FrSYREKIiVZt5lFSk3FWlJ
	rHIA7OcSon2CftW5q0I6TprK3mFZOav4XzEuzzsbSA55JdZOOxby0Btb50zUW4l/fnfwqbSx
	8zdG6s6Gs5GhHJf/sIePzYStO1eKz3Q4x1FirjOrqEutyqzNbRIHeR3IwK6Z9b1HInRRi9Cx
	azUgy/5nuXTodGpQmNw3WmfI9710rNnQPNGz+VoRyzCTM095U1dy7u/0F+82ReaICGW8NNAP
	VyilfwE0YhHhxAIAAA==
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies extcon-gpio driver to use initialization data from
devicetree if platform data is not available. It allows to set controller
and cable names, and another parameters from devicetree bindings.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-gpio.c       |   63 ++++++++++++++++++++++++++++++------
 include/linux/extcon/extcon-gpio.h |    2 +-
 2 files changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index fc90b7a..2a3cfd7 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -28,6 +28,8 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/extcon.h>
 #include <linux/extcon/extcon-gpio.h>
 
@@ -53,7 +55,7 @@ static void gpio_extcon_work(struct work_struct *work)
 	state = gpio_get_value(data->gpio);
 	if (data->gpio_active_low)
 		state = !state;
-	extcon_set_state(&data->edev, state);
+	extcon_set_cable_state_(&data->edev, 0, state);
 }
 
 static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
@@ -70,7 +72,7 @@ static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
 	struct gpio_extcon_data	*extcon_data =
 		container_of(edev, struct gpio_extcon_data, edev);
 	const char *state;
-	if (extcon_get_state(edev))
+	if (extcon_get_cable_state_(edev, 0))
 		state = extcon_data->state_on;
 	else
 		state = extcon_data->state_off;
@@ -80,17 +82,50 @@ static ssize_t extcon_gpio_print_state(struct extcon_dev *edev, char *buf)
 	return -EINVAL;
 }
 
+static struct gpio_extcon_platform_data *get_pdata_from_dt(struct device *dev)
+{
+	int ret;
+	struct gpio_extcon_platform_data *pdata =
+				devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+
+	ret = of_property_read_string_index(dev->of_node,
+				"gpio-controller-name", 0, &pdata->name);
+	if (ret)
+		return NULL;
+
+	ret = of_property_read_string_index(dev->of_node,
+				"gpio-cable-name", 0, &pdata->cable_name);
+	if (ret)
+		return NULL;
+
+	ret = of_property_read_u32_array(dev->of_node,
+				"gpio-debounce", &pdata->debounce, 0);
+	if (ret)
+		pdata->debounce = 0;
+
+	pdata->gpio = of_get_gpio(dev->of_node, 0);
+	if (pdata->gpio < 0)
+		return NULL;
+
+	pdata->gpio_active_low = of_property_read_bool(dev->of_node,
+					"gpio-active-low");
+
+	pdata->check_on_resume = of_property_read_bool(dev->of_node,
+					"check-on-resume");
+	return pdata;
+}
+
 static int gpio_extcon_probe(struct platform_device *pdev)
 {
 	struct gpio_extcon_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct gpio_extcon_data *extcon_data;
+	const char *gpio_extcon_cable[2];
 	int ret;
 
-	if (!pdata)
-		return -EBUSY;
-	if (!pdata->irq_flags) {
-		dev_err(&pdev->dev, "IRQ flag is not specified.\n");
-		return -EINVAL;
+	if (!pdata) {
+		pdata = get_pdata_from_dt(&pdev->dev);
+		if (!pdata)
+			return -EINVAL;
 	}
 
 	extcon_data = devm_kzalloc(&pdev->dev, sizeof(struct gpio_extcon_data),
@@ -98,10 +133,14 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	if (!extcon_data)
 		return -ENOMEM;
 
+	gpio_extcon_cable[0] = pdata->cable_name;
+	gpio_extcon_cable[1] = NULL;
+
 	extcon_data->edev.name = pdata->name;
 	extcon_data->edev.dev.parent = &pdev->dev;
 	extcon_data->edev.node = pdev->dev.of_node;
 	extcon_data->gpio = pdata->gpio;
+	extcon_data->edev.supported_cable = gpio_extcon_cable;
 	extcon_data->gpio_active_low = pdata->gpio_active_low;
 	extcon_data->state_on = pdata->state_on;
 	extcon_data->state_off = pdata->state_off;
@@ -135,8 +174,8 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	}
 
 	ret = request_any_context_irq(extcon_data->irq, gpio_irq_handler,
-				      pdata->irq_flags, pdev->name,
-				      extcon_data);
+			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+			pdev->name, extcon_data);
 	if (ret < 0)
 		goto err;
 
@@ -177,6 +216,11 @@ static int gpio_extcon_resume(struct device *dev)
 }
 #endif
 
+static struct of_device_id of_gpio_match_tbl[] = {
+	{ .compatible = "extcon-gpio", },
+	{ /* end */ },
+};
+
 static SIMPLE_DEV_PM_OPS(gpio_extcon_pm_ops, NULL, gpio_extcon_resume);
 
 static struct platform_driver gpio_extcon_driver = {
@@ -184,6 +228,7 @@ static struct platform_driver gpio_extcon_driver = {
 	.remove		= gpio_extcon_remove,
 	.driver		= {
 		.name	= "extcon-gpio",
+		.of_match_table = of_gpio_match_tbl,
 		.owner	= THIS_MODULE,
 		.pm	= &gpio_extcon_pm_ops,
 	},
diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
index 8900fdf..3850588 100644
--- a/include/linux/extcon/extcon-gpio.h
+++ b/include/linux/extcon/extcon-gpio.h
@@ -43,10 +43,10 @@
  */
 struct gpio_extcon_platform_data {
 	const char *name;
+	const char *cable_name;
 	unsigned gpio;
 	bool gpio_active_low;
 	unsigned long debounce;
-	unsigned long irq_flags;
 
 	/* if NULL, "0" or "1" will be printed */
 	const char *state_on;
-- 
1.7.9.5

