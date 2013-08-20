Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3HTOES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:04:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:19968 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab3HTOEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:04:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,920,1367996400"; 
   d="scan'208";a="389127313"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC PATCH 0/2] runtime PM support for I2C clients
Date: Tue, 20 Aug 2013 17:03:34 +0300
Message-Id: <1377007416-13851-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

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

Even though this series has been developed specifically for ACPI enumerated
I2C client devices, I believe it can be useful for other I2C client drivers
because the I2C core now prepares the runtime PM on behalf of the driver
and thus reduces the amount of code a driver writer needs to add.

Aaron Lu (1):
  i2c: prepare runtime PM support for I2C client devices

Lv Zheng (1):
  i2c: attach/detach I2C client device to the ACPI power domain

 drivers/i2c/i2c-core.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

-- 
1.8.4.rc2

