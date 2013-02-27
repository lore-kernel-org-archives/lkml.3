Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab3B0CY0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:24:26 -0500
Received: from mail-ia0-f176.google.com ([209.85.210.176]:56220 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3B0CYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:24:25 -0500
MIME-Version: 1.0
In-Reply-To: <512D6BFA.8060905@cn.fujitsu.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
	<CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
	<512D6BFA.8060905@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 18:24:24 -0800
X-Google-Sender-Auth: NWrJZFvb1b38Cz8T6EcUn_gzSkw
Message-ID: <CAE9FiQUCLGta4bmpP7j_L29SQuob+B=fWx5J+XyMq17Dmz0SeQ@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 6:14 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> Hi Yinghai,
>
> Please see below. :)
>
>
> On 02/27/2013 06:44 AM, Yinghai Lu wrote:
>>>>
>>>> that commit is totally broken, and it should be reverted.
>>>>
>>>> 1. numa_init is called several times, NOT just for srat. so those
>>>>     nodes_clear(numa_nodes_parsed)
>>>>     memset(&numa_meminfo, 0, sizeof(numa_meminfo))
>>>> can not be just removed.
>>>> please consider sequence is: numaq, srat, amd, dummy.
>>>> You need to make fall back path working!
>>>>
>>>> 2. simply split acpi_numa_init to early_parse_srat.
>>>> a. that early_parse_srat is NOT called for ia64, so you break ia64.
>>>> b.  for (i = 0; i<  MAX_LOCAL_APIC; i++)
>>>>       set_apicid_to_node(i, NUMA_NO_NODE)
>>>> still left in numa_init. So it will just clear result from
>>>> early_parse_srat.
>>>> it should be moved before that....
>>>
>>>
>>>     c.  it breaks ACPI_TABLE_OVERIDE...as the acpi table scan is moved
>>> early before override from INITRD is settled.
>>>
>>>>
>>>> 3. that patch TITLE is total misleading, there is NO x86 in the title,
>>>> but it changes
>>>> to x86 code.
>>>>
>>>> 4, it does not CC to TJ and other numa guys...
>>
>>
>> After looked at the code more, thought that theory that does not let
>> kernel use ram
>> on hotplug area is not right.
>>
>> after that commit, following range can not use movable ram:
>> 1. real_mode code.... well..funny, legacy cpu0 [0,1M) could be
>> hot-removed?
>> 2. dma_continguous ?
>> 3. log buff ring.
>> 4. initrd... why it will be freed after booting, so it could be on
>> movable...
>> 5. crashkernel for kdump...: : looks like we can not put kdump kernel
>> above 4G anymore
>> 6. initmem_init: it will allocate page table to setup kernel mapping
>> for memory..., it should
>> be with BRK and near end of max_pfn....
>
>
> AFAIK, Linux kernel now cannot migrate memory used by the kernel because. So
> any memory
> used by the kernel should not be on movable area.

that depends.

initrd will be freed later, so it should be put anywhere that is under
max_pfn during boot.

>
>
>>
>> If node is hotplugable, the mem related stuff like page table and
>> vmemmap could be
>> on the that node without problem and should be on that node.
>
>
> page tables and vmemmap are kernel memory. They should not be movable, I
> think.

why do you need to migrate pagetable and vmemmap for the memory range
that will be
offline ?

>
>
>>
>> assume first cpu only have 1G ram, and other 31 socket will have bunch of
>> ram
>> and those cpu with ram could be hotadd and hotremoved.
>> Now you want to put page table and vmemmap on first node.
>> The system would not boot as not enough memory for cover whole system RAM.
>
>
> Yes, you are right. And a more extreme situation has been talked about by
> HPA.
>
> "If all the memory is hot-pluggable, then the kernel won't be able to boot."
>
> So, please refer to commit 01a178a94e8eaec351b29ee49fbb3d1c124cb7fb:
>         acpi, memory-hotplug: support getting hotplug info from SRAT
>
> I have excluded all the memory reserved by memblock, and any node that has
> memory
> reserved by memblock will be set to un-hot-pluggable, which means we will
> have
> enough memory (all the memory on the node) to boot the kernel. So I think
> the problem
> you are talking about has been solved.

I don't think that you understand the problem.

for the system that will put all pagetable and vmemmap on the 1G ram
of first cpu.
as all other ram are MOVABLE, so memblock_find_in_range will not use any local
ram on those nodes.

>
>
>>
>> e8d1955258091e4c92d5a975ebd7fd8a98f5d30f and related commits should be
>> just
>> reverted now.
>>
>> Thanks
>>
>> Yinghai
>>
>
