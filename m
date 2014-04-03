Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbaDCDH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 23:07:58 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:7186 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964771AbaDCDH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 23:07:57 -0400
X-IronPort-AV: E=Sophos;i="4.97,783,1389715200"; 
   d="scan'208";a="28811544"
Message-ID: <533CD04F.8060003@cn.fujitsu.com>
Date: Thu, 3 Apr 2014 11:06:55 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Li Zhong <zhong@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, <nfont@linux.vnet.ibm.com>,
        <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>  <533CBB46.4050800@cn.fujitsu.com> <1396492623.2913.31.camel@ThinkPad-T5421.cn.ibm.com>
In-Reply-To: <1396492623.2913.31.camel@ThinkPad-T5421.cn.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.197]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 10:37 AM, Li Zhong wrote:
> On Thu, 2014-04-03 at 09:37 +0800, Zhang Yanfei wrote:
>> Add ccing
>>
>> On 04/02/2014 04:56 PM, Li Zhong wrote:
>>> I noticed the phys_index and end_phys_index under 
>>> /sys/devices/system/memory/memoryXXX/ have the same value, e.g.
>>> (for the test machine, one memory block has 8 sections, that is 
>>>  sections_per_block equals 8)
>>>
>>> # cd /sys/devices/system/memory/memory100/
>>> # cat phys_index end_phys_index 
>>> 00000064
>>> 00000064
>>>
>>> Seems they should reflect the start/end section number respectively, which 
>>> also matches what is said in Documentation/memory-hotplug.txt
>>
> Hi Yanfei, 
> 
> Thanks for the review. 
> 
>> Indeed. I've noticed this before. The value in 'end_phys_index' doesn't
>> match what it really means. But, the name itself is vague, it looks like
>> it is the index of some page frame. (we keep this name for compatibility?)
> 
> I guess so, Dave just reminded me that the RFC would also break
> userspace..
> 
> And now my plan is: 
>  leave the code unchanged
>  update the document, state the end_phys_index/phys_index are the same,
> and means the memory block index

Ah. I doubt whether there is userspace tool which is using the two sysfiles?
for example, the memory100 directory itself can tell us which block it is.
So why there is the two files under it give the same meaning.

If there is userspace tool using the two files, does it use 'end_phys_index'
in the correct way? That said, if a userspace tool knows what the 'end_phys_index'
really mean, does it still need it since we have 'phys_index' with the same value?

>  [optional] create two new files start_sec_nr, end_sec_nr if needed

These two are the really meaningful sysfiles for userspace, IMO.

> 
> Do you have any other suggestions? 

No. I think we should wait for other guys to comment more.

Thanks.

> 
> Thanks, Zhong
> 
>>
>> The corresponding member in struct memory_block is:
>>
>> struct memory_block {
>>         unsigned long start_section_nr;
>>         unsigned long end_section_nr;
>> ...
>>
>> The two members seem to have the right name, and have the right value in kernel.
>>
>>
>>>
>>> This patch tries to modify that so the two files could show the start/end
>>> section number of the memory block.
>>>
>>> After this change, output of the above example looks like:
>>>
>>> # cat phys_index end_phys_index 
>>> 00000320
>>> 00000327
>>>
>>> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
>>> ---
>>>  drivers/base/memory.c | 4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>>> index bece691..b10f2fa 100644
>>> --- a/drivers/base/memory.c
>>> +++ b/drivers/base/memory.c
>>> @@ -114,7 +114,7 @@ static ssize_t show_mem_start_phys_index(struct device *dev,
>>>  	struct memory_block *mem = to_memory_block(dev);
>>>  	unsigned long phys_index;
>>>  
>>> -	phys_index = mem->start_section_nr / sections_per_block;
>>> +	phys_index = mem->start_section_nr;
>>>  	return sprintf(buf, "%08lx\n", phys_index);
>>>  }
>>>  
>>> @@ -124,7 +124,7 @@ static ssize_t show_mem_end_phys_index(struct device *dev,
>>>  	struct memory_block *mem = to_memory_block(dev);
>>>  	unsigned long phys_index;
>>>  
>>> -	phys_index = mem->end_section_nr / sections_per_block;
>>> +	phys_index = mem->end_section_nr;
>>>  	return sprintf(buf, "%08lx\n", phys_index);
>>>  }
>>>  
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
>>
> 
> 
> .
> 


-- 
Thanks.
Zhang Yanfei
