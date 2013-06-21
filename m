Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161325Ab3FUAP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:15:26 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:60018 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161284Ab3FUAPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:15:25 -0400
Message-ID: <51C39B1A.5070902@linaro.org>
Date: Thu, 20 Jun 2013 17:15:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: clocksource with changing frequency?
References: <f5e5d3d7-699d-4f89-80c8-849e432e8b26@VA3EHSMHS017.ehs.local>
In-Reply-To: <f5e5d3d7-699d-4f89-80c8-849e432e8b26@VA3EHSMHS017.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 05:01 PM, Sören Brinkmann wrote:
> Hi all,
>
> I have a question/problem with a clocksource whose input frequency can
> change.

That behavior isn't supported by the clocksource core. We expect 
frequency changing clocksources to be detected and disqualified (as we 
do w/ freq changing TSCs on older laptops).


> On Zynq we use the cadece_ttc timer as clocksource. Its input clock is
> tightly coupled to the CPU clock. I.e. it changes when cpufreq scales
> the CPU clocks.
> To compensate this, I added a clock notifier doing this on a frequency
> change:
> 	clocksource_unregister(&ttccs->cs);
> 	clocksource_register_hz(&ttccs->cs, ndata->new_rate / PRESCALE);

This will definitely have problems if this is the only high-res capable 
clocksource.

> This just seems not to be the most elegant way, a heavy weight operation
> and results in a couple of locking errors in combination with
> suspend/hotplug.
>
> Is there a sane solution for such a case? E.g. for clockevent devices
> there is a 'clockevents_update_freq()' to adjust to changing
> frequencies.

If you want to experiment with things, my suggestion would be to try to 
fake a constant frequency clocksource in the clocksource driver(tracking 
the change intervals and multiplying them up as needed). However, I 
worry the quality of timekeeping won't be very good, as any latency in 
the detection of the freq change will cause time error.


> I assume the sanest solution is an external oscillator as clock input,
> but I think our platforms don't provide that :(

I suspect your best bet, if there really is no other consistent clocks, 
would be to disable highres timers and use the jiffies clocksource for 
timekeeping, allowing you to change cpufreq to save power or increase 
performance as you need. This will result in coarse timekeeping and 
larger timer latency. But the only other approach is to fix the cpu freq 
so the clocksource freq doesn't change (at the cost of cpu performance 
or battery life - both of which I suspect are bigger issues then coarse 
time).

thanks
-john


