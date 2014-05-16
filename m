Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789AbaEPNiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:38:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:39337 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766AbaEPNiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:38:12 -0400
Date: Fri, 16 May 2014 15:38:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mingo@kernel.org,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH RFC] sched,numa: move tasks to preferred_node at wakeup
 time
Message-ID: <20140516133805.GS11096@twins.programming.kicks-ass.net>
References: <20140516001332.67f91af2@annuminas.surriel.com>
 <20140516021450.473361ea@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PgFjNgMZ2k7V6t4+"
Content-Disposition: inline
In-Reply-To: <20140516021450.473361ea@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PgFjNgMZ2k7V6t4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 16, 2014 at 02:14:50AM -0400, Rik van Riel wrote:
> +#ifdef CONFIG_NUMA_BALANCING
> +static int numa_balance_on_wake(struct task_struct *p, int prev_cpu)
> +{
> +	long load, src_load, dst_load;

> +	int cur_node = cpu_to_node(prev_cpu);
> +	struct numa_group *numa_group = ACCESS_ONCE(p->numa_group);
> +	struct sched_domain *sd;
> +	struct task_numa_env env = {
> +		.p = p,
> +		.best_task = NULL,
> +		.best_imp = 0,
> +		.best_cpu = -1
> +	};

That's all code, ideally you'd move that after we're done checking the
reasons to not do work, say somehere like...

> +
> +	if (!sched_feat(NUMA))
> +		return prev_cpu;

Yah.. :-( I think some people changed that to numabalancing_enabled.

Fixing that is still on the todo list somewhere.

> +
> +	if (p->numa_preferred_nid == -1)
> +		return prev_cpu;
> +
> +	if (p->numa_preferred_nid == cur_node);
> +		return prev_cpu;
> +
> +	if (numa_group && node_isset(cur_node, numa_group->active_nodes))
> +		return prev_cpu;
> +
> +	sd = rcu_dereference(per_cpu(sd_numa, env.src_cpu));
> +	if (sd)
> +		env.imbalance_pct = 100 + (sd->imbalance_pct - 100) / 2;
> +
> +	/*
> +	 * Cpusets can break the scheduler domain tree into smaller
> +	 * balance domains, some of which do not cross NUMA boundaries.
> +	 * Tasks that are "trapped" in such domains cannot be migrated
> +	 * elsewhere, so there is no point in (re)trying.
> +	 */
> +	if (unlikely(!sd)) {

How about you bail early, and then have the above test evaporate?

> +		p->numa_preferred_nid = cur_node;
> +		return prev_cpu;
> +	}

.. here.

> +
> +	/*
> +	 * Only allow p to move back to its preferred nid if
> +	 * that does not create an imbalance that would cause
> +	 * the load balancer to move a task around later.
> +	 */
> +	env.src_nid = cur_node;
> +	env.dst_nid = p->numa_preferred_nid;
> +
> +	update_numa_stats(&env.src_stats, env.src_nid);
> +	update_numa_stats(&env.dst_stats, env.dst_nid);
> +
> +	dst_load = env.dst_stats.load;
> +	src_load = env.src_stats.load;
> +
> +	/* XXX missing power terms */
> +	load = task_h_load(p);
> +	dst_load += load;
> +	src_load -= load;
> +
> +	if (load_too_imbalanced(env.src_stats.load, env.dst_stats.load,
> +				src_load, dst_load, &env))
> +		return prev_cpu;

So I'm thinking that load_too_imbalanced() is from another patch I
haven't yet seen, lemme go see if you did send it and I missed it.

> +
> +	return cpumask_first(cpumask_of_node(p->numa_preferred_nid));
> +}

--PgFjNgMZ2k7V6t4+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdhS9AAoJEHZH4aRLwOS6idMP/j2Cns+IDlc49fQeewSAFvjI
eCowBqzxYbQBNIeYC7knVYdG1gGYg3imQKiBcrTTBs0c6hwvf/w+2y7p8QPeisP7
R+AJc0lDLjFA/gF2e+3rZSWrfkSOOiYXJGoU93fQzYcJTXBFL1Mg6TeMrbQSuHd6
hbs5Ja5kRnJZJaM5+YGlPGqUE68h4tId/GpQ6TpIe9qnvD31Nzb2jZvVhrXDEfmu
9gkahr0YpqSgtNGW8M2Z4+bwvUfHkpzcJJS9aynuOKpomAxd//BZT7mVPyNUnjBC
m6m5DhOGhKJ9Orx3GsBgCiE46y8SZdj9yrGzTEqCkYK97EJaX6lNbe9HirdmC3TE
Od6jHFpei0R5iLmRHlghAB6rjsek+EjRw/R2poZqo0iQG81ftyVdqzGcQooyNjnf
M4O2eYCvd8UcgXuHz9+cP5W6UVqoKp+sDPSsh8amzO+se/l65gP8P1WL90pt1buR
qpd1U1Og8RS7ARmwzaKF7MugrBCieh4d2LEGebEbCra0uZlRnskbAGhe8NJrYWZz
2sa8CuRMlBDF++tuehr12Doe7VvV5oFnLxccWgJn2heQJT6lEgXG+rv3e49SAwTu
GVDpIqcw62Oy/WFiHX6+TYq3vs9/TcXv0xLmItBET171IJ7QSpuOgzwEQMQL5Dv8
sIOn1ypmj0Vgxy2rGAW7
=MWxY
-----END PGP SIGNATURE-----

--PgFjNgMZ2k7V6t4+--
