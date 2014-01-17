Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaAQC6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 21:58:30 -0500
Received: from gate.crashing.org ([63.228.1.57]:47350 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbaAQC61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 21:58:27 -0500
Message-ID: <1389927490.7406.10.camel@pasglop>
Subject: Re: Kernel stack overflows due to  "powerpc: Remove ksp_limit on
 ppc64" with v3.13-rc8 on ppc32 (P2020)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Kevin Hao <haokexin@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Fri, 17 Jan 2014 13:58:10 +1100
In-Reply-To: <20140117022005.GA29880@pek-khao-d1.corp.ad.wrs.com>
References: <20140116180532.GA1616@roeck-us.net>
	 <20140117022005.GA29880@pek-khao-d1.corp.ad.wrs.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-17 at 10:20 +0800, Kevin Hao wrote:
> On Thu, Jan 16, 2014 at 10:05:32AM -0800, Guenter Roeck wrote:
> > Hi all,
> > 
> > I am getting kernel stack overflows with v3.13-rc8 on a system with P2020 CPU.
> > The kernel is patched for the target, but I don't think that is related.
> > Stack overflows are in different areas, but always in calls from __do_softirq.
> > 
> > Crashes happen reliably either during boot or if I put any kind of load
> > onto the system.
> 
> How about the following fix:

Wow. I've been staring at that code for 15mn this morning and didn't
spot it ! Nice catch :-)

Any chance you can send a version of that patch that adds the C
prototype of the function in a comment right before the assembly ?

We should generalize that practice...

Cheers,
Ben.
 
> diff --git a/arch/powerpc/kernel/misc_32.S b/arch/powerpc/kernel/misc_32.S
> index e47d268727a4..52fffe5616b4 100644
> --- a/arch/powerpc/kernel/misc_32.S
> +++ b/arch/powerpc/kernel/misc_32.S
> @@ -61,7 +61,7 @@ _GLOBAL(call_do_irq)
>  	mflr	r0
>  	stw	r0,4(r1)
>  	lwz	r10,THREAD+KSP_LIMIT(r2)
> -	addi	r11,r3,THREAD_INFO_GAP
> +	addi	r11,r4,THREAD_INFO_GAP
>  	stwu	r1,THREAD_SIZE-STACK_FRAME_OVERHEAD(r4)
>  	mr	r1,r4
>  	stw	r10,8(r1)
> 
> Thanks,
> Kevin
> > 
> > Example:
> > 
> > Kernel stack overflow in process eb3e5a00, r1=eb79df90
> > CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19eca00 #4
> > task: eb3e5a00 ti: c0616000 task.ti: ef440000
> > NIP: c003a420 LR: c003a410 CTR: c0017518
> > REGS: eb79dee0 TRAP: 0901   Not tainted (3.13.0-rc8-juniper-00146-g19eca00)
> > MSR: 00029000 <CE,EE,ME>  CR: 24008444  XER: 00000000
> > GPR00: c003a410 eb79df90 eb3e5a00 00000000 eb05d900 00000001 65d87646 00000000
> > GPR08: 00000000 020b8000 00000000 00000000 44008442
> > NIP [c003a420] __do_softirq+0x94/0x1ec
> > LR [c003a410] __do_softirq+0x84/0x1ec
> > Call Trace:
> > [eb79df90] [c003a410] __do_softirq+0x84/0x1ec (unreliable)
> > [eb79dfe0] [c003a970] irq_exit+0xbc/0xc8
> > [eb79dff0] [c000cc1c] call_do_irq+0x24/0x3c
> > [ef441f20] [c00046a8] do_IRQ+0x8c/0xf8
> > [ef441f40] [c000e7f4] ret_from_except+0x0/0x18
> > --- Exception: 501 at 0xfcda524
> >     LR = 0x10024900
> > Instruction dump:
> > 7c781b78 3b40000a 3a73b040 543c0024 3a800000 3b3913a0 7ef5bb78 48201bf9
> > 5463103a 7d3b182e 7e89b92e 7c008146 <3ba00000> 7e7e9b78 48000014 57fff87f
> > Kernel panic - not syncing: kernel stack overflow
> > CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19eca00 #4
> > Call Trace:
> > Rebooting in 180 seconds..
> > 
> > Reverting the following commit fixes the problem.
> > 
> > cbc9565ee8 "powerpc: Remove ksp_limit on ppc64"
> > 
> > Should I submit a patch reverting this commit, or is there a better way to fix
> > the problem on short notice (given that 3.13 is close) ?
> > 
> > Thanks,
> > Guenter
> > _______________________________________________
> > Linuxppc-dev mailing list
> > Linuxppc-dev@lists.ozlabs.org
> > https://lists.ozlabs.org/listinfo/linuxppc-dev


