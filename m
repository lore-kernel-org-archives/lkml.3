Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3A3Kor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 05:44:47 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61538 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754149Ab3A3Kon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 05:44:43 -0500
Date: Wed, 30 Jan 2013 11:44:32 +0100
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        josephl@nvidia.com, swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org
Subject: Re: [PATCH 2/5] cpufreq: star/stop cpufreq timers on cpu hotplug
Message-ID: <20130130104432.GB32315@balto.lan>
References: <1356620142-8680-1-git-send-email-fabio.baltieri@linaro.org>
 <1356620142-8680-3-git-send-email-fabio.baltieri@linaro.org>
 <CAOh2x=mjNbSbGrirOOddE-Kitj7MqtDXiwb6rSo8UWQK4wzJvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOh2x=mjNbSbGrirOOddE-Kitj7MqtDXiwb6rSo8UWQK4wzJvw@mail.gmail.com>
X-Operating-System: Linux balto 3.8.0-rc3-00668-g55706d3 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

On Wed, Jan 30, 2013 at 10:22:37AM +0530, Viresh Kumar wrote:
> Hi Fabio,
> 
> Sorry for waking up very late :)
> 
> The reason why i am starting this thread again is due to problem
> reported by Joseph,
> with latest linux-next/master branch (which contains few big patches
> from me :) ):
> 
> Reboot is giving following to him:
> 
> * Will now halt
> [ 193.756068] Disabling non-boot CPUs...
> [ 193.760088] BUG: scheduling while atomic: halt/780/0x00000002
> [ 193.765845] Modules linked in: brcmfmac brcmutil
> [ 193.770613] [<c0014990>] (unwind_backtrace+0x0/0xf8) from [<c0049510>]
> (__schedule_bug+0x44/0x5c)
> [ 193.779548] [<c0049510>] (__schedule_bug+0x44/0x5c) from [<c04fa320>]
> (__schedule+0x688/0x6ec)
> [ 193.788206] [<c04fa320>] (__schedule+0x688/0x6ec) from [<c04fa75c>]
> (schedule_preempt_disabled+0x24/0x34)
> [ 193.797811] [<c04fa75c>] (schedule_preempt_disabled+0x24/0x34) from
> [<c04f916c>] (__mutex_lock_slowpath+0x170/0x34c)
> [ 193.808367] [<c04f916c>] (__mutex_lock_slowpath+0x170/0x34c) from
> [<c04f9354>] (mutex_lock+0xc/0x24)
> [ 193.817554] [<c04f9354>] (mutex_lock+0xc/0x24) from [<c04f1cdc>]
> (unregister_cpu_notifier+0xc/0x24)
> [ 193.826640] [<c04f1cdc>] (unregister_cpu_notifier+0xc/0x24) from
> [<c033a8a4>] (cpufreq_governor_dbs+0x118/0x614)
> [ 193.836866] [<c033a8a4>] (cpufreq_governor_dbs+0x118/0x614) from
> [<c033747c>] (__cpufreq_governor+0x58/0xc0)
> [ 193.846737] [<c033747c>] (__cpufreq_governor+0x58/0xc0) from
> [<c0339104>] (__cpufreq_remove_dev.clone.7+0x58/0x320)
> [ 193.857207] [<c0339104>] (__cpufreq_remove_dev.clone.7+0x58/0x320)
> from [<c04f7958>] (cpufreq_cpu_callback+0x8c/0x9c)
> [ 193.867850] [<c04f7958>] (cpufreq_cpu_callback+0x8c/0x9c) from
> [<c0044f4c>] (notifier_call_chain+0x44/0x84)
> [ 193.877623] [<c0044f4c>] (notifier_call_chain+0x44/0x84) from
> [<c0026e24>] (__cpu_notify+0x2c/0x48)
> [ 193.886704] [<c0026e24>] (__cpu_notify+0x2c/0x48) from [<c04f1b08>]
> (_cpu_down+0xb0/0x23c)
> [ 193.895004] [<c04f1b08>] (_cpu_down+0xb0/0x23c) from [<c00270ec>]
> (disable_nonboot_cpus+0x68/0x104)
> [ 193.904089] [<c00270ec>] (disable_nonboot_cpus+0x68/0x104) from
> [<c0034fbc>] (kernel_power_off+0x24/0x48)
> [ 193.913688] [<c0034fbc>] (kernel_power_off+0x24/0x48) from
> [<c0035810>] (sys_reboot+0x104/0x1e0)
> [ 193.922517] [<c0035810>] (sys_reboot+0x104/0x1e0) from [<c000e520>]
> (ret_fast_syscall+0x0/0x30)
> 
> 
> And the crash log show this patch of yours somewhere :)

It looks like the two patches clashed togher quite badly... :-)

On Wed, Jan 30, 2013 at 10:22:37AM +0530, Viresh Kumar wrote:
[...]
> First question: Is this patch still required? Because following patch
> from me is
> sending a STOP/START to governors on cpu hot-[un]plug ?
> 
> commit dbcb63407c095af73f3464767e00902cdee55e8b
> Author: Viresh Kumar <viresh.kumar@linaro.org>
> Date:   Sat Jan 12 05:14:39 2013 +0000
> 
>     cpufreq: Notify governors when cpus are hot-[un]plugged
> 
> For me, the answer is NO.

I confirm that your patch handles correctly the problem solved by this
one so I agree on dropping mine.

Rafael, this is screwing up a bit on bisection for cpu hotplug problems
so I'm sending a v7 with the cleanup on first patch and this one
dropped if you are ok with rebasing your pm-cpufreq-next.  Let me know
if you prefer me to just send a revert + cleanup patch instead.

Thanks,
Fabio

-- 
Fabio Baltieri
