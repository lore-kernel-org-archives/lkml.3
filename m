Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbaLJMeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:34:19 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:45092 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaLJMeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:34:17 -0500
Message-ID: <54883DB6.10504@linux.vnet.ibm.com>
Date: Wed, 10 Dec 2014 18:03:58 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Santosh Shukla <santosh.shukla@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, fweisbec@gmail.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        daniel.lezcano@linaro.org, Kevin Hilman <khilman@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Query] Spurious interrupts from clockevent device on X86 Ivybridge
References: <CA+iXiiOhPxvJKR5-9U_9Hd6mOnXJadBS+WRZhtv3yPw2r8KgJQ@mail.gmail.com>
In-Reply-To: <CA+iXiiOhPxvJKR5-9U_9Hd6mOnXJadBS+WRZhtv3yPw2r8KgJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121012-0033-0000-0000-000002F7586E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santhosh,

On 12/10/2014 11:00 AM, Santosh Shukla wrote:
> Hi Guys,
> 
> I have been chasing spurious clockevent interrupts (In HIGHRES mode) on my x86
> IvyBridge server and stuck on some blockers (mostly due to lack of knowledge)
> and need some help..
> 
> What does spurious mean ?
> I take it as the case when a core is unnecessarily interrupted by the clockevent
> device while we didn't wanted it to.

Right. We get an interrupt when nobody had asked for it to be delivered
or had asked for it to be delivered and later canceled the request. It
is most often in the latter situation, that there can be race
conditions. If these race conditions are not taken care of, they can
result in spurious interrupts.

> 
> I tried to catch them with the help of few new trace points in
> hrtimer_interrupt() when it didn't serviced any pending hrtimers..
> 
> The causes I could find:
> - Clockevent device's counter overflow: When we need to program a clockevt
>   device for times larger than it can handle, we program it for max time and
>   then reprogram again on expiration. Because of hardware counter limitations we
>   have to do it this way and this isn't really a spurious interrupt as we
>   programmed it that way.

Yes this is a possible cause for spurious interrupts. On PowerPC we
check for such a situation specifically before we begin to handle timers.

> 
> - Hardware timer firing before its expiration: Yes, its hard to digest but from
>   my tests it looks like this does happen. Will circulate another mail once I am
>   sure about it.

Yep, will need more information if at all this is happening.

> 
> - Difference between time returned by hrtimer_update_base() and clockevt
>   device's notion of time: Wanted to discuss this here..
> 
> 
> An example of what I am witnessing in my tests:
> 
> clockevt device programmed to fire after 199 ms and it fires exactly after that
> time (Verified with ftrace time-diff and tsc diff [tsc: timestamp counter
> instructions for x86]).
> 
> But when hrtimer_interrupt() tries to find the hrtimer for which the event
> occurred, it finds the value returned by hrtimer_update_base() being lesser than
> the softexpires of the timer for which the event was programmed. And the diff is
> approximately 1 us most of the times I see the spurious interrupt.
> 
> <idle>-0     [010] d...    68.961171: clk_evt_program: delta:199933679
> expires=69071000000 /* programmed for 199 ms */
> <idle>-0     [010] d...    68.961171: lapic_next_deadline:
> cur_tsc:365799488705427 new_tsc:365799907536051 delta:199443 usec /*
> sets new_tsc */
> <idle>-0     [010] d.h.    69.161183: local_timer_entry: vector=239
> <idle>-0     [010] d.h.    69.161185: local_apic_timer_interrupt:
> cur_tsc:365799907547595 delta:199448 usec /* Interrupt arrived
> afterexactly 199 ms */
> <idle>-0     [010] d.h.    69.161187:
> hrtimer_interrupt:function=tick_sched_timer expires=69071000000
> softexpires=69071000000
> basenow:69070997234 /* But Softexpires > basenow ?? */
> <idle>-0     [010] d.h.    69.161188: clk_evt_program: delta:1000
> expires=69071000000 /* new expiry value (1 us) */
> <idle>-0     [010] d.h.    69.161189: lapic_next_deadline:
> cur_tsc:365799907556179 new_tsc:365799907558259 delta:0 usec /* sets
> new tsc value */
> <idle>-0     [010] d.h.    69.161189: local_timer_exit: vector=239

Since the difference is 1us and not a noticeably high value, it is most
probably because during hrtimer handling, we traverse all queued timers
and call their handlers, till we find timers whose expiry is in the
future. I would not be surprised if we overshoot the expiry of the
timers at the end of the list by a microsecond by the time we call their
handlers.

Regards
Preeti U Murthy
> 
> Tested on: Ivybrdge V2, 12 core X86 server, though it occurs on ARM as well
> (but not that frequent).
> 
> Regards,
> Santosh
> 

