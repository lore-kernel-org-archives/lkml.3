Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab3GLL5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 07:57:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53462 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932877Ab3GLL46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 07:56:58 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>, Rajendra Nayak <rnayak@ti.com>,
        Felipe Balbi <balbi@ti.com>, Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 1/2] serial: omap: enable PM runtime only when its fully configured
Date: Fri, 12 Jul 2013 14:55:41 +0300
Message-ID: <1373630142-21765-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If earlyprintk is enabled and current UART is console port the platform
code can mark it as RPM_ACTIVE to sync real IP state with PM Runtime and
avoid resuming of already active device, but now, driver initialization
will be performed in the wrong way:

	pm_runtime_enable(&pdev->dev);
    <-- PM runtime alowed (device state RPM_ACTIVE)
	if (omap_up_info->autosuspend_timeout == 0)
		omap_up_info->autosuspend_timeout = -1;
	device_init_wakeup(up->dev, true);
	pm_runtime_use_autosuspend(&pdev->dev);
	<-- update_autosuspend() will be called and it will disable device
        (device state RPM_SUSPENDED)
	pm_runtime_set_autosuspend_delay(&pdev->dev,
			omap_up_info->autosuspend_timeout);
	<-- update_autosuspend() will be called which will re-enable device
        (device state RPM_ACTIVE), because autosuspend_timeout < 0

	pm_runtime_irq_safe(&pdev->dev);
	pm_runtime_get_sync(&pdev->dev);
	<-- will do nothing

Such behavior isn't expected by OMAP serial drivers and causes
unpredictable calls of serial_omap_runtime_suspend() and
serial_omap_runtime_resume().

Hence, fix it by allowing PM runtime only after all its parameters are
configured.

CC: Tony Lindgren <tony@atomide.com>
CC: Rajendra Nayak <rnayak@ti.com>
CC: Felipe Balbi <balbi@ti.com>
CC: Kevin Hilman <khilman@linaro.org>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
tested on OMAP4 SDP with and without earlyprintk enabled.
 drivers/tty/serial/omap-serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index b6d1728..f39bf0c 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1501,7 +1501,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 	INIT_WORK(&up->qos_work, serial_omap_uart_qos_work);
 
 	platform_set_drvdata(pdev, up);
-	pm_runtime_enable(&pdev->dev);
 	if (omap_up_info->autosuspend_timeout == 0)
 		omap_up_info->autosuspend_timeout = -1;
 	device_init_wakeup(up->dev, true);
@@ -1510,6 +1509,8 @@ static int serial_omap_probe(struct platform_device *pdev)
 			omap_up_info->autosuspend_timeout);
 
 	pm_runtime_irq_safe(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	pm_runtime_get_sync(&pdev->dev);
 
 	omap_serial_fill_features_erratas(up);
-- 
1.7.9.5

