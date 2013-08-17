Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3HQIzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 04:55:08 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62160 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3HQIzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 04:55:05 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH] pinctrl: queue GPIO request instead of defering
Date: Sat, 17 Aug 2013 10:54:52 +0200
Message-Id: <1376729692-21108-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently defer probing of the caller if a pinctrl GPIO
request comes in before the range mapping a certain GPIO to
a certain pin controller is available.

If this pinctrl_gpio_request() is done for a GPIO driver
adding the range from the gpiochip side (as is recommended)
they can end up with a circular dependency: the GPIO driver
needs the pin controller to be ready and the pin controller
need the GPIO driver to be ready. This also happens if
pin controllers and GPIO controllers compiled as modules
are inserted in a certain order.

To break this circular dependence, queue any requests
coming to the framework until the range is ready, instead
of deferring the probe of the caller.

On the Nomadik we get this situation with the pinctrl
driver when moving to requesting GPIOs off the gpiochip
right after it has been added, and with this patch the
boot dilemma is sorted out nicely, as can be seen in this
condensed bootlog:

pinctrl core: initialized pinctrl subsystem
gpio 101e4000.gpio: at address cc852000
gpio 101e5000.gpio: at address cc854000
gpio 101e6000.gpio: at address cc856000
pinctrl core: queueing pinctrl request for GPIO 104
gpio 101e7000.gpio: at address cc858000
pinctrl core: requested queued GPIO 104
pinctrl-nomadik pinctrl.0: initialized Nomadik pin control driver

Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Lars Poeschel <poeschel@lemonage.de>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Some testing of this would be appreciated, especially for
HiSilicon etc that already have some complicated GPIO ranges.
---
 drivers/pinctrl/core.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 2a00239..59cbf41 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -404,9 +404,11 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
 		}
 	}
 
-	return -EPROBE_DEFER;
+	return -EINVAL;
 }
 
+static void pinctrl_process_queued_gpio_requests(void);
+
 /**
  * pinctrl_add_gpio_range() - register a GPIO range for a controller
  * @pctldev: pin controller device to add the range to
@@ -421,6 +423,8 @@ void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 	mutex_lock(&pctldev->mutex);
 	list_add_tail(&range->node, &pctldev->gpio_ranges);
 	mutex_unlock(&pctldev->mutex);
+	/* Maybe we have outstanding GPIO requests for this range? */
+	pinctrl_process_queued_gpio_requests();
 }
 EXPORT_SYMBOL_GPL(pinctrl_add_gpio_range);
 
@@ -534,6 +538,16 @@ int pinctrl_get_group_selector(struct pinctrl_dev *pctldev,
 	return -EINVAL;
 }
 
+/*
+ * Queued GPIO requests are stored in this list.
+ */
+struct pinctrl_gpio_req {
+	struct list_head node;
+	int gpio;
+};
+
+static LIST_HEAD(pinctrl_queued_gpio_requests);
+
 /**
  * pinctrl_request_gpio() - request a single pin to be used in as GPIO
  * @gpio: the GPIO pin number from the GPIO subsystem number space
@@ -551,9 +565,26 @@ int pinctrl_request_gpio(unsigned gpio)
 
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
+		/* Maybe this pin does not have a pinctrl back-end at all? */
 		if (pinctrl_ready_for_gpio_range(gpio))
-			ret = 0;
-		return ret;
+			return 0;
+		/*
+		 * We get to this point if pinctrl_request_gpio() is called
+		 * from a GPIO driver which does not yet have a registered
+		 * pinctrl driver backend, and thus no ranges are defined for
+		 * it. This could happen during system start up or if we're
+		 * probing pin controllers as modules. Queue the request and
+		 * handle it when and if the range arrives.
+		 */
+		struct pinctrl_gpio_req *req =
+			kzalloc(sizeof(struct pinctrl_gpio_req), GFP_KERNEL);
+
+		if (!req)
+			return -ENOMEM;
+		req->gpio = gpio;
+		list_add_tail(&req->node, &pinctrl_queued_gpio_requests);
+		pr_info("queueing pinctrl request for GPIO %d\n", req->gpio);
+		return 0;
 	}
 
 	/* Convert to the pin controllers number space */
@@ -566,6 +597,42 @@ int pinctrl_request_gpio(unsigned gpio)
 EXPORT_SYMBOL_GPL(pinctrl_request_gpio);
 
 /**
+ * pinctrl_process_queued_gpio_requests() - process queued GPIO requests
+ *
+ * This is called whenever a new GPIO range is added to see if some GPIO
+ * driver has outstanding requests to GPIOs in the range, and then these
+ * get processed at this point.
+ */
+static void pinctrl_process_queued_gpio_requests(void)
+{
+	struct list_head *node, *tmp;
+
+        list_for_each_safe(node, tmp, &pinctrl_queued_gpio_requests) {
+                struct pinctrl_gpio_req *req =
+			list_entry(node, struct pinctrl_gpio_req, node);
+		struct pinctrl_dev *pctldev;
+		struct pinctrl_gpio_range *range;
+		int pin;
+		int ret;
+
+		ret = pinctrl_get_device_gpio_range(req->gpio, &pctldev, &range);
+		if (ret)
+			continue;
+
+		/* Convert to the pin controllers number space */
+		pin = gpio_to_pin(range, req->gpio);
+		ret = pinmux_request_gpio(pctldev, range, pin, req->gpio);
+
+		if (ret)
+			pr_err("failed to request queued GPIO %d\n", req->gpio);
+		else
+			pr_info("requested queued GPIO %d\n", req->gpio);
+                list_del(node);
+                kfree(req);
+        }
+}
+
+/**
  * pinctrl_free_gpio() - free control on a single pin, currently used as GPIO
  * @gpio: the GPIO pin number from the GPIO subsystem number space
  *
-- 
1.8.1.4

