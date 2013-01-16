Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556Ab3APQTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:19:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36832 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859Ab3APQJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:58 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 194/222] Input: gpio_keys - defer probing if GPIO probing is deferred
Date: Wed, 16 Jan 2013 13:56:34 -0200
Message-Id: <1358351822-7675-195-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit e324ce61ef483dd26d03502d35666ad48a2e1b33 upstream.

If of_get_gpio_flags() returns an error (as in case when GPIO probe is
deferred) the driver would attempt to claim invalid GPIO. It should
propagate the error code up the stack instead so that the probe either
fails or will be retried later (in case of -EPROBE_DEFER).

Reported-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ herton: backport for 3.5:
  * adjust context, different error handling and return type in
    gpio_keys_get_devtree_pdata function
  * drop check for EPROBE_DEFER, of_get_gpio_flags doesn't return it on
    3.5. The patch just will return an error, no deferring is done. ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/input/keyboard/gpio_keys.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 62bfce4..4f5cce8 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -548,6 +548,7 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 	struct device_node *node, *pp;
 	int i;
 	struct gpio_keys_button *buttons;
+	int error = -ENODEV;
 	u32 reg;
 
 	node = dev->of_node;
@@ -574,6 +575,7 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 	pp = NULL;
 	i = 0;
 	while ((pp = of_get_next_child(node, pp))) {
+		int gpio;
 		enum of_gpio_flags flags;
 
 		if (!of_find_property(pp, "gpios", NULL)) {
@@ -581,7 +583,17 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 			dev_warn(dev, "Found button without gpios\n");
 			continue;
 		}
-		buttons[i].gpio = of_get_gpio_flags(pp, 0, &flags);
+
+		gpio = of_get_gpio_flags(pp, 0, &flags);
+		if (gpio < 0) {
+			error = gpio;
+			dev_err(dev,
+				"Failed to get gpio flags, error: %d\n",
+				error);
+			goto out_fail;
+		}
+
+		buttons[i].gpio = gpio;
 		buttons[i].active_low = flags & OF_GPIO_ACTIVE_LOW;
 
 		if (of_property_read_u32(pp, "linux,code", &reg)) {
@@ -613,7 +625,7 @@ static int gpio_keys_get_devtree_pdata(struct device *dev,
 
 out_fail:
 	kfree(buttons);
-	return -ENODEV;
+	return error;
 }
 
 static struct of_device_id gpio_keys_of_match[] = {
-- 
1.7.9.5

