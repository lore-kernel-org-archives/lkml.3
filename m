Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3HAUhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:37:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51046 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3HAUhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:37:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH] cpufreq: Do not hold driver module references for additional policy CPUs
Date: Thu, 01 Aug 2013 22:47:32 +0200
Message-ID: <1757496.qSuJuAun9Z@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51FAC46D.1000703@linux.vnet.ibm.com>
References: <2362640.pUofnXyzOi@vostro.rjw.lan> <31284072.zAs57d3QXU@vostro.rjw.lan> <51FAC46D.1000703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 01:56:21 AM Srivatsa S. Bhat wrote:
> On 08/02/2013 01:34 AM, Rafael J. Wysocki wrote:
> > On Friday, August 02, 2013 12:51:24 AM Srivatsa S. Bhat wrote:
> >> On 08/02/2013 12:51 AM, Rafael J. Wysocki wrote:
> >>> On Friday, August 02, 2013 12:31:23 AM Srivatsa S. Bhat wrote:
> >>>> On 08/02/2013 12:31 AM, Rafael J. Wysocki wrote:
> >>>>> On Thursday, August 01, 2013 11:36:49 PM Srivatsa S. Bhat wrote:
> >>>>>> Its the cpufreq_cpu_get() hidden away in cpufreq_add_dev_symlink(). With
> >>>>>> that taken care of, everything should be OK. Then we can change the
> >>>>>> synchronization part to avoid using refcounts.
> >>>>>
> >>>>> So I actually don't see why cpufreq_add_dev_symlink() needs to call
> >>>>> cpufreq_cpu_get() at all, since the policy refcount is already 1 at the
> >>>>> point it is called and the bumping up of the driver module refcount is
> >>>>> pointless.
> >>>>>
> >>>>
> >>>> Hmm, yes, it seems so.
> >>>>
> >>>>> However, if I change that I also need to change the piece of code that
> >>>>> calls the complementary cpufreq_cpu_put() and I kind of cannot find it.
> >>>>>
> >>>>
> >>>> ... I guess that's because you are looking at the code with your patch
> >>>> applied (and your patch removed that _put()) ;-)
> >>>
> >>> No, it's not that one.  That one was complementary to the cpufreq_cpu_get()
> >>> done by cpufreq_add_policy_cpu() before my patch.  Since my patch changes
> >>> cpufreq_add_policy_cpu() to call cpufreq_cpu_put() before returning and
> >>> bump up the policy refcount with kobject_get(), the one in
> >>> __cpufreq_remove_dev() is changed into kobject_put() (correctly, IMO).
> >>>
> >>> What gives?
> >>>
> >>
> >> Actually, it _is_ the one I pointed above. This thing is tricky, here's why:
> >>
> >> cpufreq_add_policy_cpu() is called only if:
> >> a. The CPU being onlined has per_cpu(cpufreq_cpu_data, cpu) == NULL
> >> and 
> >> b. Its is present in some CPU's related_cpus mask. 
> >>
> >> If condition (a) doesn't hold good, you get out right in the beginning of
> >> __cpufreq_add_dev().
> >>
> >> So, cpufreq_add_policy_cpu() is called very rarely because, inside
> >> __cpufreq_add_dev we do:
> >>
> >> 1093         write_lock_irqsave(&cpufreq_driver_lock, flags);
> >> 1094         for_each_cpu(j, policy->cpus) {
> >> 1095                 per_cpu(cpufreq_cpu_data, j) = policy;
> >> 1096                 per_cpu(cpufreq_policy_cpu, j) = policy->cpu;
> >> 1097         }
> >> 1098         write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> >>
> >> So for all the CPUs in the above policy->cpus mask, we simply return
> >> without further ado when they are onlined. In particular, we *dont* call
> >> cpufreq_add_policy_cpu() for any of them.
> >>
> >> And their refcounts are incremented by the cpufreq_add_dev_interface()->
> >> cpufreq_add_dev_symlink() function.
> >>
> >> So, ultimately, we increment the refcount for a given non-policy-owner CPU
> >> only once. *Either* in cpufreq_add_dev_symlink() *or* in cpufreq_add_policy_cpu(),
> >> but never both.
> >>
> >> So, in the teardown path, __cpufreq_remove_dev() needs only one place to
> >> decrement it as shown below:
> >>
> >> 1303         } else {
> >> 1304 
> >> 1305                 if (!frozen) {
> >> 1306                         pr_debug("%s: removing link, cpu: %d\n", __func__, cpu);
> >> 1307                         cpufreq_cpu_put(data);
> >> 1308                 }
> >>
> >>
> >> Pretty good maze, right? ;-(
> > 
> > Oh dear.  Right.
> > 
> > I tgought I could change cpufreq_add_dev_symlink() to use kobject_get() to bump
> > up the policy refcount in analogy with cpufreq_add_policy_cpu() and then it
> > wouldn't need to call cpufreq_cpu_get() at all, but there is a bug in the
> > error code path of cpufreq_add_dev_interface(), because if
> > cpufreq_add_dev_symlink() fails for one of the CPUs sharing the policy,
> > it will just fail to drop references grabbed in there.  [Moreover, if it
> > fails for the first one different from policy->cpu, kobject_put() will be
> > called for that policy twice in a row if I'm not mistaken (first by
> > cpufreq_add_dev_interface() and then by __cpufreq_add_dev()), but that's
> > a different matter.]
> > 
> > So I think that neither cpufreq_add_dev_symlink() nor
> > cpufreq_add_policy_cpu() should bump up the policy refcount in any way.
> > 
> 
> Yeah, that greatly simplifies things, as seen in the patch below.
> 
> > Which entirely boils down to something like this:
> >
> 
> Looks good to me.
> 
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks! :-)

I actually think that I should move the error code path bug fix ->

> > ---
> >  drivers/cpufreq/cpufreq.c |   31 +++++++------------------------
> >  1 file changed, 7 insertions(+), 24 deletions(-)
> > 
> > Index: linux-pm/drivers/cpufreq/cpufreq.c
> > ===================================================================
> > --- linux-pm.orig/drivers/cpufreq/cpufreq.c
> > +++ linux-pm/drivers/cpufreq/cpufreq.c
> > @@ -818,14 +818,11 @@ static int cpufreq_add_dev_symlink(struc
> >  			continue;
> > 
> >  		pr_debug("Adding link for CPU: %u\n", j);
> > -		cpufreq_cpu_get(policy->cpu);
> >  		cpu_dev = get_cpu_device(j);
> >  		ret = sysfs_create_link(&cpu_dev->kobj, &policy->kobj,
> >  					"cpufreq");
> > -		if (ret) {
> > -			cpufreq_cpu_put(policy);
> > -			return ret;
> > -		}
> > +		if (ret)
> > +			break;
> >  	}
> >  	return ret;
> >  }
> > @@ -908,7 +905,8 @@ static int cpufreq_add_policy_cpu(unsign
> >  	unsigned long flags;
> > 
> >  	policy = cpufreq_cpu_get(sibling);
> > -	WARN_ON(!policy);
> > +	if (WARN_ON_ONCE(!policy))
> > +		return -ENODATA;
> > 
> >  	if (has_target)
> >  		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
> > @@ -930,16 +928,10 @@ static int cpufreq_add_policy_cpu(unsign
> >  	}
> > 
> >  	/* Don't touch sysfs links during light-weight init */
> > -	if (frozen) {
> > -		/* Drop the extra refcount that we took above */
> > -		cpufreq_cpu_put(policy);
> > -		return 0;
> > -	}
> > -
> > -	ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> > -	if (ret)
> > -		cpufreq_cpu_put(policy);
> > +	if (!frozen)
> > +		ret = sysfs_create_link(&dev->kobj, &policy->kobj, "cpufreq");
> > 
> > +	cpufreq_cpu_put(policy);
> >  	return ret;
> >  }
> >  #endif
> > @@ -1117,9 +1109,6 @@ err_out_unregister:
> >  	}
> >  	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
> > -	kobject_put(&policy->kobj);
> > -	wait_for_completion(&policy->kobj_unregister);
> > -
> >  err_set_policy_cpu:
> >  	per_cpu(cpufreq_policy_cpu, cpu) = -1;
> >  	cpufreq_policy_free(policy);

-> into a separate patch, because it's not really related to the other changes
made here.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
