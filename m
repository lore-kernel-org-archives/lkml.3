Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaEOIwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:52:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:56837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaEOIwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:52:02 -0400
Date: Thu, 15 May 2014 10:51:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140515085156.GG30445@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
 <20140514140034.GM30445@twins.programming.kicks-ass.net>
 <20140515104055.e91844a5b75529edc560349a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADUFSHE2qQv+ehpq"
Content-Disposition: inline
In-Reply-To: <20140515104055.e91844a5b75529edc560349a@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADUFSHE2qQv+ehpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 10:40:55AM +0200, Juri Lelli wrote:
> Hi,
>=20
> > @@ -37,10 +38,7 @@ static inline int dl_time_before(u64 a, u64 b)
> > =20
> >  static void cpudl_exchange(struct cpudl *cp, int a, int b)
> >  {
> > -	int cpu_a =3D cp->elements[a].cpu, cpu_b =3D cp->elements[b].cpu;
> > -
> >  	swap(cp->elements[a], cp->elements[b]);
> > -	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
> >  }
> > =20
>=20
> I think there is a problem here. Your patch "embeds" cpu_to_idx array
> in elements array, but here the swap operates differently on the two.

<snip>

> Sorry for this long reply, but I had to convince also myself...

Glad you explained it before I tried to untangle that code myself.

> So, I think that having just one dynamic array is nicer and better, but
> we still need to swap things separately. Something like (on top of
> yours):
>=20
> diff --git a/kernel/sched/cpudeadline.c b/kernel/sched/cpudeadline.c
> index 60ad0af..10dc7ab 100644
> --- a/kernel/sched/cpudeadline.c
> +++ b/kernel/sched/cpudeadline.c
> @@ -36,9 +36,31 @@ static inline int dl_time_before(u64 a, u64 b)
>         return (s64)(a - b) < 0;
>  }
> =20
> +static inline void swap_element(struct cpudl *cp, int a, int b)
> +{
> +       int cpu_tmp =3D cp->elements[a].cpu;
> +       u64 dl_tmp =3D cp->elements[a].dl;
> +
> +       cp->elements[a].cpu =3D cp->elements[b].cpu;
> +       cp->elements[a].dl =3D cp->elements[b].dl;
> +       cp->elements[b].cpu =3D cpu_tmp;
> +       cp->elements[b].dl =3D dl_tmp;

You could've just written:

	swap(cp->elements[a].cpu, cp->elements[b].cpu);
	swap(cp->elements[a].dl , cp->elements[b].dl );

The swap macro does the tmp var for you.

> +}
> +
> +static inline void swap_idx(struct cpudl *cp, int a, int b)
> +{
> +       int idx_tmp =3D cp->elements[a].idx;
> +
> +       cp->elements[a].idx =3D cp->elements[b].idx;
> +       cp->elements[b].idx =3D idx_tmp;

	swap(cp->elements[a].idx, cp->elements[b].idx);

> +}
> +
>  static void cpudl_exchange(struct cpudl *cp, int a, int b)
>  {
> -       swap(cp->elements[a], cp->elements[b]);
> +       int cpu_a =3D cp->elements[a].cpu, cpu_b =3D cp->elements[b].cpu;
> +
> +       swap_element(cp, a, b);
> +       swap_idx(cp, cpu_a, cpu_b);

Or just skip the lot and put the 3 swap() stmts here.

>  }
> =20
>  static void cpudl_heapify(struct cpudl *cp, int idx)
> ---
>=20
> But, I don't know if this is too ugly and we better go with two arrays
> (or a better solution, as this is the fastest thing I could come up
> with :)).

Thanks for looking at it, and sorry for breaking it.

--ADUFSHE2qQv+ehpq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdIAsAAoJEHZH4aRLwOS6q2MQALVyUfJm0CPA67EDAX+8ZWVU
gYI6Y/rT4ZPoOvtawbKkKx8D3ozRAG9a7rUtRsg2H3+i88z5z6U/x1nvd15FUBoo
lcvdbOFu885QRVq4s7Bq24l6bwBPJOzUrkAIPUXG60EsoiUnzzB1b9fBc2QaSybi
dLcBbEITYni6BgPfas19uBd6uxp9qIR8rlkV5wPzizHGHiVEJ8efTrNumeO9UUkS
jud6cvmEYG5mWBgLjNNHz1PyZI6MHozdEF2c3XCExm3mamxPQZz3BBSTwm6QrW8g
U70KsbCL9qdJoih5KYB3w4SDyiVhakChvSgYOanweWOHlH2WExkkuDIukIvnq7++
qXgbiakLfBE23VFA5I94KDnbeIWLixfLgOZhgR43FT1Tu40ktlZOQU9fBKVYNIoY
Fituv728plScT8SnzjvXZYUIB/VWO8k6tb+aF0LagckBZFdvzvsAgemdugmcCp+N
srWRl46M2zfF3EGheCtse/sPkQahWvEB5R72uzHSiM7mKnng/revnG42DqZiAsEV
svUP9oxMphmIBeVhFZzipdRRCogKZWps/t68hv3z5u+JAhf7+Z8Jj5oaZbwSEE/9
npUdcXMDWC82Pu3o0JRaIktefeXxLTcKj9FJvErGhmdBqL3yiuhYjS30nksJ+fjH
nTf46+4XeVN4pvfUNtzY
=4T+U
-----END PGP SIGNATURE-----

--ADUFSHE2qQv+ehpq--
