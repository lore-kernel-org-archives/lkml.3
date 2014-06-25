Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932405AbaFYRLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:11:08 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:41484 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824AbaFYRJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:09:56 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 09/13] leds: ss4200: fix attribute-creation race
Date: Wed, 25 Jun 2014 19:08:52 +0200
Message-Id: <1403716136-32694-10-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1403716136-32694-1-git-send-email-johan@kernel.org>
References: <1403716136-32694-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the attribute groups of the led-class to create the blink attribute
during probe in order to avoid racing with userspace.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-ss4200.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
index 2eb3ef62962b..046cb7008745 100644
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -469,6 +469,12 @@ static ssize_t nas_led_blink_store(struct device *dev,
 
 static DEVICE_ATTR(blink, 0644, nas_led_blink_show, nas_led_blink_store);
 
+static struct attribute *nasgpio_led_attrs[] = {
+	&dev_attr_blink.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(nasgpio_led);
+
 static int register_nasgpio_led(int led_nr)
 {
 	int ret;
@@ -481,20 +487,18 @@ static int register_nasgpio_led(int led_nr)
 		led->brightness = LED_FULL;
 	led->brightness_set = nasgpio_led_set_brightness;
 	led->blink_set = nasgpio_led_set_blink;
+	led->groups = nasgpio_led_groups;
 	ret = led_classdev_register(&nas_gpio_pci_dev->dev, led);
 	if (ret)
 		return ret;
-	ret = device_create_file(led->dev, &dev_attr_blink);
-	if (ret)
-		led_classdev_unregister(led);
-	return ret;
+
+	return 0;
 }
 
 static void unregister_nasgpio_led(int led_nr)
 {
 	struct led_classdev *led = get_classdev_for_led_nr(led_nr);
 	led_classdev_unregister(led);
-	device_remove_file(led->dev, &dev_attr_blink);
 }
 /*
  * module load/initialization
-- 
1.8.5.5

