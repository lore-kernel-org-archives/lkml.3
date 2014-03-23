Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaCWAAe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 20:00:34 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:32812 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCWAAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 20:00:33 -0400
Date: Sun, 23 Mar 2014 00:00:31 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/apic changes for v3.14
In-Reply-To: <20140120134220.GA12050@gmail.com>
Message-ID: <alpine.LFD.2.10.1403222327130.21669@eddie.linux-mips.org>
References: <20140120134220.GA12050@gmail.com>
User-Agent: Alpine 2.10 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Ingo Molnar wrote:

> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index d278736..7f26c9a 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -1982,21 +1989,20 @@ static inline void __smp_error_interrupt(struct pt_regs *regs)
>  	};
>  
>  	/* First tickle the hardware, only then report what went on. -- REW */
> -	v0 = apic_read(APIC_ESR);
>  	apic_write(APIC_ESR, 0);
> -	v1 = apic_read(APIC_ESR);
> +	v = apic_read(APIC_ESR);
>  	ack_APIC_irq();
>  	atomic_inc(&irq_err_count);
>  
> -	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
> -		    smp_processor_id(), v0 , v1);
> +	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x",
> +		    smp_processor_id(), v);
>  
> -	v1 = v1 & 0xff;
> -	while (v1) {
> -		if (v1 & 0x1)
> +	v &= 0xff;
> +	while (v) {
> +		if (v & 0x1)
>  			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
>  		i++;
> -		v1 >>= 1;
> +		v >>= 1;
>  	}
>  
>  	apic_printk(APIC_DEBUG, KERN_CONT "\n");

 Sorry to come up with this so late, I've been cleaning up my mailbox from 
old mailing traffic and came across your change only now.

 I'm afraid this interferes with an old Pentium APIC erratum:

"3AP. Writes to Error Register Clears Register

PROBLEM: The APIC Error register is intended to only be read.  If there is 
a write to this register the data in the APIC Error register will be 
cleared and lost.

IMPLICATION: There is a possibility of clearing the Error register status 
since the write to the register is not specifically blocked.

WORKAROUND: Writes should not occur to the Pentium processor APIC Error 
register.

STATUS: For the steppings affected see the Summary Table of Changes at the 
beginning of this section."

The steppings affected are actually: B1, B3 and B5.  Do we want to keep 
supporting them?  I think yes, we already handle the erratum elsewhere 
(lapic_setup_esr).  So how about:

	if (lapic_get_maxlvt() > 3)	/* Due to the Pentium erratum 3AP. */
		apic_write(APIC_ESR, 0);
	v = apic_read(APIC_ESR);

instead?  I can make a patch if that would make your life easier.

 There's room for optimisation here, but I think it's not worth the effort 
as this is a slow path, APIC error interrupts are not supposed to happen 
and are I believe extremely uncommon with FSB message delivery.

  Maciej
