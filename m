Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbaCFAvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:51:15 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57433 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754865AbaCFAvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:51:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: skannan@codeaurora.org, linaro-kernel@lists.linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH V2 3/3] cpufreq: initialize governor for a new policy under policy->rwsem
Date: Thu, 06 Mar 2014 02:06:25 +0100
Message-ID: <1571634.sBIk9PhU1o@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1892466.Txf61ZRumM@vostro.rjw.lan>
References: <98b7ae22d936456bf830aa749556a115969cfa47.1393904428.git.viresh.kumar@linaro.org> <2f6efe0c9058f64212ee220a1b386e04ba415686.1393904428.git.viresh.kumar@linaro.org> <1892466.Txf61ZRumM@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 06, 2014 02:04:39 AM Rafael J. Wysocki wrote:
> On Tuesday, March 04, 2014 11:44:01 AM Viresh Kumar wrote:
> > policy->rwsem is used to lock access to all parts of code modifying struct
> > cpufreq_policy but wasn't used on a new policy created from __cpufreq_add_dev().
> > 
> > Because of which if we call cpufreq_update_policy() repeatedly on one CPU and do
> > offline/online of another CPU then we might see these crashes:
> > 
> > Unable to handle kernel NULL pointer dereference at virtual address 00000020
> > pgd = c0003000
> > [00000020] *pgd=80000000004003, *pmd=00000000
> > Internal error: Oops: 206 [#1] PREEMPT SMP ARM
> > 
> > PC is at __cpufreq_governor+0x10/0x1ac
> > LR is at cpufreq_update_policy+0x114/0x150
> > 
> > ---[ end trace f23a8defea6cd706 ]---
> > Kernel panic - not syncing: Fatal exception
> > CPU0: stopping
> > CPU: 0 PID: 7136 Comm: mpdecision Tainted: G      D W    3.10.0-gd727407-00074-g979ede8 #396
> > 
> > [<c0afe180>] (notifier_call_chain+0x40/0x68) from [<c02a23ac>] (__blocking_notifier_call_chain+0x40/0x58)
> > [<c02a23ac>] (__blocking_notifier_call_chain+0x40/0x58) from [<c02a23d8>] (blocking_notifier_call_chain+0x14/0x1c)
> > [<c02a23d8>] (blocking_notifier_call_chain+0x14/0x1c) from [<c0803c68>] (cpufreq_set_policy+0xd4/0x2b8)
> > [<c0803c68>] (cpufreq_set_policy+0xd4/0x2b8) from [<c0803e7c>] (cpufreq_init_policy+0x30/0x98)
> > [<c0803e7c>] (cpufreq_init_policy+0x30/0x98) from [<c0805a18>] (__cpufreq_add_dev.isra.17+0x4dc/0x7a4)
> > [<c0805a18>] (__cpufreq_add_dev.isra.17+0x4dc/0x7a4) from [<c0805d38>] (cpufreq_cpu_callback+0x58/0x84)
> > [<c0805d38>] (cpufreq_cpu_callback+0x58/0x84) from [<c0afe180>] (notifier_call_chain+0x40/0x68)
> > [<c0afe180>] (notifier_call_chain+0x40/0x68) from [<c02812dc>] (__cpu_notify+0x28/0x44)
> > [<c02812dc>] (__cpu_notify+0x28/0x44) from [<c0aeed90>] (_cpu_up+0xf4/0x1dc)
> > [<c0aeed90>] (_cpu_up+0xf4/0x1dc) from [<c0aeeed4>] (cpu_up+0x5c/0x78)
> > [<c0aeeed4>] (cpu_up+0x5c/0x78) from [<c0aec808>] (store_online+0x44/0x74)
> > [<c0aec808>] (store_online+0x44/0x74) from [<c03a40f4>] (sysfs_write_file+0x108/0x14c)
> > [<c03a40f4>] (sysfs_write_file+0x108/0x14c) from [<c03517d4>] (vfs_write+0xd0/0x180)
> > [<c03517d4>] (vfs_write+0xd0/0x180) from [<c0351ca8>] (SyS_write+0x38/0x68)
> > [<c0351ca8>] (SyS_write+0x38/0x68) from [<c0205de0>] (ret_fast_syscall+0x0/0x30)
> > 
> > Fix these by taking locks at appropriate places in __cpufreq_add_dev() as well.
> > 
> > Reported-by: Saravana Kannan <skannan@codeaurora.org>
> > Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> 
> I've rebased this one on top of 3.14-rc5 and queued it up for 3.14-rc6.
> 
> Please check the bleeding-edge branch for the result.

Actually, I think I'll queue up [2-3/3] for 3.14-rc6 instead.

> 
> > ---
> > V1->V2: No change
> > 
> >  drivers/cpufreq/cpufreq.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 3c6f9a5..e2a1e67 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -1128,6 +1128,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
> >  		policy->user_policy.max = policy->max;
> >  	}
> >  
> > +	down_write(&policy->rwsem);
> >  	write_lock_irqsave(&cpufreq_driver_lock, flags);
> >  	for_each_cpu(j, policy->cpus)
> >  		per_cpu(cpufreq_cpu_data, j) = policy;
> > @@ -1202,6 +1203,7 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
> >  		policy->user_policy.policy = policy->policy;
> >  		policy->user_policy.governor = policy->governor;
> >  	}
> > +	up_write(&policy->rwsem);
> >  
> >  	kobject_uevent(&policy->kobj, KOBJ_ADD);
> >  	up_read(&cpufreq_rwsem);
> > 
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
