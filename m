Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab3IKCQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:16:23 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35913 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3IKCQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:16:22 -0400
Date: Tue, 10 Sep 2013 19:16:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v2 2/6] extcon-gpio: Use gpio driver/chip debounce if
 supported
Message-ID: <20130911021618.GA2657@roeck-us.net>
References: <1377836978-24082-1-git-send-email-linux@roeck-us.net>
 <1377836978-24082-3-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377836978-24082-3-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: rephrase patch subject
    call gpio_set_debounce before registering extcon device,
    and set debounce_jiffies only if the call was not successful

 drivers/extcon/extcon-gpio.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 77d35a7..e5a4405 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -100,7 +100,13 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 	extcon_data->state_off = pdata->state_off;
 	if (pdata->state_on && pdata->state_off)
 		extcon_data->edev.print_state = extcon_gpio_print_state;
-	extcon_data->debounce_jiffies = msecs_to_jiffies(pdata->debounce);
+	if (pdata->debounce) {
+		ret = gpio_set_debounce(extcon_data->gpio,
+					pdata->debounce * 1000);
+		if (ret < 0)
+			extcon_data->debounce_jiffies =
+				msecs_to_jiffies(pdata->debounce);
+	}
 
 	ret = extcon_dev_register(&extcon_data->edev, &pdev->dev);
 	if (ret < 0)
-- 
1.7.9.7

