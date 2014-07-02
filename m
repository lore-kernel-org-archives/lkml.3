Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaGBIt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:49:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:59459 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaGBIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:48:43 -0400
Date: Wed, 2 Jul 2014 10:48:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 02/16] perf, core: introduce pmu context switch
 callback
Message-ID: <20140702084833.GT6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-3-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwBPO0Eqq9aLXgcG"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-3-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwBPO0Eqq9aLXgcG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 30, 2014 at 04:50:39PM +0800, Yan, Zheng wrote:
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 707617a..71fb77a 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -262,6 +262,12 @@ struct pmu {
>  	 * flush branch stack on context-switches (needed in cpu-wide mode)
>  	 */
>  	void (*flush_branch_stack)	(void);
> +
> +	/*
> +	 * PMU callback for context-switches. optional
> +	 */
> +	void (*sched_task)		(struct perf_event_context *ctx,
> +					 bool sched_in);
>  };

Here you make it a general facility..

> +/*
> + * This function provides the context switch callback to the lower code
> + * layer. It is invoked ONLY when the context switch callback is enabled.
> + */
> +static void perf_pmu_sched_task(struct task_struct *prev,
> +				struct task_struct *next,
> +				bool sched_in)
> +{
> +	struct perf_cpu_context *cpuctx;
> +	struct pmu *pmu;
> +	unsigned long flags;
> +
> +	if (prev == next)
> +		return;
> +
> +	local_irq_save(flags);
> +
> +	rcu_read_lock();
> +
> +	list_for_each_entry_rcu(pmu, &pmus, entry) {
> +		if (pmu->sched_task) {
> +			cpuctx = this_cpu_ptr(pmu->pmu_cpu_context);
> +
> +			perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +
> +			perf_pmu_disable(pmu);
> +
> +			pmu->sched_task(cpuctx->task_ctx, sched_in);
> +
> +			perf_pmu_enable(pmu);
> +
> +			perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +			/* only CPU PMU has context switch callback */
> +			break;

And here you break it..

> +		}
> +	}
> +
> +	rcu_read_unlock();
> +
> +	local_irq_restore(flags);
> +}

--rwBPO0Eqq9aLXgcG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs8dVAAoJEHZH4aRLwOS6GRUP/iWGlw6/gfrqfPLoGm1DVn6O
RSHjz0VwgnzoSnigHFxA1hw/e2aK7XXYiPq7gR16URRjchzejVgvX9TRTmAovWWU
300EBLmON6gg7XLukJAd/T7qhyGfrfyJk/qmaB5J81sCZOV4f7UE8lnUJiZY1Oqh
2s+ueGXkM+I3lTM+YItgFhUwuBy7j+CVk2ybafjIHdpgwPjFdWA07FbbCJxGNK7U
xRU2XvbwIO75N/PO7AuDpppJPek9VsYX/MiZfHMCQwNe2wp2mp7vvIjSCi0D60GO
CwX4r15K2J4h1w3pjdJk+oJXSZzvCGrEwqlmOuyshRyx95T/4IJ7wmEV04i0EG7L
oLyPLPNxXDuUncXw6C99jEqozjsM7nJ+YPcJgdH/qT1CVnxL+dX5PAnEO944B5pC
5BHyb2Jh1IHPPWp956WWrD4Wy0x+MC9F6k9zQBB7b4X8mBMSjvGL5TLGoivir8Nt
enqo626wLO8nz+Tbxwlm62ZWBcXR2kZZ/FaCypWBuMzocDxbccNCLwg1n4QSv4pA
Joulqfwzp8fttWGvbzN7rVQ7aYFXLIdT9PNma39X/1ah8A4a/310PEqQVNpGLzAP
lF9vVgeF/8daATNF/OCwXSAZZnjFwtHzybPWns7qocqK3Y+kUkuKlwTuXZkzC6q1
zDQmi7JtHR8pnuIcruxS
=fz18
-----END PGP SIGNATURE-----

--rwBPO0Eqq9aLXgcG--
