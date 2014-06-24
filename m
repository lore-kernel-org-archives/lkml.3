Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965444AbaFXQJF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:09:05 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40672 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965137AbaFXQJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:09:00 -0400
Date: Tue, 24 Jun 2014 17:08:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v6 4/4] ARM: Add KGDB/KDB FIQ debugger generic code
Message-ID: <20140624160844.GV32514@n2100.arm.linux.org.uk>
References: <1403174303-25456-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-5-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403623097-1153-5-git-send-email-daniel.thompson@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 04:18:17PM +0100, Daniel Thompson wrote:
> +	.align	5
> +__fiq_svc:
> +	svc_entry

Remember that the registers you have on the stack here are r0-r12, plus
the SVC banked sp and lr registers.  These may not be the registers
from the mode you took the FIQ (eg, if it was IRQ, or abort mode.)

Also bear in mind that svc_entry calls trace_hardirqs_off - is this
appropriate and safe for the FIQ to call?

> +	fiq_handler
> +	mov	r0, sp
> +	ldmib	r0, {r1 - r14}

So this restores r1 to r12, and the SVC mode sp and lr registers.
Nothing touches the SVC SPSR, so we hope that retains its value
throughout the FIQ processing.  Note that the stack pointer at this
point will be above state which we have not yet read, so we better
not take any exceptions from this instruction (not even an imprecise
abort).

> +	msr	cpsr_c, #FIQ_MODE | PSR_I_BIT | PSR_F_BIT

Here we switch to FIQ mode.  What about the PSR_A_BIT which prevents
imprecise aborts on ARMv6+ ?

Nevertheless, I think it's safe because the A bit will be set by the
CPU when taking the FIQ exception, and it should remain set since
cpsr_c won't modify it.

> +	add	r8, r0, #S_PC
> +	ldr	r9, [r0, #S_PSR]
> +	msr	spsr_cxsf, r9

Here we update the FIQ SPSR with the calling mode's CPSR, ready to
return...

> +	ldr	r0, [r0, #S_R0]

Load the calling mode's R0 value.

> +	ldmia	r8, {pc}^

And return (restoring CPSR from SPSR_fiq).

This looks pretty good except for the niggles...

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
