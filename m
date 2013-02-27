Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab3B0EdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 23:33:12 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:8795 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab3B0EdL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 23:33:11 -0500
X-IronPort-AV: E=Sophos;i="4.84,746,1355068800"; 
   d="scan'208";a="6776266"
Message-ID: <512D8C65.50505@cn.fujitsu.com>
Date: Wed, 27 Feb 2013 12:32:37 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D6BFA.8060905@cn.fujitsu.com> <CAE9FiQUCLGta4bmpP7j_L29SQuob+B=fWx5J+XyMq17Dmz0SeQ@mail.gmail.com>
In-Reply-To: <CAE9FiQUCLGta4bmpP7j_L29SQuob+B=fWx5J+XyMq17Dmz0SeQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 12:32:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 12:32:18
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 10:24 AM, Yinghai Lu wrote:
>>> After looked at the code more, thought that theory that does not let
>>> kernel use ram
>>> on hotplug area is not right.
>>>
>>> after that commit, following range can not use movable ram:
>>> 1. real_mode code.... well..funny, legacy cpu0 [0,1M) could be
>>> hot-removed?
>>> 2. dma_continguous ?
>>> 3. log buff ring.
>>> 4. initrd... why it will be freed after booting, so it could be on
>>> movable...
>>> 5. crashkernel for kdump...: : looks like we can not put kdump kernel
>>> above 4G anymore
>>> 6. initmem_init: it will allocate page table to setup kernel mapping
>>> for memory..., it should
>>> be with BRK and near end of max_pfn....
>>
>>
>> AFAIK, Linux kernel now cannot migrate memory used by the kernel because. So
>> any memory
>> used by the kernel should not be on movable area.
>
> that depends.
>
> initrd will be freed later, so it should be put anywhere that is under
> max_pfn during boot.
>

OK，but initrd is not that big. Actually, before my code start to work, 
memblock
has reserved some memory. But it is not that big. On the other hand, it 
is not that
easy to find out which memory should be kept in unmovable area, and 
which should not.

>>
>>
>>>
>>> If node is hotplugable, the mem related stuff like page table and
>>> vmemmap could be
>>> on the that node without problem and should be on that node.
>>
>>
>> page tables and vmemmap are kernel memory. They should not be movable, I
>> think.
>
> why do you need to migrate pagetable and vmemmap for the memory range
> that will be
> offline ?

Hum, you are right. :)

True, we can store pagetable and vmemmap on the node that is hot-pluggable.
But just like the page_cgroup structs, we need additional work to handle it.

But based on the existing code, we didn't do any special handling. I think
we can improve it if needed. ：）

>
>>
>>
>>>
>>> assume first cpu only have 1G ram, and other 31 socket will have bunch of
>>> ram
>>> and those cpu with ram could be hotadd and hotremoved.
>>> Now you want to put page table and vmemmap on first node.
>>> The system would not boot as not enough memory for cover whole system RAM.
>>
>>
>> Yes, you are right. And a more extreme situation has been talked about by
>> HPA.
>>
>> "If all the memory is hot-pluggable, then the kernel won't be able to boot."
>>
>> So, please refer to commit 01a178a94e8eaec351b29ee49fbb3d1c124cb7fb:
>>          acpi, memory-hotplug: support getting hotplug info from SRAT
>>
>> I have excluded all the memory reserved by memblock, and any node that has
>> memory
>> reserved by memblock will be set to un-hot-pluggable, which means we will
>> have
>> enough memory (all the memory on the node) to boot the kernel. So I think
>> the problem
>> you are talking about has been solved.
>
> I don't think that you understand the problem.
>
> for the system that will put all pagetable and vmemmap on the 1G ram
> of first cpu.
> as all other ram are MOVABLE, so memblock_find_in_range will not use any local
> ram on those nodes.
>

Yes, I konw that. :)

In this case, the kernel will not able to use local ram on those nodes. 
It will
cause some performance down.

I mean if the 1G ram is not enough for the kernel to boot, the current 
code will
set all the ram on the same node as un-hot-pluggable.

If all the ram on the node is not enough for kernel to boot, it is a 
really extreme
situation, IIUC.

I think users can solve this problem in two ways:
1) add more ram to the node.
2) use movablemem_map=nn[KMG]@ss[KMG] to configure more ram as unmovable.


Thanks. :)

