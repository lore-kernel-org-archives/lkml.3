Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaEVUX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:23:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58407 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaEVUX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:23:57 -0400
Message-ID: <537E5CD9.80501@codeaurora.org>
Date: Thu, 22 May 2014 16:23:53 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Larry Bassel <larry.bassel@linaro.org>
CC: catalin.marinas@arm.com, will.deacon@arm.com, khilman@linaro.org,
        linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/2] arm64: adjust el0_sync so that a function can
 be called
References: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org> <1400786855-32656-2-git-send-email-larry.bassel@linaro.org>
In-Reply-To: <1400786855-32656-2-git-send-email-larry.bassel@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Larry,

On 05/22/2014 03:27 PM, Larry Bassel wrote:
> To implement the context tracker properly on arm64,
> a function call needs to be made after debugging and
> interrupts are turned on, but before the lr is changed
> to point to ret_to_user(). If the function call
> is made after the lr is changed the function will not
> return to the correct place.
> 
> For similar reasons, defer the setting of x0 so that
> it doesn't need to be saved around the function call
> (save far_el1 in x26 temporarily instead).
> 
> Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
> ---
>  arch/arm64/kernel/entry.S | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index e8b23a3..20b336e 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -354,7 +354,6 @@ el0_sync:
>  	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
>  	cmp	x24, #ESR_EL1_EC_SVC64		// SVC in 64-bit state
>  	b.eq	el0_svc
> -	adr	lr, ret_to_user
>  	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
>  	b.eq	el0_da
>  	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
> @@ -383,7 +382,6 @@ el0_sync_compat:
>  	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
>  	cmp	x24, #ESR_EL1_EC_SVC32		// SVC in 32-bit state
>  	b.eq	el0_svc_compat
> -	adr	lr, ret_to_user
>  	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
>  	b.eq	el0_da
>  	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
> @@ -426,22 +424,26 @@ el0_da:
>  	/*
>  	 * Data abort handling
>  	 */
> -	mrs	x0, far_el1
> -	bic	x0, x0, #(0xff << 56)
> +	mrs	x26, far_el1
>  	// enable interrupts before calling the main handler
>  	enable_dbg_and_irq
> +	mov	x0, x26
> +	bic	x0, x0, #(0xff << 56)

Nit: I believe you can bit clear with x26 as the source register and omit the
move instruction.

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
