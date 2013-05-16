Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab3EPHt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:49:27 -0400
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:36101 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399Ab3EPHt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:49:26 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: sink pinctrldev_list_mutex
Date: Thu, 16 May 2013 09:48:45 +0200
Message-ID: <1368690525-32252-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The pinctrldev_list_mutex is sinked into the functions that
actually traverse the list and lock it there. The code makes
much more sense in this way. All the callers are in
non-performance critical paths and the code is way more
readable this way.

Also refactor the function get_pinctrl_dev_from_devname() to
follow the design pattern of get_pinctrl_dev_from_of_node()
which is slightly simpler.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/core.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 5327f35..1f9608b 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -101,20 +101,23 @@ EXPORT_SYMBOL_GPL(pinctrl_dev_get_drvdata);
 struct pinctrl_dev *get_pinctrl_dev_from_devname(const char *devname)
 {
 	struct pinctrl_dev *pctldev = NULL;
-	bool found = false;
 
 	if (!devname)
 		return NULL;
 
+	mutex_lock(&pinctrldev_list_mutex);
+
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
 		if (!strcmp(dev_name(pctldev->dev), devname)) {
 			/* Matched on device name */
-			found = true;
-			break;
+			mutex_unlock(&pinctrldev_list_mutex);
+			return pctldev;
 		}
 	}
 
-	return found ? pctldev : NULL;
+	mutex_unlock(&pinctrldev_list_mutex);
+
+	return NULL;
 }
 
 struct pinctrl_dev *get_pinctrl_dev_from_of_node(struct device_node *np)
@@ -326,6 +329,8 @@ static bool pinctrl_ready_for_gpio_range(unsigned gpio)
 	struct pinctrl_gpio_range *range = NULL;
 	struct gpio_chip *chip = gpio_to_chip(gpio);
 
+	mutex_lock(&pinctrldev_list_mutex);
+
 	/* Loop over the pin controllers */
 	list_for_each_entry(pctldev, &pinctrldev_list, node) {
 		/* Loop over the ranges */
@@ -334,9 +339,13 @@ static bool pinctrl_ready_for_gpio_range(unsigned gpio)
 			if (range->base + range->npins - 1 < chip->base ||
 			    range->base > chip->base + chip->ngpio - 1)
 				continue;
+			mutex_unlock(&pinctrldev_list_mutex);
 			return true;
 		}
 	}
+
+	mutex_unlock(&pinctrldev_list_mutex);
+
 	return false;
 }
 #else
@@ -408,8 +417,6 @@ struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 {
 	struct pinctrl_dev *pctldev;
 
-	mutex_lock(&pinctrldev_list_mutex);
-
 	pctldev = get_pinctrl_dev_from_devname(devname);
 
 	/*
@@ -418,13 +425,10 @@ struct pinctrl_dev *pinctrl_find_and_add_gpio_range(const char *devname,
 	 * range need to defer probing.
 	 */
 	if (!pctldev) {
-		mutex_unlock(&pinctrldev_list_mutex);
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 	pinctrl_add_gpio_range(pctldev, range);
 
-	mutex_unlock(&pinctrldev_list_mutex);
-
 	return pctldev;
 }
 EXPORT_SYMBOL_GPL(pinctrl_find_and_add_gpio_range);
@@ -517,13 +521,10 @@ int pinctrl_request_gpio(unsigned gpio)
 	int ret;
 	int pin;
 
-	mutex_lock(&pinctrldev_list_mutex);
-
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
 		if (pinctrl_ready_for_gpio_range(gpio))
 			ret = 0;
-		mutex_unlock(&pinctrldev_list_mutex);
 		return ret;
 	}
 
@@ -532,7 +533,6 @@ int pinctrl_request_gpio(unsigned gpio)
 
 	ret = pinmux_request_gpio(pctldev, range, pin, gpio);
 
-	mutex_unlock(&pinctrldev_list_mutex);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pinctrl_request_gpio);
@@ -552,11 +552,8 @@ void pinctrl_free_gpio(unsigned gpio)
 	int ret;
 	int pin;
 
-	mutex_lock(&pinctrldev_list_mutex);
-
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
-		mutex_unlock(&pinctrldev_list_mutex);
 		return;
 	}
 	mutex_lock(&pctldev->mutex);
@@ -567,7 +564,6 @@ void pinctrl_free_gpio(unsigned gpio)
 	pinmux_free_gpio(pctldev, pin, range);
 
 	mutex_unlock(&pctldev->mutex);
-	mutex_unlock(&pinctrldev_list_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_free_gpio);
 
@@ -578,11 +574,8 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
 	int ret;
 	int pin;
 
-	mutex_lock(&pinctrldev_list_mutex);
-
 	ret = pinctrl_get_device_gpio_range(gpio, &pctldev, &range);
 	if (ret) {
-		mutex_unlock(&pinctrldev_list_mutex);
 		return ret;
 	}
 
@@ -593,7 +586,6 @@ static int pinctrl_gpio_direction(unsigned gpio, bool input)
 	ret = pinmux_gpio_direction(pctldev, range, pin, input);
 
 	mutex_unlock(&pctldev->mutex);
-	mutex_unlock(&pinctrldev_list_mutex);
 
 	return ret;
 }
-- 
1.7.11.3

