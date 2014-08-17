Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaHQGFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 02:05:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:51910 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaHQGFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 02:05:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,878,1400050800"; 
   d="scan'208";a="585897242"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>, Max Eliaser <max.eliaser@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/9] Add ACPI _DSD and unified device properties support
Date: Sun, 17 Aug 2014 09:04:10 +0300
Message-Id: <1408255459-17625-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Resending with fewer people in CC list. For some reason the series never
  reached attented mailing lists. ]

The recent publication of the ACPI 5.1 specification [1] adds a reserved name
for Device Specific Data (_DSD, Section 6.2.5). This mechanism allows for
passing arbitrary hardware description data to the OS. The exact format of the
_DSD data is specific to the UUID paired with it [2].   

An ACPI Device Properties UUID has been defined [3] to provide a format
compatible with existing device tree schemas. The purpose for this was to allow
for the reuse of the existing schemas and encourage the development of firmware
agnostic device drivers.

This series accomplishes the following (as well as some other dependencies):

 * Add _DSD support to the ACPI core
   This simply reads the UUID and the accompanying Package

 * Add ACPI Device Properties _DSD format support
   This understands the hierarchical key:value pair structure
   defined by the Device Properties UUID

 * Add a unified device properties API with ACPI and OF backends
   This provides for the firmware agnostic device properties
   Interface to be used by drivers

 * Provides 2 example drivers that were previously Device Tree aware that
   can now be used with either Device Tree or ACPI Device Properties. The
   both drivers use an arbitrary _HID.

This has been tested on Minnowboard with relevant parts of the modified
DSDT at the end of this email.

This series does not provide for a means to append to a system DSDT. That
will ultimately be required to make the most effective use of the _DSD
mechanism. Work is underway on that as a separate effort.

[1] http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf
[2] http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
[3] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf

Aaron Lu (3):
  of: Add property_ops callback for devices with of_node
  gpiolib: add API to get gpio desc and flags
  Input: gpio_keys_polled - Make use of device property API

Max Eliaser (1):
  leds: leds-gpio: Make use of device property API

Mika Westerberg (4):
  ACPI: Add support for device specific properties
  ACPI: Document ACPI device specific properties
  mfd: Add ACPI support
  gpio: sch: Consolidate core and resume banks

Rafael J. Wysocki (1):
  Driver core: Unified device properties interface for platform firmware

 Documentation/acpi/enumeration.txt        |  27 ++
 Documentation/acpi/properties.txt         | 359 ++++++++++++++++++++
 drivers/acpi/Makefile                     |   1 +
 drivers/acpi/glue.c                       |   4 +-
 drivers/acpi/internal.h                   |   6 +
 drivers/acpi/property.c                   | 542 ++++++++++++++++++++++++++++++
 drivers/acpi/scan.c                       |  14 +-
 drivers/base/Makefile                     |   2 +-
 drivers/base/property.c                   |  48 +++
 drivers/gpio/gpio-sch.c                   | 303 ++++++-----------
 drivers/gpio/gpiolib-acpi.c               |  81 +++--
 drivers/gpio/gpiolib.c                    |  18 +
 drivers/gpio/gpiolib.h                    |   8 +
 drivers/input/keyboard/gpio_keys_polled.c | 139 +++++---
 drivers/leds/leds-gpio.c                  | 130 ++++---
 drivers/mfd/mfd-core.c                    |  41 +++
 drivers/of/base.c                         | 194 ++++++++++-
 drivers/of/platform.c                     |   4 +-
 include/acpi/acpi_bus.h                   |   8 +
 include/linux/acpi.h                      |  40 +++
 include/linux/device.h                    |   3 +
 include/linux/gpio/consumer.h             |  11 +
 include/linux/mfd/core.h                  |   3 +
 include/linux/property.h                  |  54 +++
 24 files changed, 1716 insertions(+), 324 deletions(-)
 create mode 100644 Documentation/acpi/properties.txt
 create mode 100644 drivers/acpi/property.c
 create mode 100644 drivers/base/property.c
 create mode 100644 include/linux/property.h

------ DSDT For Minnowboard ------

    Scope (\_SB.PCI0.LPC)
    {
        Device (LEDS)
        {
            Name (_HID, "MNW0001")

            Name (_CRS, ResourceTemplate ()
            {
                GpioIo (Exclusive, PullDown, 0, 0, IoRestrictionOutputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {10}
                GpioIo (Exclusive, PullDown, 0, 0, IoRestrictionOutputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {11}
            })

            Device (LEDH)
            {
                Name (_HID, "PRP0000")
                Name (_DSD, Package ()
                {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package ()
                    {
                        Package () {"label", "Heartbeat"},
                        Package () {"gpios", Package () {^^LEDS, 0, 0, 0}},
                        Package () {"linux,default-trigger", "heartbeat"},
                        Package () {"linux,default-state", "off"},
                        Package () {"linux,retain-state-suspended", 1},
                    }
                })
            }

            Device (LEDM)
            {
                Name (_HID, "PRP0000")
                Name (_DSD, Package ()
                {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package ()
                    {
                        Package () {"label", "MMC0 Activity"},
                        Package () {"gpios", Package () {^^LEDS, 1, 0, 0}},
                        Package () {"linux,default-trigger", "mmc0"},
                        Package () {"linux,default-state", "on"},
                        Package () {"linux,retain-state-suspended", 1},
                    }
                })
            }
        }
        
        Device (BTNS)
        {
            Name (_HID, "MNW0002")

            Name (_CRS, ResourceTemplate ()
            {
                GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {0}
                GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {1}
                GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {2}
                GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {3}
            })

            Name (_DSD, Package ()
            {
                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                Package ()
                {
                    Package () {"poll-interval", 100},
                    Package () {"autorepeat", 1}
                }
            })

            Device (BTN0)
            {
                Name (_HID, "PRP0000")
                Name (_DSD, Package ()
                {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package ()
                    {
                        Package () {"linux,code", 105},
                        Package () {"linux,input-type", 1},
                        Package () {"gpios", Package () {^^BTNS, 0, 0, 1}},
                    }
                })
            }

            Device (BTN1)
            {
                Name (_HID, "PRP0000")
                Name (_DSD, Package ()
                {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package ()
                    {
                        Package () {"linux,code", 108},
                        Package () {"linux,input-type", 1},
                        Package () {"gpios", Package (4) {^^BTNS, 1, 0, 1}},
                    }
                })
            }
            
            Device (BTN2)
            {
                Name (_HID, "PRP0000")
                Name (_DSD, Package ()
                {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package ()
                    {
                        Package () {"linux,code", 103},
                        Package () {"linux,input-type", 1},
                        Package () {"gpios", Package () {^^BTNS, 2, 0, 1}},
                    }
                })
            }
            
            Device (BTN3)
            {
                Name (_HID, "PRP0000")
                Name (_DSD, Package ()
                {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package ()
                    {
                        Package () {"linux,code", 106},
                        Package () {"linux,input-type", 1},
                        Package () {"gpios", Package (4) {^^BTNS, 3, 0, 1}},
                    }
                })
            }

        }

    }

-- 
2.1.0.rc1

