Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaKYV14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:27:56 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:54029 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaKYV1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:27:51 -0500
MIME-Version: 1.0
In-Reply-To: <20141125180159.GI5050@linux.vnet.ibm.com>
References: <CAMuHMdXaaa2t6+sH2egGacVxkAPeTUkAgwdYsOnMnEPnuLdB5Q@mail.gmail.com>
	<545BE1DE.6060900@linaro.org>
	<CAMuHMdXQr65g4He0D0ZRN923OJ2A7WNgwbiTru_1dGWnvbvCJA@mail.gmail.com>
	<CAMuHMdUjYMC8i2F9n6fWdPBOQVSohKA3ZxJJyq8h808Z9tEypw@mail.gmail.com>
	<20141125180159.GI5050@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2014 22:27:49 +0100
X-Google-Sender-Auth: kknSELODxIGB8bBqxU98n77j7PI
Message-ID: <CAMuHMdUMpmdYe+ED=M8FVvMMWNmrs8o4WzQ-uc2nFHNdL99HNQ@mail.gmail.com>
Subject: Re: (bisected) Lock up on sh73a0/kzm9g on cpuidle initialization
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Nov 25, 2014 at 7:01 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Nov 25, 2014 at 06:49:16PM +0100, Geert Uytterhoeven wrote:
>> On Fri, Nov 7, 2014 at 8:59 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > On Thu, Nov 6, 2014 at 10:02 PM, Daniel Lezcano
>> > <daniel.lezcano@linaro.org> wrote:
>> >> On 11/06/2014 09:38 PM, Geert Uytterhoeven wrote:
>> >>> When CONFIG_CPU_IDLE=y, the kernel locks up during cpuidle initialization
>> >>> on Renesas sh73a0/kzm9g-reference, which has a dual-core Cortex-A9.
>> >>>
>> >>> Last message is:
>> >>>
>> >>>      DMA: preallocated 256 KiB pool for atomic coherent allocations
>> >>>
>> >>> After this it's supposed to print:
>> >>>
>> >>>      cpuidle: using governor ladder
>> >>>      cpuidle: using governor menu
>> >>>
>> >>> I've bisected this to commit 442bf3aaf55a91ebfec71da46a4ee10a3c905bcc
>> >>> ("sched: Let the scheduler see CPU idle states").
>> >>>
>> >>> Reverting that commit, and commit 83a0a96a5f26d974580fd7251043ff70c8f1823d
>> >>> ("sched/fair: Leverage the idle state info when choosing the "idlest"
>> >>> cpu") which
>> >>> depends on it, fixes the problem.
>> >>>
>> >>> I saw the discussion "lockdep splat in CPU hotplug", so I enabled lockdep
>> >>> debugging, but didn't see a lockdep splat.
>> >>
>> >> Did you try the fix attached ?
>> >>
>> >> https://lkml.org/lkml/2014/10/22/722
>> >
>> > Thanks, I didn't try that.
>> >
>> > However, this patch seems to be in v3.18-rc3, so I'm already using it.
>> > Hence it doesn't fix the problem for me.
>> >
>> > On another board, with a dual Cortex-A15, the problem doesn't show up.
>>
>> This problem (regression introduced in v3.18-rc1) is still present in v3.18-rc6.
>>
>> I did some more investigations, and it's hanging in the call to
>> synchronize_rcu() in cpuidle_uninstall_idle_handler(), which was added in
>> commit 442bf3aaf55a91ebfec71da46a4ee10a3c905bcc.
>> More specificailly, it's blocked on the wait_for_completion(&rcu.completion)
>> in kernel/rcu/update.c:void wait_rcu_gp(call_rcu_func_t crf).
>
> You didn't disable RCU CPU stall warnings, did you?  If you did, please
> re-enable them, as the stall warning messages will likely help to debug
> this.  The soft-lockup checks can also be quite valuable.
>
> If you haven't run with CONFIG_PROVE_RCU=y, please try that.  For example,
> if you have CONFIG_PREEMPT=y and you do synchronize_rcu() from within
> an RCU read-side critical section (don't do that, it will hang!!!),
> then you will get a lockdep splat.
>
> Does any sort of system activity (keyboard, network, etc.) unstick the
> system?

Thanks! Unfortunately none of the above helped.

However, I found the culprit. It turned out to be a platform issue, not an
issue in the generic cpu idle or RCU code. Read on below if you're
interested in the gory details. Else just skip, and sleep well again tonight ;-)

> If you have tried all those things without good effect, could you please
> send along your .config and an alt-sysrq-t dump of all tasks' stacks?

As I didn't manage to trigger a sysrq dump over the serial console,
I just called __handle_sysrq() right before the wait_for_completion(), after
a small delay. The dump didn't show anything suspicious. Everything
looked the same as on the dual-core Cortex A15, where the problem
doesn't manifest.

Then I noticed the sched debug output on the A15, which was missing
on the CA9 build. Enabling it on the A9 gave:

Sched Debug Version: v0.11,
3.18.0-rc6-kzm9g-reference-04913-gedc89a2a2059c7ff-dirty #101
ktime                                   : 0.000000
sched_clk                               : 0.000000
cpu_clk                                 : 0.000000
jiffies                                 : 4294928896

Oops, time is not advancing?

Dmesg also shows (early):

    clocksource_of_init: no matching clocksources found

and the timer is only initialized much later, after cpu idle initialization:

    sh_cmt e6138000.timer: ch0: used for periodic clock events

Hacking up a timer node for "arm,cortex-a9-twd-timer" in sh73a0.dtsi
(with some "guessed" values) made it work.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
