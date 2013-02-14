Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab3BNETW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 23:19:22 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36159 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3BNETV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 23:19:21 -0500
Message-ID: <511C65B3.7060109@ti.com>
Date: Thu, 14 Feb 2013 09:48:59 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <khilman@deeprootsystems.com>
Subject: Re: [PATCH RFC] davinci: poll for sleep completion in resume routine.
References: <1359624393-5898-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1359624393-5898-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manish,

On 1/31/2013 2:56 PM, Vishwanathrao Badarkhe, Manish wrote:
> As per OMAP-L138 TRM, Software must poll for
> SLEEPCOMPLETE bit until it is set to 1 before clearing
> SLEEPENABLE bit in DEEPSLEEP register in resume routine.
> Modifications are as per datasheet:
> http://www.ti.com/lit/ug/spruh77a/spruh77a.pdf
> See sections 10.10.2.2 and 11.5.21 for more detailed
> explanation.

Polling for SLEEPCOMPLETE is not required in RTC controlled wake-up
which is the mode currently supported (see section 10.10.2.1 of the
TRM). Polling for SLEEPCOMPLETE is required for external controlled
wake-up which to my knowledge has never been tested. If you have tested
this with external controlled wakep-up, then I can consider this patch.
Else, I would like to take it only after externally controlled wake-up
is fully tested/supported instead of taking bits and pieces.

Thanks,
Sekhar

> 
> Tested on da850-evm.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>
> ---
> :100644 100644 d4e9316... 976f096... M	arch/arm/mach-davinci/sleep.S
>  arch/arm/mach-davinci/sleep.S |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/sleep.S b/arch/arm/mach-davinci/sleep.S
> index d4e9316..976f096 100644
> --- a/arch/arm/mach-davinci/sleep.S
> +++ b/arch/arm/mach-davinci/sleep.S
> @@ -35,6 +35,7 @@
>  #define PLL_LOCK_CYCLES		(PLL_LOCK_TIME * 25)
>  
>  #define DEEPSLEEP_SLEEPENABLE_BIT	BIT(31)
> +#define DEEPSLEEP_SLEEPCOMPLETE_BIT 	BIT(30)
>  
>  	.text
>  /*
> @@ -110,6 +111,13 @@ ENTRY(davinci_cpu_suspend)
>  
>  	/* Wake up from sleep */
>  
> +	/* wait for sleep complete */
> +sleep_complete:
> +	ldr 	ip, [r4]
> +	and 	ip, ip, #DEEPSLEEP_SLEEPCOMPLETE_BIT
> +	cmp 	ip, #DEEPSLEEP_SLEEPCOMPLETE_BIT
> +	bne 	sleep_complete
> +
>  	/* Clear sleep enable */
>  	ldr	ip, [r4]
>  	bic	ip, ip, #DEEPSLEEP_SLEEPENABLE_BIT
> 
