Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3IKPdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:33:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:9323 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab3IKPdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:33:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,885,1371106800"; 
   d="scan'208";a="399998717"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 0/9] runtime PM support for I2C and SPI client devices
Date: Wed, 11 Sep 2013 18:32:31 +0300
Message-Id: <1378913560-2752-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is second version of the patches. The previous version can be found
here:

	http://www.spinics.net/lists/linux-i2c/msg13152.html

With the advent of ACPI 5.0 we are starting to see I2C client devices
described in ACPI namespace that support power management by the means of
standard ACPI _PSx-methods. For example Intel Haswell based platforms might
have touch screen or sensor-hub connected to the I2C bus that can be
powered on and off by calling _PS0 and _PS3 -methods.

In order to support such I2C client devices, we decided to hook the ACPI
power management for these to the standard Linux runtime PM framework.

These patches implement runtime PM support for I2C client devices in a
similar way that is done already for the PCI bus. Just before a driver is
bound to an I2C client device the device runtime PM is being prepared for
that device.

If the device in question has an ACPI handle we attach it to the ACPI power
domain that then makes sure that the right _PSx methods are called in
response to runtime PM events the driver generates.

A driver that wants to participate in runtime PM and power manage its
device should:
 1) Implement device specific runtime PM callbacks if needed.
 2) Call pm_runtime_put() (or some variant of that) to decrease the runtime
    PM reference count.

If the driver doesn't do anything the device is regarded as runtime PM
active and powered on.

In the previous version we did this only for the I2C bus. However, Mark
Brown suggested that the same thing should be done also for the SPI bus.
This series now attempts to address that as well.

In addition we convert the existing I2C client drivers to use this model to
prevent any regressions from happening. I split the patches per subsystem
and the maintainers should be in CC list.

Note that I don't have hardware to test these existing I2C drivers so they
are only compile tested (well, except the s5p-tv which I wasn't able to
compile at all on x86).

Since the I2C patches are dependent on the core support I suggest that if this
gets merged, they would go through the I2C tree.

The SPI part could go separately via SPI tree as there are no existing
runtime PM users.

Changes to the previous version:
 * Runtime PM is now unblocked by default.
 * The existing I2C drivers have been converted to this model.
 * Added runtime PM support for SPI devices.

[ Rafael ACKed the previous version but I've changed the patches a bit, so I
  only kept his ACK in the second patch (it is unchanged). ]

Aaron Lu (1):
  i2c: prepare runtime PM support for I2C client devices

Lv Zheng (1):
  i2c: attach/detach I2C client device to the ACPI power domain

Mika Westerberg (7):
  Input: misc - convert existing I2C client drivers to use I2C core runtime PM
  [media] s5p-tv: convert to use I2C core runtime PM
  drivers/misc: convert existing I2C clients driver to use I2C core runtime PM
  mfd: wm8994: convert to use I2C core runtime PM
  ASoC: codecs: convert existing I2C client drivers to use I2C core runtime PM
  spi: prepare runtime PM support for SPI devices
  spi: attach/detach SPI device to the ACPI power domain

 drivers/i2c/i2c-core.c                      | 53 +++++++++++++++++++++++++-
 drivers/input/misc/bma150.c                 |  4 +-
 drivers/input/misc/mpu3050.c                | 16 ++------
 drivers/media/platform/s5p-tv/sii9234_drv.c | 30 +++------------
 drivers/mfd/wm8994-core.c                   |  5 +--
 drivers/misc/apds9802als.c                  |  7 +---
 drivers/misc/apds990x.c                     | 16 +++-----
 drivers/misc/bh1770glc.c                    | 12 +++---
 drivers/misc/fsa9480.c                      |  2 -
 drivers/misc/isl29020.c                     |  3 +-
 drivers/spi/spi.c                           | 58 ++++++++++++++++++++++++++++-
 sound/soc/codecs/wm2200.c                   | 12 +++---
 sound/soc/codecs/wm5100.c                   |  8 ++--
 sound/soc/codecs/wm8962.c                   |  5 +--
 14 files changed, 147 insertions(+), 84 deletions(-)

-- 
1.8.4.rc3

