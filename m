Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3EUGOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:14:03 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:42751 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754369Ab3EUGOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:14:00 -0400
To: Chen Gang <gang.chen@asianux.com>
Subject: Re: [PATCH] arm64: kernel: compiling issue, need =?UTF-8?Q?=27EXPORT=5FSY?=
 =?UTF-8?Q?MBOL=5FGPL=28read=5Fcurrent=5Ftimer=29=27?=
X-PHP-Originating-Script: 0:func.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 21 May 2013 08:13:54 +0200
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>
Organization: ARM Ltd
In-Reply-To: <519AF2DC.2040200@asianux.com>
References: <5199C725.8050102@asianux.com> <168084c28e8ba5124c05553e97463172@localhost> <20130520095606.GH31359@mudshark.cambridge.arm.com> <519AF2DC.2040200@asianux.com>
Message-ID: <5bf8a8dd20ecd01c14f0ed9aa054f2df@localhost>
User-Agent: RoundCube Webmail/0.3.1
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: gang.chen@asianux.com, will.deacon@arm.com, Catalin.Marinas@arm.com, linux-kernel@vger.kernel.org, tony@atomide.com, santosh.shilimkar@ti.com, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013 12:06:52 +0800, Chen Gang <gang.chen@asianux.com>
wrote:
> On 05/20/2013 05:56 PM, Will Deacon wrote:
>> On Mon, May 20, 2013 at 08:15:04AM +0100, Marc Zyngier wrote:
>>> On Mon, 20 May 2013 14:48:05 +0800, Chen Gang <gang.chen@asianux.com>
>>> wrote:
>>>> Need 'EXPORT_SYMBOL_GPL(read_current_timer)' if build with
>>>> allmodconfig.
>>>>
>>>> The related error:
>>>>   ERROR: "read_current_timer" [lib/rbtree_test.ko] undefined!
>>>>   ERROR: "read_current_timer" [lib/interval_tree_test.ko] undefined!
>>>>   ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
>>>>   ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
>>>>
>>>>
>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>> ---
>>>>  arch/arm64/kernel/time.c |    1 +
>>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
>>>> index a551f88..7fcba80 100644
>>>> --- a/arch/arm64/kernel/time.c
>>>> +++ b/arch/arm64/kernel/time.c
>>>> @@ -73,6 +73,7 @@ int read_current_timer(unsigned long *timer_value)
>>>>  	*timer_value = arch_timer_read_counter();
>>>>  	return 0;
>>>>  }
>>>> +EXPORT_SYMBOL_GPL(read_current_timer);
>>>>  
>>>>  void __init time_init(void)
>>>>  {
>>>
>>> While this solves the problem, I'm not sure this is the best fix. The
>>> real
>>> issue is with get_cycles, which is a macro around read_current_timer.
>>>
>>> AArch32 exports it because of the number of timer implementations. On
>>> arm64, we should be able to just return CNTVCT_EL0.
>>>
>>> Catalin, Will, what do you think?
>> 
>> Should be ok once the arch timer driver has moved exclusively to
virtual
>> time. I'm also not sure we even need to implement read_current_timer()
--
>> it's only used for delay-loop calibration, which we don't need for the
>> arch timer.
>> 
> 
> For whether we need implement read_current_timer():
> 
>   many platforms have implemented it (openrisc, arm, sparc, hexagon,
>   avr32, x86).
>   it is called by init/calibrate.c when 'ARCH_HAS_READ_CURRENT_TIMER' is
>   defined.
>   since arm64 can implement it, better to provide it as an architect
>   features to let outside use.

Nobody disputes the interest of read_current_timer.

> For the implementation of read_current_timer():
> 
>   it has to face various configurations
>     (e.g. CONFIG_ARM_ARCH_TIMER, arch_timer_read_zero,
>     arch_counter_get_cntvct, arch_counter_get_cntpct)
>   so better still use variable instead of.
>     (excuse me, I do not know what is 'CNTVCT_EL0', is it like a
constant
>     number ?)

Architected timer is mandatory on arm64, so we can always rely on it it be
present. CNTVCT_EL0 is the system register accessing the Virtual Counter,
which is basically what read_current_timer() returns.

> For the implementation of get_cycles()
> 
>   if read_current_timer() is provided,
>   better to let get_cycles() to call it, instead of implement once
again.

There is certainly some value in reusing existing code, but in this
particular case we can simply inline two instructions (isb + mrs
cntvct_el0), and I'm not even completely sure about the isb.

        M.
-- 
Fast, cheap, reliable. Pick two.
