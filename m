Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3IWO2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:28:33 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:45956 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3IWO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:27:58 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>, Mark Brown <broonie@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-pcmcia@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 0/7] driver core: prevent deferred probe with platform_driver_probe
Date: Mon, 23 Sep 2013 16:27:25 +0200
Message-Id: <1379946452-25649-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130923134028.GF21013@sirena.org.uk>
References: <20130923134028.GF21013@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deferred probing cannot be used with platform_driver_probe as by the
time probing is retried either the driver has been unregistered or its
probe function has been set to platform_drv_probe_fail.

With commit e9354576 ("gpiolib: Defer failed gpio requests by default")
the gpio subsystem started returning -EPROBE_DEFER, which in turn
several platform drivers using platform_driver_probe return to driver
core. Other subsystems (e.g. regulator) has since started doing the
same.

The first patch in this series prevents platform drivers using
platform_driver_probe from requesting probe deferral while warning that
it is not supported.

The remaining patches move six platform-driver probe functions that rely
on gpio_request out of __init. There are likely other probe functions
that might return -EPROBE_DEFER and should be moved out of __init as
well.

Note that the mvsdio, at91_cf and pxa25x_udc patches are completely
untested.

Johan


Johan Hovold (7):
  driver core: prevent deferred probe with platform_driver_probe
  mmc: mvsdio: fix deferred probe from __init
  mtd: atmel_nand: fix deferred probe from __init
  pcmcia: at91_cf: fix deferred probe from __init
  usb: gadget: pxa25x_udc: fix deferred probe from __init
  usb: phy: gpio-vbus: fix deferred probe from __init
  backlight: atmel-pwm-bl: fix deferred probe from __init

 drivers/base/platform.c                | 17 +++++++++++++----
 drivers/mmc/host/mvsdio.c              | 11 ++++++-----
 drivers/mtd/nand/atmel_nand.c          | 13 +++++++------
 drivers/pcmcia/at91_cf.c               | 11 +++++------
 drivers/usb/gadget/pxa25x_udc.c        |  9 +++++----
 drivers/usb/phy/phy-gpio-vbus-usb.c    | 11 +++++------
 drivers/video/backlight/atmel-pwm-bl.c |  9 +++++----
 include/linux/platform_device.h        |  1 +
 8 files changed, 47 insertions(+), 35 deletions(-)

-- 
1.8.3.2

