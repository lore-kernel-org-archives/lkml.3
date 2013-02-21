Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3BUGSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 01:18:34 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40967 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab3BUGSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 01:18:33 -0500
Message-ID: <5125BC7C.7080007@ti.com>
Date: Thu, 21 Feb 2013 11:49:40 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linaro-dev >> Lists Linaro-dev" <linaro-dev@lists.linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [resend] Timer broadcast question
References: <5123BE35.8070902@linaro.org> <alpine.LFD.2.02.1302191904560.22263@ionos> <5123C299.3080005@linaro.org>
In-Reply-To: <5123C299.3080005@linaro.org>
Content-Type: multipart/mixed;
	boundary="------------010603040003030705030008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------010603040003030705030008
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

On Tuesday 19 February 2013 11:51 PM, Daniel Lezcano wrote:
> On 02/19/2013 07:10 PM, Thomas Gleixner wrote:
>> On Tue, 19 Feb 2013, Daniel Lezcano wrote:
>>> I am working on identifying the different wakeup sources from the
>>> interrupts and I have a question regarding the timer broadcast.
>>>
>>> The broadcast timer is setup to the next event and that will wake up any
>>> idle cpu belonging to the "broadcast cpumask", right ?
>>>
>>> The cpu which has been woken up will look for each cpu the next-event
>>> and send an IPI to wake it up.
>>>
>>> Although, it is possible the sender of this IPI may not be concerned by
>>> the timer expiration and has been woken up just for sending the IPI, right ?
>>
>> Correct.
>>
>>> If this is correct, is it possible to setup the timer irq affinity to a
>>> cpu which will be concerned by the timer expiration ? so we prevent an
>>> unnecessary wake up for a cpu.
>>
>> It is possible, but we never implemented it.
>>
>> If we go there, we want to make that conditional on a property flag,
>> because some interrupt controllers especially on x86 only allow to
>> move the affinity from interrupt context, which is pointless.
>
> Thanks Thomas for your quick answer. I will write a RFC patchset.
>
Last year I implemented the affinity hook for broad-cast code and
experimented with it. Since the system I was using was dual core,
it wasn't much beneficial and hence gave up later. I did remember
discussing the approach with few folks in the conference.

Patch in the end of the email (also attached) for generic broadcast
code. I didn't look at all corner case though. In arch code then
you need to setup "broadcast_affinity" hook which should be able
to get handle of the arch irqchip and call the respective affinity
handler. Just 3 lines function should do the trick.

As Thomas said, effectiveness of such optimization solely depends
on how well the affinity (in low powers) supported by your IRQ chip.

Hope this is helpful for you.

Regards,
Santosh


 From d70f2d48ec08a3f1d73187c49b16e4e60f81a50c Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Wed, 25 Jul 2012 03:42:33 +0530
Subject: [PATCH] tick-broadcast: Add tick road-cast affinity suport

Current tick broad-cast code has affinity set to the boot CPU and hence
the boot CPU will always wakeup from low power states when broad cast timer
is armed even if the next expiry event doesn't belong to it.

Patch adds broadcast affinity functionality to avoid above and let the
tick framework set the affinity of the event for the CPU it belongs.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
  include/linux/clockchips.h   |    2 ++
  kernel/time/tick-broadcast.c |   13 ++++++++++++-
  2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 8a7096f..5488cdc 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -95,6 +95,8 @@ struct clock_event_device {
  	unsigned long		retries;

  	void			(*broadcast)(const struct cpumask *mask);
+	void			(*broadcast_affinity)
+					(const struct cpumask *mask, int irq);
  	void			(*set_mode)(enum clock_event_mode mode,
  					    struct clock_event_device *);
  	void			(*suspend)(struct clock_event_device *);
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..2ec2425 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -39,6 +39,8 @@ static void tick_broadcast_clear_oneshot(int cpu);
  static inline void tick_broadcast_clear_oneshot(int cpu) { }
  #endif

+static inline void dummy_broadcast_affinity(const struct cpumask *mask,
+							int irq) { }
  /*
   * Debugging: see timer_list.c
   */
@@ -485,14 +487,19 @@ void tick_broadcast_oneshot_control(unsigned long 
reason)
  		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
  			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
  			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
-			if (dev->next_event.tv64 < bc->next_event.tv64)
+			if (dev->next_event.tv64 < bc->next_event.tv64) {
  				tick_broadcast_set_event(dev->next_event, 1);
+				bc->broadcast_affinity(
+				tick_get_broadcast_oneshot_mask(), bc->irq);
+			}
  		}
  	} else {
  		if (cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
  			cpumask_clear_cpu(cpu,
  					  tick_get_broadcast_oneshot_mask());
  			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+			bc->broadcast_affinity(
+				tick_get_broadcast_oneshot_mask(), bc->irq);
  			if (dev->next_event.tv64 != KTIME_MAX)
  				tick_program_event(dev->next_event, 1);
  		}
@@ -536,6 +543,10 @@ void tick_broadcast_setup_oneshot(struct 
clock_event_device *bc)

  		bc->event_handler = tick_handle_oneshot_broadcast;

+		/* setup dummy broadcast affinity handler if not provided */
+		if (bc->broadcast_affinity)
+			bc->broadcast_affinity = dummy_broadcast_affinity;
+
  		/* Take the do_timer update */
  		tick_do_timer_cpu = cpu;

-- 
1.7.9.5



--------------010603040003030705030008
Content-Type: text/x-patch;
	name="0001-tick-broadcast-Add-tick-road-cast-affinity-suport.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-tick-broadcast-Add-tick-road-cast-affinity-suport.patch"

>From d70f2d48ec08a3f1d73187c49b16e4e60f81a50c Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Wed, 25 Jul 2012 03:42:33 +0530
Subject: [PATCH] tick-broadcast: Add tick road-cast affinity suport

Current tick broad-cast code has affinity set to the boot CPU and hence
the boot CPU will always wakeup from low power states when broad cast timer
is armed even if the next expiry event doesn't belong to it.

Patch adds broadcast affinity functionality to avoid above and let the
tick framework set the affinity of the event for the CPU it belongs.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 include/linux/clockchips.h   |    2 ++
 kernel/time/tick-broadcast.c |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 8a7096f..5488cdc 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -95,6 +95,8 @@ struct clock_event_device {
 	unsigned long		retries;
 
 	void			(*broadcast)(const struct cpumask *mask);
+	void			(*broadcast_affinity)
+					(const struct cpumask *mask, int irq);
 	void			(*set_mode)(enum clock_event_mode mode,
 					    struct clock_event_device *);
 	void			(*suspend)(struct clock_event_device *);
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f113755..2ec2425 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -39,6 +39,8 @@ static void tick_broadcast_clear_oneshot(int cpu);
 static inline void tick_broadcast_clear_oneshot(int cpu) { }
 #endif
 
+static inline void dummy_broadcast_affinity(const struct cpumask *mask,
+							int irq) { }
 /*
  * Debugging: see timer_list.c
  */
@@ -485,14 +487,19 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 		if (!cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
 			cpumask_set_cpu(cpu, tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
-			if (dev->next_event.tv64 < bc->next_event.tv64)
+			if (dev->next_event.tv64 < bc->next_event.tv64) {
 				tick_broadcast_set_event(dev->next_event, 1);
+				bc->broadcast_affinity(
+				tick_get_broadcast_oneshot_mask(), bc->irq);
+			}
 		}
 	} else {
 		if (cpumask_test_cpu(cpu, tick_get_broadcast_oneshot_mask())) {
 			cpumask_clear_cpu(cpu,
 					  tick_get_broadcast_oneshot_mask());
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
+			bc->broadcast_affinity(
+				tick_get_broadcast_oneshot_mask(), bc->irq);
 			if (dev->next_event.tv64 != KTIME_MAX)
 				tick_program_event(dev->next_event, 1);
 		}
@@ -536,6 +543,10 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 
+		/* setup dummy broadcast affinity handler if not provided */
+		if (bc->broadcast_affinity)
+			bc->broadcast_affinity = dummy_broadcast_affinity;
+
 		/* Take the do_timer update */
 		tick_do_timer_cpu = cpu;
 
-- 
1.7.9.5


--------------010603040003030705030008--
