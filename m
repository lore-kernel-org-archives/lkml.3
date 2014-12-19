Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaLSTv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 14:51:27 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:36737 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaLSTv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 14:51:26 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
References: <CA+55aFyYYPgBfRdqtvqxdo==D_BOFSW3fvNULuVxPAr2vnq7Rg@mail.gmail.com>
	<CA+55aFz6KEKdz4Nxkx2fa-FH3PZ+Aa51iA_nXobsQ-dDW5PGEg@mail.gmail.com>
	<20141218051327.GA31988@redhat.com>
	<1418918059.17358.6@mail.thefacebook.com>
	<20141218161230.GA6042@redhat.com>
	<20141219024549.GB1671@redhat.com>
	<CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
	<20141219035859.GA20022@redhat.com>
	<20141219040308.GB20022@redhat.com>
	<CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
	<20141219145528.GC13404@redhat.com>
	<CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
Date: Fri, 19 Dec 2014 11:51:25 -0800
X-Google-Sender-Auth: BWwusjf1BLYuA9GobysRsCS_FI0
Message-ID: <CA+55aFyb6N47N2Jg75EmRxDTjFF2y_oy4dHNDeW_dyM4PUTDrA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 11:15 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> In your earlier trace (with spinlock debugging), the softlockup
> detection was in lock_acquire for copy_page_range(), but CPU2 was
> always in that "generic_exec_single" due to a TLB flush from that
> zap_page_range thing again. But there are no timer traces from that
> one, so I dunno.

Ahh, and that's because the TLB flushing is done under the page table
lock these days (see commit 1cf35d47712d: "mm: split 'tlb_flush_mmu()'
into tlb flushing and memory freeing parts").

Which means that if the TLB flushing gets stuck on CPU#2, CPU#1 that
is trying to get the page table lock will be locked up too.

So this is all very consistent, actually. The underlying bug in both
cases seems to be that the IPI for the TLB flushing doesn't happen for
some reason.

In your second trace, that's explained by the fact that CPU0 is in a
timer interrupt. In the first trace with spinlock debugging, no such
obvious explanation exists. It could be that an IPI has gotten lost
for some reason.

However, the first trace does have this:

   NMI backtrace for cpu 3
   INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too
long to run: 66.180 msecs
   CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0+ #107
   RIP: 0010:   intel_idle+0xdb/0x180
   Code: 31 d2 65 48 8b 34 ...
   INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too
long to run: 95.053 msecs

so something odd is happening (probably on CPU3). It took a long time
to react to the NMI IPI too.

So there's definitely something screwy going on here in IPI-land.

I do note that we depend on the "new mwait" semantics where we do
mwait with interrupts disabled and a non-zero RCX value. Are there
possibly even any known CPU errata in that area? Not that it sounds
likely, but still..

                         Linus
