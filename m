Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaEAXCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 19:02:24 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61098 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750904AbaEAXCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 19:02:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Stratos Karafotis <stratosk@semaphore.gr>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cpufreq: intel_pstate: Change the calculation of next pstate
Date: Fri, 02 May 2014 01:18:54 +0200
Message-ID: <21200760.cENPVVrS5i@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5362BD02.5020006@gmail.com>
References: <5362B5F5.1020706@semaphore.gr> <5362BD02.5020006@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 01, 2014 02:30:42 PM Dirk Brandewie wrote:
> On 05/01/2014 02:00 PM, Stratos Karafotis wrote:
> > Currently the driver calculates the next pstate proportional to
> > core_busy factor, scaled by the ratio max_pstate / current_pstate.
> >
> > Using the scaled load (core_busy) to calculate the next pstate
> > is not always correct, because there are cases that the load is
> > independent from current pstate. For example, a tight 'for' loop
> > through many sampling intervals will cause a load of 100% in
> > every pstate.
> >
> > So, change the above method and calculate the next pstate with
> > the assumption that the next pstate should not depend on the
> > current pstate. The next pstate should only be directly
> > proportional to measured load.
> >
> > Tested on Intel i7-3770 CPU @ 3.40GHz.
> > Phoronix benchmark of Linux Kernel Compilation 3.1 test shows an
> > increase ~1.5% in performance. Below the test results using turbostat
> > (5 iterations):
> >
> > Without patch:
> >
> > Ph. avg Time	Total time	PkgWatt		Total Energy
> > 	79.63	266.416		57.74		15382.85984
> > 	79.63	265.609		57.87		15370.79283
> > 	79.57	266.994		57.54		15362.83476
> > 	79.53	265.304		57.83		15342.53032
> > 	79.71	265.977		57.76		15362.83152
> > avg	79.61	266.06		57.74		15364.36985
> >
> > With patch:
> >
> > Ph. avg Time	Total time	PkgWatt		Total Energy
> > 	78.23	258.826		59.14		15306.96964
> > 	78.41	259.110		59.15		15326.35650
> > 	78.40	258.530		59.26		15320.48780
> > 	78.46	258.673		59.20		15313.44160
> > 	78.19	259.075		59.16		15326.87700
> > avg	78.34	258.842		59.18		15318.82650
> >
> > The total test time reduced by ~2.6%, while the total energy
> > consumption during a test iteration reduced by ~0.35%
> >
> > Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
> > ---
> >
> > Changes v1 -> v2
> > 	- Enhance change log as Rafael and Viresh suggested
> >
> >
> >   drivers/cpufreq/intel_pstate.c | 15 +++++++--------
> >   1 file changed, 7 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
> > index 0999673..8e309db 100644
> > --- a/drivers/cpufreq/intel_pstate.c
> > +++ b/drivers/cpufreq/intel_pstate.c
> > @@ -608,28 +608,27 @@ static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
> >   	mod_timer_pinned(&cpu->timer, jiffies + delay);
> >   }
> >
> > -static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
> > +static inline int32_t intel_pstate_get_busy(struct cpudata *cpu)
> >   {
> > -	int32_t core_busy, max_pstate, current_pstate;
> > +	int32_t core_busy, max_pstate;
> >
> >   	core_busy = cpu->sample.core_pct_busy;
> >   	max_pstate = int_tofp(cpu->pstate.max_pstate);
> > -	current_pstate = int_tofp(cpu->pstate.current_pstate);
> > -	core_busy = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
> > +	core_busy = mul_fp(core_busy, max_pstate);
> 
> NAK,  The goal of this code is to find out how busy the core is at the current
> P state. This change will return a value WAY too high.
> 
> Assume core_busy is 100 and the max non-turbo P state is 34 (3.4GHz) this code
> would return a busy value of 3400. The PID  is trying to keep the busy value
> at the setpoint any value of ~3% will drive the P state to the highest turbo
> P state in this example.

Well, the problem is that the numbers above indicate an improvement in energy
efficiency as a result of this patch and we need to explain that result.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
