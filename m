Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3BEC0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 21:26:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:48023 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab3BEC0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 21:26:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,602,1355126400"; 
   d="scan'208";a="280953120"
Message-ID: <51106DE0.1060103@intel.com>
Date: Tue, 05 Feb 2013 10:26:40 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com> <510F1064.1060302@intel.com> <20130204110959.GE24173@gmail.com>
In-Reply-To: <20130204110959.GE24173@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Ingo, I appreciate for any comments from you. :)
> 
> Have you tried to quantify the actual real or expected power 
> savings with the knob enabled?

Thanks a lot for your comments! :)

Yes, the following power data copied form patch 17th:
---
A test can show the effort on different policy:
for ((i = 0; i < I; i++)) ; do while true; do :; done  &   done

On my SNB laptop with 4core* HT: the data is Watts
        powersaving     balance         performance
i = 2   40              54              54
i = 4   57              64*             68
i = 8   68              68              68

Note:
When i = 4 with balance policy, the power may change in 57~68Watt,
since the HT capacity and core capacity are both 1.

on SNB EP machine with 2 sockets * 8 cores * HT:
        powersaving     balance         performance
i = 4   190             201             238
i = 8   205             241             268
i = 16  271             348             376

If system has few continued tasks, use power policy can get
the performance/power gain. Like sysbench fileio randrw test with 16
thread on the SNB EP box.
=====

and the following from patch 18th
---
On my SNB EP 2 sockets machine with 8 cores * HT: 'make -j x vmlinux'
results:

		powersaving		balance		performance
x = 1    175.603 /417 13          175.220 /416 13        176.073 /407 13
x = 2    192.215 /218 23          194.522 /202 25        217.393 /200 23
x = 4    205.226 /124 39          208.823 /114 42        230.425 /105 41
x = 8    236.369 /71 59           249.005 /65 61         257.661 /62 62
x = 16   283.842 /48 73           307.465 /40 81         309.336 /39 82
x = 32   325.197 /32 96           333.503 /32 93         336.138 /32 92

data explains: 175.603 /417 13
	175.603: average Watts
	417: seconds(compile time)
	13:  scaled performance/power = 1000000 / seconds / watts
=====

some data for parallel compress: https://lkml.org/lkml/2012/12/11/155
---
Another testing of parallel compress with pigz on Linus' git tree.
results show we get much better performance/power with powersaving and
balance policy:

testing command:
#pigz -k -c  -p$x -r linux* &> /dev/null

On a NHM EP box
         powersaving               balance               performance
x = 4    166.516 /88 68           170.515 /82 71         165.283 /103 58
x = 8    173.654 /61 94           177.693 /60 93         172.31 /76 76

On a 2 sockets SNB EP box.
         powersaving               balance               performance
x = 4    190.995 /149 35          200.6 /129 38          208.561 /135 35
x = 8    197.969 /108 46          208.885 /103 46        213.96 /108 43
x = 16   205.163 /76 64           212.144 /91 51         229.287 /97 44

data format is: 166.516 /88 68
        166.516: average Watts
        88: seconds(compress time)
        68:  scaled performance/power = 1000000 / time / power
=====

BTW, bltk-game with openarena dropped 0.3/1.5 Watt on powersaving policy
or 0.2/0.5 Watt on balance policy on my laptop wsm/snb;
> 
> I'd also love to have an automatic policy here, with a knob that 
> has 3 values:
> 
>    0: always disabled
>    1: automatic
>    2: always enabled
> 
> here enabled/disabled is your current knob's functionality, and 
> those can also be used by user-space policy daemons/handlers.

Sure, this patch has a knob for user-space policy selecting,

$cat /sys/devices/system/cpu/sched_policy/available_sched_policy
performance powersaving balance

User can change the policy by commend 'echo':
 echo performance > /sys/devices/system/cpu/current_sched_policy

The 'performance' policy means 'always disabled' power friendly scheduling.

The 'balance/powersaving' is automatic power friendly scheduling, since
system will auto bypass power scheduling when cpus utilisation in a
sched domain is beyond the domain's cpu weight (powersaving) or beyond
the domain's capacity (balance).

There is no always enabled power scheduling, since the patchset bases on
'race to idle'. but it's easy to add this function if needed.

> 
> The interesting thing would be '1' which should be the default: 
> on laptops that are on battery it should result in a power 
> saving policy, on laptops that are on AC or on battery-less 
> systems it should mean 'performance' policy.

yes, with above sysfs interface it is easy to be done. :)
> 
> It should generally default to 'performance', switching to 
> 'power saving on' only if there's positive, reliable information 
> somewhere in the kernel that we are operating on battery power. 
> A callback or two would have to go into the ACPI battery driver 
> I suspect.
> 
> So I'd like this feature to be a tangible improvement for laptop 
> users (as long as the laptop hardware is passing us battery/AC 
> events reliably).

Maybe it is better to let system admin change it from user space? I am
not sure some one like to enable a call back in ACPI battery driver?

CC to Zhang Rui.
> 
> Or something like that - with .config switches to influence 
> these values as well.
> 
> Thanks,
> 
> 	Ingo
> 


-- 
Thanks Alex
