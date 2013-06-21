Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946100Ab3FUVS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:18:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:41551 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945954Ab3FUVS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:18:27 -0400
Date: Fri, 21 Jun 2013 23:18:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCHv3/RESEND 4/4] clocksource: arch_timer: Add support for
 memory mapped timers
In-Reply-To: <1371836361-20574-5-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.DEB.2.02.1306212304480.4013@ionos.tec.linutronix.de>
References: <1371836361-20574-1-git-send-email-sboyd@codeaurora.org> <1371836361-20574-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jun 2013, Stephen Boyd wrote:
>  /*
>   * Architected system timer support.
> @@ -46,13 +73,69 @@ static bool arch_timer_use_virtual = true;
>  static inline void arch_timer_reg_write(int access, int reg, u32 val,
>  					struct clock_event_device *clk)
>  {
> -	arch_timer_reg_write_cp15(access, reg, val);
> +	if (access == ARCH_TIMER_MEM_PHYS_ACCESS) {
> +		struct arch_timer *timer = to_arch_timer(clk);
> +		switch (reg) {
> +		case ARCH_TIMER_REG_CTRL:
> +			writel_relaxed(val, timer->base + CNTP_CTL);
> +			break;
> +		case ARCH_TIMER_REG_TVAL:
> +			writel_relaxed(val, timer->base + CNTP_TVAL);
> +			break;
> +		default:
> +			BUILD_BUG();

So you are relying on the compiler cleverness to identify a caller
which calls that inline with a not supported reg value.

How does that work, when the compiler decides not to inline that?

enum without a default case emits at least a reliable warning.

> +		}
> +	} else if (access == ARCH_TIMER_MEM_VIRT_ACCESS) {
> +		struct arch_timer *timer = to_arch_timer(clk);
> +		switch (reg) {
> +		case ARCH_TIMER_REG_CTRL:
> +			writel_relaxed(val, timer->base + CNTV_CTL);
> +			break;
> +		case ARCH_TIMER_REG_TVAL:
> +			writel_relaxed(val, timer->base + CNTV_TVAL);
> +			break;
> +		default:
> +			BUILD_BUG();
> +		}
> +	} else {
> +		arch_timer_reg_write_cp15(access, reg, val);
> +	}
>  }

Something in my little brain yells: function pointer

You can't be serious about hacking nested if/else/switch constructs
into a hot path.

Why not making your cpu data:

struct arch_timer {
       struct clock_event_device evt;
       ....
       void (*write_ctrl)(val, timer);
       void (*write_tval)(val, timer);
       ....
}

and get rid of all that conditionals?

Thanks,

	tglx
