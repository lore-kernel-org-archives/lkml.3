Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbaIIHkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:40:43 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:56882 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaIIHkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:40:41 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: linux-leds@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Bryan Wu <cooloney@gmail.com>,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH 1/2] leds: trigger: gpio: fix warning in gpio trigger for gpios whose accessor function may sleep
Date: Tue,  9 Sep 2014 09:40:32 +0200
Message-Id: <1410248433-24005-2-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410248433-24005-1-git-send-email-LW@KARO-electronics.de>
References: <1410248433-24005-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a GPIO driver whose accessor functions may sleep (e.g. an
I2C GPIO extender like PCA9554) the following warning is issued:
WARNING: CPU: 0 PID: 665 at drivers/gpio/gpiolib.c:2274 gpiod_get_raw_value+0x3c/0x48()
Modules linked in:
CPU: 0 PID: 665 Comm: kworker/0:2 Not tainted 3.16.0-karo+ #115
Workqueue: events gpio_trig_work
[<c00142cc>] (unwind_backtrace) from [<c00118f8>] (show_stack+0x10/0x14)
[<c00118f8>] (show_stack) from [<c001bf10>] (warn_slowpath_common+0x64/0x84)
[<c001bf10>] (warn_slowpath_common) from [<c001bf4c>] (warn_slowpath_null+0x1c/0x24)
[<c001bf4c>] (warn_slowpath_null) from [<c020a1b8>] (gpiod_get_raw_value+0x3c/0x48)
[<c020a1b8>] (gpiod_get_raw_value) from [<c02f68a0>] (gpio_trig_work+0x1c/0xb0)
[<c02f68a0>] (gpio_trig_work) from [<c0030c1c>] (process_one_work+0x144/0x38c)
[<c0030c1c>] (process_one_work) from [<c0030ef8>] (worker_thread+0x60/0x5cc)
[<c0030ef8>] (worker_thread) from [<c0036dd4>] (kthread+0xb4/0xd0)
[<c0036dd4>] (kthread) from [<c000f0f0>] (ret_from_fork+0x14/0x24)
---[ end trace cd51a1dad8b86c9c ]---

Fix this by using the _cansleep() variant of gpio_get_value().

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/leds/trigger/ledtrig-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-gpio.c b/drivers/leds/trigger/ledtrig-gpio.c
index 35812e3..c86c418 100644
--- a/drivers/leds/trigger/ledtrig-gpio.c
+++ b/drivers/leds/trigger/ledtrig-gpio.c
@@ -48,7 +48,7 @@ static void gpio_trig_work(struct work_struct *work)
 	if (!gpio_data->gpio)
 		return;
 
-	tmp = gpio_get_value(gpio_data->gpio);
+	tmp = gpio_get_value_cansleep(gpio_data->gpio);
 	if (gpio_data->inverted)
 		tmp = !tmp;
 
-- 
1.7.10.4

