Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbaFPIwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 04:52:16 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:48053 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbaFPIwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 04:52:14 -0400
Message-ID: <539EB03C.5080100@linaro.org>
Date: Mon, 16 Jun 2014 10:52:12 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chirantan Ekbote <chirantan@chromium.org>,
        David Riley <davidriley@chromium.org>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] clocksource: exynos_mct: Fix ftrace
References: <1401903034-20074-1-git-send-email-dianders@chromium.org>	<539E0D8E.9080706@linaro.org> <CAD=FV=XA09XawT-fxAm2tTMw4kZ=7RHceXuww2y6q+zMV71pew@mail.gmail.com>
In-Reply-To: <CAD=FV=XA09XawT-fxAm2tTMw4kZ=7RHceXuww2y6q+zMV71pew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 06:40 AM, Doug Anderson wrote:
> Daniel,
>
> On Sun, Jun 15, 2014 at 2:18 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> On 06/04/2014 07:30 PM, Doug Anderson wrote:
>>>
>>> In (93bfb76 clocksource: exynos_mct: register sched_clock callback) we
>>> supported using the MCT as a scheduler clock.  We properly marked
>>> exynos4_read_sched_clock() as notrace.  However, we then went and
>>> called another function that _wasn't_ notrace.  That means if you do:
>>>
>>>     cd /sys/kernel/debug/tracing/
>>>     echo function_graph > current_tracer
>>>
>>> You'll get a crash.
>>>
>>> Fix this (but still let other readers of the MCT be trace-enabled) by
>>> adding an extra function.  It's important to keep other users of MCT
>>> traceable because the MCT is actually quite slow.
>>
>>
>>
>> Hi Doug,
>>
>> could you elaborate ? I don't get the 'because the MCT ... slow'
>
> Sorry, I was trying to avoid duplication in the series and it's more
> obvious when you look at parts 2 and 3 of the series.  ;)
>
> Doing the math (please correct any miscalculations) using the numbers
> from the other patches: You can see that the existing code takes
> 1323852 us for 1000000 gettimeofday in userspace.  The fastest
> implementation (just shaving to a 32-bit timer) gets us as fast as
> ~1000000 us for 1000000 gettimeofday in userspace.
>
>  From profiling, I believe that gettimeofday from userspace is about
> 50% overhead (system call, multiplication, copies, etc) and about 50%
> MCT read.  That means that the fastest you can possibly do an MCT read
> is in .5us or 500ns.
>
> I believe an A15 has something like 1 or 2 cycles per instruction.  If
> it were 2 cycles per instruction, it can execute a normal instruction
> on a 2GHz machine in .5ns.  That means we can execute 1000 normal
> instructions in the time it takes to do a since MCT access.
>
> ...so I guess that's what I'd call slow.  ;)  What do you think?  I
> know that the MCT read shows up in whole system profiles of
> gettimeofday.

Hi Dough,

thanks for the explanation. I still don't get why it is important to 
keep others users of mct traceable because it is quite slow ? May be it 
is what you explained here, but I miss the connection between 'the other 
users' <-> 'traceable' <-> 'because slow'.

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

