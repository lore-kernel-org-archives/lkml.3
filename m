Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaHESWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:22:44 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49986 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbaHESOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:50 -0400
Message-ID: <53E11F53.4040106@arm.com>
Date: Tue, 05 Aug 2014 19:15:47 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Sudeep Holla <sudeep.holla@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 2/9] drivers: base: support cpu cache information interface
 to userspace via sysfs
References: <1403717444-23559-1-git-send-email-sudeep.holla@arm.com> <1406306692-7135-1-git-send-email-sudeep.holla@arm.com> <1406306692-7135-3-git-send-email-sudeep.holla@arm.com> <53D829BF.3040907@codeaurora.org> <53D91BE8.8050008@arm.com> <53DA9D03.60606@codeaurora.org>
In-Reply-To: <53DA9D03.60606@codeaurora.org>
X-OriginalArrivalTime: 05 Aug 2014 18:14:48.0068 (UTC) FILETIME=[24507C40:01CFB0D9]
X-MC-Unique: 114080519144800201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 31/07/14 20:46, Stephen Boyd wrote:
> On 07/30/14 09:23, Sudeep Holla wrote:
>> Hi Stephen,
>>
>> Thanks for reviewing this.
>>
>> On 30/07/14 00:09, Stephen Boyd wrote:
>>> On 07/25/14 09:44, Sudeep Holla wrote:
>>
>>>> +
>>>> +             shared_cpu_map: logical cpu mask containing the list
>>>> of cpus sharing
>>>> +                             the cache
>>>> +
>>>> +             size: the total cache size in kB
>>>> +
>>>> +             type:
>>>> +                     - instruction: cache that only holds instructions
>>>> +                     - data: cache that only caches data
>>>> +                     - unified: cache that holds both data and
>>>> instructions
>>>> +
>>>> +             ways_of_associativity: degree of freedom in placing a
>>>> particular block
>>>> +                                     of memory in the cache
>>>> diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
>>>> new file mode 100644
>>>> index 000000000000..983728a919ec
>>>> --- /dev/null
>>>> +++ b/drivers/base/cacheinfo.c
>>>> @@ -0,0 +1,539 @@
>>> [...]
>>>> +
>>>> +static int detect_cache_attributes(unsigned int cpu)
>>>
>>> Unused if sysfs is disabled? Actually it looks like everything except
>>> the weak functions are unused in such a case.
>>>

I see that sysfs has dummy implementations, probably I can remove #ifdef

>>
>>> I see that ia64 has this attributes file, but in that case only two
>>> attributes exist (write through and write back) and only one value is
>>> ever shown. When we have multiple attributes we'll have multiple lines
>>> to parse here. What if we left attributes around for the ia64 case
>>> (possibly even hiding that entirely within that architecture specific
>>> code) and then have files like "allocation_policy" and "storage_method"
>>> that correspond to whether its read/write allocation and write through
>>> or write back? The goal being to make only one value exist in any sysfs
>>> attribute.
>>>
>>
>> I like your idea, but is it hard rule to have only one value in any
>> sysfs attribute ? Though one concern I have is if different cache designs
>> make have different features and like to express that, 'attributes' is a
>> unified place to do that similar to cpu features in /proc/cpuinfo.
>
> 'attributes' seems too generic. Pretty much anything is an attribute.
>

Yes I agree and hence I compared it to /proc/cpuinfo.
As I said I am fine with new single value sysfs, but my main concern is
the extendability. If we don't for-see any changes in near future, then
we can go with new files as you suggested.

>>
>> Anyways if we decide to split it, how about write_policy instead of
>> storage_method ?
>
> Sounds good.
>

Thanks.

>>
>>>> +     buf[n] = '\0';
>>>> +     return n;
>>>> +}
>>>> +
>>>> +static umode_t
>>>> +cache_default_attrs_is_visible(struct kobject *kobj,
>>>> +                            struct attribute *attr, int unused)
>>>> +{
>>>> +     struct device *dev = kobj_to_dev(kobj);
>>>> +     struct device_attribute *dev_attr;
>>>> +     umode_t mode = attr->mode;
>>>> +     char *buf;
>>>> +
>>>> +     dev_attr = container_of(attr, struct device_attribute, attr);
>>>> +     buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>>>> +     if (!buf)
>>>> +             return 0;
>>>> +
>>>> +     /* create attributes that provides meaningful value */
>>>> +     if (dev_attr->show && dev_attr->show(dev, dev_attr, buf) < 0)
>>>> +             mode = 0;
>>>> +
>>>> +     kfree(buf);
>>>
>>> This is sort of sad. We have to allocate a whole page and call the show
>>> function to figure out if the attribute is visible? Why don't we
>>> actually look at what the attribute is and check for the structure
>>> members we care about? It looks like there are only a few combinations.
>>>
>>
>> Yes I thought about that, as even I didn't like that allocation. But if
>> we want the private attributes also use the same is_visible callback, we
>> can't check member directly as we don't know the details of the
>> individual element.
>>
>> Even if we have compare elements we need to compare the attribute and
>> then the value for each element in the structure, requiring changes if
>> elements are added/removed. I am fine either way, just explaining why
>> it's done so.
>
> Does any other sysfs attribute group do this? If it was desired I would
> think someone else would have done this already, or we wouldn't have
> even had an is_visible in the first place as this generic code would
> replace it.
>

I saw this first in PPC cacheinfo. Not sure who else have done that.

>>
>>
>>>> +     case CPU_ONLINE:
>>>> +     case CPU_ONLINE_FROZEN:
>>>> +             rc = detect_cache_attributes(cpu);
>>>> +             if (!rc)
>>>> +                     rc = cache_add_dev(cpu);
>>>> +             break;
>>>> +     case CPU_DEAD:
>>>> +     case CPU_DEAD_FROZEN:
>>>> +             cache_remove_dev(cpu);
>>>> +             if (per_cpu_cacheinfo(cpu))
>>>> +                     free_cache_attributes(cpu);
>>>> +             break;
>>>> +     }
>>>> +     return notifier_from_errno(rc);
>>>> +}
>>>
>>> Hm... adding/detecting/destroying this stuff every time a CPU is
>>> logically hotplugged seems like a waste of time and energy. Why can't we
>>> only do this work when the CPU is actually physically removed? The path
>>> for that is via the subsys_interface and it would make it easier on
>>> programs that want to learn about cache info as long as the CPU is
>>> present in the system even if it isn't online at the time of reading.
>>>
>>
>> I agree, but the main reason I retained it as most of the existing
>> architectures implement this way and I didn't want tho change that
>> behaviour.
>
> Would anything bad happen if we loosened the behavior so that the
> directory is always present as long as the CPU is present? I doubt it.
> Seems like a low risk change.
>

Yes, but before I change, I would like to see people are fine with that.
I don't want to move existing implementations into this generic one and
cause breakage.

Regards,
Sudeep

