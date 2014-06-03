Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaFCO3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:29:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37652 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaFCO3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:29:14 -0400
Date: Tue, 3 Jun 2014 16:28:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140603142845.GP30445@twins.programming.kicks-ass.net>
References: <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516115737.GP11096@twins.programming.kicks-ass.net>
 <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com>
 <20140516162945.GZ11096@twins.programming.kicks-ass.net>
 <53849EB7.9090302@linux.vnet.ibm.com>
 <20140527142637.GB19143@laptop.programming.kicks-ass.net>
 <53875F09.3090607@linux.vnet.ibm.com>
 <538DB076.4090704@cn.fujitsu.com>
 <538DC373.9@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s4QZEMnjKRGdPWeD"
Content-Disposition: inline
In-Reply-To: <538DC373.9@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s4QZEMnjKRGdPWeD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 08:45:39PM +0800, Lai Jiangshan wrote:
>=20
> Hi, Peter,
>=20
> I rewrote the analyse. (scheduler_ipi() must be called before stopper-tas=
k,
> so the part for workqueue of the old analyse maybe be wrong.)

But I don't think there is any guarantee we'll do the wakeup before
running the stop work.

Suppose the initial task gets queued, and the thing gets send the
interrupt, meanwhile we'll do the stopper work wakeup !queueing, the
set_cpus_allowed_ptr() isn't crossing llc boundaries.

Now, the remote cpu preempts/schedules before the interrupt hits and
runs the stop task.

At which point we'll run __migrate_task() while the task is still queued
on the wake list.

> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45e..1a198a5 100644
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

So while this will close the window somewhat, I don't think its entirely
closed.

--s4QZEMnjKRGdPWeD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjdudAAoJEHZH4aRLwOS6e98P/2bNJAL+Z8JcO2WnElMcg6lH
TWXhDgpNfPie740+gMjMZ76EL7u+BLtM8W62TxnmT1GRo0bPFN/aoUSlIYlHo0oL
sYDpjmDELesBd4TM+CYNgO26QWkujWx6WjhLcgV6n6umi80COWvc6gDb3Vmtkc74
eNvYMS5GvXR58FdYXgTt3MDkKW4A1o/wVFNj6Q/8CGCi0MFbhIjRKkHK91XKCtGv
rcg/eP0FMBgwvbnEz5o8vCZC4ccUDd52r1bzSO5w1BoSW2StbyTOoWcBoAq61oyf
sQBu/aDBA8CA0GPl+pP3M3WxnH8J58tPavP8KAC2bFKm38/0bXlGetVpR7QX2nIW
RXz6DFmuH1IbYHKPVRp5MpTX9fDrJ6WoFZKnebXVQdApRlLA1hoo40rSVlHd07KK
B4xmr9QLuEmwhgzbi99DX/ljDkODWAmTcIT6UJhTb38D5kP94GVHgvRgJlXaqMx9
DzvwOvZZOvExggIlXcnmd3F+Lrt0Y6l2UicSZY7TC1pWXScOs1G1AGTk0rTFhi4v
7FYeDB6gyRD3cuo8UbxRpCH3l1pHI/GSqvwkH/BHIjxMWRI9U9vqhhKiUoxxLibR
3mRGW8umT6Q3i/O+jJUNevAKIAlxA1RWOYOfR2NTOY4axyswSyVHnFZXYPjZdIrQ
ttWeazodsNbPfCf+HccW
=XkmA
-----END PGP SIGNATURE-----

--s4QZEMnjKRGdPWeD--
