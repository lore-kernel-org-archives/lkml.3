Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbaD2Jmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:42:53 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:43310 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757262AbaD2Jmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:42:51 -0400
Date: Tue, 29 Apr 2014 10:42:11 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH 1/3] arm64: adjust el0_sync so that a function can be
 called
Message-ID: <20140429094211.GC17007@arm.com>
References: <1398627854-9617-1-git-send-email-larry.bassel@linaro.org>
 <1398627854-9617-2-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398627854-9617-2-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 08:44:12PM +0100, Larry Bassel wrote:
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index 39ac630..eda7755 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
[...]
> @@ -421,28 +421,30 @@ el0_da:
>  	/*
>  	 * Data abort handling
>  	 */
> -	mrs	x0, far_el1
> -	bic	x0, x0, #(0xff << 56)
>  	disable_step x1
>  	isb
>  	enable_dbg
>  	// enable interrupts before calling the main handler
>  	enable_irq
> +	mrs	x0, far_el1
> +	bic	x0, x0, #(0xff << 56)
>  	mov	x1, x25
>  	mov	x2, sp
> +	adr	lr, ret_from_exception
>  	b	do_mem_abort

Reading the far_el1 after enable_dbg and enable_irq is racy, we can no
longer guarantee its value in the original data abort context.

>  el0_ia:
>  	/*
>  	 * Instruction abort handling
>  	 */
> -	mrs	x0, far_el1
>  	disable_step x1
>  	isb
>  	enable_dbg
>  	// enable interrupts before calling the main handler
>  	enable_irq
> +	mrs	x0, far_el1
>  	orr	x1, x25, #1 << 24		// use reserved ISS bit for instruction aborts
>  	mov	x2, sp
> +	adr	lr, ret_from_exception
>  	b	do_mem_abort
>  el0_fpsimd_acc:

Same here.

-- 
Catalin
