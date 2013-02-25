Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3BYWu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:50:58 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:48206 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab3BYWu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:50:57 -0500
MIME-Version: 1.0
In-Reply-To: <512BD753.4080001@hp.com>
References: <512B7D10.4060304@tpi.com>
	<512B8407.2090807@canonical.com>
	<512BD753.4080001@hp.com>
Date: Mon, 25 Feb 2013 14:50:56 -0800
X-Google-Sender-Auth: HAvD0nnulVWF5I3yVAgC_knO6QY
Message-ID: <CAE9FiQVY4io_mO3PhTtE6FbGUgo1uZKKXO=pjx_FoZ1JuZmsAw@mail.gmail.com>
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
From: Yinghai Lu <yinghai@kernel.org>
To: Don Morris <don.morris@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
        tangchen@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 1:27 PM, Don Morris <don.morris@hp.com> wrote:
> On 02/25/2013 10:32 AM, Tim Gardner wrote:
>> On 02/25/2013 08:02 AM, Tim Gardner wrote:
>>> Is this an expected warning ? I'll boot a vanilla kernel just to be sure.
>>>
>>> rebased against ab7826595e9ec51a51f622c5fc91e2f59440481a in Linus' repo:
>>>
>>
>> Same with a vanilla kernel, so it doesn't appear that any Ubuntu cruft
>> is having an impact:
>
> Reproduced on a HP z620 workstation (E5-2620 instead of E5-2680, but
> still Sandy Bridge, though I don't think that matters).
>
> Bisection leads to:
> # bad: [e8d1955258091e4c92d5a975ebd7fd8a98f5d30f] acpi, memory-hotplug:
> parse SRAT before memblock is ready
>
> Nothing terribly obvious leaps out as to *why* that reshuffling messes
> up the cpu<-->node bindings, but I wanted to put this out there while
> I poke around further. [Note that the SRAT: PXM -> APIC -> Node print
> outs during boot are the same either way -- if you look at the APIC
> numbers of the processors (from /proc/cpuinfo), the processors should
> be assigned to the correct node, but they aren't.] cc'ing Tang Chen
> in case this is obvious to him or he's already fixed it somewhere not
> on Linus's tree yet.
>
> Don Morris
>
>>
>> [    0.170435] ------------[ cut here ]------------
>> [    0.170450] WARNING: at arch/x86/kernel/smpboot.c:324
>> topology_sane.isra.2+0x71/0x84()
>> [    0.170452] Hardware name: S2600CP
>> [    0.170454] sched: CPU #1's llc-sibling CPU #0 is not on the same
>> node! [node: 1 != 0]. Ignoring dependency.
>> [    0.156000] smpboot: Booting Node   1, Processors  #1
>> [    0.170455] Modules linked in:
>> [    0.170460] Pid: 0, comm: swapper/1 Not tainted 3.8.0+ #1
>> [    0.170461] Call Trace:
>> [    0.170466]  [<ffffffff810597bf>] warn_slowpath_common+0x7f/0xc0
>> [    0.170473]  [<ffffffff810598b6>] warn_slowpath_fmt+0x46/0x50
>> [    0.170477]  [<ffffffff816cc752>] topology_sane.isra.2+0x71/0x84
>> [    0.170482]  [<ffffffff816cc9de>] set_cpu_sibling_map+0x23f/0x436
>> [    0.170487]  [<ffffffff816ccd0c>] start_secondary+0x137/0x201
>> [    0.170502] ---[ end trace 09222f596307ca1d ]---

that commit is totally broken, and it should be reverted.

1. numa_init is called several times, NOT just for srat. so those
   nodes_clear(numa_nodes_parsed)
   memset(&numa_meminfo, 0, sizeof(numa_meminfo))
can not be just removed.
please consider sequence is: numaq, srat, amd, dummy.
You need to make fall back path working!

2. simply split acpi_numa_init to early_parse_srat.
a. that early_parse_srat is NOT called for ia64, so you break ia64.
b.  for (i = 0; i < MAX_LOCAL_APIC; i++)
     set_apicid_to_node(i, NUMA_NO_NODE)
still left in numa_init. So it will just clear result from early_parse_srat.
it should be moved before that....

3. that patch TITLE is total misleading, there is NO x86 in the title,
but it changes
to x86 code.

4, it does not CC to TJ and other numa guys...

Thanks

Yinghai
