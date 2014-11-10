Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbaKJPkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:40:47 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:58602 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaKJPkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:40:46 -0500
MIME-Version: 1.0
In-Reply-To: <1415615671.4862.30.camel@x220>
References: <1415038066-22423-1-git-send-email-mathieu.poirier@linaro.org>
	<1415038066-22423-8-git-send-email-mathieu.poirier@linaro.org>
	<1415615671.4862.30.camel@x220>
Date: Mon, 10 Nov 2014 08:40:46 -0700
Message-ID: <CANLsYkxivqgyRZspS2uP9Mkwit4obCjZxYr0YUhR3G_zQejERg@mail.gmail.com>
Subject: Re: [PATCH v9 07/12] coresight-etm: add CoreSight ETM/PTM driver
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>, Kaixu Xia <kaixu.xia@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>,
        "r.sengupta@samsung.com" <r.sengupta@samsung.com>,
        trollkarlen Marklund <robbelibobban@gmail.com>,
        Patch Tracking <patches@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 November 2014 03:34, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Mon, 2014-11-03 at 11:07 -0700, mathieu.poirier@linaro.org wrote:
>> From: Pratik Patel <pratikp@codeaurora.org>
>>
>> This driver manages CoreSight ETM (Embedded Trace Macrocell) that
>> supports processor tracing. Currently supported version are ARM
>> ETMv3.x and PTM1.x.
>>
>> Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>>
>> coresight-etm3x: adding missing error checking
>
> This landed in today's linx-next (ie, next-20141110) as commit
> a939fc5a71ad ("coresight-etm: add CoreSight ETM/PTM driver").
>
>>  arch/arm/Kconfig.debug                 |    9 +
>>  arch/arm/include/asm/hardware/cp14.h   |  542 +++++++++
>>  drivers/coresight/Makefile             |    1 +
>>  drivers/coresight/coresight-etm-cp14.c |  591 ++++++++++
>>  drivers/coresight/coresight-etm.h      |  251 +++++
>>  drivers/coresight/coresight-etm3x.c    | 1928 ++++++++++++++++++++++++++++++++
>>  6 files changed, 3322 insertions(+)
>>  create mode 100644 arch/arm/include/asm/hardware/cp14.h
>>  create mode 100644 drivers/coresight/coresight-etm-cp14.c
>>  create mode 100644 drivers/coresight/coresight-etm.h
>>  create mode 100644 drivers/coresight/coresight-etm3x.c
>>
>>[...]
>> diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
>> new file mode 100644
>> index 0000000..d9e3ed6
>> --- /dev/null
>> +++ b/drivers/coresight/coresight-etm3x.c
>> @@ -0,0 +1,1928 @@
>> +/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/init.h>
>> +#include <linux/types.h>
>> +#include <linux/device.h>
>> +#include <linux/io.h>
>> +#include <linux/err.h>
>> +#include <linux/fs.h>
>> +#include <linux/slab.h>
>> +#include <linux/delay.h>
>> +#include <linux/smp.h>
>> +#include <linux/sysfs.h>
>> +#include <linux/stat.h>
>> +#include <linux/clk.h>
>> +#include <linux/cpu.h>
>> +#include <linux/of.h>
>> +#include <linux/coresight.h>
>> +#include <linux/amba/bus.h>
>> +#include <linux/seq_file.h>
>> +#include <linux/uaccess.h>
>> +#include <asm/sections.h>
>> +
>> +#include "coresight-etm.h"
>> +
>> +#ifdef CONFIG_CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE
>
> There's no Kconfig symbol CORESIGHT_SOURCE_ETM_DEFAULT_ENABLE. Neither
> is there a preprocessor definition of this macro. So why was this
> added?

Correct - the feature (as we really want it) is currently being worked
on but not yet part of the code base.  The default option probably
should have been removed but it doesn't do much else when mandating
one to add a boot option on the kernel cmd line.

Thanks for the review,
Mathieu

>
>> +static int boot_enable = 1;
>> +#else
>> +static int boot_enable;
>> +#endif
>> +module_param_named(
>> +     boot_enable, boot_enable, int, S_IRUGO
>> +);
>
>
> Paul Bolle
>
