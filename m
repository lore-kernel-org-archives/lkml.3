Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab3B0COy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:14:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:4743 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab3B0COx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:14:53 -0500
X-IronPort-AV: E=Sophos;i="4.84,744,1355068800"; 
   d="scan'208";a="6775234"
Message-ID: <512D6BFA.8060905@cn.fujitsu.com>
Date: Wed, 27 Feb 2013 10:14:18 +0800
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
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com> <512BD753.4080001@hp.com> <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com> <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com> <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
In-Reply-To: <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 10:13:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/27 10:14:00,
	Serialize complete at 2013/02/27 10:14:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

Please see below. :)

On 02/27/2013 06:44 AM, Yinghai Lu wrote:
>>> that commit is totally broken, and it should be reverted.
>>>
>>> 1. numa_init is called several times, NOT just for srat. so those
>>>     nodes_clear(numa_nodes_parsed)
>>>     memset(&numa_meminfo, 0, sizeof(numa_meminfo))
>>> can not be just removed.
>>> please consider sequence is: numaq, srat, amd, dummy.
>>> You need to make fall back path working!
>>>
>>> 2. simply split acpi_numa_init to early_parse_srat.
>>> a. that early_parse_srat is NOT called for ia64, so you break ia64.
>>> b.  for (i = 0; i<  MAX_LOCAL_APIC; i++)
>>>       set_apicid_to_node(i, NUMA_NO_NODE)
>>> still left in numa_init. So it will just clear result from early_parse_srat.
>>> it should be moved before that....
>>
>>     c.  it breaks ACPI_TABLE_OVERIDE...as the acpi table scan is moved
>> early before override from INITRD is settled.
>>
>>>
>>> 3. that patch TITLE is total misleading, there is NO x86 in the title,
>>> but it changes
>>> to x86 code.
>>>
>>> 4, it does not CC to TJ and other numa guys...
>
> After looked at the code more, thought that theory that does not let
> kernel use ram
> on hotplug area is not right.
>
> after that commit, following range can not use movable ram:
> 1. real_mode code.... well..funny, legacy cpu0 [0,1M) could be hot-removed?
> 2. dma_continguous ?
> 3. log buff ring.
> 4. initrd... why it will be freed after booting, so it could be on movable...
> 5. crashkernel for kdump...: : looks like we can not put kdump kernel
> above 4G anymore
> 6. initmem_init: it will allocate page table to setup kernel mapping
> for memory..., it should
> be with BRK and near end of max_pfn....

AFAIK, Linux kernel now cannot migrate memory used by the kernel 
because. So any memory
used by the kernel should not be on movable area.

>
> If node is hotplugable, the mem related stuff like page table and
> vmemmap could be
> on the that node without problem and should be on that node.

page tables and vmemmap are kernel memory. They should not be movable, I 
think.

>
> assume first cpu only have 1G ram, and other 31 socket will have bunch of ram
> and those cpu with ram could be hotadd and hotremoved.
> Now you want to put page table and vmemmap on first node.
> The system would not boot as not enough memory for cover whole system RAM.

Yes, you are right. And a more extreme situation has been talked about 
by HPA.

"If all the memory is hot-pluggable, then the kernel won't be able to boot."

So, please refer to commit 01a178a94e8eaec351b29ee49fbb3d1c124cb7fb:
	acpi, memory-hotplug: support getting hotplug info from SRAT

I have excluded all the memory reserved by memblock, and any node that 
has memory
reserved by memblock will be set to un-hot-pluggable, which means we 
will have
enough memory (all the memory on the node) to boot the kernel. So I 
think the problem
you are talking about has been solved.

>
> e8d1955258091e4c92d5a975ebd7fd8a98f5d30f and related commits should be just
> reverted now.
>
> Thanks
>
> Yinghai
>
