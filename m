Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbaEPJfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:35:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbaEPJfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:35:50 -0400
Date: Fri, 16 May 2014 11:35:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140516093530.GN11096@twins.programming.kicks-ass.net>
References: <537119EF.2060102@oracle.com>
 <20140512200135.GL1421@htj.dyndns.org>
 <53718119.1090000@cn.fujitsu.com>
 <537180B9.6080407@oracle.com>
 <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/eSpIzx5LyAe5lwl"
Content-Disposition: inline
In-Reply-To: <53758B12.8060609@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/eSpIzx5LyAe5lwl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 11:50:42AM +0800, Lai Jiangshan wrote:
> After debugging, I found the hotlug-in cpu is atctive but !online in this=
 case.
> the problem was introduced by 5fbd036b.
> Some code assumes that any cpu in cpu_active_mask is also online, but 5fb=
d036b breaks
> this assumption, so the corresponding code with this assumption should be=
 changed too.

Good find, and yes it does that.

> The following patch is just a workaround. After it is applied, the above =
WARNING
> is gone, but I can't hit the wq problem that you found.

Seeing how the entirety of hotplug is basically duct tape and twigs, the
below isn't that bad.

> ---
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index a9e710e..253a129 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -726,9 +726,10 @@ void set_cpu_present(unsigned int cpu, bool present)
> =20
>  void set_cpu_online(unsigned int cpu, bool online)
>  {
> -	if (online)
> +	if (online) {
>  		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
> -	else
> +		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
> +	} else
>  		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
>  }
> =20
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45e..c1a712d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5043,7 +5043,6 @@ static int sched_cpu_active(struct notifier_block *=
nfb,
>  				      unsigned long action, void *hcpu)
>  {
>  	switch (action & ~CPU_TASKS_FROZEN) {
> -	case CPU_STARTING:
>  	case CPU_DOWN_FAILED:
>  		set_cpu_active((long)hcpu, true);
>  		return NOTIFY_OK;

--/eSpIzx5LyAe5lwl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTddviAAoJEHZH4aRLwOS6IWMQAKE/16AoFPYzZ3kHHInfhKNx
ptGb4hey6e2oBhsEgHmmk6Ua8RDDi/VvwShuFpI59onONf3PgnSGs/FA3h2CceyX
mN/A8dWuD/tB4a17JqfbQflJM6ecduuARxaE0dRC68C/tswpV21gm0BWD7Roqixe
IKiKh48jBW6QFHKnYbdMXhfhZpTSH6HTx9jm4x7/VHqE2iRoj5qZTVlyh+63asfz
m5xUi4+qLEiS1HCkdcW2ERhbf/lCa+siDx5+DnrMjJHA6QQ06Y/r0emFrMvVOyj0
aqdIsfnM9CbrsgzCqXtsODgzBYOFfW6Cori0UgbOs0x5A3FTuUDVlwG7Dz5j8+z5
5pn4XEPzqfa2IYQ7BA2qeXfKFYkEy4Hy0dTKHs5pdhF5zQ7DGWT+/ZKdsLX6Pr9i
B/YesYVHzmnBSCIYtybckLepCaqWG9ZuYS+DdgkayjF49bCjfgZQQXoMd3XLKxnc
Uz+yVfzqiHZf/FeJ2928/yBO0eiICbw2Z55U7SzO300PB4j/xceBfJn/LcZC8eac
BSPthSPhHovJF4qyT09grr1L4fBWUvzXEAbhPQ6nCkChvASd3aYLOW2V8jtHmsxG
fspAYGC3ais5E5DjGG7A7WRjktu+P9hOjuD5aNNa3K5AA8GVWcqalnbsD5sjyFqV
wD7ahN38yAHmNKu5BVe/
=gp//
-----END PGP SIGNATURE-----

--/eSpIzx5LyAe5lwl--
