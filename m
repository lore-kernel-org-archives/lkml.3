Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaIITZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:25:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:19752 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216AbaIITZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:25:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,492,1406617200"; 
   d="scan'208";a="476418233"
From: Octavian Purdila <octavian.purdila@intel.com>
To: gregkh@linuxfoundation.org, linus.walleij@linaro.org, gnurou@gmail.com,
        wsa@the-dreams.de, sameo@linux.intel.com, lee.jones@linaro.org
Cc: arnd@arndb.de, johan@kernel.org, daniel.baluta@intel.com,
        laurentiu.palcu@intel.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v4 0/3] mfd: add support for Diolan DLN-2
Date: Tue,  9 Sep 2014 22:24:43 +0300
Message-Id: <1410290686-6680-1-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds support for Diolan USB-I2C/GPIO Master Adapter
DLN-2. Details about device can be found here:

https://www.diolan.com/i2c/i2c_interface.html.

Changes since v3:

 * Mostly addressing latest review comments from Johan

 * MFD driver: more message size checks for responses, switched to
   using unsigned for buffer sizes and use const void * for output
   buffer for the dln2_transfer() API, more codying style cleanups,
   renamed DLN2_HANDLE_GPIO_EVENT to DLN2_HANDLE_EVENT

 * MFD driver: turns out the RX buf size was too low for certain I2C
   drivers (I was seeing request up to 257 bytes), so increase it from
   64 to 512

 * GPIO driver: revert the retry chip remove change, as there are
   still issues if the gpio if exported to sysfs; coding style
   cleanups, correctly clamp no pin numbers to 32, use devm_kzalloc
   and simplify the error path in probe, cache pin direction to save
   one transfer when reading the pin value

 * I2C driver: add an i2c port parameter in the platform data
   (although only one port seems to be supported), make frequency a
   sysfs attribute instead of a module paramter, coding style
   cleanups, use devm_kzalloc and simplify the error path in probe,
   move the I2C buffers from the stack to the dln2_i2c structure (it
   is enough as we can have only one transfer at a time on the i2c
   adapter)

Changes since v2:

 * MFD driver: fix a few obsolete comments for the DLN2 I/O API

 * GPIO driver: retry the chip remove call if -EBUSY is returned, see
   the comments in dln2_do_remove for more details; also removed a
   redundant !dln2->pdev check from dln2_irq_event - we do it in
   dln2_transfer already

 * I2C driver: add I2C_FUNC_SMBUS_I2C_BLOCK support

Changes since v1:

 * rewrite the drivers as an MFD

 * rewrite the irq part of the gpio driver to use GPIOLIB_IRQCHIP

 * cleanup the I/O interface

 * various fixes and cleanps: check received message sizes before
   parsing, error handling for usb_submit_urb, check URB status, use
   single bit manipulation functions instead of bitmap_*, move
   GFP_KERNEL URB submit away from under lock


Daniel Baluta (1):
  gpio: add support for the Diolan DLN-2 USB GPIO driver

Laurentiu Palcu (1):
  i2c: add support for Diolan DLN-2 USB-I2C adapter

Octavian Purdila (1):
  mfd: add support for Diolan DLN-2 devices

 drivers/gpio/Kconfig          |  12 +
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-dln2.c      | 529 ++++++++++++++++++++++++++++++++
 drivers/i2c/busses/Kconfig    |  10 +
 drivers/i2c/busses/Makefile   |   1 +
 drivers/i2c/busses/i2c-dln2.c | 390 ++++++++++++++++++++++++
 drivers/mfd/Kconfig           |   9 +
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/dln2.c            | 681 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/dln2.h      |  71 +++++
 10 files changed, 1705 insertions(+)
 create mode 100644 drivers/gpio/gpio-dln2.c
 create mode 100644 drivers/i2c/busses/i2c-dln2.c
 create mode 100644 drivers/mfd/dln2.c
 create mode 100644 include/linux/mfd/dln2.h

-- 
1.9.1

