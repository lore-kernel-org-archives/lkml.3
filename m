Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbbA0G2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:28:16 -0500
Received: from ozlabs.org ([103.22.144.67]:34750 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbbA0G2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:28:13 -0500
Message-ID: <1422340090.27133.4.camel@ellerman.id.au>
Subject: Re: cpuidle/powernv: Read target_residency value of idle states
 from DT if available
From: Michael Ellerman <mpe@ellerman.id.au>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: rafael.j.wysocki@intel.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Date: Tue, 27 Jan 2015 17:28:10 +1100
In-Reply-To: <54C70DDD.9040408@linux.vnet.ibm.com>
References: <20150123045906.D0086140297@ozlabs.org>
	 <54C70DDD.9040408@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 09:32 +0530, Preeti U Murthy wrote:
> On 01/23/2015 10:29 AM, Michael Ellerman wrote:
> > On Tue, 2015-20-01 at 11:26:49 UTC, Preeti U Murthy wrote:
> >> @@ -177,34 +178,39 @@ static int powernv_add_idle_states(void)
> > 
> >>  	for (i = 0; i < dt_idle_states; i++) {
> >>  
> >>  		flags = be32_to_cpu(idle_state_flags[i]);
> >> -
> >> -		/* Cpuidle accepts exit_latency in us and we estimate
> >> -		 * target residency to be 10x exit_latency
> >> +		/*
> >> +		 * Cpuidle accepts exit_latency and target_residency in us.
> >> +		 * Use default target_residency values if f/w does not expose it.
> >>  		 */
> >> -		latency_ns = be32_to_cpu(idle_state_latency[i]);
> >>  		if (flags & OPAL_PM_NAP_ENABLED) {
> >>  			/* Add NAP state */
> >>  			strcpy(powernv_states[nr_idle_states].name, "Nap");
> >>  			strcpy(powernv_states[nr_idle_states].desc, "Nap");
> >>  			powernv_states[nr_idle_states].flags = 0;
> >> -			powernv_states[nr_idle_states].exit_latency =
> >> -					((unsigned int)latency_ns) / 1000;
> >> -			powernv_states[nr_idle_states].target_residency =
> >> -					((unsigned int)latency_ns / 100);
> >> +			powernv_states[nr_idle_states].target_residency = 100;
> >>  			powernv_states[nr_idle_states].enter = &nap_loop;
> >> -			nr_idle_states++;
> > 
> > That looks wrong? Or do you mean to do that?
> 
> If you are pointing at the lines that remove increment of
> nr_idle_states, it has to be done so towards the end of the iteration
> because we are yet to populate the exit_latency and target_residency
> outside of these conditions using this index.

Oh OK I think I get it, it's not clear at all.

The resulting code is:

	for (i = 0; i < dt_idle_states; i++) {

		flags = be32_to_cpu(idle_state_flags[i]);
		/*
		 * Cpuidle accepts exit_latency and target_residency in us.
		 * Use default target_residency values if f/w does not expose it.
		 */
		if (flags & OPAL_PM_NAP_ENABLED) {
			/* Add NAP state */
			strcpy(powernv_states[nr_idle_states].name, "Nap");
			strcpy(powernv_states[nr_idle_states].desc, "Nap");
			powernv_states[nr_idle_states].flags = 0;
			powernv_states[nr_idle_states].target_residency = 100;
			powernv_states[nr_idle_states].enter = &nap_loop;
		}

		if (flags & OPAL_PM_SLEEP_ENABLED ||
			flags & OPAL_PM_SLEEP_ENABLED_ER1) {
			/* Add FASTSLEEP state */
			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");
			powernv_states[nr_idle_states].flags = CPUIDLE_FLAG_TIMER_STOP;
			powernv_states[nr_idle_states].target_residency = 300000;
			powernv_states[nr_idle_states].enter = &fastsleep_loop;
		}

		powernv_states[nr_idle_states].exit_latency =
				((unsigned int)latency_ns[i]) / 1000;

		if (!rc) {
			powernv_states[nr_idle_states].target_residency =
				((unsigned int)residency_ns[i]) / 1000;
		}

		nr_idle_states++;
	}


Which looks like you could potentially overwrite the first set of values, "Nap"
with "FastSleep". But I think what you're going to tell me is that flags can
never satisfy both conditions, so we will only ever execute either the "Nap"
case OR the "FastSleep".

If so please change the code to make that obvious, ie. by using else if.

cheers


