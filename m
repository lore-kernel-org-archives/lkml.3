Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbaBSQEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:04:10 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43751 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbaBSQEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:04:08 -0500
Message-ID: <5304D610.1060504@arm.com>
Date: Wed, 19 Feb 2014 16:04:32 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sudeep.Holla@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH RFC/RFT v2 1/8] drivers: base: support cpu cache information
 interface to userspace via sysfs
References: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com> <1391791763-28518-2-git-send-email-sudeep.holla@arm.com> <20140207192925.GB18771@kroah.com> <52F915F6.9000501@arm.com> <20140211001310.GB3692@kroah.com> <52FCEB03.6040608@arm.com> <20140218215344.GC20495@kroah.com>
In-Reply-To: <20140218215344.GC20495@kroah.com>
X-OriginalArrivalTime: 19 Feb 2014 16:04:07.0823 (UTC) FILETIME=[382DC9F0:01CF2D8C]
X-MC-Unique: 114021916040532301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 18/02/14 21:53, Greg Kroah-Hartman wrote:
> On Thu, Feb 13, 2014 at 03:55:47PM +0000, Sudeep Holla wrote:
>> Hi Greg,
>> On 11/02/14 00:13, Greg Kroah-Hartman wrote:
[...]
>>> Make the cpu devices be part of a class?
>>
>> I was able to convert these to use struct device instead of raw kobjects. But it
>> requires some changes in order to retain the existing sysfs path mainly due to
>> the fact that cpus are using legacy subsys_system_register and introducing
>> cpu_class conflicts with cpu bus. The base changes in the driver core is as
>> below. Is this acceptable ? or any other alternate suggestions ?
>>
>> --->8
>>  drivers/base/bus.c  | 2 ++
>>  drivers/base/core.c | 8 ++++++++
>>  drivers/base/cpu.c  | 7 +++++++
>>  include/linux/cpu.h | 2 ++
>>  4 files changed, 19 insertions(+)
>>
>> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
>> index 59dc808..c33bfdb 100644
>> --- a/drivers/base/bus.c
>> +++ b/drivers/base/bus.c
>> @@ -518,10 +518,12 @@ int bus_add_device(struct device *dev)
>>  						&dev->kobj, dev_name(dev));
>>  		if (error)
>>  			goto out_id;
>> +		if (!dev->class) {
>>  			error = sysfs_create_link(&dev->kobj,
>>  				&dev->bus->p->subsys.kobj, "subsystem");
>>  			if (error)
>>  				goto out_subsys;
>> +		}
>>  		klist_add_tail(&dev->p->knode_bus, &bus->p->klist_devices);
>>  	}
>>  	return 0;
> 
> This change worries me, does it cause anything else to happen in sysfs
> that looks differently from what it does today?
> 
Yes, I found that out 2 days back and have now fixed it, the above change is
removed. It's now handled in device_{add,remove}_class_symlinks correctly.

>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 2b56717..ef81984 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -10,6 +10,7 @@
>>   *
>>   */
>>
>> +#include <linux/cpu.h>
>>  #include <linux/device.h>
>>  #include <linux/err.h>
>>  #include <linux/init.h>
>> @@ -759,6 +760,8 @@ static struct kobject *get_device_parent(struct device *dev,
>>  			return &block_class.p->subsys.kobj;
>>  		}
>>  #endif
>> +		if (dev->class == cpu_class)
>> +			return &parent->kobj;
> 
> I don't think this is ok :)
> 
> Oh wait, we do this for disk classes today, ick, ok, nevermind, but
> comment it really well please.
> 

Yes I was initially worried but I don't see any other way to retain the sysfs
paths as is. I have commented it well enough now in the patch IMO. I will send
v3 series soon.

Regards,
Sudeep

