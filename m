Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3B0Dju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:39:50 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45917 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab3B0Djt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:39:49 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <512D7FAD.1040003@jp.fujitsu.com>
Date: Wed, 27 Feb 2013 12:38:21 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Gardner <tim.gardner@canonical.com>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <x86@kernel.org>, <a.p.zijlstra@chello.nl>,
        <jarkko.sakkinen@intel.com>, <tangchen@cn.fujitsu.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com> <512D58C2.1090403@jp.fujitsu.com> <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com>
In-Reply-To: <CAE9FiQV5APHSGXuz3NrsApC+V7rsDQMDXMNwZszZuUqQVaZSew@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/02/27 11:30, Yinghai Lu wrote:
> On Tue, Feb 26, 2013 at 4:52 PM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> 2013/02/27 7:44, Yinghai Lu wrote:
>>>>>
>>>>> that commit is totally broken, and it should be reverted.
>>>>>
>>>>> 1. numa_init is called several times, NOT just for srat. so those
>>>>>      nodes_clear(numa_nodes_parsed)
>>>>>      memset(&numa_meminfo, 0, sizeof(numa_meminfo))
>>>>> can not be just removed.
>>>>> please consider sequence is: numaq, srat, amd, dummy.
>>>>> You need to make fall back path working!
>>>>>
>>>>> 2. simply split acpi_numa_init to early_parse_srat.
>>>>> a. that early_parse_srat is NOT called for ia64, so you break ia64.
>>>>> b.  for (i = 0; i < MAX_LOCAL_APIC; i++)
>>>>>        set_apicid_to_node(i, NUMA_NO_NODE)
>>>>> still left in numa_init. So it will just clear result from
>>>>> early_parse_srat.
>>>>> it should be moved before that....
>>>>
>>>>
>>>>      c.  it breaks ACPI_TABLE_OVERIDE...as the acpi table scan is moved
>>>> early before override from INITRD is settled.
>>>>
>>>>>
>>>>> 3. that patch TITLE is total misleading, there is NO x86 in the title,
>>>>> but it changes
>>>>> to x86 code.
>>>>>
>>>>> 4, it does not CC to TJ and other numa guys...
>>>
>>>
>>> After looked at the code more, thought that theory that does not let
>>> kernel use ram
>>> on hotplug area is not right.
>>>
>>
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
>> If you use "movablemem_map=srat", abobe memory can not use movable memory.
>> But in my understanding, current Linux cannot move above memory. So above
>> memory should not use movable memory.
>>
>
> that depends, like relocating initrd to different position.
>
>>
>>>
>>> If node is hotplugable, the mem related stuff like page table and
>>> vmemmap could be
>>> on the that node without problem and should be on that node.
>>>
>>
>>> assume first cpu only have 1G ram, and other 31 socket will have bunch of
>>> ram
>>> and those cpu with ram could be hotadd and hotremoved.
>>> Now you want to put page table and vmemmap on first node.
>>> The system would not boot as not enough memory for cover whole system RAM.
>>
>>
>> Even if we solve your above mentions, the system cannot boot.
>> In this case, user should:
>>    o add ram to first cpu
>>    o decreases hotpluggable ram by :
>>      - changing hotpluggable information of SRAT
>>      - using movablemem_map=nn[KMG]@ss[KMG]
>

> Do you mean you can not boot one socket system with 1G ram ?
> Assume socket 0 does not support hotplug, other 31 sockets support hot plug.
>
> So we could boot system only with socket0, and later one by one hot
> add other cpus.

In this case, system can boot. But other cpus with bunch of ram hot
plug may fails, since system does not have enough memory for cover
hot added memory. When hot adding memory device, kernel object for the
memory is allocated from 1G ram since hot added memory has not been
enabled.

Thanks,
Yasuaki Ishimatsu

>
> We should simulate that way, just like boot system with PXM0 at first
> and later during acpi scan, add other cpus/ram.
>
> Thanks
>
> Yinghai
>


