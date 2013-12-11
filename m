Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3LKKNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:13:25 -0500
Received: from [207.46.163.24] ([207.46.163.24]:38348 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751294Ab3LKKM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:12:56 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <cooloney@gmail.com>, <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b47053@freescale.com>
Subject: [PATCH] leds: leds-pwm: fix duty time overflow.
Date: Wed, 11 Dec 2013 17:19:42 +0800
Message-ID: <1386753582-16009-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overflow maybe occurs when calculates the duty time. For instance,
the period time is 990000000ns, and the max_brightness is 127, when
setting the brightness to 12, the duty value will be 25906026ns, but
it should be 93543307ns.
---
 drivers/leds/leds-pwm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
index bb6f948..7cb2cd8 100644
--- a/drivers/leds/leds-pwm.c
+++ b/drivers/leds/leds-pwm.c
@@ -66,9 +66,11 @@ static void led_pwm_set(struct led_classdev *led_cdev,
 	struct led_pwm_data *led_dat =
 		container_of(led_cdev, struct led_pwm_data, cdev);
 	unsigned int max = led_dat->cdev.max_brightness;
-	unsigned int period =  led_dat->period;
+	unsigned long long duty =  led_dat->period;
 
-	led_dat->duty = brightness * period / max;
+	duty *= brightness;
+	do_div(duty, max);
+	led_dat->duty = duty;
 
 	if (led_dat->can_sleep)
 		schedule_work(&led_dat->work);
-- 
1.8.4


