Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab3CSGiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 02:38:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38349 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938Ab3CSGh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 02:37:58 -0400
Message-ID: <5148082A.3060503@ti.com>
Date: Tue, 19 Mar 2013 12:09:38 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Will Deacon <will@willdeacon.co.uk>, Lokesh Vutla <lokeshvutla@ti.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if system
 supports 'has_ossr'
References: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com> <51406BA7.8010306@arm.com> <51407120.7030709@ti.com> <51417E58.5050501@ti.com> <20130315050014.GA15706@tiny-lites> <5146B972.1010002@ti.com> <20130318150724.GC28585@mudshark.cambridge.arm.com> <514736D4.4070906@ti.com> <20130318170649.GA29585@mudshark.cambridge.arm.com>
In-Reply-To: <20130318170649.GA29585@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 March 2013 10:36 PM, Will Deacon wrote:
> On Mon, Mar 18, 2013 at 03:46:28PM +0000, Santosh Shilimkar wrote:
>> On Monday 18 March 2013 08:37 PM, Will Deacon wrote:
>>> That really sucks :( Does this affect all OMAP-based boards?
>>>
>> All OMAP4 based boards..
> 
> Brilliant. Is there any way that the secure code can be fixed in future
> products?
> 
Nope. This can only be done with new silicon rev for GP devices which is
not going to happen. For secure devices, some secure patching is possible
but these are not development devices, so not much point.

>>>> +	/* Check if we have access to CPU debug features */
>>>> +	ARM_DBG_READ(c7, c14, 6, val);
>>>> +	if ((val & 0x1) == 0) {
>>>> +		pr_warn_once("CPU %d debug is unavailable\n", cpu);
>>>> +		cpumask_or(&debug_err_mask, &debug_err_mask, cpumask_of(cpu));
>>>> +		return;
>>>> +	}
>>>
>>> There are a few of problems here:
>>>
>>> 	1. That is only checking for non-secure access, which precludes
>>> 	   running Linux in secure mode.
>>>
>> We can check bit 4 as well to take care linux running in secure mode.
> 
> It still doesn't help unless we know whether Linux is running secure or
> non-secure.
> 
ok.

>>> 	2. DBGAUTHSTATUS accesses are UNPREDICTABLE when the double-lock is
>>> 	   set for v7.1 processors.
>>>
>>> 	3. DBGAUTHSTATUS doesn't exist in ARMv6.
>>>
>> We cans skip the code for these versions like...
>> 	if (!ARM_DEBUG_ARCH_V7_ECP14 == get_debug_arch())
>> 		goto skip_dbgsts_read;
> 
> Sure, I was just pointing out that the code needs fixing for this.
> 
>>> 	4. CPUs without the security extensions have DBGAUTHSTATUS.NSE == 0
>>>
>> Which bit is that ? I don't find this bit in Cortex-A9 docs. With all
>> these checks, may be a separate function like 'is_debug_available()'
>> would be better.
> 
> NSE is bit 0 (the one you're checking).
> 
ok. So the subject patch might break those devices.

>>  
>>> 	5. Accessing DBGAUTHSTATUS requires DBGEN to be driven high.
>>> 	   Assuming that your pr_warn_once is emitted, this implies that
>>> 	   DBGEN is driven high from cold boot, yet the NSE bit is low,
>>> 	   implying that DBGEN is also low. That's contradictory, so I have
>>> 	   no idea what's going on...
>>>
>> Me neither. The warning is emitted at least.
> 
> Any chance you could follow up with your firmware/hardware guys about this
> please? I'd really like to understand how we end up in this state in case we
> can do something in the architecture to stop it from happening in future.
> 
I will check on this part and update you when I hear from them.

>>> Apart from that, it's fine!
>>>
>> If you agree, I can update patch accordingly.
>> BTW, do you have any better trick to take care of
>> above scenraio ?
> 
> Well, we could just add the warn_once prints but that doesn't stop debug
> from breaking after the first pm/suspend/hotplug operation.
> 
Probably we should drop the $subject patch approach and use warn_once
at least for current rc. Ofcourse it doesn't help to get working
hw_breakpoint support. Patch end of the email with warn_once.

Regards,
Santosh

>From 6611d48eb5571e3e094c7a9c2479e652b37d35e3 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Tue, 19 Mar 2013 11:53:41 +0530
Subject: [PATCH] ARM: hw_breakpoints: Use warn_once to avoid debug message
 flood from reset_ctrl_regs()

CPU debug features like hardware break, watchpoints can be used only when
the debug mode is enabled and available. Unfortunately on OMAP4 based device,
after a CPU power cycle, the debug feature gets disabled which leads to
a flood of messages coming from reset_ctrl_regs() which gets called on
every CPU_PM_EXIT with CPUidle enabled.

So make use of warn_once() so that system is usable.

Thanks to Will for pointers and Lokesh for the analysis of the issue.

Cc: Will Deacon <Will.Deacon@arm.com>

Tested-by: Lokesh Vutla <lokeshvutla@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/kernel/hw_breakpoint.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 96093b7..5dc1aa6 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -966,7 +966,7 @@ static void reset_ctrl_regs(void *unused)
 	}
 
 	if (err) {
-		pr_warning("CPU %d debug is powered down!\n", cpu);
+		pr_warn_once("CPU %d debug is powered down!\n", cpu);
 		cpumask_or(&debug_err_mask, &debug_err_mask, cpumask_of(cpu));
 		return;
 	}
@@ -987,7 +987,7 @@ clear_vcr:
 	isb();
 
 	if (cpumask_intersects(&debug_err_mask, cpumask_of(cpu))) {
-		pr_warning("CPU %d failed to disable vector catch\n", cpu);
+		pr_warn_once("CPU %d failed to disable vector catch\n", cpu);
 		return;
 	}
 
@@ -1007,7 +1007,7 @@ clear_vcr:
 	}
 
 	if (cpumask_intersects(&debug_err_mask, cpumask_of(cpu))) {
-		pr_warning("CPU %d failed to clear debug register pairs\n", cpu);
+		pr_warn_once("CPU %d failed to clear debug register pairs\n", cpu);
 		return;
 	}
 
-- 
1.7.9.5

