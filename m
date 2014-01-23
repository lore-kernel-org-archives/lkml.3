Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbaAWCKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:10:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbaAWCKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:10:36 -0500
Date: Thu, 23 Jan 2014 10:10:28 +0800
From: Dave Young <dyoung@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140123021028.GE3768@dhcp-16-126.nay.redhat.com>
References: <20140122123022.GN31570@twins.programming.kicks-ass.net>
 <20140122131456.GA389@x4>
 <52DFD50E.800@oracle.com>
 <20140122183538.GA389@x4>
 <20140122184253.GN30183@twins.programming.kicks-ass.net>
 <20140122190905.GA391@x4>
 <20140122191254.GA390@x4>
 <20140122201605.GU11314@laptop.programming.kicks-ass.net>
 <20140122210814.GC9481@laptop.programming.kicks-ass.net>
 <20140123015354.GB3768@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123015354.GB3768@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/14 at 09:53am, Dave Young wrote:
> On 01/22/14 at 10:08pm, Peter Zijlstra wrote:
> > > 
> > > I think its the right region to look through. My current suspect is the
> > > linear continuity fit with the initial 'random' multiplier.
> > > 
> > > That initial 'random' multiplier can get us quite high, and we'll fit
> > > the function to match that but continue at a sane rate.
> > > 
> > > I'll try and prod a little more later this evening as time permits.
> > 
> > Does this cure things?
> 
> Peter, the odd timstamp still happens with this patch for me.

Hmm, seems the my physical machine is booting fine with this patch. kvm
guest problem still exist, but that kvm thing might be other problem.

> 
> > 
> > ---
> >  arch/x86/kernel/tsc.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> > index a3acbac2ee72..bb04148c5fe0 100644
> > --- a/arch/x86/kernel/tsc.c
> > +++ b/arch/x86/kernel/tsc.c
> > @@ -237,7 +237,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
> >  /* XXX surely we already have this someplace in the kernel?! */
> >  #define DIV_ROUND(n, d) (((n) + ((d) / 2)) / (d))
> >  
> > -static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
> > +static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu, bool origin)
> >  {
> >  	unsigned long long tsc_now, ns_now;
> >  	struct cyc2ns_data *data;
> > @@ -252,7 +252,10 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
> >  	data = cyc2ns_write_begin(cpu);
> >  
> >  	rdtscll(tsc_now);
> > -	ns_now = cycles_2_ns(tsc_now);
> > +	if (origin)
> > +		ns_now = 0;
> > +	else
> > +		ns_now = cycles_2_ns(tsc_now);
> >  
> >  	/*
> >  	 * Compute a new multiplier as per the above comment and ensure our
> > @@ -926,7 +929,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
> >  			mark_tsc_unstable("cpufreq changes");
> >  	}
> >  
> > -	set_cyc2ns_scale(tsc_khz, freq->cpu);
> > +	set_cyc2ns_scale(tsc_khz, freq->cpu, false);
> >  
> >  	return 0;
> >  }
> > @@ -1199,7 +1202,7 @@ void __init tsc_init(void)
> >  	 */
> >  	for_each_possible_cpu(cpu) {
> >  		cyc2ns_init(cpu);
> > -		set_cyc2ns_scale(cpu_khz, cpu);
> > +		set_cyc2ns_scale(cpu_khz, cpu, true);
> >  	}
> >  
> >  	if (tsc_disabled > 0)
