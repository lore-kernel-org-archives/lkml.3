Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbaENOGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:06:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:49784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaENOGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:06:00 -0400
Date: Wed, 14 May 2014 16:05:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140514140556.GL13658@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
 <20140514140034.GM30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Li7ckgedzMh1NgdW"
Content-Disposition: inline
In-Reply-To: <20140514140034.GM30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Li7ckgedzMh1NgdW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 04:00:34PM +0200, Peter Zijlstra wrote:
> The below is a mostly no thought involved conversion of cpudl which
                        ^^^^^^^^^^^^^^^^^^^

> boots, I'll also do cpupri and then actually stare at the algorithms to
> see if I didn't make any obvious fails.
>=20
> Juri?
>=20
> ---
> @@ -195,10 +193,21 @@ int cpudl_init(struct cpudl *cp)
>  	memset(cp, 0, sizeof(*cp));
>  	raw_spin_lock_init(&cp->lock);
>  	cp->size =3D 0;
> -	for (i =3D 0; i < NR_CPUS; i++)
> -		cp->cpu_to_idx[i] =3D IDX_INVALID;
> -	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL))
> +
> +	cp->elements =3D kcalloc(num_possible_cpus(),
> +			       sizeof(struct cpudl_item),
> +			       GFP_KERNEL);
> +	if (!cp->elements)
> +		return -ENOMEM;
> +
> +	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
> +		kfree(cp->elements);
>  		return -ENOMEM;
> +	}
> +
> +	for_each_possible_cpu(i)
> +		cp->elements[i].idx =3D IDX_INVALID;
> +
>  	cpumask_setall(cp->free_cpus);
> =20
>  	return 0;

Also add:

---
--- a/kernel/sched/cpudeadline.c
+++ b/kernel/sched/cpudeadline.c
@@ -220,4 +220,5 @@ int cpudl_init(struct cpudl *cp)
 void cpudl_cleanup(struct cpudl *cp)
 {
 	free_cpumask_var(cp->free_cpus);
+	kfree(cp->elements);
 }

--Li7ckgedzMh1NgdW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc3hEAAoJEHZH4aRLwOS6GsUP/1T4dZjfo4xlINxSfHSZkYmx
21o6/VonFzB5Kq+knksQtTFgnUAa6LQxLsoAJTSU4zEO0Koszmgf94APuJldSLfF
C2rsmuVn8hl4uccMgsGo52DSDek5zL9lERl7HMgX8iASmCJNSCxN1WGUY6sG1d1T
Z8P+rojUNdx4QdvV+K7yqQastnK7CESgDtN9DYGrdSJDkzHsuhdO4SGtQoF1LUG9
FHU79MXT8dDSyuLnyxgeJ0Gw67A533FxaTCL3/sizrGwHNTsXc6Mmcbk5NnS1oMP
9K2AJsnx3k1GJoJlm6eBM8JZyPENZGXQ/Of+KDL563ecJ85HvbzG1HxEWpOnG1P6
v4miP+skjH1iHjO1PQvpmgd1vAL+SHdjdshjbegg9k4gLMYiESjTuYdbTL08Ewwi
x9OgFNDXC5rEg4LFEnk32zO43hsL2QG6OwmTiBww+cdU8cCX9Yh4Jbxgi2luO0CO
yDIv0hTJrGlwZcL/rU/XBUwmpKq7uWvlexWJKXH/Nk94HEzhLG2ZFLF+imGnfsxc
DncBxI2gDFeRW6ZQEyycz8jpwp8GazyVk2UEEvvy006Iyw1t5z5RC4OJe0d6GOD6
KZm7AymdgRJMmd1DwBrzUVrqUe/Zfw3s2N5/wR24uYUOubrObC09WBIC95oWOA1n
wZHkw5Ymxym7cIEc1RZb
=q436
-----END PGP SIGNATURE-----

--Li7ckgedzMh1NgdW--
