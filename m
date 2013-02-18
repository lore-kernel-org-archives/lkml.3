Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab3BRFz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:55:57 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:42999
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab3BRFzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:55:55 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 18 Feb 2013 13:55:42 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>, Pavel Machek <pavel@denx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Simon Horman <horms+renesas@verge.net.au>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 8/9] [HACK] ARM: imx: work around v7_cpu_resume link error
Message-ID: <20130218055541.GK6782@S2101-09.ap.freescale.net>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de>
 <1360882071-4072668-9-git-send-email-arnd@arndb.de>
 <20130215110720.GL17833@n2100.arm.linux.org.uk>
 <alpine.LFD.2.03.1302152336520.6419@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1302152336520.6419@syhkavp.arg>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 16, 2013 at 12:14:49AM -0500, Nicolas Pitre wrote:
> On Fri, 15 Feb 2013, Russell King - ARM Linux wrote:
> 
> > On Thu, Feb 14, 2013 at 11:47:50PM +0100, Arnd Bergmann wrote:
> > > Patch c08e20d24 "arm: Add v7_invalidate_l1 to cache-v7.S"
> > > moves the v7_invalidate_l1 symbol out of imx/headsmp.S,
> > > which seems to cause a link error because it is now
> > > too far away from v7_cpu_resume when building an
> > > allyesconfig kernel.
> > > 
> > > If we move the v7_cpu_resume function from the .data
> > > section to .text, that creates another link error
> > > for the reference to phys_l2x0_saved_regs, but we
> > > can move all of the above to .text.
> > > 
> > > I believe that this is not a correct bug fix but just
> > > a bad workaround, so I'm open to ideas from people
> > > who understand the bigger picture.
> > 
> > Unfortunately, this ends up with writable data in the .text section, which
> > is supposed to be read-only.  We should try to preserve that status, even
> > though we don't enforce it.
> > 
> > I guess the problem is that we end up with the .data segment soo far away
> > from the .text segment that these branches no longer work (and remember
> > that this code executes with the MMU off.)
> > 
> > The only solution I can think is that we need to do quite a bit of magic
> > here to jump to an absolute address, but taking account of the V:P offset.
> > That's not going to be particularly nice, and it's going to then also have
> > to jump back the other way - to the cpu_resume code which is also in the
> > .data section.
> 
> Something like this should work:
> 
> diff --git a/arch/arm/mach-imx/headsmp.S b/arch/arm/mach-imx/headsmp.S
> index 7e49deb128..9de26f3edb 100644
> --- a/arch/arm/mach-imx/headsmp.S
> +++ b/arch/arm/mach-imx/headsmp.S
> @@ -99,8 +99,11 @@ phys_l2x0_saved_regs:
>  #endif
>  
>  ENTRY(v7_cpu_resume)
> -	bl	v7_invalidate_l1
> +	ldr	ip, 2f
> +	mov	lr, pc
> +1:	add	pc, pc, ip
>  	pl310_resume
>  	b	cpu_resume
> +2:	.word v7_invalidate_l1 - 1b - 8
>  ENDPROC(v7_cpu_resume)
>  #endif
> 
Yes, it works.

> 
> However it is probably best to move all the code to the .text section 
> where it belongs and fixup the data access instead.  I must plead guilty 
> for introducing this idea of putting code in the .data section with the 
> SA1100resume code over 10 years ago that everyone copied since.
> 
> So here's how I think it should look instead, and how I should have done 
> the SA1100 code back then:
> 
> diff --git a/arch/arm/mach-imx/headsmp.S b/arch/arm/mach-imx/headsmp.S
> index 7e49deb128..38a544a037 100644
> --- a/arch/arm/mach-imx/headsmp.S
> +++ b/arch/arm/mach-imx/headsmp.S
> @@ -73,16 +73,16 @@ ENDPROC(v7_secondary_startup)
>  
>  #ifdef CONFIG_PM
>  /*
> - * The following code is located into the .data section.  This is to
> - * allow phys_l2x0_saved_regs to be accessed with a relative load
> - * as we are running on physical address here.
> + * The following code must assume it is running from physical address
> + * where absolute virtual addresses to the data section have to be
> + * turned into relative ones.
>   */
> -	.data
> -	.align
>  
>  #ifdef CONFIG_CACHE_L2X0
>  	.macro	pl310_resume
> -	ldr	r2, phys_l2x0_saved_regs
> +	adr	r0, phys_l2x0_saved_ptr_offset
> +	ldr	r2, [r0]
> +	add	r2, r2, r0
>  	ldr	r0, [r2, #L2X0_R_PHY_BASE]	@ get physical base of l2x0
>  	ldr	r1, [r2, #L2X0_R_AUX_CTRL]	@ get aux_ctrl value
>  	str	r1, [r0, #L2X0_AUX_CTRL]	@ restore aux_ctrl
> @@ -90,9 +90,13 @@ ENDPROC(v7_secondary_startup)
>  	str	r1, [r0, #L2X0_CTRL]		@ re-enable L2
>  	.endm
>  
> +	.bss
>  	.globl	phys_l2x0_saved_regs
>  phys_l2x0_saved_regs:
> -        .long   0
> +        .space   4
> +	.previous
> +phys_l2x0_saved_ptr_offset:
> +	.word	phys_l2x0_saved_regs - .
>  #else
>  	.macro	pl310_resume
>  	.endm
> 
But this does not work.  It seems the execution jumps to the start of
kernel on system resuming.

Shawn

root@freescale ~$ ./rtcwakeup.sh
rtcwakeup.out: wakeup from "mem" using rtc0 at Fri Jan  2 00:09:43 1970
PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
mmc0: card a8a5 removed
mmc1: card b368 removed
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Entering mem sleep
fec_stop : Graceful transmit stop did not complete !
PM: suspend of devices complete after 8.361 msecs
PM: suspend devices took 0.010 seconds
PM: late suspend of devices complete after 0.267 msecs
PM: noirq suspend of devices complete after 0.754 msecs
Disabling non-boot CPUs ...
CPU1: shutdown
CPU2: shutdown
CPU3: shutdown
Booting Linux on physical CPU 0x0
Linux version 3.8.0-rc7-next-20130215+ (r65073@S2101-09) (gcc version
4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #341 SMP Mon Feb 18 13:36:48 CST
2013
CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: Freescale i.MX6 Quad (Device Tree), model: Freescale i.MX6 Quad
SABRE Lite Board
Memory policy: ECC disabled, Data cache writealloc


