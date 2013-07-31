Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864Ab3GaVIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 17:08:51 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49883 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3GaVIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 17:08:50 -0400
Message-ID: <51F97CE3.9030306@linaro.org>
Date: Wed, 31 Jul 2013 23:08:51 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Stephen Boyd <sboyd@codeaurora.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <f5b76049-7e5b-4dd0-9863-19cfd1d599b9@TX2EHSMHS006.ehs.local> <51E7435B.3060605@codeaurora.org> <ff4d40be-7177-4a55-ab2f-dff11fa18642@DB9EHSMHS009.ehs.local> <51ED8DF2.60600@codeaurora.org> <20130722201348.GI453@xsjandreislx> <0735ab8c-0f80-4b64-b2b2-8d4553482c2a@CO9EHSMHS013.ehs.local> <51F66565.7010600@linaro.org> <8d56935e-2a20-46c7-b80a-f779572dd839@CO1EHSMHS014.ehs.local> <51F77D93.4030505@linaro.org> <51F97842.6050200@linaro.org> <068436c6-ff98-428f-8875-bb1c6f86466b@TX2EHSMHS008.ehs.local>
In-Reply-To: <068436c6-ff98-428f-8875-bb1c6f86466b@TX2EHSMHS008.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 10:58 PM, Sören Brinkmann wrote:
> On Wed, Jul 31, 2013 at 10:49:06PM +0200, Daniel Lezcano wrote:
>> On 07/31/2013 12:34 AM, Sören Brinkmann wrote:
>>> On Tue, Jul 30, 2013 at 10:47:15AM +0200, Daniel Lezcano wrote:
>>>> On 07/30/2013 02:03 AM, Sören Brinkmann wrote:
>>>>> Hi Daniel,
>>>>>
>>>>> On Mon, Jul 29, 2013 at 02:51:49PM +0200, Daniel Lezcano wrote:
>>>>> (snip)
>>>>>>
>>>>>> the CPUIDLE_FLAG_TIMER_STOP flag tells the cpuidle framework the local
>>>>>> timer will be stopped when entering to the idle state. In this case, the
>>>>>> cpuidle framework will call clockevents_notify(ENTER) and switches to a
>>>>>> broadcast timer and will call clockevents_notify(EXIT) when exiting the
>>>>>> idle state, switching the local timer back in use.
>>>>>
>>>>> I've been thinking about this, trying to understand how this makes my
>>>>> boot attempts on Zynq hang. IIUC, the wrongly provided TIMER_STOP flag
>>>>> would make the timer core switch to a broadcast device even though it
>>>>> wouldn't be necessary. But shouldn't it still work? It sounds like we do
>>>>> something useless, but nothing wrong in a sense that it should result in
>>>>> breakage. I guess I'm missing something obvious. This timer system will
>>>>> always remain a mystery to me.
>>>>>
>>>>> Actually this more or less leads to the question: What is this
>>>>> 'broadcast timer'. I guess that is some clockevent device which is
>>>>> common to all cores? (that would be the cadence_ttc for Zynq). Is the
>>>>> hang pointing to some issue with that driver?
>>>>
>>>> If you look at the /proc/timer_list, which timer is used for broadcasting ?
>>>
>>> So, the correct run results (full output attached).
>>>
>>> The vanilla kernel uses the twd timers as local timers and the TTC as
>>> broadcast device:
>>> 	Tick Device: mode:     1                                                         
>>> 	Broadcast device  
>>> 	Clock Event Device: ttc_clockevent
>>>
>>> When I remove the offending CPUIDLE flag and add the DT fragment to
>>> enable the global timer, the twd timers are still used as local timers
>>> and the broadcast device is the global timer:
>>> 	Tick Device: mode:     1                                                         
>>> 	Broadcast device                                                                 
>>> 	Clock Event Device: arm_global_timer
>>>
>>> Again, since boot hangs in the actually broken case, I don't see way to
>>> obtain this information for that case.
>>
>> Can't you use the maxcpus=1 option to ensure the system to boot up ?
> 
> Right, that works. I forgot about that option after you mentioned, that
> it is most likely not that useful.
> 
> Anyway, this are those sysfs files with an unmodified cpuidle driver and
> the gt enabled and having maxcpus=1 set.
> 
> /proc/timer_list:
> 	Tick Device: mode:     1
> 	Broadcast device
> 	Clock Event Device: arm_global_timer
> 	 max_delta_ns:   12884902005
> 	 min_delta_ns:   1000
> 	 mult:           715827876
> 	 shift:          31
> 	 mode:           3

Here the mode is 3 (CLOCK_EVT_MODE_ONESHOT)

The previous timer_list output you gave me when removing the offending
cpuidle flag, it was 1 (CLOCK_EVT_MODE_SHUTDOWN).

Is it possible you try to get this output again right after onlining the
cpu1 in order to check if the broadcast device switches to SHUTDOWN ?

> 	 next_event:     108080000000 nsecs
> 	 set_next_event: gt_clockevent_set_next_event
> 	 set_mode:       gt_clockevent_set_mode
> 	 event_handler:  tick_handle_oneshot_broadcast
> 	 retries:        0
> 	
> 	tick_broadcast_mask: 00000001
> 	tick_broadcast_oneshot_mask: 00000000
> 	
> 	Tick Device: mode:     1
> 	Per CPU device: 0
> 	Clock Event Device: local_timer
> 	 max_delta_ns:   12884902005
> 	 min_delta_ns:   1000
> 	 mult:           715827876
> 	 shift:          31
> 	 mode:           3
> 	 next_event:     106900000000 nsecs
> 	 set_next_event: twd_set_next_event
> 	 set_mode:       twd_set_mode
> 	 event_handler:  hrtimer_interrupt
> 	 retries:        0
> 
> # cat /proc/interrupts 
> 	           CPU0       
> 	 27:        252       GIC  27  gt
> 	 29:        626       GIC  29  twd
> 	 43:          0       GIC  43  ttc_clockevent
> 	 82:        410       GIC  82  xuartps
> 	IPI0:          0  CPU wakeup interrupts
> 	IPI1:          0  Timer broadcast interrupts
> 	IPI2:          0  Rescheduling interrupts
> 	IPI3:          0  Function call interrupts
> 	IPI4:          0  Single function call interrupts
> 	IPI5:          0  CPU stop interrupts
> 	Err:          0
> 
> 
> 	Sören
> 
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

