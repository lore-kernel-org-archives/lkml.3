Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaLKEoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 23:44:16 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33562 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaLKEoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 23:44:15 -0500
Message-ID: <54892111.3000102@linux.vnet.ibm.com>
Date: Thu, 11 Dec 2014 10:14:01 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: Santosh Shukla <santosh.shukla@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [Query] Spurious interrupts from clockevent device on X86 Ivybridge
References: <CA+iXiiOhPxvJKR5-9U_9Hd6mOnXJadBS+WRZhtv3yPw2r8KgJQ@mail.gmail.com> <54883DB6.10504@linux.vnet.ibm.com> <CAKohpokJxXe2RNc4Jqb20PJo2adr49nKBbzdXzYk9=H4kNjfRQ@mail.gmail.com>
In-Reply-To: <CAKohpokJxXe2RNc4Jqb20PJo2adr49nKBbzdXzYk9=H4kNjfRQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121104-0013-0000-0000-000006F7DEBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 06:22 PM, Viresh Kumar wrote:
> On 10 December 2014 at 18:03, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> 
>> Right. We get an interrupt when nobody had asked for it to be delivered
>> or had asked for it to be delivered and later canceled the request. It
>> is most often in the latter situation, that there can be race
>> conditions. If these race conditions are not taken care of, they can
>> result in spurious interrupts.
> 
> But the delta time will be very small then, right ?

I was talking of the case where we get an interrupt from the clockevent
device but dont find the hrtimer to service and not really of an anomaly
in timekeeping.
   For instance one of the issues that we had seen earlier wherein we
cancel the tick-sched-timer before going tickless, but since we had
programmed the clock event device to fire, we get a spurious interrupt.

> 
>> Since the difference is 1us and not a noticeably high value, it is most
>> probably because during hrtimer handling, we traverse all queued timers
>> and call their handlers, till we find timers whose expiry is in the
>> future. I would not be surprised if we overshoot the expiry of the
>> timers at the end of the list by a microsecond by the time we call their
>> handlers.
> 
> Looks like you misunderstood what he wrote. He isn't saying that we
> serviced the timers/hrtimers sometime after we should have.
> 
> What he is saying is: we got the clockevent device's interrupt at the
> time we requested but hrtimer_update_base() returned a time
> lesser than what it *should* have. And that results in a spurious
> interrupt.. We enqueue again for 1 us and service the timer then.

Oh ok I see. I understand this better now after reading Thomas's
explanation.

Regards
Preeti U Murthy

