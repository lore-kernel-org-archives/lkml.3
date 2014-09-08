Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaIHPtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:49:46 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:44422 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaIHPto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:49:44 -0400
Date: Mon, 8 Sep 2014 11:49:39 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 3/5] arm: fiq: Replace default FIQ handler
In-Reply-To: <1410190115-32604-4-git-send-email-daniel.thompson@linaro.org>
Message-ID: <alpine.LFD.2.11.1409081140360.16533@knanqh.ubzr>
References: <1409931198-22600-1-git-send-email-daniel.thompson@linaro.org> <1410190115-32604-1-git-send-email-daniel.thompson@linaro.org> <1410190115-32604-4-git-send-email-daniel.thompson@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014, Daniel Thompson wrote:

> +@
> +@ Taking a FIQ in abort mode is similar to taking a FIQ in SVC mode
> +@ and reuses the same macros. However in abort mode we must also
> +@ save/restore lr_abt and spsr_abt to make nested aborts safe.
> +@
> +	.align 5
> +__fiq_abt:
> +	svc_entry 0, 0
> +
> + ARM(	msr	cpsr_c, #ABT_MODE | PSR_I_BIT | PSR_F_BIT )
> + THUMB( mov	r0, #ABT_MODE | PSR_I_BIT | PSR_F_BIT )
> + THUMB( msr	cpsr_c, r0 )
> +	mov	r1, lr		@ Save lr_abt
> +	mrs	r2, spsr	@ Save spsr_abt, abort is now safe
> + ARM(	msr	cpsr_c, #SVC_MODE | PSR_I_BIT | PSR_F_BIT )
> + THUMB( mov	r0, #SVC_MODE | PSR_I_BIT | PSR_F_BIT )
> + THUMB( msr	cpsr_c, r0 )
> +	push	{r1 - r2}

	stmfd sp!, {r1 - r2}

> +
> +	sub	r0, sp, #8			@ struct pt_regs *regs
> +	bl	handle_fiq_as_nmi
> +
> +	pop	{r1 - r2}

	ldmfd sp!, {r1 - r2}

... so that old binutils we still accept to compile the kernel (in ARM 
mode) are happy.

Otherwise...

Acked-by: Nicolas Pitre <nico@linaro.org>


Nicolas
