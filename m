Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3HXSzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 14:55:22 -0400
Received: from nm19-vm1.access.bullet.mail.bf1.yahoo.com ([216.109.115.96]:39868
	"EHLO nm19-vm1.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353Ab3HXSzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 14:55:21 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Aug 2013 14:55:20 EDT
X-Yahoo-Newman-Id: 16228.26432.bm@smtp112.sbc.mail.ne1.yahoo.com
X-Rocket-Received: from localhost.localdomain (danielfsantos@99.70.244.137 with login)
        by smtp112.sbc.mail.ne1.yahoo.com with SMTP; 24 Aug 2013 11:48:29 -0700 PDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: h_22rXwVM1naTHui8h05MqV_gjesRWHcg4wBvEVRssR1A_j
 j3LRG4Pls2A0MkW8P9yl.IEht.zX1erOsm3AUplm.WwMJtLo8925zDdn8GIK
 yoHA_KUVIt.L1nKcwyLDqVFBWPiysi1XhoTQQgYTjTxVCq5Vm9Gf7hL2zuUt
 gqz2uNjvW1SHLo4X_9zpmKZqy4KzWQ3Uq9n_sAdgz4Ei4V5IwfETXJBXnL6g
 r4JivJro.9jZY_kwi_OgGkv39ht0dU9TXDRkc4tdmAod_bpra7vwQqT9opR8
 Ib._T3m2KnKYGpn.ounHn81_OvjgXNrUfVqQelcnEi.ucoAYP.yD1idoyQjh
 goyUmUYIPJxQWiCEkioQobXSQn5a3kw6.grhlB5lk_W2CvphoGt1o_DTprC4
 leqo0LZOWiwzgW10cL4oY3z7bCedVc4xXBhYHenluB8nRaiwZ3RHAOOCIaX5
 J.VA..HP9m51HJEdjo4SROsQlDtvq0ruXxIClXJHVduJbxFtH9Wv9TfhkK7a
 vWkQ2pBoI3hyzbJsdiqfZHmGL42WC4dJUdeZyeZ6ja7MzIsXgbMLb8pVMiMY
 ZWogxjfsgm2ganR_RoHkJ6EMOLsW6Bv8K9SuW.Ss3pxdTwidJViY4bA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH] gpiolib: Fix crash when exporting non-existant gpio
Date: Sat, 24 Aug 2013 13:48:28 -0500
Message-Id: <1377370108-2867-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.8.1.5
Reply-To: Daniel Santos <daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this on an RPi and I can't find anything specific to that.
Besides, it's clearly wrong to try to access desc->chip when we have
just tested that it may be NULL at drivers/gpio/gpiolib.c:1409:

	chip = desc->chip;
	if (chip == NULL)
		goto done;

....

done:
	if (status)
		pr_debug("_gpio_request: gpio-%d (%s) status %d\n",
			 desc_to_gpio(desc), label ? : "?", status);

To reproduce, just pick an invalid gpio nubmer and:

echo -n 248 > /sys/class/gpio/export

However, I wasn't able to reproduce it on my laptop, maybe because I
don't have any real gpio chips there, not sure.  More info on RPi bug
report: https://github.com/raspberrypi/linux/issues/364

[  222.961384] Unable to handle kernel NULL pointer dereference at
virtual address 00000044
[  222.969486] pgd = d97d0000
[  222.972190] [00000044] *pgd=1aaca831, *pte=00000000, *ppte=00000000
[  222.978483] Internal error: Oops: 17 [#1] PREEMPT ARM
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d6413b2..e547f75f8b 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -136,7 +136,7 @@ static struct gpio_desc *gpio_to_desc(unsigned gpio)
  */
 static int desc_to_gpio(const struct gpio_desc *desc)
 {
-	return desc->chip->base + gpio_chip_hwgpio(desc);
+	return desc->chip ?  desc->chip->base + gpio_chip_hwgpio(desc) : -1;
 }
 
 
-- 
1.8.1.5

