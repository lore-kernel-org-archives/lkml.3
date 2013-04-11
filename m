Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937259Ab3DKAGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:06:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933361Ab3DKAGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 05/30] tty: serial/samsung: prepare for common clock API
Date: Thu, 11 Apr 2013 02:04:47 +0200
Message-Id: <1365638712-1028578-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:KyQbOUpbyZHPWhwt8ZZEiDct7TTIJtZsAyEwRUOD0mY
 lzzfCpe6ZBjzm/hOhor7odjuB1HN/T0DGxum67zWTGDYjT+o3L
 SqCYZ+sv06xy4gJNvmhFahlKcGErJnOuBka9PJD59wTUMvt1XI
 vDG3WFXfFcmzOhlm5ArVyBg05GUPIiu4zph7jswMwIJH6KKTw0
 569OwTU4SfqP/P7/HjWDNzFUCVs1pUYJZkv7HXJA1YMQ+X65L7
 bA6CcAscl6FGt6db1670tH51MnJAXr3yv+bUjla8ucvG21f/MR
 IXLwInpqOhCJW/6ee7n4Ym3r+RIahP4LlloGbiHAAigLIgGoUK
 /SAeMvLLLyPqXVf0vD3HiutMFvum8RcGDapP0A2TKVg9U3qvE9
 6E8TWY9MAWDyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the common clock interface, there is no way to provide the
"clock_source" sysfs attribute for the samsung serial ports. Given that
this file was purely informational and had fixed contents, we have reason
to believe that no user space programs were relying on it.

The sysfs file is not documented in the ABI docs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/samsung.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index 2769a38..603f3f3 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1179,6 +1179,7 @@ static int s3c24xx_serial_init_port(struct s3c24xx_uart_port *ourport,
 	return 0;
 }
 
+#ifdef CONFIG_SAMSUNG_CLOCK
 static ssize_t s3c24xx_serial_show_clksrc(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
@@ -1194,7 +1195,7 @@ static ssize_t s3c24xx_serial_show_clksrc(struct device *dev,
 }
 
 static DEVICE_ATTR(clock_source, S_IRUGO, s3c24xx_serial_show_clksrc, NULL);
-
+#endif
 
 /* Device driver serial port probe */
 
@@ -1252,9 +1253,11 @@ static int s3c24xx_serial_probe(struct platform_device *pdev)
 	uart_add_one_port(&s3c24xx_uart_drv, &ourport->port);
 	platform_set_drvdata(pdev, &ourport->port);
 
+#ifdef CONFIG_SAMSUNG_CLOCK
 	ret = device_create_file(&pdev->dev, &dev_attr_clock_source);
 	if (ret < 0)
 		dev_err(&pdev->dev, "failed to add clock source attr.\n");
+#endif
 
 	ret = s3c24xx_serial_cpufreq_register(ourport);
 	if (ret < 0)
@@ -1272,7 +1275,9 @@ static int s3c24xx_serial_remove(struct platform_device *dev)
 
 	if (port) {
 		s3c24xx_serial_cpufreq_deregister(to_ourport(port));
+#ifdef CONFIG_SAMSUNG_CLOCK
 		device_remove_file(&dev->dev, &dev_attr_clock_source);
+#endif
 		uart_remove_one_port(&s3c24xx_uart_drv, port);
 	}
 
-- 
1.8.1.2

