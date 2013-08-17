Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3HQO5D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 10:57:03 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:49597 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab3HQO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 10:57:01 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Lars Poeschel <poeschel@lemonage.de>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2] pinctrl: queue GPIO operations instead of defering
Date: Sat, 17 Aug 2013 16:56:50 +0200
Message-Id: <1376751410-14560-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently defer probing of the caller if a pinctrl GPIO
request or direction setting comes in before the range mapping
a certain GPIO to a certain pin controller is available.

This can end up with a circular dependency: the GPIO driver
needs the pin controller to be ready and the pin controller
need the GPIO driver to be ready. This also happens if
pin controllers and GPIO controllers compiled as modules
are inserted in a certain order.

To break this circular dependence, queue any GPIO
operations coming to the framework until the range is ready,
instead of deferring the probe of the caller.

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

ChangeLog v1->v2:
- Apart from queueing requests, also queue direction setting
  operations.

Cc: Haojian Zhuang <haojian.zhuang@linaro.org>
Cc: Lars Poeschel <poeschel@lemonage.de>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 119 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index a97b717..41c7479 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -404,7 +404,111 @@ static int pinctrl_get_device_gpio_range(unsigned gpio,
 		}
 	}
 
-	return -EPROBE_DEFER;
+	return -EINVAL;
+}
+
+/**
+ * enum pinctrl_gpio_operation - queued operations type for GPIOs
+ * @PINCTRL_GPIO_REQUEST: queued request operation
+ * @PINCTRL_SET_DIR_OUT: queued set as output operation
+ * @PINCTRL_SET_DIR_IN: queued set as input operation
+ */
+enum pinctrl_gpio_operation {
+	PINCTRL_GPIO_REQUEST,
+	PINCTRL_GPIO_DIR_OUT,
+	PINCTRL_GPIO_DIR_IN,
+};
+
+/**
+ * struct pinctrl_gpio_op - a queue list holder
+ * @node: a list node for list processing
+ * @gpio: the targeted gpio for this operation
+ * @request: true of this is a request, then the gpio will be requested
+ * @input: if this is not a request, we're setting the direction
+ * Queued GPIO range-based deferred operations are stored in this list.
+ */
+struct pinctrl_gpio_op {
+	struct list_head node;
+	int gpio;
+	enum pinctrl_gpio_operation op;
+};
+
+static LIST_HEAD(pinctrl_queued_gpio_ops);
+
+static int pinctrl_queue_gpio_operation(int gpio,
+					enum pinctrl_gpio_operation op)
+{
+	struct pinctrl_gpio_op *qop;
+
+	/*
+	 * We get to this point if pinctrl_*_gpio() is called
+	 * from a GPIO driver which does not yet have a registered
+	 * pinctrl driver backend, and thus no ranges are defined for
+	 * it. This could happen during system start up or if we're
+	 * probing pin controllers as modules. Queue the request and
+	 * handle it when and if the range arrives.
+	 */
+	qop = kzalloc(sizeof(struct pinctrl_gpio_op), GFP_KERNEL);
+	if (!qop)
+		return -ENOMEM;
+	qop->gpio = gpio;
+	qop->op = op;
+	list_add_tail(&qop->node, &pinctrl_queued_gpio_ops);
+	pr_info("queueing pinctrl request for GPIO %d\n", qop->gpio);
+	return 0;
+}
+
+
+/**
+ * pinctrl_process_queued_gpio_ops() - process queued GPIO operations
+ *
+ * This is called whenever a new GPIO range is added to see if some GPIO
+ * driver has outstanding operations to GPIOs in the range, and then these
+ * get processed at this point.
+ */
+static void pinctrl_process_queued_gpio_ops(void)
+{
+	struct list_head *node, *tmp;
+
+        list_for_each_safe(node, tmp, &pinctrl_queued_gpio_ops) {
+                struct pinctrl_gpio_op *op =
+			list_entry(node, struct pinctrl_gpio_op, node);
+		struct pinctrl_dev *pctldev;
+		struct pinctrl_gpio_range *range;
+		int pin;
+		int ret;
+
+		ret = pinctrl_get_device_gpio_range(op->gpio, &pctldev, &range);
+		if (ret)
+			continue;
+
+		/* Convert to the pin controllers number space */
+		pin = gpio_to_pin(range, op->gpio);
+
+		switch(op->op) {
+		case PINCTRL_GPIO_REQUEST:
+			ret = pinmux_request_gpio(pctldev, range, pin, op->gpio);
+			if (ret)
+				pr_err("failed to request queued GPIO %d\n",
+					op->gpio);
+			else
+				pr_info("requested queued GPIO %d\n", op->gpio);
+			break;
+		case PINCTRL_GPIO_DIR_IN:
+		case PINCTRL_GPIO_DIR_OUT:
+			ret = pinmux_gpio_direction(pctldev, range, pin,
+					op->op == PINCTRL_GPIO_DIR_IN);
+			if (ret)
+				pr_err("failed to set direction on queued GPIO %d\n",
+				       op->gpio);
+			break;
+		default:
+			pr_err("unknown queued GPIO operation\n");
+			break;
+		}
+		list_del(node);
+		kfree(op);
+        }
 }
 
 /**
@@ -421,6 +525,8 @@ void pinctrl_add_gpio_range(struct pinctrl_dev *pctldev,
 	mutex_lock(&pctldev->mutex);
 	list_add_tail(&range->node, &pctldev->gpio_ranges);
 	mutex_unlock(&pctldev->mutex);
+	/* Maybe we have outstanding GPIO requests for this range? */
+	pinctrl_process_queued_gpio_ops();
 }
 EXPORT_SYMBOL_GPL(pinctrl_add_gpio_range);
 
@@ -552,8 +658,8 @@ int pinctrl_request_gpio(unsigned gpio)
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
 		if (pinctrl_ready_for_gpio_range(gpio))
-			ret = 0;
-		return ret;
+			return 0;
+		return pinctrl_queue_gpio_operation(gpio, PINCTRL_GPIO_REQUEST);
 	}
 
 	/* Convert to the pin controllers number space */
@@ -604,7 +710,16 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
 
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
-		return ret;
+		/* Maybe this pin does not have a pinctrl back-end at all? */
+		if (pinctrl_ready_for_gpio_range(gpio))
+			return 0;
+		/* Que the operation until the range arrives */
+		if (input)
+			return pinctrl_queue_gpio_operation(gpio,
+							PINCTRL_GPIO_DIR_IN);
+		else
+			return pinctrl_queue_gpio_operation(gpio,
+							PINCTRL_GPIO_DIR_OUT);
 	}
 
 	mutex_lock(&pctldev->mutex);
-- 
1.8.1.4

