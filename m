Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3EJPnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:43:55 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:40602 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab3EJPny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:43:54 -0400
Date: Fri, 10 May 2013 17:43:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123
 native_smp_send_reschedule
Message-ID: <20130510154349.GB9358@somewhere>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
 <20130510002930.GB2394@somewhere>
 <alpine.LNX.2.00.1305101702250.23038@pobox.suse.cz>
 <20130510152102.GD22942@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130510152102.GD22942@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 05:21:02PM +0200, Borislav Petkov wrote:
> On Fri, May 10, 2013 at 05:03:56PM +0200, Jiri Kosina wrote:
> > [ ... snip ... ]
> >  Enabling non-boot CPUs ...
> >  smpboot: Booting Node 0 Processor 1 APIC 0x1
> >  CPU1 microcode updated early to revision 0x60f, date = 2010-09-29
> >  Disabled fast string operations
> >  1 1
> >  CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.9.0-12317-gb2031d4 #1
> >  Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
> >   ffff88007c28cca0 ffff880079851e08 ffffffff8154837e ffff880079851e28
> >   ffffffff81077514 ffff88007c28cca0 ffff88007c28cca0 ffff880079851e68
> >   ffffffff810529db 0000000179851e78 ffff88007c28cca0 0000000000000001
> >  Call Trace:
> >   [<ffffffff8154837e>] dump_stack+0x19/0x1b
> >   [<ffffffff81077514>] wake_up_nohz_cpu+0xd4/0xf0
> >   [<ffffffff810529db>] add_timer_on+0xdb/0x110
> >   [<ffffffff8101e4f4>] mce_start_timer+0x64/0x70
> >   [<ffffffff8101e552>] __mcheck_cpu_init_timer+0x52/0x60
> >   [<ffffffff8153e22e>] mcheck_cpu_init+0x6f/0x111
> >   [<ffffffff8153b94e>] identify_cpu+0x3cc/0x3f9
> >   [<ffffffff8153b98d>] identify_secondary_cpu+0x12/0x1d
> >   [<ffffffff8153fdd6>] smp_store_cpu_info+0x3a/0x3c
> >   [<ffffffff8153fec2>] smp_callin+0xea/0x1c1
> >   [<ffffffff8153ffbd>] start_secondary+0x24/0x97
> 
> Ok, I got it:
> 
> smp_callin is called by start_secondary() and down that path we add the
> timer and do wake_up_nohz_cpu.
> 
> HOWEVER(!), the bit in the cpu_online_mask is set much later in
> smp_callin() with
> 
> 	set_cpu_online(smp_processor_id(), true);
> 
> Thus, when we come to send the IPI, the cpu is still offline, according
> to the cpu_online_mask, thus the WARN_ON.
> 
> Nice :-\

Right. But this is adding a timer locally, from CPU 1 to CPU 1, as indicated in the
trace with the "1 1" line. So the only way for this IPI to be self-sent is if the
tick is stopped locally (cf: wake_up_full_nohz_cpu()).

But the tick is not supposed to be stopped so early in a secondary CPU initialization.
The tick can be stopped only from two places:

1) idle loop, but we haven't yet reached that place. cpu_idle() is called much later
2) interrupt exit, but interrupts are supposed to be disabled at this stage

So either interrupts are spuriously enabled early, or ts->tick_stopped is
not correctly initialized.

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
