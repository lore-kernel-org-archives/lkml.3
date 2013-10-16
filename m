Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab3JPHJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:09:15 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48727 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab3JPHJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 03:09:12 -0400
Message-ID: <525E3A86.205@linux.vnet.ibm.com>
Date: Wed, 16 Oct 2013 12:34:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, Andrew Lunn <andrew@lunn.ch>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: cpufreq-next opps with cpufreq-bench
References: <20131013090159.GB24566@lunn.ch>	<20131013211436.GB24927@lunn.ch> <20131013214547.GC24927@lunn.ch>	<2502389.2uE805jDh9@vostro.rjw.lan> <CAKohponEEagXGYOXYXrAqdDJn23Po6=sVhpZEO_+Sta8MUY-XA@mail.gmail.com>
In-Reply-To: <CAKohponEEagXGYOXYXrAqdDJn23Po6=sVhpZEO_+Sta8MUY-XA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101607-5140-0000-0000-000003FE476C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 09:49 AM, Viresh Kumar wrote:
> On 16/10/2013, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> Well, I've dropped the offending commit from my queue.  Hopefully, it still
>> builds on all targets it used to build on.
> 
> Thanks!!
> 
> I tried to reproduce it 2 days back and my laptop was almost completely
> discharged and I have left my charger at a friends place last week :(
> So couldn't really do anything until then.. Got my charger today and so
> coming back on this..
> 
> I couldn't run and find cpufreq-bench on ubuntu (Is it available?)..
> But I think I have found the problem..
> 
> @Andrew: Can you give this a try please? (Use attached commit)..
> 
> commit 0c5d6493fe02606512e94fad3ea075bc4f56b7e7
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Wed Oct 16 09:39:18 2013 +0530
> 
>     cpufreq: Use correct rwsem in cpufreq_set_policy()
> 
>     Recent commit "cpufreq: create per policy rwsem instead of per CPU
>     cpu_policy_rwsem" introduced a bug where kernel crashes when we run
>     cpufreq-bench. Crash looks like this:
> 
>     Unable to handle kernel NULL pointer dereference at virtual address 00000000
>     pgd = cfa60000
>     [00000000] *pgd=0d7c9831, *pte=00000000, *ppte=00000000
>     Internal error: Oops: 17 [#1] PREEMPT ARM
>     Modules linked in:
>     CPU: 0 PID: 2427 Comm: cpufreq-bench Not tainted
> 3.12.0-rc4-00708-g1546af5 #86
>     task: cfa98e60 ti: ce58a000 task.ti: ce58a000
>     PC is at wake_up_process+0xc/0x48
>     LR is at __up_write+0x158/0x164
>     pc : [<c0040a14>]    lr : [<c0209630>]    psr: 60000093
>     sp : ce58bd90  ip : ce58bda8  fp : ce58bda4
>     r10: cfb3aa28  r9 : ce58bea8  r8 : ce58beb8
>     r7 : ce58beac  r6 : 00000000  r5 : cfb3a9c0  r4 : ce58be10
>     r3 : cfb3aa5c  r2 : cfb3aa5c  r1 : 00000000  r0 : 00000000
>     Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
>     Control: 0005397f  Table: 0fa60000  DAC: 00000015
>     Process cpufreq-bench (pid: 2427, stack limit = 0xce58a1c0)
>     Stack: (0xce58bd90 to 0xce58c000)
> 
>     <snip>
> 
>     Backtrace:
>     [<c0040a08>] (wake_up_process+0x0/0x48) from [<c0209630>]
> (__up_write+0x158/0x164)
>      r5:cfb3a9c0 r4:ce58be10
>     [<c02094d8>] (__up_write+0x0/0x164) from [<c0039fe8>] (up_write+0x10/0x14)
>     [<c0039fd8>] (up_write+0x0/0x14) from [<c03578a0>]
> (cpufreq_set_policy+0x120/0x1cc)
>     [<c0357780>] (cpufreq_set_policy+0x0/0x1cc) from [<c0358efc>]
> (store_scaling_governor+0xac/0x1a4)
>      r7:0000000b r6:00000000 r5:ce58be10 r4:cfb3a9c0
>     [<c0358e50>] (store_scaling_governor+0x0/0x1a4) from [<c03576e8>]
> (store+0x88/0xa4)
>      r8:c04d6e3c r7:cfae6a80 r6:ce58bf78 r5:cfb3a9c0 r4:cfb3aa58
>     [<c0357660>] (store+0x0/0xa4) from [<c011a078>]
> (sysfs_write_file+0x108/0x188)
>      r5:cfa12f58 r4:cfa12f40
>     [<c0119f70>] (sysfs_write_file+0x0/0x188) from [<c00bb340>]
> (vfs_write+0xcc/0x198)
>     [<c00bb274>] (vfs_write+0x0/0x198) from [<c00bb4f0>] (SyS_write+0x4c/0x78)
>     [<c00bb4a4>] (SyS_write+0x0/0x78) from [<c0009480>]
> (ret_fast_syscall+0x0/0x2c)
>      r8:c00095e4 r7:00000004 r6:bedcfaf0 r5:00000006 r4:0000000b
>     Code: e89da800 e1a0c00d e92dd830 e24cb004 (e5903000)
>     ---[ end trace a412cb5cfd5edab9 ]---
>     note: cpufreq-bench[2427] exited with preempt_count 1
> 
>     This happened because we used rwsem of new policy structure instead of the
>     existing one. And that one was never initialized.
>

Hmm, so the problem is that we lock one policy structure in store() whereas we
unlock a totally different one in __cpufreq_set_policy(). I would have expected
lockdep to complain about this before we hit the NULL pointer dereference.
Andrew, can you enable lockdep on your system and confirm this please, just to
be sure?

And in the previous locking design, since the policy structure was per-cpu,
it wouldn't cause this problem because, as long as the cpu parameter passed
was the same, both the lock and unlock operations would happen on the same
policy structure.

The fix looks good to me.

Regards,
Srivatsa S. Bhat

 
>     Reported-by: Andrew Lunn <andrew@lunn.ch>
>     Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/cpufreq.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 8a3914b..5c9be08 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1902,10 +1902,10 @@ static int cpufreq_set_policy(struct
> cpufreq_policy *policy,
>                         /* end old governor */
>                         if (policy->governor) {
>                                 __cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> -                               up_write(&new_policy->rwsem);
> +                               up_write(&policy->rwsem);
>                                 __cpufreq_governor(policy,
>                                                 CPUFREQ_GOV_POLICY_EXIT);
> -                               down_write(&new_policy->rwsem);
> +                               down_write(&policy->rwsem);
>                         }
> 
>                         /* start new governor */
> @@ -1914,10 +1914,10 @@ static int cpufreq_set_policy(struct
> cpufreq_policy *policy,
>                                 if (!__cpufreq_governor(policy,
> CPUFREQ_GOV_START)) {
>                                         failed = 0;
>                                 } else {
> -                                       up_write(&new_policy->rwsem);
> +                                       up_write(&policy->rwsem);
>                                         __cpufreq_governor(policy,
> 
> CPUFREQ_GOV_POLICY_EXIT);
> -                                       down_write(&new_policy->rwsem);
> +                                       down_write(&policy->rwsem);
>                                 }
>                         }
> 

