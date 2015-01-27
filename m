Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbbA0KYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:24:37 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:58347 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbbA0KYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:24:33 -0500
Message-ID: <54C7675D.8000204@cogentembedded.com>
Date: Tue, 27 Jan 2015 13:24:29 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wenyou Yang <wenyou.yang@atmel.com>, nicolas.ferre@atmel.com,
        linux@arm.linux.org.uk
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, sylvain.rochet@finsecur.com,
        peda@axentia.se, linux@maxim.org.za
Subject: Re: [PATCH v3 03/13] pm: at91: Workaround DDRSDRC self-refresh bug
 with LPDDR1 memories.
References: <1422337810-3257-1-git-send-email-wenyou.yang@atmel.com> <1422338006-3371-1-git-send-email-wenyou.yang@atmel.com>
In-Reply-To: <1422338006-3371-1-git-send-email-wenyou.yang@atmel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/27/2015 8:53 AM, Wenyou Yang wrote:

> From: Peter Rosin <peda@axentia.se>

> The DDRSDR controller fails miserably to put LPDDR1 memories in
> self-refresh. Force the controller to think it has DDR2 memories
> during the self-refresh period, as the DDR2 self-refresh spec is
> equivalent to LPDDR1, and is correctly implemented in the
> controller.

> Assume that the second controller has the same fault, but that is
> untested.

> Signed-off-by: Peter Rosin <peda@axentia.se>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>   arch/arm/mach-at91/pm_slowclock.S  |   43 +++++++++++++++++++++++++++++++-----
>   include/soc/at91/at91sam9_ddrsdr.h |    2 +-
>   2 files changed, 39 insertions(+), 6 deletions(-)

> diff --git a/arch/arm/mach-at91/pm_slowclock.S b/arch/arm/mach-at91/pm_slowclock.S
> index e2bfaf5..1155217 100644
> --- a/arch/arm/mach-at91/pm_slowclock.S
> +++ b/arch/arm/mach-at91/pm_slowclock.S
[...]
> @@ -108,14 +118,26 @@ ddr_sr_enable:
>
>   	/* figure out if we use the second ram controller */
>   	cmp	ramc1, #0
> -	ldrne	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
> -	strne	tmp2, .saved_sam9_lpr1
> -	bicne	tmp2, #AT91_DDRSDRC_LPCB
> -	orrne	tmp2, #AT91_DDRSDRC_LPCB_SELF_REFRESH
> +	beq	ddr_no_2nd_ctrl
> +
> +	ldr	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> +	str	tmp2, .saved_sam9_mdr1
> +	bic	tmp2, tmp2, #~AT91_DDRSDRC_MD
> +	cmp	tmp2, #AT91_DDRSDRC_MD_LOW_POWER_DDR
> +	ldreq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> +	biceq	tmp2, tmp2, #AT91_DDRSDRC_MD

    Didn't you forget ~? Either that, or ~ above is not needed, I think.

> +	orreq	tmp2, tmp2, #AT91_DDRSDRC_MD_DDR2
> +	streq	tmp2, [ramc1, #AT91_DDRSDRC_MDR]
> +
> +	ldr	tmp2, [ramc1, #AT91_DDRSDRC_LPR]
> +	str	tmp2, .saved_sam9_lpr1
> +	bic	tmp2, #AT91_DDRSDRC_LPCB

    Didn't you forget ~? And isn't it 3-operand instruction (as seen in the 
above code)?

> +	orr	tmp2, #AT91_DDRSDRC_LPCB_SELF_REFRESH

    Only 2 operands?

[...]

WBR, Sergei

