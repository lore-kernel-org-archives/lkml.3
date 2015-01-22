Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbbAVBiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 20:38:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65009 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751896AbbAVBiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 20:38:17 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: linus.walleij@linaro.org, lee.jones@linaro.org, johan@kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, heikki.krogerus@intel.com,
        mika.westerberg@linux.intel.com, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/4] mfd: dln2: add support for ACPI
Date: Thu, 22 Jan 2015 03:00:51 +0100
Message-ID: <2755822.qV1ICgGMEY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418746353-3481-4-git-send-email-octavian.purdila@intel.com>
References: <1418746353-3481-1-git-send-email-octavian.purdila@intel.com> <1418746353-3481-4-git-send-email-octavian.purdila@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 16, 2014 06:12:32 PM Octavian Purdila wrote:
> This patch adds support to load a custom ACPI table that describes
> devices connected via the DLN2 USB to I2C/SPI/GPIO bridge.
> 
> The ACPI table can be loaded either externally (from QEMU or with
> CONFIG_ACPI_CUSTOM_DSDT) or it can be loaded as firmware file with the
> name dln2.aml. The driver looks for an ACPI device entry with _HID set
> to "DLN20000" and makes it the ACPI companion for DLN2 USB
> sub-drivers.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> ---
>  Documentation/acpi/dln2-acpi.txt |  62 ++++++++++++++++++
>  drivers/mfd/dln2.c               | 134 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 196 insertions(+)
>  create mode 100644 Documentation/acpi/dln2-acpi.txt
> 
> diff --git a/Documentation/acpi/dln2-acpi.txt b/Documentation/acpi/dln2-acpi.txt
> new file mode 100644
> index 0000000..d76605f
> --- /dev/null
> +++ b/Documentation/acpi/dln2-acpi.txt
> @@ -0,0 +1,62 @@
> +Diolan DLN2 custom APCI table
> +
> +The Diolan DLN2 is an USB to I2C/SPI/GPIO bridge and as such it can be used to
> +connect to various I2C or SPI devices. Because these busses lack an enumeration
> +protocol, the driver obtains various information about the device (such as I2C
> +address and GPIO pins) from either ACPI or device tree.
> +
> +To allow enumerating devices and their properties via ACPI, the Diolan
> +driver looks for an ACPI tree with the root _HID set to "DLN20000". If
> +it finds such an ACPI object it will set the ACPI companion to the
> +DLN2 MFD driver and from their it will be propagated to all its
> +sub-devices (I2C, GPIO, SPI).
> +
> +The user can either load the custom DSDT table with three methods:

s/DSDT/ACPI/

> +
> +1. Via QEMU (see -acpitable)
> +
> +2. Via the CONFIG_ACPI_CUSTOM_DSDT kernel config option (see
> +Documentation/acpi/dsdt-override.txt)
> +
> +3. By placing the custom DSDT in the firmware paths in a file name
> +dln2.aml.

Surely SSDT?

> +
> +Here is an example ACPI table that enumerates a BMC150 accelerometer
> +and defines its I2C address and GPIO pin used as an interrupt source:
> +
> +DefinitionBlock ("ssdt.aml", "SSDT", 1, "INTEL ", "CpuDptf", 0x00000003)
> +{
> +	Device (DLN0)
> +	{
> +		Name (_ADR, Zero)
> +		Name (_HID, "DLN2000")
> +
> +		Device (STAC)
> +		{
> +			Name (_ADR, Zero)
> +			Name (_HID, "BMC150A")
> +			Name (_CID, "INTACCL")
> +			Name (_UID, One)
> +
> +			Method (_CRS, 0, Serialized)
> +			{
> +				Name (RBUF, ResourceTemplate ()
> +				{
> +					I2cSerialBus (0x0010, ControllerInitiated, 0x00061A80,
> +						      AddressingMode7Bit, "\\DLN0",
> +						      0x00, ResourceConsumer, ,)
> +
> +					GpioInt (Level, ActiveHigh, Exclusive, PullDown, 0x0000,
> +						 "\\DLN0", 0x00, ResourceConsumer, , )
> +					{ // Pin list
> +						0
> +					}
> +				})
> +				Return (RBUF)
> +		       }
> +		}
> +	}
> +}
> +
> +The resources defined in the devices under the DLN0 are those
> +supported by the I2C, GPIO and SPI sub-systems.
> diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> index f9c4a0b..93f6d1d 100644
> --- a/drivers/mfd/dln2.c
> +++ b/drivers/mfd/dln2.c
> @@ -23,6 +23,8 @@
>  #include <linux/mfd/core.h>
>  #include <linux/mfd/dln2.h>
>  #include <linux/rculist.h>
> +#include <linux/acpi.h>
> +#include <linux/firmware.h>
>  

OK, so correct me if I'm wrong.

When the (USB) dnl2 device is probed, it is supposed to find an ACPI companion
for itself and if it's not there, the driver will try to load a custom SSDT from
a firmware blob in the hope that the companion will be there?

So if I'm not wrong, why is this not broken?

It is not sufficient to call ACPI_COMPANION_SET(dev, ai->dev) to set the device's
companion.  acpi_bind_one() needs to be run in addition to that, but acpi_bind_one()
is not to be called from drivers.  It is called by the core automatically during
device registration and ACPI_COMPANION_SET() is to be used *before* that, not after.

So if I'm not missing anything, the design here is entirely backwards and we
need to talk about how to implement it correctly at the design level in the
first place.

And no, "Let's come up with a patch that sort of works, throw it at the maintainers
and see what happens" is not an acceptable approach, sorry.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
