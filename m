Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaBIGGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 01:06:04 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37563 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaBIGGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 01:06:00 -0500
Message-ID: <52F719EE.9010304@linux.vnet.ibm.com>
Date: Sun, 09 Feb 2014 11:32:22 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: fengguang.wu@intel.com, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time/cpuidle:Fixup fallout from hrtimer broadcast mode
 inclusion
References: <20140207172924.8248.55002.stgit@preeti> <alpine.DEB.2.02.1402071856420.21991@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402071856420.21991@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020906-3568-0000-0000-000004E95560
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 02/07/2014 11:27 PM, Thomas Gleixner wrote:
> On Fri, 7 Feb 2014, Preeti U Murthy wrote:
> 
>> The broadcast timer registration has to be done only when
>> GENERIC_CLOCKEVENTS_BROADCAST and TICK_ONESHOT config options are enabled.
> 
> Then we should compile that file only when those options are
> enabled. Where is the point to compile that code w/o the registration
> function?

Hmm of course. The delta patch is at the end.

Another concern I have is with regard to the periodic mode of broadcast .
We currently do not support the hrtimer mode of broadcast in periodic mode.
The BROADCAST_ON/OFF calls which take effect in periodic mode has not yet
been modified by this patchset to disable one CPU from going into deep idle,
since we expect the deep idle states to never be chosen by the cpuidle
governor in this mode. Do you think we should bother to modify this piece
of code at all?

On the same note, my understanding is that BROADCAST_ON/OFF takes effect
only in periodic mode, in oneshot mode it is a nop. But why do we expect
the CPUs to avail broadcast in periodic mode when they are not supposed
to be entering deep idle states? Am I missing something here? IOW what
is the point of periodic mode of broadcast? Is it for malfunctioning
local clock devices?

The delta patch below for fixing the compile time errors. This is based on
tip/timers/core branch.


time/cpuidle:Fixup fallout from hrtimer broadcast mode inclusion

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>

The hrtimer mode of broadcast is supported only when
GENERIC_CLOCKEVENTS_BROADCAST and TICK_ONESHOT config options
are enabled. Hence compile in the functions for hrtimer mode
of broadcast only when these options are selected.
Also fix max_delta_ticks value for the pseudo clock device.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
---
 include/linux/clockchips.h           |    1 +
 kernel/time/Makefile                 |    5 ++++-
 kernel/time/tick-broadcast-hrtimer.c |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 20a7183..2e4cb67 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -207,6 +207,7 @@ static inline void clockevents_resume(void) {}
 
 static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
 static inline int tick_check_broadcast_expired(void) { return 0; }
+static inline void tick_setup_hrtimer_broadcast(void) {};
 
 #endif
 
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 06151ef..57a413f 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -3,7 +3,10 @@ obj-y += timeconv.o posix-clock.o alarmtimer.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
-obj-$(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST)	+= tick-broadcast.o tick-broadcast-hrtimer.o
+ifeq ($(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST),y)
+ obj-y						+= tick-broadcast.o
+ obj-$(CONFIG_TICK_ONESHOT)			+= tick-broadcast-hrtimer.o
+endif
 obj-$(CONFIG_GENERIC_SCHED_CLOCK)		+= sched_clock.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-oneshot.o
 obj-$(CONFIG_TICK_ONESHOT)			+= tick-sched.o
diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
index 9242527..eb682d5 100644
--- a/kernel/time/tick-broadcast-hrtimer.c
+++ b/kernel/time/tick-broadcast-hrtimer.c
@@ -82,7 +82,7 @@ static struct clock_event_device ce_broadcast_hrtimer = {
 	.min_delta_ns		= 1,
 	.max_delta_ns		= KTIME_MAX,
 	.min_delta_ticks	= 1,
-	.max_delta_ticks	= KTIME_MAX,
+	.max_delta_ticks	= ULONG_MAX,
 	.mult			= 1,
 	.shift			= 0,
 	.cpumask		= cpu_all_mask,



Thanks

Regards
Preeti U Murthy

> 
>> Also fix max_delta_ticks value for the pseudo clock device.
>>
>> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
>> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> ---
>>
>>  kernel/time/tick-broadcast-hrtimer.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
>> index 5591aaa..bc383ac 100644
>> --- a/kernel/time/tick-broadcast-hrtimer.c
>> +++ b/kernel/time/tick-broadcast-hrtimer.c
>> @@ -81,7 +81,7 @@ static struct clock_event_device ce_broadcast_hrtimer = {
>>  	.min_delta_ns		= 1,
>>  	.max_delta_ns		= KTIME_MAX,
>>  	.min_delta_ticks	= 1,
>> -	.max_delta_ticks	= KTIME_MAX,
>> +	.max_delta_ticks	= ULONG_MAX,
>>  	.mult			= 1,
>>  	.shift			= 0,
>>  	.cpumask		= cpu_all_mask,
>> @@ -102,9 +102,11 @@ static enum hrtimer_restart bc_handler(struct hrtimer *t)
>>  	return HRTIMER_RESTART;
>>  }
>>  
>> +#if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
>>  void tick_setup_hrtimer_broadcast(void)
>>  {
>>  	hrtimer_init(&bctimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
>>  	bctimer.function = bc_handler;
>>  	clockevents_register_device(&ce_broadcast_hrtimer);
>>  }
>> +#endif
>>
>>
> 

