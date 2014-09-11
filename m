Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbaIKND6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:03:58 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36302 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbaIKND4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:03:56 -0400
Message-ID: <54119DB6.8020807@collabora.co.uk>
Date: Thu, 11 Sep 2014 15:03:50 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        wsa@the-dreams.de, sjoerd.simons@collabora.co.uk
Subject: SPI and module auto-loading
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

We found an issue with module auto-loading on an I2C driver [0] and it turned
out to be a problem on how the I2C subsystem reports the module alias to
user-space. It always report modalias as "i2c:<dev_id>" even when the driver
is probed via DT. The problem with this particular driver is that the I2C
device ID table didn't contain an entry that matched what the I2C core was
reporting as the MODALIAS uevent env var.

I looked at the SPI core and it does the same. It always reports to udev as
modalias "spi:<dev_id>" so the aliases filled in a module from the OF table
are never used.

This can be easily worked around (and probably why it never was an issue) if
the OF and SPI tables are kept in sync but I don't know if that is a hard
requirement for all use-cases (e.g: a SPI driver that is DT only?).

Now, changing this behavior will break module auto-loading for a lot of
drivers relies on the current behavior and don't define a struct of_device_id
or are not using the MODULE_DEVICE_TABLE(of,..) macro but I wonder if that
means that the drivers are broken and should be fixed?

I'm sending an RFC patch [1] to know what you think about it.

Thanks a lot and best regards,
Javier

[0]: https://lkml.org/lkml/2014/9/11/127
[1]
>From a7cd35209a597a578df6c801e5ff7b63b584bf3e Mon Sep 17 00:00:00 2001
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Date: Thu, 11 Sep 2014 14:31:04 +0200
Subject: [PATCH RFC] spi: core: report OF style modalias when probing using DT

An SPI driver that supports both OF and legacy platforms, will have
both an OF and SPI ID table. This means that when built as a module,
the aliases will be filled from both tables, e.g:

$ modinfo cros_ec_spi | grep alias
alias:          spi:cros-ec-spi
alias:          of:N*T*Cgoogle,cros-ec-spi*

But currently always an alias of the form spi:<dev_id> is reported
even when the it was probed by matching the OF compatible string.

$ cat /sys/devices/12d40000.spi/spi_master/spi2/spi2.0/modalias
spi:cros-ec-spi

Drivers for IP blocks that are included in DT-only platforms, may not
have an updated SPI ID table so if a device is probed by matching its
compatible string, udev can get a MODALIAS uevent env var that doesn't
match with one of the valid aliases so the module won't be auto-loaded
by libkmod/modprobe.

This patch reports OF related uevent env vars (e.g: OF_COMPATIBLE) and
so the module can be auto-loaded and also report the correctly on sysfs:

$ cat /sys/devices/12d40000.spi/spi_master/spi2/spi2.0/modalias
of:Ncros-ecT<NULL>Cgoogle,cros-ec-spi

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

NOTE: this will break module auto-loading for all drivers that rely on the
current behavior so it should not be applied unless is part of a series that
fix all the broken drivers.

 drivers/spi/spi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 95cfe3b..154e1d6 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -63,6 +63,10 @@ modalias_show(struct device *dev, struct device_attribute
*a, char *buf)
 	const struct spi_device	*spi = to_spi_device(dev);
 	int len;

+	len = of_device_get_modalias(dev, buf, PAGE_SIZE - 1);
+	if (len != -ENODEV)
+		return len;
+
 	len = acpi_device_modalias(dev, buf, PAGE_SIZE - 1);
 	if (len != -ENODEV)
 		return len;
@@ -124,6 +128,10 @@ static int spi_uevent(struct device *dev, struct
kobj_uevent_env *env)
 	const struct spi_device		*spi = to_spi_device(dev);
 	int rc;

+	rc = of_device_uevent_modalias(dev, env);
+	if (rc != -ENODEV)
+		return rc;
+
 	rc = acpi_device_uevent_modalias(dev, env);
 	if (rc != -ENODEV)
 		return rc;
-- 
2.1.0
