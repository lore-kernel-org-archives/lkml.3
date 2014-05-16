Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaEPNWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:22:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:39142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbaEPNWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:22:23 -0400
Date: Fri, 16 May 2014 15:22:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mingo@kernel.org,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH RFC] sched,numa: decay wakee_flips instead of zeroing
Message-ID: <20140516132217.GR11096@twins.programming.kicks-ass.net>
References: <20140516001332.67f91af2@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fIj/D6Y6BN1okdX1"
Content-Disposition: inline
In-Reply-To: <20140516001332.67f91af2@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fIj/D6Y6BN1okdX1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 12:13:32AM -0400, Rik van Riel wrote:
> Affine wakeups have the potential to interfere with NUMA placement.
> If a task wakes up too many other tasks, affine wakeups will get
> disabled.
>=20
> However, regardless of how many other tasks it wakes up, it gets
> re-enabled once a second, potentially interfering with NUMA
> placement of other tasks.
>=20
> By decaying wakee_wakes in half instead of zeroing it, we can avoid
> that problem for some workloads.

See https://lkml.org/lkml/2013/7/2/110 and further

> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4f01e2f1..0381b11 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4009,7 +4009,7 @@ static void record_wakee(struct task_struct *p)
>  	 * about the loss.
>  	 */
>  	if (jiffies > current->wakee_flip_decay_ts + HZ) {
> -		current->wakee_flips =3D 0;
> +		current->wakee_flips >>=3D 1;
>  		current->wakee_flip_decay_ts =3D jiffies;
>  	}

Would it make sense to do something like:

	now =3D jiffies;
	while (current->wakee_flips && now > current->wakee_flip_decay_ts + HZ) {
		current->wakee_flips >>=3D 1;
		current->wakee_flip_decay_ts +=3D HZ;
	}
	if (unlikely(now > current->wakee_flip_decay_ts + HZ))
		current->wakee_flip_decay_ts =3D now;

Or is that over engineering things?



--fIj/D6Y6BN1okdX1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdhEJAAoJEHZH4aRLwOS6WnQP/3X2BqfmPOvFv3Ut9hSg78fZ
dJ/nI5hfR3raWkiwBKUo7DXkpYQRB9zHPl0Zrj38mSwBEOHquD086CIN7O2BcWxR
HnFNWMWJabqYkLFnF82lBNWOaCQ5hNVvHRppjlQyvQebIoO5fwhVSgRVP2McYWFW
BruJBMm/DVjS5KcopIrZLnLhfhf5ku1CaZVER9tw1Y4+DEddVhHXRzvpvLuCSO5c
JscsgAefppIxkUTkgTZd60Co+OdHbs6sdjVxTdkKoViRrLuo2Al11XpPooL0dC+3
93anZ1ZC+7gqdgKQp5dNDYXxbdIksOjbu4PLu1EpM+cWdHZgfR5sCb03gg021VrP
tNHswj9kMjkfxlXoA9caih6Tq56wsTxuvTO/WXxQ09LrZevlcgOUClLnNGEvQVQq
2ytV5UsoCwJvjIsuFX3IF0h86fahuJEzn6ONeHb802kG0xpnge1hwfkR/uUjgtQo
aEA5tESLJQQ7Ibbul4K/VGZTNh4BvPvXoB9Jz6TTpos6YqHghtnMG6rXeQtm2o4j
PbCqx3pmPFY9q7x42ad/CcfsA+/xqUcwMXYKPUfEAHGnwCUCNkj5zt3Gp2g36fY4
luUTQe01TxTdadq0Bs6kZv110XsFNfJQgrmNnoOGEwfFfxMESRO6r5zGWLhoLp5x
CExK8rcUJeVju0hXpgWd
=0JMm
-----END PGP SIGNATURE-----

--fIj/D6Y6BN1okdX1--
