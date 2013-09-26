Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab3IZLeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:34:11 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:59151 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756142Ab3IZLeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:34:08 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Sep 2013 07:34:07 EDT
From: Josh Wu <josh.wu@atmel.com>
To: <cooloney@gmail.com>
CC: <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Josh Wu <josh.wu@atmel.com>
Subject: [PATCH][resend] leds-gpio: of: led should not be created if its status is disabled
Date: Thu, 26 Sep 2013 19:27:56 +0800
Message-ID: <1380194876-25821-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now the leds-gpio driver will create every child led node without
checking the status is disabled or not.

for example, if we have a led node like d3, and its status is disabled:
	leds {
		d3 {
			label = "d3";
			gpios = <&pioE 24 0>;
			status = "disabled";
		};
	};

we except the d3 should not be created. And the gpios should not be
request as well.

But current driver will create d3 and request its gpio.

This patch fix this by using for_each_available_child_of_node() and
of_get_available_child_count() to enumerate all child nodes. So the
disabled node will be inavailable.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
resend this patch based on the patch:
 - http://www.spinics.net/lists/devicetree/msg05903.html

 drivers/leds/leds-gpio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index e8b01e5..62bfc3a 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -170,11 +170,11 @@ static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
 	int count, ret;
 
 	/* count LEDs in this device, so we know how much to allocate */
-	count = of_get_child_count(np);
+	count = of_get_available_child_count(np);
 	if (!count)
 		return ERR_PTR(-ENODEV);
 
-	for_each_child_of_node(np, child)
+	for_each_available_child_of_node(np, child)
 		if (of_get_gpio(child, 0) == -EPROBE_DEFER)
 			return ERR_PTR(-EPROBE_DEFER);
 
@@ -183,7 +183,7 @@ static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
 
-	for_each_child_of_node(np, child) {
+	for_each_available_child_of_node(np, child) {
 		struct gpio_led led = {};
 		enum of_gpio_flags flags;
 		const char *state;
-- 
1.7.9.5

