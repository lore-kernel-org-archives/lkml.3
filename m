Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3BYV1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:27:53 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:38599 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab3BYV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:27:51 -0500
Message-ID: <512BD753.4080001@hp.com>
Date: Mon, 25 Feb 2013 16:27:47 -0500
From: Don Morris <don.morris@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        a.p.zijlstra@chello.nl, jarkko.sakkinen@intel.com,
        tangchen@cn.fujitsu.com
Subject: Re: sched: CPU #1's llc-sibling CPU #0 is not on the same node!
References: <512B7D10.4060304@tpi.com> <512B8407.2090807@canonical.com>
In-Reply-To: <512B8407.2090807@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2013 10:32 AM, Tim Gardner wrote:
> On 02/25/2013 08:02 AM, Tim Gardner wrote:
>> Is this an expected warning ? I'll boot a vanilla kernel just to be sure.
>>
>> rebased against ab7826595e9ec51a51f622c5fc91e2f59440481a in Linus' repo:
>>
> 
> Same with a vanilla kernel, so it doesn't appear that any Ubuntu cruft
> is having an impact:

Reproduced on a HP z620 workstation (E5-2620 instead of E5-2680, but
still Sandy Bridge, though I don't think that matters).

Bisection leads to:
# bad: [e8d1955258091e4c92d5a975ebd7fd8a98f5d30f] acpi, memory-hotplug:
parse SRAT before memblock is ready

Nothing terribly obvious leaps out as to *why* that reshuffling messes
up the cpu<-->node bindings, but I wanted to put this out there while
I poke around further. [Note that the SRAT: PXM -> APIC -> Node print
outs during boot are the same either way -- if you look at the APIC
numbers of the processors (from /proc/cpuinfo), the processors should
be assigned to the correct node, but they aren't.] cc'ing Tang Chen
in case this is obvious to him or he's already fixed it somewhere not
on Linus's tree yet.

Don Morris

> 
> [    0.170435] ------------[ cut here ]------------
> [    0.170450] WARNING: at arch/x86/kernel/smpboot.c:324
> topology_sane.isra.2+0x71/0x84()
> [    0.170452] Hardware name: S2600CP
> [    0.170454] sched: CPU #1's llc-sibling CPU #0 is not on the same
> node! [node: 1 != 0]. Ignoring dependency.
> [    0.156000] smpboot: Booting Node   1, Processors  #1
> [    0.170455] Modules linked in:
> [    0.170460] Pid: 0, comm: swapper/1 Not tainted 3.8.0+ #1
> [    0.170461] Call Trace:
> [    0.170466]  [<ffffffff810597bf>] warn_slowpath_common+0x7f/0xc0
> [    0.170473]  [<ffffffff810598b6>] warn_slowpath_fmt+0x46/0x50
> [    0.170477]  [<ffffffff816cc752>] topology_sane.isra.2+0x71/0x84
> [    0.170482]  [<ffffffff816cc9de>] set_cpu_sibling_map+0x23f/0x436
> [    0.170487]  [<ffffffff816ccd0c>] start_secondary+0x137/0x201
> [    0.170502] ---[ end trace 09222f596307ca1d ]---
> 
> rtg
> 

