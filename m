Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbaGQX1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 19:27:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47712 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbaGQX1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 19:27:35 -0400
Message-ID: <53C85BE5.6030901@codeaurora.org>
Date: Thu, 17 Jul 2014 16:27:33 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@deeprootsystems.com>, Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] PM / OPP: cpufreq: Avoid sleeping while atomic
References: <1405553740-5067-1-git-send-email-sboyd@codeaurora.org> <CAKohpond9aNvX+x--G7AADkRhAu1iZ5mFW8pDvAXJ6yp_CCH_A@mail.gmail.com>
In-Reply-To: <CAKohpond9aNvX+x--G7AADkRhAu1iZ5mFW8pDvAXJ6yp_CCH_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/14 22:26, Viresh Kumar wrote:
> On 17 July 2014 05:05, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> We allocate the cpufreq table after calling rcu_read_lock(),
>> which disables preemption. This causes scheduling while atomic
>> warnings. Use GFP_ATOMIC instead of GFP_KERNEL and update for
>> kcalloc while we're here.
> I am surprised to see that this isn't reported by anybody since the time
> it came into existence? Some special config option required to observe
> this?

First you need to enable sleeping while atomic checking, but in reality,
I assume nobody has tried inserting a cpufreq driver as a module. The
might_sleep() code has a check to see if the system_state is
SYSTEM_RUNNING. If it isn't running then there isn't a warning and
might_sleep() doesn't flag any problem. I wonder if that is actually the
right thing to do though? Perhaps the intention of that code is to skip
warning early on in the boot path when the scheduler isn't up and
running yet. But once the scheduler is running (which is fairly early
nowadays) I would think we want might_sleep() to trigger warnings. Maybe
that check in might_sleep() needs to be updated to check for "scheduler
running" instead of "system running"?

>
>> BUG: sleeping function called from invalid context at mm/slub.c:1246
>> in_atomic(): 0, irqs_disabled(): 0, pid: 80, name: modprobe
>> 5 locks held by modprobe/80:
>>  #0:  (&dev->mutex){......}, at: [<c050d484>] __driver_attach+0x48/0x98
>>  #1:  (&dev->mutex){......}, at: [<c050d494>] __driver_attach+0x58/0x98
>>  #2:  (subsys mutex#5){+.+.+.}, at: [<c050c114>] subsys_interface_register+0x38/0xc8
>>  #3:  (cpufreq_rwsem){.+.+.+}, at: [<c05a9c8c>] __cpufreq_add_dev.isra.22+0x84/0x92c
>>  #4:  (rcu_read_lock){......}, at: [<c05ab24c>] dev_pm_opp_init_cpufreq_table+0x18/0x10c
>> Preemption disabled at:[<  (null)>]   (null)
>>
>> CPU: 2 PID: 80 Comm: modprobe Not tainted 3.16.0-rc3-next-20140701-00035-g286857f216aa-dirty #217
>> [<c0214da8>] (unwind_backtrace) from [<c02123f8>] (show_stack+0x10/0x14)
>> [<c02123f8>] (show_stack) from [<c070141c>] (dump_stack+0x70/0xbc)
>> [<c070141c>] (dump_stack) from [<c02f4cb0>] (__kmalloc+0x124/0x250)
>> [<c02f4cb0>] (__kmalloc) from [<c05ab270>] (dev_pm_opp_init_cpufreq_table+0x3c/0x10c)
>> [<c05ab270>] (dev_pm_opp_init_cpufreq_table) from [<bf000508>] (cpufreq_init+0x48/0x378 [cpufreq_generic])
>> [<bf000508>] (cpufreq_init [cpufreq_generic]) from [<c05a9e08>] (__cpufreq_add_dev.isra.22+0x200/0x92c)
>> [<c05a9e08>] (__cpufreq_add_dev.isra.22) from [<c050c160>] (subsys_interface_register+0x84/0xc8)
>> [<c050c160>] (subsys_interface_register) from [<c05a9494>] (cpufreq_register_driver+0x108/0x2d8)
>> [<c05a9494>] (cpufreq_register_driver) from [<bf000888>] (generic_cpufreq_probe+0x50/0x74 [cpufreq_generic])
>> [<bf000888>] (generic_cpufreq_probe [cpufreq_generic]) from [<c050e994>] (platform_drv_probe+0x18/0x48)
>> [<c050e994>] (platform_drv_probe) from [<c050d1f4>] (driver_probe_device+0x128/0x370)
>> [<c050d1f4>] (driver_probe_device) from [<c050d4d0>] (__driver_attach+0x94/0x98)
>> [<c050d4d0>] (__driver_attach) from [<c050b778>] (bus_for_each_dev+0x54/0x88)
>> [<c050b778>] (bus_for_each_dev) from [<c050c894>] (bus_add_driver+0xe8/0x204)
>> [<c050c894>] (bus_add_driver) from [<c050dd48>] (driver_register+0x78/0xf4)
>> [<c050dd48>] (driver_register) from [<c0208870>] (do_one_initcall+0xac/0x1d8)
>> [<c0208870>] (do_one_initcall) from [<c028b6b4>] (load_module+0x190c/0x21e8)
>> [<c028b6b4>] (load_module) from [<c028c034>] (SyS_init_module+0xa4/0x110)
>> [<c028c034>] (SyS_init_module) from [<c020f0c0>] (ret_fast_syscall+0x0/0x48)
>>
>> Fixes: a0dd7b79657b "PM / OPP: Move cpufreq specific OPP functions out of generic OPP library"
> That looks to be wrong. This commit just moved things around and I can still
> see rcu_read_lock() before this commit.
>

Right. It seems that we moved to RCU in commit
0f5c890e9b9754d9aa5bf6ae2fc00cae65780d23 so the real Fixes line should be:

Fixes: 0f5c890e9b97 "PM / OPP: Remove cpufreq wrapper dependency on
internal data organization"

One way to avoid this problem is to put things back the way they were
before that change. Is there any real benefit to having this code live
in drivers/cpufreq/ instead of just under some config option in
drivers/base/power/opp.c?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

