Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaEHI2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 04:28:12 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:54429 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaEHI2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 04:28:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@linuxdriverproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Wei WANG <wei_wang@realsil.com.cn>, Roger <rogerable@realtek.com>
Subject: [PATCH v2] mmc: rtsx: fix possible linking error if built-in
Date: Thu, 08 May 2014 10:27:54 +0200
Message-ID: <4738962.LU0Ymo0veu@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zI3bz6/uCq0Z6Q8fAoLnhvHEVbcVfHLRKUCdkWU1vMf
 Rhy5xWOvCiUQOIjnejLy701URLIEahoetIF6UUuFFoEFYpaaBX
 I93ELC0mQNI6DQmNaXSLYNPs48vWRwP1/EIe8qlTC6+Jf8bM5h
 cU+hIKcX3OjosZdgk5L2Fw6uUgzr4sLgtnF34YeJ0N6KRDq4Pq
 vwezg2x3NnDn7gzW2NEXDEQuwgMSq3KnW8FksyhQet4By4fNdu
 2F7GVD7PlNGpD4q78D+MLa4kVXVIrDXZ+Z7WpuhJD+lxJ75o3B
 BDhUlN+0N/i71785Pyr06alPaKpULxPEZSj//NyDk80CJHNelz
 Zjt27v9mlhfPmJDmZBOc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtsx_usb_sdmmc module uses the LED classdev if available, but the code
failed to consider the situation that it is built-in and the LED classdev is a
module, leading to following linking error:

   LD      init/built-in.o
drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_remove':
rtsx_usb_sdmmc.c:(.text+0x2a018e): undefined reference to
`led_classdev_unregister'
drivers/built-in.o: In function `rtsx_usb_sdmmc_drv_probe':
rtsx_usb_sdmmc.c:(.text+0x2a197e): undefined reference to
`led_classdev_register'

Fix by excluding such condition when defining macro RTSX_USB_USE_LEDS_CLASS.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
---
v2 by Arnd: change the second #ifdef as well.

diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index e11fafa..5d3766e 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -34,7 +34,8 @@
 #include <linux/mfd/rtsx_usb.h>
 #include <asm/unaligned.h>
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#if defined(CONFIG_LEDS_CLASS) || (defined(CONFIG_LEDS_CLASS_MODULE) && \
+		defined(CONFIG_MMC_REALTEK_USB_MODULE))
 #include <linux/leds.h>
 #include <linux/workqueue.h>
 #define RTSX_USB_USE_LEDS_CLASS
@@ -59,7 +60,7 @@ struct rtsx_usb_sdmmc {
 
 	unsigned char		power_mode;
 
-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#ifdef RTSX_USB_USE_LEDS_CLASS
 	struct led_classdev	led;
 	char			led_name[32];
 	struct work_struct	led_work;

