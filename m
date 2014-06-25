Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbaFYVWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:22:17 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:39967 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaFYVWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:22:15 -0400
MIME-Version: 1.0
In-Reply-To: <53AB3B53.2080104@gmail.com>
References: <1403730927-16163-1-git-send-email-tthayer@altera.com>
	<1403730927-16163-4-git-send-email-tthayer@altera.com>
	<53AB3B53.2080104@gmail.com>
Date: Wed, 25 Jun 2014 16:22:14 -0500
Message-ID: <CAF03EBe-9JEj_=FoA3So-9NvUyDJtQ=0-Y87JAvxk7pr+5_WWw@mail.gmail.com>
Subject: Re: [PATCHv7 3/3] edac: altera: Add EDAC support for Altera SoC SDRAM Controller.
From: Thor Thayer <tthayer.linux@gmail.com>
To: Dinh Nguyen <dinh.linux@gmail.com>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, Borislav Petkov <bp@alien8.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On Wed, Jun 25, 2014 at 4:12 PM, Dinh Nguyen <dinh.linux@gmail.com> wrote:
> Hi Thor,
>
>
> On 06/25/2014 04:15 PM, tthayer@altera.com wrote:
>>
>> From: Thor Thayer <tthayer@altera.com>
>>
>> This patch adds support for the CycloneV and ArriaV SDRAM controllers.
>> Correction and reporting of SBEs, Panic on DBEs.
>>
>> Signed-off-by: Thor Thayer <tthayer@altera.com>
>> ---
>> v2: Use the SDRAM controller registers to calculate memory size
>>      instead of the Device Tree. Update To & Cc list. Add maintainer
>>      information.
>>
>> v3: EDAC driver cleanup based on comments from Mailing list.
>>
>> v4: Panic on DBE. Add macro around inject-error reads to prevent
>>      them from being optimized out. Remove of_match_ptr since this
>>      will always use Device Tree.
>>
>> v5: Addition of printk to trigger function to ensure read vars
>>      are not optimized out.
>>
>> v6: Changes to split out shared SDRAM controller reg (offset 0x00)
>>      as a syscon device and allocate ECC specific SDRAM registers
>>      to EDAC.
>>
>> v7: No change. Bump version for consistency.
>> ---
>>   drivers/edac/Kconfig       |    9 +
>>   drivers/edac/Makefile      |    2 +
>>   drivers/edac/altera_edac.c |  448
>> ++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 459 insertions(+)
>>   create mode 100644 drivers/edac/altera_edac.c
>>
>> diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
>> index 878f090..4f4d379 100644
>> --- a/drivers/edac/Kconfig
>> +++ b/drivers/edac/Kconfig
>> @@ -368,4 +368,13 @@ config EDAC_OCTEON_PCI
>>           Support for error detection and correction on the
>>           Cavium Octeon family of SOCs.
>>
>> +config EDAC_ALTERA_MC
>> +       bool "Altera SDRAM Memory Controller EDAC"
>> +       depends on EDAC_MM_EDAC && ARCH_SOCFPGA
>> +       help
>> +         Support for error detection and correction on the
>> +         Altera SDRAM memory controller. Note that the
>> +         preloader must initialize the SDRAM before loading
>> +         the kernel.
>> +
>>   endif # EDAC
>> diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
>> index 4154ed6..9741336 100644
>> --- a/drivers/edac/Makefile
>> +++ b/drivers/edac/Makefile
>> @@ -64,3 +64,5 @@ obj-$(CONFIG_EDAC_OCTEON_PC)          +=
>> octeon_edac-pc.o
>>   obj-$(CONFIG_EDAC_OCTEON_L2C)         += octeon_edac-l2c.o
>>   obj-$(CONFIG_EDAC_OCTEON_LMC)         += octeon_edac-lmc.o
>>   obj-$(CONFIG_EDAC_OCTEON_PCI)         += octeon_edac-pci.o
>> +
>> +obj-$(CONFIG_EDAC_ALTERA_MC)           += altera_edac.o
>> diff --git a/drivers/edac/altera_edac.c b/drivers/edac/altera_edac.c
>> new file mode 100644
>> index 0000000..e3fcd27
>> --- /dev/null
>> +++ b/drivers/edac/altera_edac.c
>> @@ -0,0 +1,448 @@
>> +/*
>> + *  Copyright Altera Corporation (C) 2014. All rights reserved.
>> + *  Copyright 2011-2012 Calxeda, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms and conditions of the GNU General Public License,
>> + * version 2, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT
>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
>> for
>> + * more details.
>> + *
>> + * This file is subject to the terms and conditions of the GNU General
>> Public
>> + * License.  See the file "COPYING" in the main directory of this archive
>> + * for more details.
>> +
>> + *
>> + * Adapted from the highbank_mc_edac driver
>> + *
>> + */
>> +#include <linux/types.h>
>> +#include <linux/kernel.h>
>> +#include <linux/ctype.h>
>> +#include <linux/edac.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/mfd/syscon.h>
>> +#include <linux/regmap.h>
>>
>
> Did you miss my comment to put these headers in alpabetical order?
>
> Dinh

Yep, I missed your comment - looking at it now.
