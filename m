Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936344Ab3DKVCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:02:55 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:53178 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932817Ab3DKVCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:02:50 -0400
Message-ID: <516724F5.20504@kernel.org>
Date: Thu, 11 Apr 2013 17:02:45 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [patch v7 0/21] sched: power aware scheduling
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 10:00 PM, Alex Shi wrote:

> As mentioned in the power aware scheduling proposal, Power aware
> scheduling has 2 assumptions:
> 1, race to idle is helpful for power saving
> 2, less active sched groups will reduce cpu power consumption

linux-pm@vger.kernel.org should be cc:
on Linux proposals that affect power.

> Since the patch can perfect pack tasks into fewer groups, I just show
> some performance/power testing data here:
> =========================================
> $for ((i = 0; i < x; i++)) ; do while true; do :; done  &   done
> 
> On my SNB laptop with 4 core* HT: the data is avg Watts
>          powersaving     performance
> x = 8	 72.9482 	 72.6702
> x = 4	 61.2737 	 66.7649
> x = 2	 44.8491 	 59.0679
> x = 1	 43.225 	 43.0638

> on SNB EP machine with 2 sockets * 8 cores * HT:
>          powersaving     performance
> x = 32	 393.062 	 395.134
> x = 16	 277.438 	 376.152
> x = 8	 209.33 	 272.398
> x = 4	 199 	         238.309
> x = 2	 175.245 	 210.739
> x = 1	 174.264 	 173.603

The numbers above say nothing about performance,
and thus don't tell us much.

In particular, they don't tell us if reducing power
by hacking the scheduler is more or less efficient
than using the existing techniques that are already shipping,
such as controlling P-states.

> tasks number keep waving benchmark, 'make -j <x> vmlinux'
> on my SNB EP 2 sockets machine with 8 cores * HT:
>          powersaving              performance
> x = 2    189.416 /228 23          193.355 /209 24

Energy = Power * Time

189.416*228 = 43186.848 Joules for powersaving to retire the workload
193.355*209 = 40411.195 Joules for performance to retire the workload.

So the net effect of the 'powersaving' mode here is:
1. 228/209 = 9% performance degradation
2. 43186.848/40411.195 = 6.9 % more energy to retire the workload.

These numbers suggest that this patch series simultaneously
has a negative impact on performance and energy required
to retire the workload.  Why do it?

> x = 4    215.728 /132 35          219.69 /122 37

ditto here.
8% increase in time.
6% increase in energy.

> x = 8    244.31 /75 54            252.709 /68 58

ditto here
10% increase in time.
6% increase in energy.

> x = 16   299.915 /43 77           259.127 /58 66

Are you sure that powersave mode ran in 43 seconds
when performance mode ran in 58 seconds?

If that is true, than somewhere in this patch series
you have a _significant_ performance benefit
on this workload under these conditions!

Interestingly, powersave mode also ran at
15% higher power than performance mode.
maybe "powersave" isn't quite the right name for it:-)

> x = 32   341.221 /35 83           323.418 /38 81

Why does this patch series have a performance impact (8%)
at x=32.  All the processors are always busy, no?

> data explains: 189.416 /228 23
> 	189.416: average Watts during compilation
> 	228: seconds(compile time)
> 	23:  scaled performance/watts = 1000000 / seconds / watts
> The performance value of kbuild is better on threads 16/32, that's due
> to lazy power balance reduced the context switch and CPU has more boost 
> chance on powersaving balance.

25% is a huge difference in performance.
Can you get a performance benefit in that scenario
without having a negative performance impact
in the other scenarios?  In particular,
an 8% hit to the fully utilized case is a deal killer.

The x=16 performance change here suggest there is value
someplace in this patch series to increase performance.
However, the case that these scheduling changes are
a benefit from an energy efficiency point of view
is yet to be made.

thanks,
-Len Brown
Intel Open Source Technology Center

