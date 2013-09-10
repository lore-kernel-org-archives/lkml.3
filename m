Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3IJRIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:08:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab3IJRIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:08:11 -0400
Date: Tue, 10 Sep 2013 19:07:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Greg KH <greg@kroah.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: "cpufreq: fix serialization issues with freq change notifiers"
 breaks cpufreq too
In-Reply-To: <CAKohpomK7Y_6aLMA3B+hZrtgYq9U89ihgkbvYWA3BsKN3gJD3g@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1309101853170.16010@axis700.grange>
References: <Pine.LNX.4.64.1309091656200.6602@axis700.grange>
 <CAKohponZ+FnzqXYMbBzbun0-1iQMi2fS4syrEBC_MdF41vLCeA@mail.gmail.com>
 <Pine.LNX.4.64.1309101656150.16010@axis700.grange>
 <CAKohpomBBKLhNemVUpUHAftGhPJJe+ZB7T_9UYLD7LwpR1nK0g@mail.gmail.com>
 <Pine.LNX.4.64.1309101740120.16010@axis700.grange>
 <CAKohpomK7Y_6aLMA3B+hZrtgYq9U89ihgkbvYWA3BsKN3gJD3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Iofd1Kd5AYTi4lQ0ow/ucItY5SzEuq6sLOFPzxWPpgS
 RQy8z4Fu6j1zvGeqJLgG65C9TGXPbfQXXJR6kORoSzeMvE9wfh
 ceALf4CRQagfg+b5jrplr9fQPprNLPqgERn/gDus0FQMFtyy9O
 jqChlqgnQn0yD+UgXYpINCglVdyf/uRgTQfgsmo0+aBGfb0lWG
 mF+1NPU6t5z4emdmDlDnpLktPSLnb2ZRgmR7Yu+oIamXZMMCxo
 dZ3FpYSvzK34PffN4V7lFIkNAmJvYsWmY+VxJw4b0xju2SZC24
 e9mP9/bgppbny99qz6QnWS4Yol79ZE/MXV/bI2PWBtYDl5vojP
 ssTbO2bIkwHffEJI8rhSd6lgGKpm5u/jW1ZIedJqTdd35XzSfp
 ZrqPddu2UBriA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Viresh Kumar wrote:

> On 10 September 2013 21:52, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > Of course, isn't that what I've written above? reverted a commit and added
> > debug - in that order.
> 
> Ok, I misread it then :(
> 
> > Sure, I can... So, with the performance governor I get
> >
> > [    1.290000] cpufreq-cpu0 cpufreq-cpu0: Looking up cpu0-supply from device tree
> > [    1.290000] cpufreq: trying to register driver generic_cpu0
> > [    1.290000] cpufreq: adding CPU 0
> > [    1.290000] cpufreq: Adding link for CPU: 1
> > [    1.290000] cpufreq: setting new policy for CPU 0: 398667 - 1196000 kHz
> > [    1.290000] cpufreq: new min and max freqs are 398667 - 1196000 kHz
> > [    1.290000] cpufreq: governor switch
> > [    1.290000] cpufreq: __cpufreq_governor for CPU 0, event 4
> > [    1.290000] cpufreq: __cpufreq_governor for CPU 0, event 1
> > [    1.290000] cpufreq_performance: setting to 1196000 kHz because of event 1
> > [    1.290000] cpufreq: __cpufreq_driver_target().1665 1
> >
> > This is my debug - .transition_ongoing is incremented ^^^^^^^^
> >
> > [    1.300000] cpufreq: target for CPU 0: 1196000 kHz, relation 1, requested 1196000 kHz
> 
> Quite straight forward actually..

Apparently, not quite.

> Please try attached patch and see if it fixes
> your problem.. Which it should if I am not wrong.. I will send it
> separately then..

It helps only once. The first switching works, the second one doesn't. 
Below debug

[   12.010000] cpufreq: setting new policy for CPU 0: 398667 - 1196000 kHz
[   12.010000] cpufreq: new min and max freqs are 398667 - 1196000 kHz
[   12.010000] cpufreq: governor switch
[   12.010000] cpufreq: __cpufreq_governor for CPU 0, event 2
[   12.010000] cpufreq: __cpufreq_governor for CPU 0, event 5
[   12.010000] ondemand governor failed, too long transition latency of HW, fallback to performance governor
[   12.020000] cpufreq: __cpufreq_governor for CPU 0, event 4
[   12.020000] cpufreq: __cpufreq_governor for CPU 0, event 1
[   12.020000] cpufreq_performance: setting to 1196000 kHz because of event 1
[   12.020000] cpufreq: target for CPU 0: 1196000 kHz, relation 1, requested 1196000 kHz
[   12.020000] cpufreq: governor: change or update limits
[   12.020000] cpufreq: __cpufreq_governor for CPU 0, event 3
[   12.020000] cpufreq_performance: setting to 1196000 kHz because of event 3
[   12.020000] cpufreq: target for CPU 0: 1196000 kHz, relation 1, requested 1196000 kHz
[   12.030000] cpufreq: setting new policy for CPU 0: 398667 - 1196000 kHz
[   12.030000] cpufreq: new min and max freqs are 398667 - 1196000 kHz
[   12.030000] cpufreq: governor switch
[   12.030000] cpufreq: __cpufreq_governor for CPU 0, event 2
[   12.030000] cpufreq: __cpufreq_governor for CPU 0, event 5
[   12.030000] ondemand governor failed, too long transition latency of HW, fallback to performance governor
[   12.040000] cpufreq: __cpufreq_governor for CPU 0, event 4
[   12.040000] cpufreq: __cpufreq_governor for CPU 0, event 1
[   12.040000] cpufreq_performance: setting to 1196000 kHz because of event 1
[   12.040000] cpufreq: target for CPU 0: 1196000 kHz, relation 1, requested 1196000 kHz
[   12.040000] cpufreq: governor: change or update limits
[   12.040000] cpufreq: __cpufreq_governor for CPU 0, event 3
[   12.040000] cpufreq_performance: setting to 1196000 kHz because of event 3
[   12.040000] cpufreq: target for CPU 0: 1196000 kHz, relation 1, requested 1196000 kHz

echo powersave > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

[   66.490000] cpufreq: setting new policy for CPU 0: 398667 - 1196000 kHz
[   66.490000] cpufreq: new min and max freqs are 398667 - 1196000 kHz
[   66.490000] cpufreq: governor switch
[   66.490000] cpufreq: __cpufreq_governor for CPU 0, event 2
[   66.490000] cpufreq: __cpufreq_governor for CPU 0, event 5
[   66.490000] cpufreq: __cpufreq_governor for CPU 0, event 4
[   66.490000] cpufreq: __cpufreq_governor for CPU 0, event 1
[   66.490000] cpufreq: target for CPU 0: 398667 kHz, relation 0, requested 398667 kHz
[   66.490000] cpufreq: __cpufreq_driver_target().1677 1
[   66.500000] cpufreq: notification 0 of frequency transition to 398666 kHz
[   66.500000] cpufreq: __cpufreq_notify_transition().297 2
[   66.500000] cpufreq: notification 0 of frequency transition to 398666 kHz
[   66.500000] cpufreq: __cpufreq_notify_transition().297 3
[   66.510000] cpufreq: notification 1 of frequency transition to 398666 kHz
[   66.510000] cpufreq: __cpufreq_notify_transition().327 2
[   66.520000] cpufreq: FREQ: 398666 - CPU: 0
[   66.520000] cpufreq: notification 1 of frequency transition to 398666 kHz
[   66.520000] cpufreq: __cpufreq_notify_transition().327 1
[   66.520000] cpufreq: FREQ: 398666 - CPU: 1
[   66.520000] cpufreq: cpufreq_notify_transition().366 0
[   66.530000] cpufreq: governor: change or update limits
[   66.530000] cpufreq: __cpufreq_governor for CPU 0, event 3
[   66.530000] cpufreq: target for CPU 0: 398667 kHz, relation 0, requested 398667 kHz
[   66.530000] cpufreq: __cpufreq_driver_target().1677 1

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

[   72.470000] cpufreq: setting new policy for CPU 0: 398667 - 1196000 kHz
[   72.470000] cpufreq: new min and max freqs are 398667 - 1196000 kHz
[   72.470000] cpufreq: governor switch
[   72.470000] cpufreq: __cpufreq_governor for CPU 0, event 2
[   72.470000] cpufreq: __cpufreq_governor for CPU 0, event 5
[   72.470000] cpufreq: __cpufreq_governor for CPU 0, event 4
[   72.470000] cpufreq: __cpufreq_governor for CPU 0, event 1
[   72.470000] cpufreq_performance: setting to 1196000 kHz because of event 1
[   72.470000] cpufreq: target for CPU 0: 1196000 kHz, relation 1, requested 1196000 kHz
[   72.470000] cpufreq: governor: change or update limits
[   72.470000] cpufreq: __cpufreq_governor for CPU 0, event 3
[   72.470000] cpufreq_performance: setting to 1196000 kHz because of event 3
[   72.470000] cpufreq: target for CPU 0: 1196000 kHz, relation 1, requested 1196000 kHz

> Thanks for your time..

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
