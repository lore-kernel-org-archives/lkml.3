Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaJHN4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:56:46 -0400
Received: from rs04.intra2net.com ([85.214.66.2]:53352 "EHLO
	rs04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbaJHN4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:56:45 -0400
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: linux-kernel@vger.kernel.org
Cc: artem_fetishev@epam.com, Thomas D <whissi@whissi.de>
Subject: Re: 3.14.19: Oops on boot in rapl_cpu_prepare()
Date: Wed, 08 Oct 2014 15:56:41 +0200
Message-ID: <9064398.1oxO9cdJ3A@storm>
Organization: Intra2net AG
User-Agent: KMail/4.14.1 (Linux/3.16.3-200.fc20.x86_64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <10317150.0hmJcKxvss@storm>
References: <10317150.0hmJcKxvss@storm>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

On Wednesday, 24. September 2014 17:09:01 Thomas Jarosch wrote:
> ...
> general protection fault: 0000 [#1] SMP
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.19-1.i2n.i686 #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> task: f58779a0 ti: f5878000 task.ti: f5878000
> EIP: 0060:[<c101f9b2>] EFLAGS: 00000282 CPU: 0
> EIP is at rapl_cpu_prepare+0x62/0xf0
> EAX: 00000606 EBX: c14ef3e4 ECX: 00000606 EDX: 00000000
> ESI: 00000000 EDI: f5918280 EBP: f5879ec4 ESP: f5879eb4
>     DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> CR0: 80050033 CR2: ffe16000 CR3: 014fb000 CR4: 000406d0
> Stack:
>     00000006 c1491784 00000000 00000000 f5879efc c149e670 c14ee5c0
> c146a000 00000008 f5879ee0 c103b45d f5879eec c132100e c1491784 f5879efc
> 00000006 0000009e 00000000 f5879f70 c1000366 00000000 f58ab300 f58ab080
> 0000000f Call Trace:
>     [<c149e670>] rapl_pmu_init+0x88/0x1af
>     [<c103b45d>] ? cpu_maps_update_done+0xd/0x10
>     [<c132100e>] ? register_cpu_notifier+0x1e/0x30
>     [<c1000366>] do_one_initcall+0x36/0x150
>     [<c149e5e8>] ? intel_uncore_init+0x332/0x332
>     [<c1495600>] ? kernel_init_freeable+0x143/0x18c
>     [<c1051f23>] ? parse_args+0x1a3/0x330
>     [<c106aba0>] ? __wake_up+0x40/0x50
>     [<c14955a4>] kernel_init_freeable+0xe7/0x18c
>     [<c1495649>] ? kernel_init_freeable+0x18c/0x18c
>     [<c132087b>] kernel_init+0xb/0xe0
>     [<c13279b7>] ret_from_kernel_thread+0x1b/0x28
>     [<c1320870>] ? rest_init+0x60/0x60
> ...

the issue is fixed by upgrading to kernel 3.14.20.

Probably it's this patch:

----------------------------------------
commit 2968314094d8db0af32de20ad51349a30ea54a01
Author: Venkatesh Srinivas <venkateshs@google.com>
Date:   Thu Mar 13 12:36:26 2014 -0700

    perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU
    
    commit 24223657806a0ebd0ae5c9caaf7b021091889cf2 upstream.
    
    CPUs which should support the RAPL counters according to
    Family/Model/Stepping may still issue #GP when attempting to access
    the RAPL MSRs. This may happen when Linux is running under KVM and
    we are passing-through host F/M/S data, for example. Use rdmsrl_safe
    to first access the RAPL_POWER_UNIT MSR; if this fails, do not
    attempt to use this PMU.
----------------------------------------

Thanks for the backport to 3.14.

Cheers,
Thomas

