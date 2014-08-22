Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbaHVMdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:33:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42366 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756013AbaHVMdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:33:44 -0400
Message-ID: <53F738B0.5080806@arm.com>
Date: Fri, 22 Aug 2014 13:33:52 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] drivers: base: add cpu_device_create to support per-cpu
 devices
References: <CAPXgP130hg8uwdmSKAAAKZzxncT-VXYYXvmN-ta7wcXQXgXEmw@mail.gmail.com>	<1408706963-23195-1-git-send-email-sudeep.holla@arm.com>	<CANq1E4SJZQeAuXhggdnsjRFKFJD01WEnBpcdPC1pkJiv3WegCA@mail.gmail.com> <CANq1E4Snx_n3XDWXU5PtmLtt31sRqnkKrSRsx2_b=i+6GTLnxw@mail.gmail.com>
In-Reply-To: <CANq1E4Snx_n3XDWXU5PtmLtt31sRqnkKrSRsx2_b=i+6GTLnxw@mail.gmail.com>
X-OriginalArrivalTime: 22 Aug 2014 12:33:42.0065 (UTC) FILETIME=[4EA60210:01CFBE05]
X-MC-Unique: 114082213334200701
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/08/14 12:41, David Herrmann wrote:
> Hi
>
> On Fri, Aug 22, 2014 at 1:37 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
>> Hi
>>
>> On Fri, Aug 22, 2014 at 1:29 PM, Sudeep Holla <sudeep.holla@arm.com> wrote:
>>> From: Sudeep Holla <sudeep.holla@arm.com>
>>>
>>> This patch adds a new function to create per-cpu devices.
>>> This helps in:
>>> 1. reusing the device infrastructure to create any cpu related
>>>     attributes and corresponding sysfs instead of creating and
>>>     dealing with raw kobjects directly
>>> 2. retaining the legacy path(/sys/devices/system/cpu/..) to support
>>>     existing sysfs ABI
>>> 3. avoiding to create links in the bus directory pointing to the
>>>     device as there would be per-cpu instance of these devices with
>>>     the same name since dev->bus is not populated to cpu_sysbus on
>>>     purpose
>>>
>>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>>   drivers/base/cpu.c  | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   include/linux/cpu.h |  4 ++++
>>>   2 files changed, 58 insertions(+)
>>>
>>> Hi Greg,
>>>
>>> Here is the alternate solution I could come up with instead of
>>> creating cpu class. cpu_device_create is very similar to
>>> device_create_groups_vargs w/o class support, but I could not
>>> reuse anything else to avoid creating similar function.
>>>
>>> Let me know your thoughts/suggestions on this.
>>>
>>> Regards,
>>> Sudeep
>>>
>>>
>>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>>> index 277a9cfa9040..53f0c4141d05 100644
>>> --- a/drivers/base/cpu.c
>>> +++ b/drivers/base/cpu.c
>>> @@ -363,6 +363,60 @@ struct device *get_cpu_device(unsigned cpu)
>>>   }
>>>   EXPORT_SYMBOL_GPL(get_cpu_device);
>>>
>>> +static void device_create_release(struct device *dev)
>>> +{
>>> +       kfree(dev);
>>> +}
>>> +
>>> +static struct device *
>>> +__cpu_device_create(struct device *parent, void *drvdata,
>>> +                   const struct attribute_group **groups,
>>> +                   const char *fmt, va_list args)
>>> +{
>>> +       struct device *dev = NULL;
>>> +       int retval = -ENODEV;
>>> +
>>> +       dev = kzalloc(sizeof(*dev), GFP_KERNEL);
>>> +       if (!dev) {
>>> +               retval = -ENOMEM;
>>> +               goto error;
>>> +       }
>>> +
>>> +       device_initialize(dev);
>>> +       dev->parent = parent;
>>> +       dev->groups = groups;
>>> +       dev->release = device_create_release;
>>> +       dev_set_drvdata(dev, drvdata);
>>> +
>>> +       retval = kobject_set_name_vargs(&dev->kobj, fmt, args);
>>> +       if (retval)
>>> +               goto error;
>>> +
>>> +       retval = device_add(dev);
>>> +       if (retval)
>>> +               goto error;
>>
>> Exactly! As I said, simply setting dev->groups before calling device_add().
>>
>> However, I really don't understand why we need this as global API.
>> Skimming over the other patches, you use cpu_device_create() only in
>> one place. Why not hard-code this all there? It is totally OK to do
>> device initialization in drivers. All the helpers (like
>> device_create(), device_create_with_groups(), and so on) are just
>> convenience functions. The driver-core API explicitly allows drivers
>> to initialize devices manually.
>>
>> Nevertheless, this patch looks fine.
>
> Wait, no. Why don't you set dev->bus to cpu_subsys? Is this thing
> supposed to create child-devices of CPUs? Can you describe what your
> topology is supposed to look like?
>

Yes, it's not done on purpose as mentioned in the commit log.
E.g.: cacheinfo topology will be as below

/sys/devices/system/cpu/cpuX/cache/index0/<attributes>
/sys/devices/system/cpu/cpuX/cache/index1/<attributes>
..
/sys/devices/system/cpu/cpuX/cache/index<Y/<attributes>

In this case 'cache' is cpuX's child and index<0..Y> are children of
cache in cpuX. The main problem with per-cpu device is that they have
same name for each cpu's instance and when the bus is set to this
devices, the driver model tries to create symlink to each of these
devices in /sys/bus/cpu/... which fails.

Regards,
Sudeep

