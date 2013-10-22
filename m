Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3JVQdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:33:10 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:51853 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab3JVQdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:33:07 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/2] misc: atmel_pwm: set initcall level to subsys
Date: Tue, 22 Oct 2013 18:32:40 +0200
Message-Id: <1382459560-26596-3-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
References: <1382459560-26596-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even with the atmel_pwm driver and the atmel-pwm-bl backlight driver
supporting deferred probing, we still want to make sure that any
pwm-device is available when the backlight devices are probed to avoid
any unnecessary delays before enabling the backlight.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/misc/atmel_pwm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/atmel_pwm.c b/drivers/misc/atmel_pwm.c
index a6dc56e..0d0f599 100644
--- a/drivers/misc/atmel_pwm.c
+++ b/drivers/misc/atmel_pwm.c
@@ -395,7 +395,17 @@ static struct platform_driver atmel_pwm_driver = {
 	 */
 };
 
-module_platform_driver_probe(atmel_pwm_driver, pwm_probe);
+static int __init pwm_init(void)
+{
+	return platform_driver_probe(&atmel_pwm_driver, pwm_probe);
+}
+subsys_initcall(pwm_init);
+
+static void __exit pwm_exit(void)
+{
+	platform_driver_unregister(&atmel_pwm_driver);
+}
+module_exit(pwm_exit);
 
 MODULE_DESCRIPTION("Driver for AT32/AT91 PWM module");
 MODULE_LICENSE("GPL");
-- 
1.8.4

