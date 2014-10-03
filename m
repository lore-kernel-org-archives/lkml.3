Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaJCI0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:26:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57081 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaJCI0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:26:43 -0400
X-AuditID: cbfee61a-f79c06d000004e71-4b-542e5db9068a
Date: Fri, 03 Oct 2014 10:26:28 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>, Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] thermal: core: fix: Initialize the max_state variable
 to 0
Message-id: <20141003102628.7a8f36f7@amdc2363>
In-reply-to: <20141002222649.GB11510@developer>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1411547232-21493-3-git-send-email-l.majewski@samsung.com>
 <20141002222649.GB11510@developer>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jQd2dsXohBnuWsFtsnLGe1WL+lWus
	Fm8ecVtc3jWHzeJz7xFGiycP+9gc2Dx2zrrL7rF4z0smj3XT3jJ79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8aiSZoFlyUqNn7/xd7AeEO4i5GTQ0LAROLpvW2MELaYxIV769m6GLk4hASm
	M0r8aupjgXB+MUoc3z2fFaSKRUBVYuKGi2A2m4CexOe7T5lAbBEBLYkTl7aD2cwC5xkl9uw3
	AbGFBUIl5qw4zwZi8wLV3906lx3E5hTQl9h6t5kdYsEKRokvSz6BncEvICnR/u8HM8RJdhLn
	Pm1gh2gWlPgx+R4LxAItic3bmlghbHmJzWveMk9gFJyFpGwWkrJZSMoWMDKvYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAgO+WdSOxhXNlgcYhTgYFTi4f1wQzdEiDWxrLgy9xCjBAezkgjv
	5Ci9ECHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2Mx3Jk
	dtd8ZHhw2nLNnWynuuWZ5Z+/zXfVZ+u4O/W56E6dpMhD83W54/R8u3TOvXsoOF2g78LMQyeY
	g1UvXm8wP9oYdfDz1Yvys+uqSqVfqabuka0qd96xy1jqs9RmQUkfdUMT9eDNDOcOKK9YV1H8
	5ZKKuMbyUyaVVvFJNxR+n90at0wz2jZZiaU4I9FQi7moOBEAV/1yDHUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

> Hello Lukasz,
> 
> On Wed, Sep 24, 2014 at 10:27:11AM +0200, Lukasz Majewski wrote:
> > Pointer to the uninitialized max_state variable is passed to get the
> > maximal cooling state.
> > For CPU cooling device (cpu_cooling.c) the cpufreq_get_max_state()
> > is called, which even when error occurs will return the max_state
> > variable unchanged.
> > Since error for ->get_max_state() is not checked, the automatically
> 
> 
> Good that you added a fix in your series for this.
> 
> 
> > allocated value of max_state is used for (upper > max_state)
> > comparison. For any possible max_state value it is very unlikely
> > that it will be less than upper.
> > As a consequence, the cooling device is bind even without the backed
> > cpufreq table initialized.
> > 
> > This initialization will prevent from accidental binding trip
> > points to cpu freq cooling frequencies when cpufreq driver itself
> > is not yet fully initialized.
> 
> Although I agree with the fix, as long as we also include a check for
> the .get_max_state return value,  I believe the problem you are
> describing is about initialization sequence.

As you pointed out - the problem here is with initialization sequence.
Thermal and cpufreq cores are initialized very early.

However, the get_max_state() for cpu_cooling.c device (as it is the
pervasive way of cooling things) accesses cpufreq policy to get the
freq_table and count available states.

The issue here is with late initialization of cpufreq policy.

Up till now the cpu_cooling device was bind even when the
get_max_state() returned -EINVAL and everything worked after late
cpufreq policy initialization. However, during this time window the
thermal driver is not configured.

> 
> In general, I believe we need a better
> sequencing between thermal and cpufreq subsystems. One way out is to
> include a check for cpufreq driver in the thermal driver, and return
> -EPROBE_DEFER  when cpufreq is not ready.

I think that we could return -EPROBE_DEFER when cpufreq's policy is not
yet available and subscribe to cpufreq notifier to call
bind_cooling_device then.

Let's wait for Zhang opinion since he looks after the thermal core code.

> 
> > 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > ---
> >  drivers/thermal/thermal_core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/thermal/thermal_core.c
> > b/drivers/thermal/thermal_core.c index 454884a..747618a 100644
> > --- a/drivers/thermal/thermal_core.c
> > +++ b/drivers/thermal/thermal_core.c
> > @@ -927,7 +927,7 @@ int thermal_zone_bind_cooling_device(struct
> > thermal_zone_device *tz, struct thermal_instance *pos;
> >  	struct thermal_zone_device *pos1;
> >  	struct thermal_cooling_device *pos2;
> > -	unsigned long max_state;
> > +	unsigned long max_state = 0;
> >  	int result;
> >  
> >  	if (trip >= tz->trips || (trip < 0 && trip !=
> > THERMAL_TRIPS_NONE)) -- 
> > 2.0.0.rc2
> > 
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
