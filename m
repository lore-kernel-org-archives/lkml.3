Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaG1IBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:01:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:57659 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaG1IBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:01:35 -0400
Date: Mon, 28 Jul 2014 10:01:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, nicolas.pitre@linaro.org, pjt@google.com,
        oleg@redhat.com, rostedt@goodmis.org, umgwanakikbuti@gmail.com,
        ktkhai@parallels.com, tim.c.chen@linux.intel.com, mingo@kernel.org
Subject: Re: [PATCH v2 2/5] sched: Teach scheduler to understand
 ONRQ_MIGRATING state
Message-ID: <20140728080122.GL6758@twins.programming.kicks-ass.net>
References: <20140726145508.6308.69121.stgit@localhost>
 <20140726145912.6308.32554.stgit@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gs908mnGcSDw3ZDB"
Content-Disposition: inline
In-Reply-To: <20140726145912.6308.32554.stgit@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gs908mnGcSDw3ZDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 26, 2014 at 06:59:21PM +0400, Kirill Tkhai wrote:

> The profit is that double_rq_lock() is not needed now,
> and this may reduce the latencies in some situations.

> We add a loop in the beginning of set_cpus_allowed_ptr.
> It's like a handmade spinlock, which is similar
> to situation we had before. We used to spin on rq->lock,
> now we spin on "again:" label. Of course, it's worse
> than arch-dependent spinlock, but we have to have it
> here.=20

> @@ -4623,8 +4639,16 @@ int set_cpus_allowed_ptr(struct task_struct *p, co=
nst struct cpumask *new_mask)
>  	struct rq *rq;
>  	unsigned int dest_cpu;
>  	int ret =3D 0;
> +again:
> +	while (unlikely(task_migrating(p)))
> +		cpu_relax();
> =20
>  	rq =3D task_rq_lock(p, &flags);
> +	/* Check again with rq locked */
> +	if (unlikely(task_migrating(p))) {
> +		task_rq_unlock(rq, p, &flags);
> +		goto again;
> +	}
> =20
>  	if (cpumask_equal(&p->cpus_allowed, new_mask))
>  		goto out;

So I really dislike that, esp since you're now talking of adding more of
this goo all over the place.

I'll ask again, why isn't this in task_rq_lock() and co?

Also, you really need to talk the spin bounded, otherwise your two
quoted paragraphs above are in contradiction. Now I think you can
actually make an argument that way, so that's good.

--gs908mnGcSDw3ZDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1gNRAAoJEHZH4aRLwOS67dMP/jn/du1Un+jfHE1VcvCvZmzC
ER9wty8Ti1/IxKgkokJwcT4yUlWfoOW/+62GMKVg1XoK9ohpVKhqdpL9y0HGrJ7S
8bJQIvxBISQ1vUHNV6ueET8MZDtm72Xb6t7Lsz5CykEhtyMNpQd4LZLct3JIM26E
bquYhj1DOc9fd/StmAnlgoEEF9ugp5pfNjryQtAONsiio32/vTN1Snei+294VJ/2
57dkP5jjx0fVywMXnEFL1TqpJAZAtrwqkmDQT/Kn1xGPdG3TTrNcqRiY9nHmYGad
hwA5PSt6cSkrZUMextDc0zDKkGqmmgFU4rDfmMUW7by8R5dOJnWHsXCf0YTwWIgS
ibMiTVHeW3X8WvK2jF0JmZ7BkqGC/hFvJ9FzrPLfp5skKCv0/Ps5teMfhTSpc2p7
i4Hu2R4JqKhVPhrLNL03S4JFP3NX4llzMBgSnM1bqlUq+XCioG2sYpxUoJiu9Knp
Y+O/aYPSjTvbkkiLzEBmibXKn42puMaYIriiz/VygSGWpSRejbFfceGfEgRh+6n3
9kme23UdfQXze/NQ/MgkN7f52ncxaWdQoVmptXTNfIAqUZ3LEEtyWN/jOhQXh5u2
p9KnRtGFIzwfefZTjQbXhsNh56ud4dD3wN2cNhkUZqL/OA1LDiqvT1/qoL1hf4Dz
ZfZC2eTqyfmwLcxj6w8p
=GoYR
-----END PGP SIGNATURE-----

--gs908mnGcSDw3ZDB--
