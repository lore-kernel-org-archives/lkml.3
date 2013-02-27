Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3B0HL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 02:11:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:5112 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab3B0HLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 02:11:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,746,1355068800"; 
   d="scan'208";a="6778413"
Message-ID: <512DB199.5050203@cn.fujitsu.com>
Date: Wed, 27 Feb 2013 15:11:21 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Morris <don.morris@hp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jarkko.sakkinen@intel.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D58C2.1090403@jp.fujitsu.com> <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com> <512D7FAD.1040003@jp.fujitsu.com> <CAE9FiQWxq-HPKK+XNRLggZSM4NcdfaeGDWCgd3HegEhaDSSTtA@mail.gmail.com> <512D8EDA.3010602@jp.fujitsu.com> <CAE9FiQWAxL6F70fF0dQcBZKTReJOiC+Ez0xcqcosgAdSagS-bA@mail.gmail.com> <512D9E69.6010102@jp.fujitsu.com> <CAE9FiQV9JRk1SYLkBXsQmrSEDHrYZDpBV6UZb+U5rB7=4gFhVA@mail.gmail.com>
In-Reply-To: <CAE9FiQV9JRk1SYLkBXsQmrSEDHrYZDpBV6UZb+U5rB7=4gFhVA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 15:11:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 15:11:02,
	Serialize complete at 2013/02/27 15:11:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 02:54 PM, Yinghai Lu wrote:
> On Tue, Feb 26, 2013 at 9:49 PM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com>  wrote:
>> 2013/02/27 14:11, Yinghai Lu wrote:
>>>
>>> On Tue, Feb 26, 2013 at 8:43 PM, Yasuaki Ishimatsu
>>> <isimatu.yasuaki@jp.fujitsu.com>  wrote:
>>>>
>>>> 2013/02/27 13:04, Yinghai Lu wrote:
>>>>>
>>>>>
>>>>> On Tue, Feb 26, 2013 at 7:38 PM, Yasuaki Ishimatsu
>>>>> <isimatu.yasuaki@jp.fujitsu.com>  wrote:
>>>>>>
>>>>>>
>>>>>> 2013/02/27 11:30, Yinghai Lu wrote:
>>>>>>>
>>>>>>>
>>>>>>> Do you mean you can not boot one socket system with 1G ram ?
>>>>>>> Assume socket 0 does not support hotplug, other 31 sockets support hot
>>>>>>> plug.
>>>>>>>
>>>>>>> So we could boot system only with socket0, and later one by one hot
>>>>>>> add other cpus.
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> In this case, system can boot. But other cpus with bunch of ram hot
>>>>>> plug may fails, since system does not have enough memory for cover
>>>>>> hot added memory. When hot adding memory device, kernel object for the
>>>>>> memory is allocated from 1G ram since hot added memory has not been
>>>>>> enabled.
>>>>>>
>>>>>
>>>>> yes, it may fail, if the one node memory need page table and vmemmap
>>>>> is more than 1g ...
>>>>>
>>>>
>>
>>>>> for hot add memory we need to
>>>>> 1. add another wrapper for init_memory_mapping, just like
>>>>> init_mem_mapping() for booting path.
>>>>> 2. we need make memblock more generic, so we can use it with hot add
>>>>> memory during runtime.
>>>>> 3. with that we can initialize page table for hot added node with ram.
>>>>> a. initial page table for 2M near node top is from node0 ( that does
>>>>> not support hot plug).
>>>>> b. then will use 2M for memory below node top...
>>>>> c. with that we will make sure page table stay on local node.
>>>>>     alloc_low_pages need to be updated to support that.
>>>>> 4. need to make sure vmemmap on local node too.
>>>>
>>>>
>>>>
>>>> I think so too. By this, memory hot plug becomes more useful.
>>
>>
>> I agree with your idea. But I think above ideas is future work.
>> So at first we should use movable memory for memory hot plug.
>> After that, we will implement above ideas.
>>
>>
>>>>
>>>>>
>>>>> so hot-remove node will work too later.
>>>>>
>>>>> In the long run, we should make booting path and hot adding more
>>>>> similar and share at most code.
>>>>> That will make code get more test coverage.
>>>
>>>
>>> Tang,  Yasuaki, Andrew,
>>>
>>> Please check if you are ok with attached reverting patch.
>>
>>
>> We will fix this problem with no objection. So please wait a while.
>>
>> And the problem occurs by "movablemem_map=srat" not
>> "movablemem_map=nn[KMG]@ss[KMG]"
>> At least, if you want to revert it, you should revert only
>> "movablemem_map=srat" part.
>
> Those patches are tangled together.

No, they are not.

The following commits supports "movablemem_map=nn[KMG]@ss[KMG]".

commit fb06bc8e5f42f38c011de0e59481f464a82380f6
     page_alloc: bootmem limit with movablecore_map
commit 42f47e27e761fee07da69e04612ec7dd0d490edd
     page_alloc: make movablemem_map have higher priority
commit 6981ec31146cf19454c55c130625f6cee89aab95
     page_alloc: introduce zone_movable_limit[] to keep movable limit 
for nodes
commit 34b71f1e04fcba578e719e675b4882eeeb2a1f6f
     page_alloc: add movable_memmap kernel parameter
commit 4d59a75125d5a4717e57e9fc62c64b3d346e603e
     x86: get pg_data_t's memory from other node

And the following supports "movablemem_map=srat".

commit f7210e6c4ac795694106c1c5307134d3fc233e88
     mm/memblock.c: use CONFIG_HAVE_MEMBLOCK_NODE_MAP to protect 
movablecore_map in memblock_overlaps_region().
commit 01a178a94e8eaec351b29ee49fbb3d1c124cb7fb
     acpi, memory-hotplug: support getting hotplug info from SRAT
commit 27168d38fa209073219abedbe6a9de7ba9acbfad
     acpi, memory-hotplug: extend movablemem_map ranges to the end of node
commit e8d1955258091e4c92d5a975ebd7fd8a98f5d30f
     acpi, memory-hotplug: parse SRAT before memblock is ready

>
> Also it looks funny to ask user to specify mem range in boot command
> line to enable mem hotplug.

Well, I think sometimes users don't like the SRAT memory style, and want to
increase or reduce hot-pluggable memory by themselves. And also, it is 
useful
for debuging firmware bugs.

I agree that "movablemem_map=srat" functionality need more work to improve.
Can we not revert it, and improve it during 3.9rc ? I think during rc time,
at least we can fix the problems brought by early_parse_srat().

Thanks. :)
