Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab3A2NBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:01:25 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34381 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364Ab3A2NBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:01:22 -0500
Date: Tue, 29 Jan 2013 13:01:12 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Keun-O Park <kpark3469@gmail.com>
Cc: rostedt@goodmis.org, sahara <keun-o.park@windriver.com>,
        linux@arm.linux.org.uk, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: fix returning wrong CALLER_ADDRx
Message-ID: <20130129130039.GA3817@linaro.org>
References: <1357888690-24012-1-git-send-email-kpark3469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357888690-24012-1-git-send-email-kpark3469@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 04:18:10PM +0900, Keun-O Park wrote:
> From: sahara <keun-o.park@windriver.com>
> 
> This makes return_address return correct value for ftrace feature.
> unwind_frame does not update frame->lr but frame->pc for backtrace.
> And, the initialization for data.addr was missing so that wrong value
> returned when unwind_frame failed.
> 
> Signed-off-by: sahara <keun-o.park@windriver.com>

Reviewed-by: Dave Martin <dave.martin@linaro.org>

This is the same as a patch I previously posted:
http://lists.infradead.org/pipermail/linux-arm-kernel/2012-November/129381.html

...except for the initialisation of data.addr to NULL, which is needed
in order to prevent a garbage pointer being returned in the case where
the unwinder fails to unwind a frame before the required level
is reached.

Cheers
---Dave

> ---
>  arch/arm/kernel/return_address.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/kernel/return_address.c b/arch/arm/kernel/return_address.c
> index 8085417..fafedd8 100644
> --- a/arch/arm/kernel/return_address.c
> +++ b/arch/arm/kernel/return_address.c
> @@ -26,7 +26,7 @@ static int save_return_addr(struct stackframe *frame, void *d)
>  	struct return_address_data *data = d;
>  
>  	if (!data->level) {
> -		data->addr = (void *)frame->lr;
> +		data->addr = (void *)frame->pc;
>  
>  		return 1;
>  	} else {
> @@ -41,7 +41,8 @@ void *return_address(unsigned int level)
>  	struct stackframe frame;
>  	register unsigned long current_sp asm ("sp");
>  
> -	data.level = level + 1;
> +	data.level = level + 2;
> +	data.addr = NULL;
>  
>  	frame.fp = (unsigned long)__builtin_frame_address(0);
>  	frame.sp = current_sp;
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
