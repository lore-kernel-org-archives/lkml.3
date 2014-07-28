Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaG1Ksx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:48:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:58336 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaG1Ksu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:48:50 -0400
Date: Mon, 28 Jul 2014 12:48:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140728104837.GQ6758@twins.programming.kicks-ass.net>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ke4/Zunobcr7FoIC"
Content-Disposition: inline
In-Reply-To: <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ke4/Zunobcr7FoIC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 07:26:06AM +0800, Yuyang Du wrote:
> @@ -665,20 +660,27 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, stru=
ct sched_entity *se)
>  }
> =20
>  #ifdef CONFIG_SMP
> -static unsigned long task_h_load(struct task_struct *p);
> =20
> -static inline void __update_task_entity_contrib(struct sched_entity *se);
> +/* dependent on LOAD_AVG_PERIOD, see below */
> +#define LOAD_AVG_MAX 47742 /* maximum possible load avg */

Please don't separate this from the rest of the values it belongs to. If
you really have to, move the entire block.

> @@ -2071,13 +2073,9 @@ static inline long calc_tg_weight(struct task_grou=
p *tg, struct cfs_rq *cfs_rq)
>  	long tg_weight;
> =20
>  	/*
> -	 * Use this CPU's actual weight instead of the last load_contribution
> -	 * to gain a more accurate current total weight. See
> -	 * update_cfs_rq_load_contribution().
> +	 * Use this CPU's load average instead of actual weight
>  	 */
>  	tg_weight =3D atomic_long_read(&tg->load_avg);
> -	tg_weight -=3D cfs_rq->tg_load_contrib;
> -	tg_weight +=3D cfs_rq->load.weight;

I don't think that comment makes any sense after this. The comment was
there to explain the -=3D, +=3D things, but that's all gone so its pretty
trivial now, and i++ /* inc by one */ comments are not useful.

> @@ -2181,7 +2178,7 @@ static const u32 runnable_avg_yN_sum[] =3D {
>   * Approximate:
>   *   val * y^n,    where y^32 ~=3D 0.5 (~1 scheduling period)
>   */
> -static __always_inline u64 decay_load(u64 val, u64 n)
> +static __always_inline u64 decay_load32(u64 val, u64 n)
>  {
>  	unsigned int local_n;
> =20
> @@ -2210,6 +2207,18 @@ static __always_inline u64 decay_load(u64 val, u64=
 n)
>  	return val >> 32;
>  }
> =20
> +static __always_inline u64 decay_load(u64 val, u64 n)
> +{
> +	if (likely(val <=3D UINT_MAX))
> +		val =3D decay_load32(val, n);
> +	else {
> +		val *=3D (u32)decay_load32(1 << 15, n);
> +		val >>=3D 15;
> +	}
> +
> +	return val;
> +}

Please just use mul_u64_u32_shr().

/me continues reading the rest of it..

--ke4/Zunobcr7FoIC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1iqFAAoJEHZH4aRLwOS6qpsP/AgwFxS1RrgXcZWmZNGuqlNG
5ANvaI4fwTR3CTJOVvFuoAhd4YCL7YQz9UycBA5+bn/L/fUZs81bq1g8vQ1Ot+ta
rAvq6tfCT740fNRnMxiwr0jBvGtFqQA4l3PegNreyXNcv6owu4cDam4eF+cb8YGP
6VW4U4afr9kr1tTeEyvwLPLEqaxwUs3PHU0aVsHhyOf7OTPFjZ6CErpOX+E6Pi62
E64/CZlT9SuwBFKupmsDUQyNaqSBfy4IvEBZDIm0AXCfZ2Apl8wG4uA6asdMwT95
P2fMglXP3e6nnVyggP27N+4DylSLLs0C/pj2LqXOgRm8IZFB0C0BrovlWT8LoGPt
FE5jFyAvNjkiwef//N7bFizQQN/8TeTRskMIwF/yPNfLPIscntFeW9vLMM52eqiw
LEdpI3rg0CYH7lIUEQzfwFSlWTGLXfyYjYrK1Kew/jmLzC39+fSN2Esxevfa82fI
UPAOrAznIdrjpywzTYcgO7Wme7nY/EDByd+ehAaUrfeOD/SjcMBgDmoknFHC907K
TEA478aYcguafdglememD2Ddx9G+0Ogyio3xEJxkaAf1P2k61H3uY7LFvzhIKQML
uogx2/R2frAHduz97BuDkYI0rwqdvLWHmUMc+pDKmc3aBq6m850NdD6QBNfBZaYg
h6Y9aaOVs9Vbxq7F/S7a
=91DJ
-----END PGP SIGNATURE-----

--ke4/Zunobcr7FoIC--
