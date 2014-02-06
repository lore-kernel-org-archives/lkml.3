Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaBFBMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 20:12:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34206 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754483AbaBFBMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 20:12:09 -0500
Date: Thu, 6 Feb 2014 12:11:51 +1100
From: NeilBrown <neilb@suse.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 45/51] md, raid5: Fix CPU hotplug callback registration
Message-ID: <20140206121151.0cbdbaa1@notabene.brown>
In-Reply-To: <20140205221244.19080.70910.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
	<20140205221244.19080.70910.stgit@srivatsabhat.in.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8Sh5fJFndN.WKIU2q1H+blD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8Sh5fJFndN.WKIU2q1H+blD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 06 Feb 2014 03:42:45 +0530 "Srivatsa S. Bhat"
<srivatsa.bhat@linux.vnet.ibm.com> wrote:

> From: Oleg Nesterov <oleg@redhat.com>
>=20
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:
>=20
> 	get_online_cpus();
>=20
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
>=20
> 	register_cpu_notifier(&foobar_cpu_notifier);
>=20
> 	put_online_cpus();
>=20
> This is wrong, since it is prone to ABBA deadlocks involving the
> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
> with CPU hotplug operations).
>=20
> Interestingly, the raid5 code can actually prevent double initialization =
and
> hence can use the following simplified form of callback registration:
>=20
> 	register_cpu_notifier(&foobar_cpu_notifier);
>=20
> 	get_online_cpus();
>=20
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
>=20
> 	put_online_cpus();
>=20
> A hotplug operation that occurs between registering the notifier and call=
ing
> get_online_cpus(), won't disrupt anything, because the code takes care to
> perform the memory allocations only once.
>=20
> So reorganize the code in raid5 this way to fix the deadlock with callback
> registration.
>=20
> Cc: Neil Brown <neilb@suse.de>
> Cc: linux-raid@vger.kernel.org
> Cc: stable@vger.kernel.org
> [Srivatsa: Fixed the unregister_cpu_notifier() deadlock, added the
> free_scratch_buffer() helper to condense code further and wrote the chang=
elog.]
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>=20
>  drivers/md/raid5.c |   90 +++++++++++++++++++++++++---------------------=
------
>  1 file changed, 44 insertions(+), 46 deletions(-)
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f1feade..16f5c21 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5514,23 +5514,43 @@ raid5_size(struct mddev *mddev, sector_t sectors,=
 int raid_disks)
>  	return sectors * (raid_disks - conf->max_degraded);
>  }
> =20
> +static void free_scratch_buffer(struct r5conf *conf, struct raid5_percpu=
 *percpu)
> +{
> +	safe_put_page(percpu->spare_page);
> +	kfree(percpu->scribble);
> +	percpu->spare_page =3D NULL;
> +	percpu->scribble =3D NULL;
> +}
> +
> +static int alloc_scratch_buffer(struct r5conf *conf, struct raid5_percpu=
 *percpu)
> +{
> +	if (conf->level =3D=3D 6 && !percpu->spare_page)
> +		percpu->spare_page =3D alloc_page(GFP_KERNEL);
> +	if (!percpu->scribble)
> +		percpu->scribble =3D kmalloc(conf->scribble_len, GFP_KERNEL);
> +
> +	if (!percpu->scribble || (conf->level =3D=3D 6 && !percpu->spare_page))=
 {
> +		free_scratch_buffer(conf, percpu);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}
> +
>  static void raid5_free_percpu(struct r5conf *conf)
>  {
> -	struct raid5_percpu *percpu;
>  	unsigned long cpu;
> =20
>  	if (!conf->percpu)
>  		return;
> =20
> -	get_online_cpus();
> -	for_each_possible_cpu(cpu) {
> -		percpu =3D per_cpu_ptr(conf->percpu, cpu);
> -		safe_put_page(percpu->spare_page);
> -		kfree(percpu->scribble);
> -	}
>  #ifdef CONFIG_HOTPLUG_CPU
>  	unregister_cpu_notifier(&conf->cpu_notify);
>  #endif
> +
> +	get_online_cpus();
> +	for_each_possible_cpu(cpu)
> +		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
>  	put_online_cpus();
> =20
>  	free_percpu(conf->percpu);
> @@ -5557,15 +5577,7 @@ static int raid456_cpu_notify(struct notifier_bloc=
k *nfb, unsigned long action,
>  	switch (action) {
>  	case CPU_UP_PREPARE:
>  	case CPU_UP_PREPARE_FROZEN:
> -		if (conf->level =3D=3D 6 && !percpu->spare_page)
> -			percpu->spare_page =3D alloc_page(GFP_KERNEL);
> -		if (!percpu->scribble)
> -			percpu->scribble =3D kmalloc(conf->scribble_len, GFP_KERNEL);
> -
> -		if (!percpu->scribble ||
> -		    (conf->level =3D=3D 6 && !percpu->spare_page)) {
> -			safe_put_page(percpu->spare_page);
> -			kfree(percpu->scribble);
> +		if (alloc_scratch_buffer(conf, percpu)) {
>  			pr_err("%s: failed memory allocation for cpu%ld\n",
>  			       __func__, cpu);
>  			return notifier_from_errno(-ENOMEM);
> @@ -5573,10 +5585,7 @@ static int raid456_cpu_notify(struct notifier_bloc=
k *nfb, unsigned long action,
>  		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> -		safe_put_page(percpu->spare_page);
> -		kfree(percpu->scribble);
> -		percpu->spare_page =3D NULL;
> -		percpu->scribble =3D NULL;
> +		free_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
>  		break;
>  	default:
>  		break;
> @@ -5588,40 +5597,29 @@ static int raid456_cpu_notify(struct notifier_blo=
ck *nfb, unsigned long action,
>  static int raid5_alloc_percpu(struct r5conf *conf)
>  {
>  	unsigned long cpu;
> -	struct page *spare_page;
> -	struct raid5_percpu __percpu *allcpus;
> -	void *scribble;
> -	int err;
> +	int err =3D 0;
> =20
> -	allcpus =3D alloc_percpu(struct raid5_percpu);
> -	if (!allcpus)
> +	conf->percpu =3D alloc_percpu(struct raid5_percpu);
> +	if (!conf->percpu)
>  		return -ENOMEM;
> -	conf->percpu =3D allcpus;
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +	conf->cpu_notify.notifier_call =3D raid456_cpu_notify;
> +	conf->cpu_notify.priority =3D 0;
> +	err =3D register_cpu_notifier(&conf->cpu_notify);
> +	if (err)
> +		return err;
> +#endif
> =20
>  	get_online_cpus();
> -	err =3D 0;
>  	for_each_present_cpu(cpu) {
> -		if (conf->level =3D=3D 6) {
> -			spare_page =3D alloc_page(GFP_KERNEL);
> -			if (!spare_page) {
> -				err =3D -ENOMEM;
> -				break;
> -			}
> -			per_cpu_ptr(conf->percpu, cpu)->spare_page =3D spare_page;
> -		}
> -		scribble =3D kmalloc(conf->scribble_len, GFP_KERNEL);
> -		if (!scribble) {
> -			err =3D -ENOMEM;
> +		err =3D alloc_scratch_buffer(conf, per_cpu_ptr(conf->percpu, cpu));
> +		if (err) {
> +			pr_err("%s: failed memory allocation for cpu%ld\n",
> +			       __func__, cpu);
>  			break;
>  		}
> -		per_cpu_ptr(conf->percpu, cpu)->scribble =3D scribble;
>  	}
> -#ifdef CONFIG_HOTPLUG_CPU
> -	conf->cpu_notify.notifier_call =3D raid456_cpu_notify;
> -	conf->cpu_notify.priority =3D 0;
> -	if (err =3D=3D 0)
> -		err =3D register_cpu_notifier(&conf->cpu_notify);
> -#endif
>  	put_online_cpus();
> =20
>  	return err;


Looks good, thanks.
Shall I wait for a signed-of-by from Oleg, then queue it through my md tree?

NeilBrown

--Sig_/8Sh5fJFndN.WKIU2q1H+blD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUvLhVznsnt1WYoG5AQKFmg//d1Kld0oVg0+dKRhM9dDXkuU3tP4K7Q9W
DsWITNBfQU/jgGxbp0ggkkIfOHtwKc6D0v1qEHLmvNQDfgq20fnU1msJ6mmbf1/N
d/CLiEjL8f1rEQeiBbh46xy47lnYHu2nTacG2oUy4X9vowxIQqdyGTYZULdicRi1
sI+RIjb8T6GgsybeKIxuSmPnltbxCbh9weQ7fENkCj9PfZz58d919Om2WhRk4bcV
hDCG2Wuxn2CJ9gjbn9D2FrhuvtO8RJ62YXjUSGu2rM3pIihwHMyL2l1GAydsFV/Z
6r+0lnafTEJH3F02yKjAjD98hfskRg1KxHMkl9pwydtdRJ1P4CtQ+RQqaYhdsGcZ
ZptvkslUs6znykhvAY8WnBTXH2mrE2fPyfA8ENiBRJNXZ6apfwXZnydcjkYtMx3R
SQeUu3H83pgEbyVY0/vLLKfs//66KvkNFf2nYZXv9mRcqkWcQWbRb26aF9w9Q/Gx
usVnr9i+B1D39+2T18di/QvaUhmMYpobMrJfdK0XuOAY4ndfZQHnOoFUxzfguOen
WBh+yC4cUX6MfqBMHoKwO0QJvGhfsw1hy+03SqAS4zo39X+OBFHKEeQRHtZ9HCEM
Uggym6ySvNWC3q4/NJlcJ4RclE5qe6i5CYixSJAKVwlXcx5wCO75SIIYph9o1cG+
YWhf35h9I20=
=pjqx
-----END PGP SIGNATURE-----

--Sig_/8Sh5fJFndN.WKIU2q1H+blD--
