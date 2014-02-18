Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaBRTnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:43:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:45313 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaBRTnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:43:15 -0500
Date: Tue, 18 Feb 2014 20:43:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Perevalov <a.perevalov@samsung.com>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
In-Reply-To: <53021972.4050400@samsung.com>
Message-ID: <alpine.DEB.2.02.1402181955420.4468@ionos.tec.linutronix.de>
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com> <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com> <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de> <52F1DDA8.90605@samsung.com> <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
 <52F2B504.5010403@linaro.org> <alpine.DEB.2.02.1402052306580.24986@ionos.tec.linutronix.de> <52F3C8A5.708@samsung.com> <alpine.DEB.2.02.1402062148440.21991@ionos.tec.linutronix.de> <5300D752.5030403@samsung.com> <alpine.DEB.2.02.1402161634590.21991@ionos.tec.linutronix.de>
 <53021972.4050400@samsung.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014, Alexey Perevalov wrote:
> On 02/16/2014 07:39 PM, Thomas Gleixner wrote:

> Here is the summary:
> 
> now value    |  difference with previous value
> 2159122612405|
> 2158816038362|    306574043
> 2158532090801|    283947561
> 2158200013165|    332077636
> 2157928085502|    271927663
> 2157600425537|    327659965
> 2157328089996|    272335541
> 2157000091028|    327998968
> 2156728086117|    272004911
> 2156432078659|    296007458
> 2156101736770|    330341889
> 2155816087467|    285649303
> 2155532081987|    284005480
> 2155228092094|    303989893
> 2154912090729|    316001365
> 2154632081099|    280009630
> 2154328094166|    303986933
> 2154000086890|    328007276
> 
> Timer was charged with 300ms interval. And we see difference in neighborhood
>  of point 300 000 000 - 300ms. The average value as we can see:
> 301325030.294118
>  - the average delay is 1 ms.

Math is hard, right?

Lets look at the trace data:

> hrtimer=0xffffffffa04a9280 now=2154000086890 function=timerfd_tmrproc/0x0
>           <idle>-0     [000]   339.148391: hrtimer_start:
> hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc expires=2154300000000
> softexpires=2154300000000

expires=2154300000000

>           <idle>-0     [000]   339.157821: hrtimer_expire_entry:
> hrtimer=0xffffffffa04a9280 now=2154328094166 function=timerfd_tmrproc/0x0

now=2154328094166 

-> delay = 2154328094166 - 2154300000000 = 28094166 = 28ms


>           <idle>-0     [000]   339.157837: hrtimer_start:
> hrtimer=0xffffffffa04a9280 function=timerfd_tmrproc expires=2154600000000
> softexpires=2154600000000

expires=2154600000000

>           <idle>-0     [000]   339.170895: hrtimer_expire_entry:
> hrtimer=0xffffffffa04a9280 now=2154632081099 function=timerfd_tmrproc/0x0

now=2154632081099

-> delay = 2154632081099 - 2154600000000 = 32081099 = 32ms

You cannot sum up the delta between the expiry times when you use an
timer on an absolute time line. You need to look at the delta between
the programmed expiry time and the actual expiry time. That tells you
the deferred time. And running your excerpt through a filter tells me:

Delta:  28.0ms
Delta:  32.0ms
Delta:  12.0ms
Delta:  28.0ms
Delta:  32.0ms
Delta:  16.0ms
Delta:   1.0ms
Delta:  32.0ms
Delta:  28.0ms
Delta:   0.0ms
Delta:  28.0ms
Delta:   0.0ms
Delta:  28.0ms
Delta:   0.0ms
Delta:  32.0ms
Delta:  16.0ms
Delta:  22.0ms

Avg:    19.0ms

> 4298170712|    300000000
> 4298170637|    300000000
> 4298170562|    300000000
> 4298170483|    316000000
> 4298170387|    384000000
> 4298170287|    400000000
> 4298170212|    300000000
> 4298170129|    332000000
> 4298170053|    304000000
> 4298169978|    300000000
> 4298169903|    300000000
> 4298169828|    300000000
> 
> Average delay here is 20ms.

Your trace tells a different story:

Delta:   0.0ms
Delta:   0.0ms
Delta:   0.0ms
Delta:   1.0ms
Delta:   8.0ms
Delta:   0.0ms
Delta:  25.0ms
Delta:  21.0ms
Delta:   4.0ms
Delta:   0.0ms
Delta:   0.0ms
Delta:   0.0ms

Avg:     4.0ms

> Maybe it's due cpuidle implementation or clock_device on my system. It was
> MENU cpuidle governor.

I fear it's something else ...

Thanks,

	tglx
