Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab3FXJKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:10:43 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55716 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab3FXJKk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:10:40 -0400
Message-ID: <51C80D07.2020106@arm.com>
Date: Mon, 24 Jun 2013 10:10:31 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: arch timer: Set the TVAL before timer is enabled
References: <1371846684-23730-1-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1371846684-23730-1-git-send-email-rvaswani@codeaurora.org>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 24 Jun 2013 09:10:35.0689 (UTC) FILETIME=[AFDA9990:01CE70BA]
X-MC-Unique: 113062410103707501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/06/13 21:31, Rohit Vaswani wrote:
> On some hardware, the timer deasserts the interrupt when a
> new TVAL is written only when the enable bit is cleared.
> Hence explicitly disable the timer and then program the
> TVAL followed by enabling the timer.
> If this order is not followed, there are chances that
> you would not receive any timer interrupts.
> This is done as suggested in https://lkml.org/lkml/2012/8/11/39
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  drivers/clocksource/arm_arch_timer.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index a2b2541..05ba0c2 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -103,9 +103,10 @@ static inline void set_next_event(const int access, unsigned long evt)
>  {
>  	unsigned long ctrl;
>  	ctrl = arch_timer_reg_read(access, ARCH_TIMER_REG_CTRL);
> -	ctrl |= ARCH_TIMER_CTRL_ENABLE;
> -	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
> +	ctrl &= ~(ARCH_TIMER_CTRL_ENABLE | ARCH_TIMER_CTRL_IT_MASK);
> +	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
>  	arch_timer_reg_write(access, ARCH_TIMER_REG_TVAL, evt);
> +	ctrl |= ARCH_TIMER_CTRL_ENABLE;
>  	arch_timer_reg_write(access, ARCH_TIMER_REG_CTRL, ctrl);
>  }

Maybe that would deserve a comment in the code so people don't get the
idea it can be reordered to save the extra write?

Other than that, and FWIW:
Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Jazz is not dead. It just smells funny...

