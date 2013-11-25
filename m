Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3KYT7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 14:59:53 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:56276 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab3KYT7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 14:59:51 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131125195250.GD18046@saruman.home>
References: <1385408226-22369-1-git-send-email-olof@lixom.net>
	<20131125195250.GD18046@saruman.home>
Date: Mon, 25 Nov 2013 11:59:50 -0800
Message-ID: <CAOesGMhd0r6h63Y+z-6CCuo2iHPCNA56Bg762K+G7XOHO8FRGg@mail.gmail.com>
Subject: Re: [PATCH] platform/chrome: Add pstore platform_device
From: Olof Johansson <olof@lixom.net>
To: Felipe Balbi <balbi@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Benson Leung <bleung@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 11:52 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Nov 25, 2013 at 11:37:06AM -0800, Olof Johansson wrote:
>> Add the ramoops pstore device so that we get logs of panics across reboots.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> ---
>>
>>  drivers/platform/chrome/Kconfig           |  14 +++++
>>  drivers/platform/chrome/Makefile          |   1 +
>>  drivers/platform/chrome/chromeos_pstore.c | 101 ++++++++++++++++++++++++++++++
>>  3 files changed, 116 insertions(+)
>>  create mode 100644 drivers/platform/chrome/chromeos_pstore.c
>>
>> diff --git a/drivers/platform/chrome/Kconfig b/drivers/platform/chrome/Kconfig
>> index b13303e75a34..06c53c8132ad 100644
>> --- a/drivers/platform/chrome/Kconfig
>> +++ b/drivers/platform/chrome/Kconfig
>> @@ -25,4 +25,18 @@ config CHROMEOS_LAPTOP
>>         If you have a supported Chromebook, choose Y or M here.
>>         The module will be called chromeos_laptop.
>>
>> +config CHROMEOS_PSTORE
>> +     tristate "Chrome OS pstore support"
>> +     ---help---
>> +       This module instantiates the persistent storage on x86 ChromeOS
>> +       devices. It can be used to store away console logs and crash
>> +       information across reboots.
>> +
>> +       The range of memory used is 0xf00000-0x1000000, tradionally the
>> +       memory used to back VGA controller memory.
>> +
>> +       If you have a supported Chromebook, choose Y or M here.
>> +       The module will be called chromeos_pstore.
>> +
>> +
>>  endif # CHROMEOS_PLATFORMS
>> diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
>> index 015e9195e226..2b860ca7450f 100644
>> --- a/drivers/platform/chrome/Makefile
>> +++ b/drivers/platform/chrome/Makefile
>> @@ -1,2 +1,3 @@
>>
>>  obj-$(CONFIG_CHROMEOS_LAPTOP)        += chromeos_laptop.o
>> +obj-$(CONFIG_CHROMEOS_PSTORE)        += chromeos_pstore.o
>> diff --git a/drivers/platform/chrome/chromeos_pstore.c b/drivers/platform/chrome/chromeos_pstore.c
>> new file mode 100644
>> index 000000000000..e0e0e65cf442
>> --- /dev/null
>> +++ b/drivers/platform/chrome/chromeos_pstore.c
>> @@ -0,0 +1,101 @@
>> +/*
>> + *  chromeos_pstore.c - Driver to instantiate Chromebook ramoops device
>> + *
>> + *  Copyright (C) 2013 Google, Inc.
>> + *
>> + *  This program is free software; you can redistribute it and/or modify
>> + *  it under the terms of the GNU General Public License as published by
>> + *  the Free Software Foundation, version 2 of the License.
>> + */
>> +
>> +#include <linux/dmi.h>
>> +#include <linux/module.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/pstore_ram.h>
>> +
>> +static struct dmi_system_id chromeos_pstore_dmi_table[] __initdata = {
>> +     {
>> +             /*
>> +              * Today all Chromebooks/boxes ship with GOOGLE as vendor and
>> +              * coreboot as bios vendor. No other systems with this
>> +              * combination are known to date.
>> +              */
>> +             .matches = {
>> +                     DMI_MATCH(DMI_SYS_VENDOR, "GOOGLE"),
>> +                     DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
>> +             },
>> +     },
>> +     {
>> +             /*
>> +              * The first Samsung Chromebox and Chromebook Series 5 550 use
>> +              * coreboot but with Samsung as the system vendor.
>> +              */
>> +             .matches = {
>> +                     DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG"),
>> +                     DMI_MATCH(DMI_BIOS_VENDOR, "coreboot"),
>> +             },
>> +     },
>> +     {
>> +             /* x86-alex, the first Samsung Chromebook. */
>> +             .matches = {
>> +                     DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
>> +                     DMI_MATCH(DMI_PRODUCT_NAME, "Alex"),
>> +             },
>> +     },
>> +     {
>> +             /* x86-mario, the Cr-48 pilot device from Google. */
>> +             .matches = {
>> +                     DMI_MATCH(DMI_SYS_VENDOR, "IEC"),
>> +                     DMI_MATCH(DMI_PRODUCT_NAME, "Mario"),
>> +             },
>> +     },
>> +     {
>> +             /* x86-zgb, the first Acer Chromebook. */
>> +             .matches = {
>> +                     DMI_MATCH(DMI_SYS_VENDOR, "ACER"),
>> +                     DMI_MATCH(DMI_PRODUCT_NAME, "ZGB"),
>> +             },
>> +     },
>> +     { }
>> +};
>> +MODULE_DEVICE_TABLE(dmi, chromeos_pstore_dmi_table);
>
> if you have this ...
>
>> +/*
>> + * On x86 chromebooks/boxes, the firmware will keep the legacy VGA memory
>> + * range untouched across reboots, so we use that to store our pstore
>> + * contents for panic logs, etc.
>> + */
>> +static struct ramoops_platform_data chromeos_ramoops_data = {
>> +     .mem_size       = 0x100000,
>> +     .mem_address    = 0xf00000,
>> +     .record_size    = 0x20000,
>> +     .console_size   = 0x20000,
>> +     .ftrace_size    = 0x20000,
>> +     .dump_oops      = 1,
>> +};
>> +
>> +static struct platform_device chromeos_ramoops = {
>> +     .name = "ramoops",
>> +     .dev = {
>> +             .platform_data = &chromeos_ramoops_data,
>> +     },
>> +};
>> +
>> +static int __init chromeos_pstore_init(void)
>> +{
>> +     if (dmi_check_system(chromeos_pstore_dmi_table))
>
> is this check really necessary ? I would assume that your probe would
> only be called if the device matches the dmi MODULE_DEVICE_TABLE().
>
> Except that you don't have a probe function which is quite odd. Also,
> there's nothing using chromeos_ramoops_data, how does this work ?

This is just a module that registers the device. The driver side is
handled by pstore. See Documentation/ramoops.txt.

That's also why the DMI table is needed: The module init is generic,
and if built-in instead of loaded based on DMI table contents, it will
always run. There's no specific device to bind against, since there's
none in the tables passed in from firmware in this case.

-Olof
