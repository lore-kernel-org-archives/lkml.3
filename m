Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863AbaFJKhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:37:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:48520 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaFJKhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:37:04 -0400
Date: Tue, 10 Jun 2014 12:36:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
Cc: paulus@samba.org, mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [RFC PATCH] perf/amd: Try to fix some mem allocation failure
 handling
Message-ID: <20140610103659.GD6758@twins.programming.kicks-ass.net>
References: <1402393029-11561-1-git-send-email-zhouzhouyi@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UsiV5d7KlsBC0zIw"
Content-Disposition: inline
In-Reply-To: <1402393029-11561-1-git-send-email-zhouzhouyi@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UsiV5d7KlsBC0zIw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 05:37:09PM +0800, Zhouyi Zhou wrote:
> This is version 2.0 of "[PATCH 1/1] perf/amd: NULL return of kzalloc_node=
 should be handled"
> (http://www.spinics.net/lists/kernel/msg1760689.html),
>=20
> Try to correctly handle mem allocation failure in perf_event_amd_uncore.c
>=20
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> ---
>  arch/x86/kernel/cpu/perf_event_amd_uncore.c |   36 +++++++++++++++++++++=
+++---
>  1 file changed, 33 insertions(+), 3 deletions(-)
>=20
> diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kerne=
l/cpu/perf_event_amd_uncore.c
> index 3bbdf4c..bdc8e49 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
> @@ -294,12 +294,14 @@ static struct amd_uncore *amd_uncore_alloc(unsigned=
 int cpu)
>  			cpu_to_node(cpu));
>  }
> =20
> -static void amd_uncore_cpu_up_prepare(unsigned int cpu)
> +static int amd_uncore_cpu_up_prepare(unsigned int cpu)
>  {
>  	struct amd_uncore *uncore;
> =20
>  	if (amd_uncore_nb) {
>  		uncore =3D amd_uncore_alloc(cpu);
> +		if (!uncore)
> +			return 1;
>  		uncore->cpu =3D cpu;
>  		uncore->num_counters =3D NUM_COUNTERS_NB;
>  		uncore->rdpmc_base =3D RDPMC_BASE_NB;
> @@ -311,6 +313,11 @@ static void amd_uncore_cpu_up_prepare(unsigned int c=
pu)
> =20
>  	if (amd_uncore_l2) {
>  		uncore =3D amd_uncore_alloc(cpu);
> +		if (!uncore) {
> +			if (amd_uncore_nb)
> +				kfree(*per_cpu_ptr(amd_uncore_nb, cpu));
> +			return 1;
> +		}
>  		uncore->cpu =3D cpu;
>  		uncore->num_counters =3D NUM_COUNTERS_L2;
>  		uncore->rdpmc_base =3D RDPMC_BASE_L2;
> @@ -319,6 +326,8 @@ static void amd_uncore_cpu_up_prepare(unsigned int cp=
u)
>  		uncore->pmu =3D &amd_l2_pmu;
>  		*per_cpu_ptr(amd_uncore_l2, cpu) =3D uncore;
>  	}
> +
> +	return 0;
>  }

Maybe return -ENOMEM here already.

>  static struct amd_uncore *
> @@ -461,7 +470,8 @@ amd_uncore_cpu_notifier(struct notifier_block *self, =
unsigned long action,
> =20
>  	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_UP_PREPARE:
> -		amd_uncore_cpu_up_prepare(cpu);
> +		if (amd_uncore_cpu_up_prepare(cpu))
> +			return notifier_from_errno(-ENOMEM),
>  		break;
> =20
>  	case CPU_STARTING:
> @@ -514,6 +524,8 @@ static int __init amd_uncore_init(void)
> =20
>  	if (cpu_has_perfctr_nb) {
>  		amd_uncore_nb =3D alloc_percpu(struct amd_uncore *);
> +		if (!amd_uncore_nb)
> +			return -ENOMEM;
>  		perf_pmu_register(&amd_nb_pmu, amd_nb_pmu.name, -1);
> =20
>  		printk(KERN_INFO "perf: AMD NB counters detected\n");
> @@ -522,6 +534,13 @@ static int __init amd_uncore_init(void)
> =20
>  	if (cpu_has_perfctr_l2) {
>  		amd_uncore_l2 =3D alloc_percpu(struct amd_uncore *);
> +		if (!amd_uncore_l2) {
> +			if (cpu_has_perfctr_nb) {
> +				perf_pmu_unregister(&amd_nb_pmu);

Combined with the below (extra for_each_cpu loop) you might want to
think of the 'normal' error handling goto chain.

err_online:
	for_each_online_cpu(cpu2) {
		if (cpu2 =3D=3D cpu)
			break;

		/* cleanup cpu2 */
	}
err_l2:
	perf_pmu_unregister(nb);
	free_percpu(nb);
err_nb:
	return ret;
=09

> +				free_percpu(amd_uncore_nb);
> +			}
> +			return -ENOMEM;
> +		}
>  		perf_pmu_register(&amd_l2_pmu, amd_l2_pmu.name, -1);

Then you can propagate the error here, instead of assuming -ENOMEM.

>  		printk(KERN_INFO "perf: AMD L2I counters detected\n");
> @@ -535,7 +554,18 @@ static int __init amd_uncore_init(void)
> =20
>  	/* init cpus already online before registering for hotplug notifier */
>  	for_each_online_cpu(cpu) {
> -		amd_uncore_cpu_up_prepare(cpu);
> +		if (amd_uncore_cpu_up_prepare(cpu)) {
> +			if (cpu_has_perfctr_nb) {
> +				perf_pmu_unregister(&amd_nb_pmu);
> +				free_percpu(amd_uncore_nb);
> +			}
> +			if (cpu_has_perfctr_l2) {
> +				perf_pmu_unregister(&amd_l2_pmu);
> +				free_percpu(amd_uncore_l2);
> +			}
> +			cpu_notifier_register_done();
> +			return -ENOMEM;
> +		}
>  		smp_call_function_single(cpu, init_cpu_already_online, NULL, 1);
>  	}

I think you want a second for_each_online_cpu() loop and undo the work
for the other CPUs before calling unregister etc..



--UsiV5d7KlsBC0zIw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlt/LAAoJEHZH4aRLwOS6TqUQAK1yQikZWgvIaXiLoz8GOz5J
DhMuXrwhntPTgCgeH/7O/dxlgmP9b3BNHEQxiqfpbuxIYG0SMl2blGC6KBgTRqgM
4cXa2bJj5ovSfF33tOhaHSxUR7LGGKoQ2XAPi+BbocaRXPeSNzA8lUWjGMZW/AAV
o0xzpOOQZoSejJY7ChAWfY86fdBq9kfzMmQWTNZUUVi5kZgHICWjaqwgPfJRMP9c
pmp3udK/TDXC5k8WTUVmwfi3752M2Tn56j77L5POYtjnbdVfsAJwv6aGh9FsokT5
SRSDMDcLLCrsGIEMTgyA7VVD6zIgZXTnvlwW459NOFdQ7rj8iPEdqGCkw6+PE5tk
O6E9d2QoxytS0V2bGysN3YuVa/GDXSyu71G8bspANa5fcvFEAsNQzcaLYK45XW3d
RbK6sxFeSKsMWqQnLeNSeOxdaW2Uen32lpdQPypE7eW1Ouc+BxjNAfLNfGrJ4L+j
JTmx6ifhBSurjhrkJoHv9KWQf1mQo8EP97M6IuZ/ebB1/4xk7JGMWqgLhRY1oP1g
Y5+pdGE76ntLL0sTrEjv4Rq855Ur7VU4CFgF4919msIB/oVuL3/npT1f9g0q8cMt
/z3KY5+XqFrSLdKboqUbQBTMx2cm7ba7gIjwQwxHKqjPJrPNkAsHeOlm2lEjxkrE
kgBBj1ewKvELWiyfFF0f
=jRTr
-----END PGP SIGNATURE-----

--UsiV5d7KlsBC0zIw--
