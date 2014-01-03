Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbaACXkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 18:40:01 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:53523 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbaACXj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:39:57 -0500
Date: Fri, 3 Jan 2014 15:10:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Jane Li <jiel@marvell.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] cpufreq: Fix timer/workqueue corruption by protecting
 reading governor_enabled
Message-ID: <20140103231023.GC13489@core.coreip.homeip.net>
References: <1388740661-15011-1-git-send-email-jiel@marvell.com>
 <CAKohpo=osvNc0rKEsawCE9nggCQdGr7bgT+D8=KhkgpnAyXXaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=osvNc0rKEsawCE9nggCQdGr7bgT+D8=KhkgpnAyXXaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 03:40:16PM +0530, Viresh Kumar wrote:
> On 3 January 2014 14:47,  <jiel@marvell.com> wrote:
> > From: Jane Li <jiel@marvell.com>
> >
> > When a CPU is hot removed we'll cancel all the delayed work items via
> > gov_cancel_work(). Sometimes the delayed work function determines that
> > it should adjust the delay for all other CPUs that the policy is
> > managing. If this scenario occurs, the canceling CPU will cancel its own
> > work but queue up the other CPUs works to run.
> >
> > Commit 3617f2(cpufreq: Fix timer/workqueue corruption due to double
> > queueing) has tried to fix this, but reading governor_enabled is not
> > protected by cpufreq_governor_lock. Even though od_dbs_timer() checks
> > governor_enabled before gov_queue_work(), this scenario may occur. For
> > example:
> >
> >  CPU0                                        CPU1
> >  ----                                        ----
> >  cpu_down()
> >   ...                                        <work runs>
> >   __cpufreq_remove_dev()                     od_dbs_timer()
> >    __cpufreq_governor()                       policy->governor_enabled
> >     policy->governor_enabled = false;
> >     cpufreq_governor_dbs()
> >      case CPUFREQ_GOV_STOP:
> >       gov_cancel_work(dbs_data, policy);
> >        cpu0 work is canceled
> >         timer is canceled
> >         cpu1 work is canceled
> >         <waits for cpu1>
> >                                               gov_queue_work(*, *, true);
> >                                                cpu0 work queued
> >                                                cpu1 work queued
> >                                                cpu2 work queued
> >                                                ...
> >         cpu1 work is canceled
> >         cpu2 work is canceled
> >         ...
> >
> > At the end of the GOV_STOP case cpu0 still has a work queued to
> > run although the code is expecting all of the works to be
> > canceled. __cpufreq_remove_dev() will then proceed to
> > re-initialize all the other CPUs works except for the CPU that is
> > going down. The CPUFREQ_GOV_START case in cpufreq_governor_dbs()
> > will trample over the queued work and debugobjects will spit out
> > a warning:
> >
> > WARNING: at lib/debugobjects.c:260 debug_print_object+0x94/0xbc()
> > ODEBUG: init active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x14
> > Modules linked in:
> > CPU: 1 PID: 1205 Comm: sh Tainted: G        W    3.10.0 #200
> > [<c01144f0>] (unwind_backtrace+0x0/0xf8) from [<c0111d98>] (show_stack+0x10/0x14)
> > [<c0111d98>] (show_stack+0x10/0x14) from [<c01272cc>] (warn_slowpath_common+0x4c/0x68)
> > [<c01272cc>] (warn_slowpath_common+0x4c/0x68) from [<c012737c>] (warn_slowpath_fmt+0x30/0x40)
> > [<c012737c>] (warn_slowpath_fmt+0x30/0x40) from [<c034c640>] (debug_print_object+0x94/0xbc)
> > [<c034c640>] (debug_print_object+0x94/0xbc) from [<c034c7f8>] (__debug_object_init+0xc8/0x3c0)
> > [<c034c7f8>] (__debug_object_init+0xc8/0x3c0) from [<c01360e0>] (init_timer_key+0x20/0x104)
> > [<c01360e0>] (init_timer_key+0x20/0x104) from [<c04872ac>] (cpufreq_governor_dbs+0x1dc/0x68c)
> > [<c04872ac>] (cpufreq_governor_dbs+0x1dc/0x68c) from [<c04833a8>] (__cpufreq_governor+0x80/0x1b0)
> > [<c04833a8>] (__cpufreq_governor+0x80/0x1b0) from [<c0483704>] (__cpufreq_remove_dev.isra.12+0x22c/0x380)
> > [<c0483704>] (__cpufreq_remove_dev.isra.12+0x22c/0x380) from [<c0692f38>] (cpufreq_cpu_callback+0x48/0x5c)
> > [<c0692f38>] (cpufreq_cpu_callback+0x48/0x5c) from [<c014fb40>] (notifier_call_chain+0x44/0x84)
> > [<c014fb40>] (notifier_call_chain+0x44/0x84) from [<c012ae44>] (__cpu_notify+0x2c/0x48)
> > [<c012ae44>] (__cpu_notify+0x2c/0x48) from [<c068dd40>] (_cpu_down+0x80/0x258)
> > [<c068dd40>] (_cpu_down+0x80/0x258) from [<c068df40>] (cpu_down+0x28/0x3c)
> > [<c068df40>] (cpu_down+0x28/0x3c) from [<c068e4c0>] (store_online+0x30/0x74)
> > [<c068e4c0>] (store_online+0x30/0x74) from [<c03a7308>] (dev_attr_store+0x18/0x24)
> > [<c03a7308>] (dev_attr_store+0x18/0x24) from [<c0256fe0>] (sysfs_write_file+0x100/0x180)
> > [<c0256fe0>] (sysfs_write_file+0x100/0x180) from [<c01fec9c>] (vfs_write+0xbc/0x184)
> > [<c01fec9c>] (vfs_write+0xbc/0x184) from [<c01ff034>] (SyS_write+0x40/0x68)
> > [<c01ff034>] (SyS_write+0x40/0x68) from [<c010e200>] (ret_fast_syscall+0x0/0x48)
> >
> > In gov_queue_work(), lock cpufreq_governor_lock before gov_queue_work,
> > and unlock it after __gov_queue_work(). In this way, governor_enabled
> > is guaranteed not changed in gov_queue_work().
> >
> > Signed-off-by: Jane Li <jiel@marvell.com>
> > ---
> >  drivers/cpufreq/cpufreq.c          |    2 +-
> >  drivers/cpufreq/cpufreq_governor.c |    6 +++++-
> >  drivers/cpufreq/cpufreq_governor.h |    2 ++
> >  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

-- 
Dmitry
