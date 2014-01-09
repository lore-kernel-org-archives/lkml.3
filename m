Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbaAITTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 14:19:03 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46364 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316AbaAITS4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 14:18:56 -0500
Message-ID: <52CEF624.9020702@arm.com>
Date: Thu, 09 Jan 2014 19:19:00 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sudeep.Holla@arm.com, "x86@kernel.org" <x86@kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH RFC 1/3] drivers: base: support cpu cache information
 interface to userspace via sysfs
References: <1389209168-17189-1-git-send-email-sudeep.holla@arm.com> <1389209168-17189-2-git-send-email-sudeep.holla@arm.com> <20140108202707.GE8417@kroah.com>
In-Reply-To: <20140108202707.GE8417@kroah.com>
X-OriginalArrivalTime: 09 Jan 2014 19:18:53.0182 (UTC) FILETIME=[A24251E0:01CF0D6F]
X-MC-Unique: 114010919185500201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/14 20:27, Greg Kroah-Hartman wrote:
> On Wed, Jan 08, 2014 at 07:26:06PM +0000, Sudeep Holla wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> This patch adds initial support for providing processor cache information
>> to userspace through sysfs interface. This is based on x86 implementation
>> and hence the interface is intended to be fully compatible.
>>
>> A per-cpu array of cache information maintained is used mainly for
>> sysfs-related book keeping.
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> ---
>>  drivers/base/Makefile     |   2 +-
>>  drivers/base/cacheinfo.c  | 296 ++++++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/cacheinfo.h |  43 +++++++
>>  3 files changed, 340 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/base/cacheinfo.c
>>  create mode 100644 include/linux/cacheinfo.h
>>
>> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
>> index 94e8a80..76f07c8 100644
>> --- a/drivers/base/Makefile
>> +++ b/drivers/base/Makefile
>> @@ -4,7 +4,7 @@ obj-y			:= core.o bus.o dd.o syscore.o \
>>  			   driver.o class.o platform.o \
>>  			   cpu.o firmware.o init.o map.o devres.o \
>>  			   attribute_container.o transport_class.o \
>> -			   topology.o
>> +			   topology.o cacheinfo.o
>>  obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
>>  obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
>>  obj-y			+= power/
>> diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
>> new file mode 100644
>> index 0000000..f436c31
>> --- /dev/null
>> +++ b/drivers/base/cacheinfo.c
>> @@ -0,0 +1,296 @@
>> +/*
>> + * cacheinfo support - processor cache information via sysfs
>> + *
>> + * Copyright (C) 2013 ARM Ltd.
>> + * All Rights Reserved
>> + *
>> + * Author: Sudeep Holla <sudeep.holla@arm.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#include <linux/bitops.h>
>> +#include <linux/cacheinfo.h>
>> +#include <linux/compiler.h>
>> +#include <linux/cpu.h>
>> +#include <linux/device.h>
>> +#include <linux/init.h>
>> +#include <linux/kobject.h>
>> +#include <linux/of.h>
>> +#include <linux/sched.h>
>> +#include <linux/slab.h>
>> +#include <linux/smp.h>
>> +#include <linux/sysfs.h>
>> +
>> +struct cache_attr {
>> +	struct attribute attr;
>> +	 ssize_t(*show) (unsigned int, unsigned short, char *);
>> +	 ssize_t(*store) (unsigned int, unsigned short, const char *, size_t);
>> +};
>> +
>> +/* pointer to kobject for cpuX/cache */
>> +static DEFINE_PER_CPU(struct kobject *, ci_cache_kobject);
>> +#define per_cpu_cache_kobject(cpu)     (per_cpu(ci_cache_kobject, cpu))
>> +
>> +struct index_kobject {
>> +	struct kobject kobj;
>> +	unsigned int cpu;
>> +	unsigned short index;
>> +};
>> +
>> +static cpumask_t cache_dev_map;
>> +
>> +/* pointer to array of kobjects for cpuX/cache/indexY */
> 
> Please don't use "raw" kobjects for this, use the device attribute
> groups, that's what they are there for.  Bonus is that your code should
> get a lot simpler when you do that.
> 

Yes I now understand device attribute group simplifies the code, but I think
kobjects are still needed as we need to track both cpu and cache index.
By reusing only cpu device kobject, we can track cpu only.

Please correct me if I am missing to understand something here.

One thought I have is to make cache_info structure common to all architecture
(for now its ARM specific) and introduce kobject in that similar to ia64
implementation. That even eliminates lot of weak functions defined.

Regards,
Sudeep



