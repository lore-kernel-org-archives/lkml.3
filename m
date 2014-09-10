Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaIJHx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:53:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaIJHxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:53:55 -0400
Date: Wed, 10 Sep 2014 09:53:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "sasha.levin@oracle.com" <sasha.levin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jjherne@linux.vnet.ibm.com" <jjherne@linux.vnet.ibm.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:sched/core] sched: Migrate waking tasks
Message-ID: <20140910075347.GK6758@twins.programming.kicks-ass.net>
References: <538ED7EB.5050303@cn.fujitsu.com>
 <tip-5cd038f53ed9ec7a17ab7d536a727363080f4210@git.kernel.org>
 <2397411410334685@web16m.yandex.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XvrhuzKSC4pLtZe9"
Content-Disposition: inline
In-Reply-To: <2397411410334685@web16m.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XvrhuzKSC4pLtZe9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 11:38:05AM +0400, Kirill Tkhai wrote:
> 09.09.2014, 18:54, "tip-bot for Lai Jiangshan" <tipbot@zytor.com>:
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index a814b3c..78e5c83 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -4666,7 +4666,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, c=
onst struct cpumask *new_mask)
> >  		goto out;
> >
> >	dest_cpu =3D cpumask_any_and(cpu_active_mask, new_mask);
> > -	if (task_on_rq_queued(p)) {
> > +	if (task_on_rq_queued(p) || p->state =3D=3D TASK_WAKING) {
> >  		struct migration_arg arg =3D { p, dest_cpu };
> > =A0		/* Need help from migration thread: drop lock and wait. */
> > =A0		task_rq_unlock(rq, p, &flags);
>=20
>=20
> About migration_cpu_stop():
>=20
> > @@ -4799,6 +4799,12 @@ static int migration_cpu_stop(void *data)
> >  	* be on another cpu but it doesn't matter.
> >  	*/
> >  	local_irq_disable();
> > +	/*
> > +	* We need to explicitly wake pending tasks before running
> > +	* __migrate_task() such that we will not miss enforcing cpus_allowed
> > +	* during wakeups, see set_cpus_allowed_ptr()'s TASK_WAKING test.
> > +	*/
> > +	sched_ttwu_pending();
> >	__migrate_task(arg->task, raw_smp_processor_id(), arg->dest_cpu);
> >	local_irq_enable();
> >	return 0;
>=20
> It looks like we do not need this hunk, because IPI happens earlier then
> stop class begins migration_cpu_stop() execution.
>=20
> In the first hunk the check "p->state =3D=3D TASK_WAKING" is under pi_loc=
k,
> so if the task is really waking then the IPI is already set.
>=20
> So, the first hunk is enough here, the second is not need.

If the cpu is idle and has TIF_POLLING_NRFLAG we'll never send the IPI,
then again, the wake from idle required to start running the stop task
will also flush that pending queue. So you're probably right.

I'll leave it in though, better safe than sorry and its not a critical
fast path. Good thinking though.

--XvrhuzKSC4pLtZe9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEAOGAAoJEHZH4aRLwOS6LM0P/2NdS/qXzvZaCif0Ybn21wE+
dnJvy0AML9x0lWQaVJ0vYogFXgEP2Q6bEBMm/5jyw+v6CAXPKQqY/IG4cofeuOSv
bcjA1f5/AB9j5sVTiy7E0AD/Q0ss7Uc2J9ZuwSw9Q4E+bN4+bTE7O8d/Wj7s0/Cw
sjGlI8HmhWdeaPnDkuRBFep+jVBLzOLYpNO6h87X2koGYJC+XZMM5nxMaEnhVPSi
D1DPr/u7oumA3UWZpwj9xXZMpL/uFn7q71pZWTTFiCaXt4KlT8j7thCmpHRvyDFs
dhj0xVvmMuaPnAsfZ3gP3daWV30JtLAv4fMW9H4010IQvf3a54zLA0wjwWqk/t1i
1YE7pRxIN8qehtjRNm7XRj8Qiyn/Jo6l6gYmgz2mJ677OzPIv19C8ltrpRr6XkIC
v6njCpqvgHeznhdNcLtEUrPTwT3gjN88cG9NmfJhnelPT0+Im0QpsyVM0573/T3P
UJTgc9ReyF9+i6GftRjQy2zpW1qcvMswYkCGQusbUPT9fviSvlcugY/ruTtLr+77
jT/iSVRrMUHpa6V69yl8zuVNUAMJyYA1V3CMOpAPM6vdAWsz8r6zHrNUT9PxZfBM
eLCFis9uo/50xiZIk+sBm31vNyng2llU8xmvJWBlxmyY1pNoG6Vzv7/RFQPMYym5
aL9sxGCSL+9QhghY1kcW
=i/yK
-----END PGP SIGNATURE-----

--XvrhuzKSC4pLtZe9--
