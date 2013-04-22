Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab3DVPfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 11:35:44 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58661 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3DVPfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:35:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,527,1363158000"; 
   d="scan'208";a="40337486"
Message-ID: <517558CE.7090602@codeaurora.org>
Date: Mon, 22 Apr 2013 08:35:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        "arm@kernel.org" <arm@kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/4] ARM: sched_clock: Add support for >32 bit sched_clock
References: <1366417746-24990-1-git-send-email-sboyd@codeaurora.org> <1366417746-24990-4-git-send-email-sboyd@codeaurora.org> <20130422104858.GB2572@mudshark.cambridge.arm.com>
In-Reply-To: <20130422104858.GB2572@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/13 03:48, Will Deacon wrote:
> Hi Stephen,
>
> On Sat, Apr 20, 2013 at 01:29:05AM +0100, Stephen Boyd wrote:
>> The arm architected system counter has at least 56 bits of
>> useable bits. Add support to ARM's sched_clock implementation for
>> counters with more than 32 bits so we can avoid the complexity of
>> dealing with wraparound on these devices while benefiting from
>> the irqtime accounting and suspend/resume handling that the ARM
>> sched_clock code already has.
>>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>>
>> Maybe we need a union for the epoch_ns usage?
>>
>>  arch/arm/include/asm/sched_clock.h |   2 +
>>  arch/arm/kernel/sched_clock.c      | 101 +++++++++++++++++++++++++++----------
>>  2 files changed, 77 insertions(+), 26 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/sched_clock.h b/arch/arm/include/asm/sched_clock.h
>> index 3d520dd..7fcd2ee 100644
>> --- a/arch/arm/include/asm/sched_clock.h
>> +++ b/arch/arm/include/asm/sched_clock.h
>> @@ -13,4 +13,6 @@ extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
>>  
>>  extern unsigned long long (*sched_clock_func)(void);
>>  
>> +extern void setup_sched_clock_64(u64 (*read)(void), int bits,
>> +				 unsigned long rate);
> Curious, but why do we need two setup_sched_clock functions, where the bits
> are passed as a parameter? Can't we just do the right thing if the clock
> claims to be more than 32 bits wide (and get rid of the BUG_ONs at the same
> time)?

This is to avoid having to change a bunch of code that is using
setup_sched_clock() already where their read function returns a u32
instead of a u64. I suppose we could make the 64 bit version fall back
to the 32 bit version if the bits aren't large enough and provide some
sort of u32 wrapper function around the u64 callback. It may also be
useful if we can determine that the timer wraps too quickly even when
there are more than 32 bits.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

