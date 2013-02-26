Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677Ab3BZWoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:44:39 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36401 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882Ab3BZWoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:44:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
	<CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
	<CAE9FiQXRZ2VjfG4L2d2zDQ3Sud=JqjS=M9=XW=ORS58_y7i4_g@mail.gmail.com>
Date: Tue, 26 Feb 2013 14:44:17 -0800
X-Google-Sender-Auth: IXOobC66K1JoxvqhG2UW68Z4818
Message-ID: <CAE9FiQU-CV4mF8x=Bi_4pmpmeZW-tSoes_f-jOt7yYrbrppo+A@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
        tangchen@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 1:36 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Feb 25, 2013 at 2:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Mon, Feb 25, 2013 at 1:27 PM, Don Morris <don.morris@hp.com> wrote:
>>> On 02/25/2013 10:32 AM, Tim Gardner wrote:
>>>> On 02/25/2013 08:02 AM, Tim Gardner wrote:
>>>>> Is this an expected warning ? I'll boot a vanilla kernel just to be sure.
>>>>>
>>>>> rebased against ab7826595e9ec51a51f622c5fc91e2f59440481a in Linus' repo:
>>>>>
>>>>
>>>> Same with a vanilla kernel, so it doesn't appear that any Ubuntu cruft
>>>> is having an impact:
>>>
>>> Reproduced on a HP z620 workstation (E5-2620 instead of E5-2680, but
>>> still Sandy Bridge, though I don't think that matters).
>>>
>>> Bisection leads to:
>>> # bad: [e8d1955258091e4c92d5a975ebd7fd8a98f5d30f] acpi, memory-hotplug:
>>> parse SRAT before memblock is ready
>>>
>>> Nothing terribly obvious leaps out as to *why* that reshuffling messes
>>> up the cpu<-->node bindings, but I wanted to put this out there while
>>> I poke around further. [Note that the SRAT: PXM -> APIC -> Node print
>>> outs during boot are the same either way -- if you look at the APIC
>>> numbers of the processors (from /proc/cpuinfo), the processors should
>>> be assigned to the correct node, but they aren't.] cc'ing Tang Chen
>>> in case this is obvious to him or he's already fixed it somewhere not
>>> on Linus's tree yet.
>>>
>>> Don Morris
>>>
>>>>
>>>> [    0.170435] ------------[ cut here ]------------
>>>> [    0.170450] WARNING: at arch/x86/kernel/smpboot.c:324
>>>> topology_sane.isra.2+0x71/0x84()
>>>> [    0.170452] Hardware name: S2600CP
>>>> [    0.170454] sched: CPU #1's llc-sibling CPU #0 is not on the same
>>>> node! [node: 1 != 0]. Ignoring dependency.
>>>> [    0.156000] smpboot: Booting Node   1, Processors  #1
>>>> [    0.170455] Modules linked in:
>>>> [    0.170460] Pid: 0, comm: swapper/1 Not tainted 3.8.0+ #1
>>>> [    0.170461] Call Trace:
>>>> [    0.170466]  [<ffffffff810597bf>] warn_slowpath_common+0x7f/0xc0
>>>> [    0.170473]  [<ffffffff810598b6>] warn_slowpath_fmt+0x46/0x50
>>>> [    0.170477]  [<ffffffff816cc752>] topology_sane.isra.2+0x71/0x84
>>>> [    0.170482]  [<ffffffff816cc9de>] set_cpu_sibling_map+0x23f/0x436
>>>> [    0.170487]  [<ffffffff816ccd0c>] start_secondary+0x137/0x201
>>>> [    0.170502] ---[ end trace 09222f596307ca1d ]---
>>
>> that commit is totally broken, and it should be reverted.
>>
>> 1. numa_init is called several times, NOT just for srat. so those
>>    nodes_clear(numa_nodes_parsed)
>>    memset(&numa_meminfo, 0, sizeof(numa_meminfo))
>> can not be just removed.
>> please consider sequence is: numaq, srat, amd, dummy.
>> You need to make fall back path working!
>>
>> 2. simply split acpi_numa_init to early_parse_srat.
>> a. that early_parse_srat is NOT called for ia64, so you break ia64.
>> b.  for (i = 0; i < MAX_LOCAL_APIC; i++)
>>      set_apicid_to_node(i, NUMA_NO_NODE)
>> still left in numa_init. So it will just clear result from early_parse_srat.
>> it should be moved before that....
>
>    c.  it breaks ACPI_TABLE_OVERIDE...as the acpi table scan is moved
> early before override from INITRD is settled.
>
>>
>> 3. that patch TITLE is total misleading, there is NO x86 in the title,
>> but it changes
>> to x86 code.
>>
>> 4, it does not CC to TJ and other numa guys...

After looked at the code more, thought that theory that does not let
kernel use ram
on hotplug area is not right.

after that commit, following range can not use movable ram:
1. real_mode code.... well..funny, legacy cpu0 [0,1M) could be hot-removed?
2. dma_continguous ?
3. log buff ring.
4. initrd... why it will be freed after booting, so it could be on movable...
5. crashkernel for kdump...: : looks like we can not put kdump kernel
above 4G anymore
6. initmem_init: it will allocate page table to setup kernel mapping
for memory..., it should
be with BRK and near end of max_pfn....

If node is hotplugable, the mem related stuff like page table and
vmemmap could be
on the that node without problem and should be on that node.

assume first cpu only have 1G ram, and other 31 socket will have bunch of ram
and those cpu with ram could be hotadd and hotremoved.
Now you want to put page table and vmemmap on first node.
The system would not boot as not enough memory for cover whole system RAM.

e8d1955258091e4c92d5a975ebd7fd8a98f5d30f and related commits should be just
reverted now.

Thanks

Yinghai
