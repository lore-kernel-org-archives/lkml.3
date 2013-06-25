Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640Ab3FYWaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 18:30:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50890 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146Ab3FYWaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 18:30:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: od_set_powersave_bias: NULL pointer dereference
Date: Wed, 26 Jun 2013 00:39:38 +0200
Message-ID: <1516594.2Op2Cie0Tj@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51C9E443.8070100@canonical.com>
References: <51C87ADC.4070409@canonical.com> <20130625161935.GA10208@jshin-Toonie> <51C9E443.8070100@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 25, 2013 12:41:07 PM Tim Gardner wrote:
> On 06/25/2013 10:19 AM, Jacob Shin wrote:
> > On Tue, Jun 25, 2013 at 12:26:14PM +0530, Viresh Kumar wrote:
> >> On 24 June 2013 22:29, Tim Gardner <tim.gardner@canonical.com> wrote:
> >>> This is from Ubuntu Saucy based on 3.10-rc7:
> >>>
> >>> [   12.911676] BUG: unable to handle kernel NULL pointer dereference at
> >>> 0000000000000070
> >>> [   12.911691] IP: [<ffffffff8156e572>] od_set_powersave_bias+0x92/0xc0
> >>>
> >>
> >> Can you please look into this bug? It occurred after your
> >> patch... This is the boot log crash we have:
> > 
> > Hi,
> > 
> > Yes, so sorry about that, it looks like I failed to test with:
> > 
> > CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> > CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> > CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> > CONFIG_X86_AMD_FREQ_SENSITIVITY=m
> > 
> > The following patch fixes this, Tim, could you please test ? :
> > 
> > ---8<---
> > 
> > From 3c727b1f775448599e67c5fb2121d79448e80c90 Mon Sep 17 00:00:00 2001
> > From: Jacob Shin <jacob.shin@amd.com>
> > Date: Tue, 25 Jun 2013 10:40:54 -0500
> > Subject: [PATCH 1/1] cpufreq: fix NULL pointer deference at
> >  od_set_powersave_bias()
> > 
> > When initializing the default powersave_bias value, we need to first
> > make sure that this policy is running the ondemand governor.
> > 
> > Reported-by: Tim Gardner <tim.gardner@canonical.com>
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  drivers/cpufreq/cpufreq_ondemand.c |   17 +++++++++++++----
> >  1 file changed, 13 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> > index 4b9bb5d..93eb5cb 100644
> > --- a/drivers/cpufreq/cpufreq_ondemand.c
> > +++ b/drivers/cpufreq/cpufreq_ondemand.c
> > @@ -47,6 +47,8 @@ static struct od_ops od_ops;
> >  static struct cpufreq_governor cpufreq_gov_ondemand;
> >  #endif
> >  
> > +static unsigned int default_powersave_bias;
> > +
> >  static void ondemand_powersave_bias_init_cpu(int cpu)
> >  {
> >  	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
> > @@ -543,7 +545,7 @@ static int od_init(struct dbs_data *dbs_data)
> >  
> >  	tuners->sampling_down_factor = DEF_SAMPLING_DOWN_FACTOR;
> >  	tuners->ignore_nice = 0;
> > -	tuners->powersave_bias = 0;
> > +	tuners->powersave_bias = default_powersave_bias;
> >  	tuners->io_is_busy = should_io_be_busy();
> >  
> >  	dbs_data->tuners = tuners;
> > @@ -585,6 +587,7 @@ static void od_set_powersave_bias(unsigned int powersave_bias)
> >  	unsigned int cpu;
> >  	cpumask_t done;
> >  
> > +	default_powersave_bias = powersave_bias;
> >  	cpumask_clear(&done);
> >  
> >  	get_online_cpus();
> > @@ -593,11 +596,17 @@ static void od_set_powersave_bias(unsigned int powersave_bias)
> >  			continue;
> >  
> >  		policy = per_cpu(od_cpu_dbs_info, cpu).cdbs.cur_policy;
> > -		dbs_data = policy->governor_data;
> > -		od_tuners = dbs_data->tuners;
> > -		od_tuners->powersave_bias = powersave_bias;
> > +		if (!policy)
> > +			continue;
> >  
> >  		cpumask_or(&done, &done, policy->cpus);
> > +
> > +		if (policy->governor != &cpufreq_gov_ondemand)
> > +			continue;
> > +
> > +		dbs_data = policy->governor_data;
> > +		od_tuners = dbs_data->tuners;
> > +		od_tuners->powersave_bias = default_powersave_bias;
> >  	}
> >  	put_online_cpus();
> >  }
> > 
> 
> That appears to have done the trick. You can add my Tested-by.

Queued up as an urgent fix.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
