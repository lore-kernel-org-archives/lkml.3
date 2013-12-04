Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3LDXyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 18:54:46 -0500
Received: from gloria.sntech.de ([95.129.55.99]:45256 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab3LDXyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 18:54:45 -0500
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Subject: [PATCH] serial: samsung: move clock deactivation below uart registration
Date: Thu, 5 Dec 2013 00:54:38 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <chander.kashyap@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312050054.39327.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 60e93575476f (serial: samsung: enable clock before clearing pending
interrupts during init) added handling of the controller clock during init.

On most systems this clock is also one of the baud_clock sources and
possibly used by the earlycon and thus already enabled by the bootloader.

Therefore a gap exists between s3c24xx_serial_init_port disabling the
clock and an attached console reenabling it, making the transition from
earlycon to regular console possibly hang the system - as seen on my
S3C2442 based Freerunner today.

Therefore move the disabling of the clock from s3c24xx_serial_init_port
below the uart port registration, effectively creating an overlap and
keeping the clock running non-stop if the console wants to grab this port.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/tty/serial/samsung.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c1af04d..9cd706d 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1209,7 +1209,6 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 
 	/* reset the fifos (and setup the uart) */
 	s3c24xx_serial_resetport(port, cfg);
-	clk_disable_unprepare(ourport->clk);
 	return 0;
 }
 
@@ -1287,6 +1286,13 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
 	uart_add_one_port(&s3c24xx_uart_drv, &ourport->port);
 	platform_set_drvdata(pdev, &ourport->port);
 
+	/*
+	 * Deactivate the clock enabled in s3c24xx_serial_init_port here,
+	 * so that a potential re-enablement through the pm-callback overlaps
+	 * and keeps the clock enabled in this case.
+	 */
+	clk_disable_unprepare(ourport->clk);
+
 #ifdef CONFIG_SAMSUNG_CLOCK
 	ret = device_create_file(&pdev->dev, &dev_attr_clock_source);
 	if (ret < 0)
-- 
1.7.10.4

