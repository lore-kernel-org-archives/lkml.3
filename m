Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946258Ab3FUXB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 19:01:27 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41046 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946172Ab3FUXBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 19:01:25 -0400
Message-ID: <51C4DB44.7030909@codeaurora.org>
Date: Fri, 21 Jun 2013 16:01:24 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        John Stultz <john.stultz@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCHv3/RESEND 4/4] clocksource: arch_timer: Add support for
 memory mapped timers
References: <1371836361-20574-1-git-send-email-sboyd@codeaurora.org> <1371836361-20574-5-git-send-email-sboyd@codeaurora.org> <alpine.DEB.2.02.1306212304480.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1306212304480.4013@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/13 14:18, Thomas Gleixner wrote:
> On Fri, 21 Jun 2013, Stephen Boyd wrote:
>>  /*
>>   * Architected system timer support.
>> @@ -46,13 +73,69 @@ static bool arch_timer_use_virtual = true;
>>  static inline void arch_timer_reg_write(int access, int reg, u32 val,
>>  					struct clock_event_device *clk)
>>  {
>> -	arch_timer_reg_write_cp15(access, reg, val);
>> +	if (access == ARCH_TIMER_MEM_PHYS_ACCESS) {
>> +		struct arch_timer *timer = to_arch_timer(clk);
>> +		switch (reg) {
>> +		case ARCH_TIMER_REG_CTRL:
>> +			writel_relaxed(val, timer->base + CNTP_CTL);
>> +			break;
>> +		case ARCH_TIMER_REG_TVAL:
>> +			writel_relaxed(val, timer->base + CNTP_TVAL);
>> +			break;
>> +		default:
>> +			BUILD_BUG();
> So you are relying on the compiler cleverness to identify a caller
> which calls that inline with a not supported reg value.
>
> How does that work, when the compiler decides not to inline that?
>
> enum without a default case emits at least a reliable warning.

Right now arm and arm64 don't allow inline to be anything besides
always_inline so the compiler is forced to inline. But point taken, I'll
remove the BUILD_BUG and make the register argument into an enum (which
it isn't right now).

>
>> +		}
>> +	} else if (access == ARCH_TIMER_MEM_VIRT_ACCESS) {
>> +		struct arch_timer *timer = to_arch_timer(clk);
>> +		switch (reg) {
>> +		case ARCH_TIMER_REG_CTRL:
>> +			writel_relaxed(val, timer->base + CNTV_CTL);
>> +			break;
>> +		case ARCH_TIMER_REG_TVAL:
>> +			writel_relaxed(val, timer->base + CNTV_TVAL);
>> +			break;
>> +		default:
>> +			BUILD_BUG();
>> +		}
>> +	} else {
>> +		arch_timer_reg_write_cp15(access, reg, val);
>> +	}
>>  }
> Something in my little brain yells: function pointer
>
> You can't be serious about hacking nested if/else/switch constructs
> into a hot path.
>
> Why not making your cpu data:
>
> struct arch_timer {
>        struct clock_event_device evt;
>        ....
>        void (*write_ctrl)(val, timer);
>        void (*write_tval)(val, timer);
>        ....
> }
>
> and get rid of all that conditionals?

It sounds like that's undesirable according to the comment above
arch_timer_reg_write(). It seems that all this code was written under
the assumption that the compiler is good enough to optimize all the code
paths and only generate the code that is necessary. So far this seems to
be working and the hotpath is optimized for each type of access.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

