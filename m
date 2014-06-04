Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaFDJj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:39:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34706 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaFDJjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:39:25 -0400
Date: Wed, 4 Jun 2014 11:39:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140604093907.GC11096@twins.programming.kicks-ass.net>
References: <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com>
 <20140516162945.GZ11096@twins.programming.kicks-ass.net>
 <53849EB7.9090302@linux.vnet.ibm.com>
 <20140527142637.GB19143@laptop.programming.kicks-ass.net>
 <53875F09.3090607@linux.vnet.ibm.com>
 <538DB076.4090704@cn.fujitsu.com>
 <20140603141659.GO30445@twins.programming.kicks-ass.net>
 <538E840D.2040300@cn.fujitsu.com>
 <20140604064946.GF30445@twins.programming.kicks-ass.net>
 <538ED7EB.5050303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6tPBpOxN+lFhHURE"
Content-Disposition: inline
In-Reply-To: <538ED7EB.5050303@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6tPBpOxN+lFhHURE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 04:25:15PM +0800, Lai Jiangshan wrote:
> I think the following code works. (inspirited from the sched_ttwu_pending=
() in migration_call().)
>=20
> if p->on_rq =3D=3D 0 && p->state =3D=3D TASK_WAKING in __migrate_task() a=
fter this patch,
> it means the cpuallowed is changed before __migrate_task() along with oth=
er scheduler
> movements happens between sched_ttwu_pending() and __migrate_task().

Yes, this is better. Can you send a full patch with the below comment in
as well, then I can apply.

Thanks!

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45e..277f3bc 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4530,7 +4530,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, con=
st struct cpumask *new_mask)
>  		goto out;
> =20
>  	dest_cpu =3D cpumask_any_and(cpu_active_mask, new_mask);
> -	if (p->on_rq) {
> +	if (p->on_rq || p->state =3D=3D TASK_WAKING) {
>  		struct migration_arg arg =3D { p, dest_cpu };
>  		/* Need help from migration thread: drop lock and wait. */
>  		task_rq_unlock(rq, p, &flags);
> @@ -4656,6 +4656,7 @@ static int migration_cpu_stop(void *data)
>  	 * be on another cpu but it doesn't matter.
>  	 */
>  	local_irq_disable();

	/*
	 * We need to explicitly wake pending tasks before running
	 * __migrate_task() such that we will not miss enforcing
	 * cpus_allowed during wakeups, see set_cpus_allowed_ptr()'s
	 * TASK_WAKING test.
	 */

> +	sched_ttwu_pending();
>  	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
>  	local_irq_enable();
>  	return 0;

--6tPBpOxN+lFhHURE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjuk7AAoJEHZH4aRLwOS6CG0P/1IWmELDoMEmNsO3aIgK5NsZ
e9TbHlPvhrDQKfhiczc6K7hbJRUetZEuCB7TBImkEAM2R7NVLtlJNCLCJEb/GeBL
WR//h+O55m2iNdk6iOgywkSptbdjksvZY95UXYifuEfT8HDpudocrOQSCR/cGKNN
MWZbDs5ES/DX6j9uwQXztZ14qtnnLdm3R/GjI13zmC0MImBEJoHPl5m4sdHhsP9v
o+93k2r5gV72X9y912TrW2Ww1TpK76LFLdn13rMNo2om+CvxYEH9WRrjMWtrkdRT
/pWLSiyRYtnjYvH+gV98MVd4iNEJhm1GGbpNnGOlGteckPhhrf9JPGT+UDaHxjlr
IO8t2MVqA+yfHRiOBd9tuCtneNnYmrO/HjvuGWdWXYPXnSrGFMkk2IgXDsv6PSlZ
Lqb5yL69TcU5lQcJMhm9UBxgxpfZVKoWjMZQ0bpPyzb9l71Mh4teLpnMiR7E/a4G
mP260MwZrwLb7Y4EeYEnVQ6mQZPemF9+vFzDzd7Qzi0CDCIG8PSJnNAwzkaGTYsN
FNMW/mE2+/F+F7H7nR+yPqImMWh+ndobFfR9ELYeC+jASMelri8dmbU+41QuM275
9hpxWz550GxU68rdl4vsH/0+BHCU1255z0S6nnCdAMHQf7+VTsCvujzk6OCTN02W
Y+pWaMxJOmocFdi8EhJt
=/0F8
-----END PGP SIGNATURE-----

--6tPBpOxN+lFhHURE--
