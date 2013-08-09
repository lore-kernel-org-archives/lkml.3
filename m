Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967738Ab3HIKqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:46:51 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:55224 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967440Ab3HIKqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:46:47 -0400
Message-ID: <5204C54A.9020105@st.com>
Date: Fri, 09 Aug 2013 11:32:42 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <51F77D93.4030505@linaro.org> <51F97842.6050200@linaro.org> <068436c6-ff98-428f-8875-bb1c6f86466b@TX2EHSMHS008.ehs.local> <51F97CE3.9030306@linaro.org> <15e19315-ce88-4d3c-bad9-0a37d9e52f6b@CO1EHSMHS007.ehs.local> <51F99747.4060901@linaro.org> <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local> <51FA9AE8.1060004@linaro.org> <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local> <51FA9F54.3060704@linaro.org> <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local>
In-Reply-To: <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/13 18:11, Sören Brinkmann wrote:
> Hi Daniel,
> 
> On Thu, Aug 01, 2013 at 07:48:04PM +0200, Daniel Lezcano wrote:
>> On 08/01/2013 07:43 PM, Sören Brinkmann wrote:
>>> On Thu, Aug 01, 2013 at 07:29:12PM +0200, Daniel Lezcano wrote:
>>>> On 08/01/2013 01:38 AM, Sören Brinkmann wrote:
>>>>> On Thu, Aug 01, 2013 at 01:01:27AM +0200, Daniel Lezcano wrote:
>>>>>> On 08/01/2013 12:18 AM, Sören Brinkmann wrote:
>>>>>>> On Wed, Jul 31, 2013 at 11:08:51PM +0200, Daniel Lezcano wrote:
>>>>>>>> On 07/31/2013 10:58 PM, Sören Brinkmann wrote:
>>>>>>>>> On Wed, Jul 31, 2013 at 10:49:06PM +0200, Daniel Lezcano wrote:
>>>>>>>>>> On 07/31/2013 12:34 AM, Sören Brinkmann wrote:
>>>>>>>>>>> On Tue, Jul 30, 2013 at 10:47:15AM +0200, Daniel Lezcano wrote:
>>>>>>>>>>>> On 07/30/2013 02:03 AM, Sören Brinkmann wrote:
>>>>>>>>>>>>> Hi Daniel,
>>>>>>>>>>>>>
>>>>>>>>>>>>> On Mon, Jul 29, 2013 at 02:51:49PM +0200, Daniel Lezcano wrote:
>>>>>>>>>>>>> (snip)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> the CPUIDLE_FLAG_TIMER_STOP flag tells the cpuidle framework the local
>>>>>>>>>>>>>> timer will be stopped when entering to the idle state. In this case, the
>>>>>>>>>>>>>> cpuidle framework will call clockevents_notify(ENTER) and switches to a
>>>>>>>>>>>>>> broadcast timer and will call clockevents_notify(EXIT) when exiting the
>>>>>>>>>>>>>> idle state, switching the local timer back in use.
>>>>>>>>>>>>>
>>>>>>>>>>>>> I've been thinking about this, trying to understand how this makes my
>>>>>>>>>>>>> boot attempts on Zynq hang. IIUC, the wrongly provided TIMER_STOP flag
>>>>>>>>>>>>> would make the timer core switch to a broadcast device even though it
>>>>>>>>>>>>> wouldn't be necessary. But shouldn't it still work? It sounds like we do
>>>>>>>>>>>>> something useless, but nothing wrong in a sense that it should result in
>>>>>>>>>>>>> breakage. I guess I'm missing something obvious. This timer system will
>>>>>>>>>>>>> always remain a mystery to me.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Actually this more or less leads to the question: What is this
>>>>>>>>>>>>> 'broadcast timer'. I guess that is some clockevent device which is
>>>>>>>>>>>>> common to all cores? (that would be the cadence_ttc for Zynq). Is the
>>>>>>>>>>>>> hang pointing to some issue with that driver?
>>>>>>>>>>>>
>>>>>>>>>>>> If you look at the /proc/timer_list, which timer is used for broadcasting ?
>>>>>>>>>>>
>>>>>>>>>>> So, the correct run results (full output attached).
>>>>>>>>>>>
>>>>>>>>>>> The vanilla kernel uses the twd timers as local timers and the TTC as
>>>>>>>>>>> broadcast device:
>>>>>>>>>>> 	Tick Device: mode:     1                                                         
>>>>>>>>>>> 	Broadcast device  
>>>>>>>>>>> 	Clock Event Device: ttc_clockevent
>>>>>>>>>>>
>>>>>>>>>>> When I remove the offending CPUIDLE flag and add the DT fragment to
>>>>>>>>>>> enable the global timer, the twd timers are still used as local timers
>>>>>>>>>>> and the broadcast device is the global timer:
>>>>>>>>>>> 	Tick Device: mode:     1                                                         
>>>>>>>>>>> 	Broadcast device                                                                 
>>>>>>>>>>> 	Clock Event Device: arm_global_timer
>>>>>>>>>>>
>>>>>>>>>>> Again, since boot hangs in the actually broken case, I don't see way to
>>>>>>>>>>> obtain this information for that case.
>>>>>>>>>>
>>>>>>>>>> Can't you use the maxcpus=1 option to ensure the system to boot up ?
>>>>>>>>>
>>>>>>>>> Right, that works. I forgot about that option after you mentioned, that
>>>>>>>>> it is most likely not that useful.
>>>>>>>>>
>>>>>>>>> Anyway, this are those sysfs files with an unmodified cpuidle driver and
>>>>>>>>> the gt enabled and having maxcpus=1 set.
>>>>>>>>>
>>>>>>>>> /proc/timer_list:
>>>>>>>>> 	Tick Device: mode:     1
>>>>>>>>> 	Broadcast device
>>>>>>>>> 	Clock Event Device: arm_global_timer
>>>>>>>>> 	 max_delta_ns:   12884902005
>>>>>>>>> 	 min_delta_ns:   1000
>>>>>>>>> 	 mult:           715827876
>>>>>>>>> 	 shift:          31
>>>>>>>>> 	 mode:           3
>>>>>>>>
>>>>>>>> Here the mode is 3 (CLOCK_EVT_MODE_ONESHOT)
>>>>>>>>
>>>>>>>> The previous timer_list output you gave me when removing the offending
>>>>>>>> cpuidle flag, it was 1 (CLOCK_EVT_MODE_SHUTDOWN).
>>>>>>>>
>>>>>>>> Is it possible you try to get this output again right after onlining the
>>>>>>>> cpu1 in order to check if the broadcast device switches to SHUTDOWN ?
>>>>>>>
>>>>>>> How do I do that? I tried to online CPU1 after booting with maxcpus=1
>>>>>>> and that didn't end well:
>>>>>>> 	# echo 1 > online && cat /proc/timer_list 
>>>>>>
>>>>>> Hmm, I was hoping to have a small delay before the kernel hangs but
>>>>>> apparently this is not the case... :(
>>>>>>
>>>>>> I suspect the global timer is shutdown at one moment but I don't
>>>>>> understand why and when.
>>>>>>
>>>>>> Can you add a stack trace in the "clockevents_shutdown" function with
>>>>>> the clockevent device name ? Perhaps, we may see at boot time an
>>>>>> interesting trace when it hangs.
>>>>>
>>>>> I did this change:
>>>>> 	diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
>>>>> 	index 38959c8..3ab11c1 100644
>>>>> 	--- a/kernel/time/clockevents.c
>>>>> 	+++ b/kernel/time/clockevents.c
>>>>> 	@@ -92,6 +92,8 @@ void clockevents_set_mode(struct clock_event_device *dev,
>>>>> 	  */
>>>>> 	 void clockevents_shutdown(struct clock_event_device *dev)
>>>>> 	 {
>>>>> 	+       pr_info("ce->name:%s\n", dev->name);
>>>>> 	+       dump_stack();
>>>>> 	        clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
>>>>> 	        dev->next_event.tv64 = KTIME_MAX;
>>>>> 	 }
>>>>>
>>>>> It is hit a few times during boot, so I attach a full boot log. I really
>>>>> don't know what to look for, but I hope you can spot something in it. I
>>>>> really appreciate you taking the time.
>>>>
>>>> Thanks for the traces.
>>>
>>> Sure.
>>>
>>>>
>>>> If you try without the ttc_clockevent configured in the kernel (but with
>>>> twd and gt), does it boot ?
>>>
>>> Absence of the TTC doesn't seem to make any difference. It hangs at the
>>> same location.
>>
>> Ok, IMO there is a problem with the broadcast device registration (may
>> be vs twd).
> 
> I have an idea, but no real evidence to prove it:
> Some of the registers in the arm_global_timer are banked per CPU. I.e.
> some code must be executed on the CPU the timer is associated with
> (struct clock_event_device.cpumask) to have the intended effect
> As far as I can tell, there is no guarantee, that the set_mode()
> and program_next_event() calls execute on the correct CPU.
> If this was correct, shutting down the timer for the CPU entering
> idle might actually shut down the timer for the running CPU, if
> set_mode() executes on the CPU which is _not_ about to enter idle.

Hi Sören,
Am able to reproduce similar issue on StiH415 SOC by enabling both
global_timer and twd and using cpuidle driver like zynq.

When CPU0 goes to idle, I noticed that the global timer used for
boardcast is actually scheduled on wrong cpu.
My traces for printk like this
	printk("DEBUG: %s on CPU:%d CPUMASK:%s\n", __FUNCTION__,
smp_processor_id(), scpumask);

shows:

DEBUG: gt_clockevent_set_mode on CPU:1 CPUMASK: 0
DEBUG: gt_clockevent_set_next_event on CPU:1 CPUMASK:0

Which indicates that setting the mode and next_event for a clkevent with
cpumask 0 is scheduled on cpu1, this will generate an global timer
interrupt on cpu1 rather than cpu0.

This might be the reason for cpu0 not coming out of the cpu_idle_loop.

Thanks,
srini
> 
> I tried to prove this by adding some really ugly smp_call_any() wrappers
> in kernel/time/clockevents.c for the calls to set_mode() and
> program_net_event() but that ends in all kinds of dead locks.
> 
> 	Sören
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

