Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaHTGjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 02:39:14 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:60566 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaHTGjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 02:39:09 -0400
From: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Cc: =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>
Subject: [PATCH] pwm-backlight: fix bogus request for GPIO#0 when instantiated from DT
Date: Wed, 20 Aug 2014 08:38:36 +0200
Message-Id: <1408516716-28828-1-git-send-email-LW@KARO-electronics.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 257462dbf3ed ("pwm-backlight: switch to gpiod interface")
introduced a regression leading to acquiring a bogus GPIO-0 when
configured from DT without an 'enable-gpios' property.
The driver will happily accept the 0 initialized 'enable_gpio' member
of the struct platform_pwm_backlight_data as valid gpio number, and
request this GPIO as enable pin. In case of multiple driver instances,
the second will fail to register with the error message:
pwm-backlight backlight1.23: failed to request GPIO#0: -16

Fix this by setting enable_gpio in the pdata struct to -EINVAL.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/video/backlight/pwm_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index d7a3d13..e6ef6b4 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -172,7 +172,7 @@ static int pwm_backlight_parse_dt(struct device *dev,
 		data->dft_brightness = value;
 		data->max_brightness--;
 	}
-
+	data->enable_gpio = -EINVAL;
 	return 0;
 }
 
-- 
1.7.10.4

