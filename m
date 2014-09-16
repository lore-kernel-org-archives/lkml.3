Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaIPM2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 08:28:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:21085 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbaIPM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:28:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="603534434"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Aaron Lu <aaron.lu@intel.com>, Darren Hart <dvhart@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC PATCH v2 00/16] Add ACPI _DSD and unified device properties support
Date: Tue, 16 Sep 2014 14:52:31 +0300
Message-Id: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a second revision of the patches first submitted here [1].

The recent publication of the ACPI 5.1 specification [2] adds a reserved name
for Device Specific Data (_DSD, Section 6.2.5). This mechanism allows for
passing arbitrary hardware description data to the OS. The exact format of the
_DSD data is specific to the UUID paired with it [3].   

An ACPI Device Properties UUID has been defined [4] to provide a format
compatible with existing device tree schemas. The purpose for this was to
allow for the reuse of the existing schemas and encourage the development
of firmware agnostic device drivers.

This series accomplishes the following (as well as some other dependencies):

 * Add _DSD support to the ACPI core
   This simply reads the UUID and the accompanying Package

 * Add ACPI Device Properties _DSD format support
   This understands the hierarchical key:value pair structure
   defined by the Device Properties UUID

 * Add a unified device properties API with ACPI and OF backends
   This provides for the firmware agnostic device properties
   Interface to be used by drivers

 * Provides 3 example drivers that were previously Device Tree aware that
   can now be used with either Device Tree or ACPI Device Properties. The
   drivers use "PRP0001" as their _HID which means that the match should be
   done using driver's .of_match_table instead.

The patch series has been tested on Minnoboard and Minnowboard MAX and the
relevant part of DSDTs are at the end of this cover letter.

This series does not provide for a means to append to a system DSDT. That
will ultimately be required to make the most effective use of the _DSD
mechanism. Work is underway on that as a separate effort.

Most important changes to the previous RFC version:

  * Added wrapper functions for most used property types
  * Return -EOVERFLOW in case integer would not fit to a type
  * Dropped dev_prop_ops
  * We now have dev_node_xxx() functions to access firmware node
    properties without dev pointer
  * The accessor function names try to be close to their corresponding of_*
    counterpart
  * Tried to have a bit better examples in the documentation patch
  * gpiolib got support for _DSD and also it now understand firmware node
    properties with dev_node_get_named_gpiod() that requests the GPIO
    properly.
  * Support for "PRP0001" _HID/_CID. This means that the match should be
    done using driver .of_match_table instead.
  * Add unified property support for at25 SPI eeprom driver as well.

[1] https://lkml.org/lkml/2014/8/17/10
[2] http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf
[3] http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
[4] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf

Aaron Lu (2):
  input: gpio_keys_polled - Add support for GPIO descriptors
  input: gpio_keys_polled - Make use of device property API

Max Eliaser (2):
  leds: leds-gpio: Make use of device property API
  leds: leds-gpio: Add ACPI probing support

Mika Westerberg (11):
  ACPI: Add support for device specific properties
  ACPI: Allow drivers to match using Device Tree compatible property
  ACPI: Document ACPI device specific properties
  mfd: Add ACPI support
  gpio / ACPI: Add support for _DSD device properties
  gpio: Add support for unified device properties interface
  gpio: sch: Consolidate core and resume banks
  leds: leds-gpio: Add support for GPIO descriptors
  input: gpio_keys_polled - Add ACPI probing support
  misc: at25: Make use of device property API
  misc: at25: Add ACPI probing support

Rafael J. Wysocki (1):
  Driver core: Unified device properties interface for platform firmware

 Documentation/acpi/enumeration.txt        |  27 ++
 Documentation/acpi/properties.txt         | 410 +++++++++++++++++++++
 drivers/acpi/Makefile                     |   1 +
 drivers/acpi/internal.h                   |   6 +
 drivers/acpi/property.c                   | 584 ++++++++++++++++++++++++++++++
 drivers/acpi/scan.c                       |  93 ++++-
 drivers/base/Makefile                     |   2 +-
 drivers/base/property.c                   | 196 ++++++++++
 drivers/gpio/devres.c                     |  35 ++
 drivers/gpio/gpio-sch.c                   | 293 ++++++---------
 drivers/gpio/gpiolib-acpi.c               |  78 +++-
 drivers/gpio/gpiolib.c                    |  85 ++++-
 drivers/gpio/gpiolib.h                    |   7 +-
 drivers/input/keyboard/gpio_keys_polled.c | 169 +++++----
 drivers/leds/leds-gpio.c                  | 188 +++++-----
 drivers/mfd/mfd-core.c                    |  40 ++
 drivers/misc/eeprom/at25.c                |  41 +--
 drivers/of/base.c                         | 188 ++++++++++
 include/acpi/acpi_bus.h                   |   8 +
 include/linux/acpi.h                      |  90 ++++-
 include/linux/gpio/consumer.h             |   7 +
 include/linux/gpio_keys.h                 |   3 +
 include/linux/leds.h                      |   1 +
 include/linux/mfd/core.h                  |   3 +
 include/linux/of.h                        |  37 ++
 include/linux/property.h                  | 193 ++++++++++
 26 files changed, 2377 insertions(+), 408 deletions(-)
 create mode 100644 Documentation/acpi/properties.txt
 create mode 100644 drivers/acpi/property.c
 create mode 100644 drivers/base/property.c
 create mode 100644 include/linux/property.h

DSDT modifications for Minnowboard (for leds-gpio.c and gpio_keys_polled.c)
---------------------------------------------------------------------------

    Scope (\_SB.PCI0.LPC)
    {
        Device (LEDS)
        {
            Name (_HID, "PRP0001")

            Name (_CRS, ResourceTemplate () {
                GpioIo (Exclusive, PullDown, 0, 0, IoRestrictionOutputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {10}
                GpioIo (Exclusive, PullDown, 0, 0, IoRestrictionOutputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {11}
            })

            Name (_DSD, Package () {
                  ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                  Package () {
                      Package () {"compatible", Package () {"gpio-leds"}},
                  }
            })

            Device (LEDH)
            {
                Name (_DSD, Package () {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package () {
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
                Name (_DSD, Package () {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package () {
                        Package () {"label", "MMC0 Activity"},
                        Package () {"gpios", Package () {^^LEDS, 1, 0, 0}},
                        Package () {"linux,default-trigger", "mmc0"},
                        Package () {"linux,default-state", "off"},
                        Package () {"linux,retain-state-suspended", 1},
                    }
                })
            }
        }
        
        Device (BTNS)
        {
            Name (_HID, "PRP0001")

            Name (_CRS, ResourceTemplate () {
                GpioIo (Exclusive, PullUp, 0, 0, IoRestrictionInputOnly,
                        "\\_SB.PCI0.LPC", 0, ResourceConsumer) {0, 1, 2, 3}
            })

            Name (_DSD, Package () {
                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                Package () {
                    Package () {"compatible", Package () {"gpio-keys-polled"}},
                    Package () {"poll-interval", 100},
                    Package () {"autorepeat", 1}
                }
            })

            Device (BTN0)
            {
                Name (_DSD, Package () {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package () {
                        Package () {"linux,code", 105},
                        Package () {"linux,input-type", 1},
                        Package () {"gpios", Package () {^^BTNS, 0, 0, 1}},
                    }
                })
            }

            Device (BTN1)
            {
                Name (_DSD, Package () {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package () {
                        Package () {"linux,code", 108},
                        Package () {"linux,input-type", 1},
                        Package () {"gpios", Package (4) {^^BTNS, 0, 1, 1}},
                    }
                })
            }
            
            Device (BTN2)
            {
                Name (_DSD, Package () {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package () {
                        Package () {"linux,code", 103},
                        Package () {"linux,input-type", 1},
                        Package () {"gpios", Package () {^^BTNS, 0, 2, 1}},
                    }
                })
            }
            
            Device (BTN3)
            {
                Name (_DSD, Package () {
                    ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package ()
                    {
                        Package () {"linux,code", 106},
                        Package () {"linux,input-type", 1},
                        Package () {"gpios", Package (4) {^^BTNS, 0, 3, 1}},
                    }
                })
            }
        }
    }

DSDT modifications for Minnowboard MAX (for at25.c)
---------------------------------------------------

    Scope (\_SB.SPI1)
    {
        Device (AT25)
        {
            Name (_HID, "PRP0001")
            Method (_CRS, 0, Serialized) {
                Name (UBUF, ResourceTemplate () {
                    SpiSerialBus (0x0000, PolarityLow, FourWireMode, 0x08,
                        ControllerInitiated, 0x007A1200, ClockPolarityLow,
                        ClockPhaseSecond, "\\_SB.SPI1",
                        0x00, ResourceConsumer)
                })
                Return (UBUF)
            }

            Name (_DSD, Package () {
                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                Package () {
                    Package () {"compatible", Package () {"atmel,at25"}},
		    Package () {"size", 1024},
		    Package () {"pagesize", 32},
		    Package () {"address-width", 16},
                }
            })

            Method (_STA, 0, NotSerialized)
            {
                Return (0xF)
            }
        }
    }
-- 
2.1.0

