Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaJFKH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:07:28 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:63765 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751564AbaJFKH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:07:26 -0400
Message-ID: <1412590043.4054.61.camel@x220>
Subject: [PATCH] serial: samsung: Remove checks for CONFIG_SAMSUNG_CLOCK
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2014 12:07:23 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 10:07:24.0254 (UTC) FILETIME=[534117E0:01CFE14D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 32726d2d5502 ("ARM: SAMSUNG: Remove legacy clock code") removed
the Kconfig symbol SAMSUNG_CLOCK. Remove the last checks for its macro,
and the dead code they hide, too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This trivial fix has been discussed for some time now in the thread
starting at http://lkml.kernel.org/r/1405502840.4408.2.camel@x220 It
seems it's time to submit it.

Build tested on top of next-20141003, on x86_64 (!), with these horrific
commands:
    make EXTRA_CFLAGS=-DCONFIG_SERIAL_SAMSUNG_UARTS=3 drivers/tty/serial/samsung.o
    make EXTRA_CFLAGS=-DCONFIG_SERIAL_SAMSUNG_UARTS=4 drivers/tty/serial/samsung.o

Please note that
    make EXTRA_CFLAGS=-DCONFIG_SERIAL_SAMSUNG_UARTS=0 drivers/tty/serial/samsung.o

doesn't build. Perhaps some "range" should be added to config
SERIAL_SAMSUNG_UARTS. And I also wonder whether SERIAL_SAMSUNG_UARTS
should be a dependency (somehow) of config SERIAL_SAMSUNG. I have not
looked into those questions.

 drivers/tty/serial/samsung.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index c78f43a481ce..796c04c77dc1 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1226,24 +1226,6 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 	return 0;
 }
 
-#ifdef CONFIG_SAMSUNG_CLOCK
-static ssize_t s3c24xx_serial_show_clksrc(struct device *dev,
-					  struct device_attribute *attr,
-					  char *buf)
-{
-	struct uart_port *port = s3c24xx_dev_to_port(dev);
-	struct s3c24xx_uart_port *ourport = to_ourport(port);
-
-	if (IS_ERR(ourport->baudclk))
-		return -EINVAL;
-
-	return snprintf(buf, PAGE_SIZE, "* %s\n",
-			ourport->baudclk->name ?: "(null)");
-}
-
-static DEVICE_ATTR(clock_source, S_IRUGO, s3c24xx_serial_show_clksrc, NULL);
-#endif
-
 /* Device driver serial port probe */
 
 static const struct of_device_id s3c24xx_uart_dt_match[];
@@ -1329,12 +1311,6 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
 	 */
 	clk_disable_unprepare(ourport->clk);
 
-#ifdef CONFIG_SAMSUNG_CLOCK
-	ret = device_create_file(&pdev->dev, &dev_attr_clock_source);
-	if (ret < 0)
-		dev_err(&pdev->dev, "failed to add clock source attr.\n");
-#endif
-
 	ret = s3c24xx_serial_cpufreq_register(ourport);
 	if (ret < 0)
 		dev_err(&pdev->dev, "failed to add cpufreq notifier\n");
@@ -1348,9 +1324,6 @@ static int s3c24xx_serial_remove(struct platform_device *dev)
 
 	if (port) {
 		s3c24xx_serial_cpufreq_deregister(to_ourport(port));
-#ifdef CONFIG_SAMSUNG_CLOCK
-		device_remove_file(&dev->dev, &dev_attr_clock_source);
-#endif
 		uart_remove_one_port(&s3c24xx_uart_drv, port);
 	}
 
-- 
1.9.3

