Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbaENMfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:35:54 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:10806 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaENMfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:35:51 -0400
Message-ID: <537362A0.7030803@huawei.com>
Date: Wed, 14 May 2014 20:33:36 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
CC: "will.deacon@arm.com" <will.deacon@arm.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "peifeiyue@huawei.com" <peifeiyue@huawei.com>,
        "liusdu@126.com" <liusdu@126.com>
Subject: Re: [RFC PATCH 2/2] makedumpfile: get additional information from
 vmcore
References: <1399469234-54925-1-git-send-email-sdu.liu@huawei.com> <1399469234-54925-3-git-send-email-sdu.liu@huawei.com> <0910DD04CBD6DE4193FCF86B9C00BE97210369@BPXM01GP.gisp.nec.co.jp> <5371C8E6.6080700@huawei.com> <0910DD04CBD6DE4193FCF86B9C00BE97210997@BPXM01GP.gisp.nec.co.jp>
In-Reply-To: <0910DD04CBD6DE4193FCF86B9C00BE97210997@BPXM01GP.gisp.nec.co.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014/5/14 15:53, Atsushi Kumagai 写道:
>> On 2014/5/13 14:21, Atsushi Kumagai wrote:
>>> Hello Liu,
>>>
>>>> Now we define MAX_PHYSMEM_BITS and SECTION_SIZE_BITS as
>>>> macros. So if we deal with vmcores with different values
>>>> of these two macros. We have to recompile makedumpfile.
>>>
>>> There are other macros which have architecture-specific values
>>> (e.g. __PAGE_OFFSET), and some functions are specific to each
>>> architecture (e.g. vaddr_to_paddr()), so we need recompilation
>>> eventually.
>>>
>>> OTOH, we already don't need recompilation for the same architecture
>>> since the values of such macros are defined for each kernel version
>>> like below:
>>>
>>> #ifdef __x86_64__
>>> ...
>>> #define _MAX_PHYSMEM_BITS_ORIG          (40)
>>> #define _MAX_PHYSMEM_BITS_2_6_26        (44)
>>> #define _MAX_PHYSMEM_BITS_2_6_31        (46)
>>>
>>> So I don't think this patch is valuable.
>>
>> Hi Atsushi,
>>
>> For x86, it is not necessory. But for arm, different venders
>> may define different SECTION_SIZE_BITS. for example:
>>
>>   1 arch/arm/mach-clps711x/include/mach/memory.h
>>     #define SECTION_SIZE_BITS 24
>>   2 arch/arm/mach-exynos/include/mach/memory.h
>>     #define SECTION_SIZE_BITS 28
>>   4 arch/arm/mach-hisi/include/mach/memory.h
>>     #define SECTION_SIZE_BITS 26
>>   8 arch/arm/mach-sa1100/include/mach/memory.h
>>     #define SECTION_SIZE_BITS 27
>>
>> Perhaps we should find another way to let the userspace tools
>> to get the architecture-specific values.
> 
> I see, I think this description is better than the first one.
> 
> Now, makedumpfile can't get an appropriate values of the two macros since the
> values are variable even if the architecture and the kernel version are fixed
> (at least for arm), and we can't solve this without *manual code fixing*, right?
> 
> In practice, the current code expects that all arm machines adopt Exynos
> processors, this is an problem definitely.
> 
>   #ifdef __arm__
>   #define KVBASE_MASK             (0xffff)
>   #define KVBASE                  (SYMBOL(_stext) & ~KVBASE_MASK)
>   #define _SECTION_SIZE_BITS      (28)
>   #define _MAX_PHYSMEM_BITS       (32)
> 
> I think it's better to fix the descriptions to get acceptability,
> but this patch is necessary from the view point of makedumpfile.
> So I recommend you to repost this patch set, then I'll accept it.
> 
Ok, Thanks for you suggest. I will repost this patch. By now no one
relpy my kernel patch related to this issue, named "[RFC PATCH 1/2]
kdump: add sparse memory related values to vmcore". Didn't I cc
the right person or something else?

BTW, For patch "[PATCH] makedumpfile: ARM: get correct mem_map offset",
Did I explain my idea clearly ? If not, I would like repost one with
more details.

Thanks,
Liu Hua

> 
> Thanks
> Atsushi Kumagai
> 
>>>
>>>> This patch makes makedumpfile get these two values from
>>>> vmcore info, if existing. It makes the makedumpfile more
>>>> compatible to vmcores with different section size.
>>>>
>>>> Signed-off-by: Liu Hua <sdu.liu@huawei.com>
>>>> ---
>>>> makedumpfile.c | 17 +++++++++++++++++
>>>> makedumpfile.h |  2 ++
>>>> 2 files changed, 19 insertions(+)
>>>>
>>>> diff --git a/makedumpfile.c b/makedumpfile.c
>>>> index 6cf6e24..3cdf323 100644
>>>> --- a/makedumpfile.c
>>>> +++ b/makedumpfile.c
>>>> @@ -2111,6 +2111,8 @@ read_vmcoreinfo(void)
>>>> 	READ_NUMBER("PG_slab", PG_slab);
>>>> 	READ_NUMBER("PG_buddy", PG_buddy);
>>>> 	READ_NUMBER("PG_hwpoison", PG_hwpoison);
>>>> +	READ_NUMBER("SECTION_SIZE_BITS", SECTION_SIZE_BITS);
>>>> +	READ_NUMBER("MAX_PHYSMEM_BITS", MAX_PHYSMEM_BITS);
>>>>
>>>> 	READ_SRCFILE("pud_t", pud_t);
>>>>
>>>> @@ -2998,6 +3000,18 @@ initialize_bitmap_memory(void)
>>>> }
>>>>
>>>> int
>>>> +calibrate_machdep_info(void)
>>>> +{
>>>> +	if (NUMBER(MAX_PHYSMEM_BITS) > 0)
>>>> +		info->max_physmem_bits = NUMBER(MAX_PHYSMEM_BITS);
>>>> +
>>>> +	if (NUMBER(SECTION_SIZE_BITS) > 0)
>>>> +		info->section_size_bits = NUMBER(SECTION_SIZE_BITS);
>>>> +
>>>> +	return TRUE;
>>>> +}
>>>> +
>>>> +int
>>>> initial(void)
>>>> {
>>>> 	off_t offset;
>>>> @@ -3214,6 +3228,9 @@ out:
>>>> 	if (debug_info && !get_machdep_info())
>>>> 		return FALSE;
>>>>
>>>> +	if (debug_info && !calibrate_machdep_info())
>>>> +		return FALSE;
>>>> +
>>>> 	if (is_xen_memory() && !get_dom0_mapnr())
>>>> 		return FALSE;
>>>>
>>>> diff --git a/makedumpfile.h b/makedumpfile.h
>>>> index eb03688..7acb23a 100644
>>>> --- a/makedumpfile.h
>>>> +++ b/makedumpfile.h
>>>> @@ -1434,6 +1434,8 @@ struct number_table {
>>>> 	long    PG_hwpoison;
>>>>
>>>> 	long	PAGE_BUDDY_MAPCOUNT_VALUE;
>>>> +	long	SECTION_SIZE_BITS;
>>>> +	long	MAX_PHYSMEM_BITS;
>>>> };
>>>>
>>>> struct srcfile_table {
>>>> --
>>>> 1.9.0
>>>
>>> .
>>>
>>


