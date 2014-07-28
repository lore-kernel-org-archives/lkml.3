Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaG1OaV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:30:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58544 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaG1OaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:30:20 -0400
Date: Mon, 28 Jul 2014 16:30:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH v2] sched: make update_sd_pick_busiest return true on a
 busier sd
Message-ID: <20140728143005.GU6758@twins.programming.kicks-ass.net>
References: <20140722144559.382c5243@annuminas.surriel.com>
 <20140725152728.GB6758@twins.programming.kicks-ass.net>
 <53D27B7E.8090404@redhat.com>
 <20140725160549.GD6758@twins.programming.kicks-ass.net>
 <53D28457.202@redhat.com>
 <CAKfTPtBVTgTYmgRKbuhKNZZRuCRK126YVvsG1+a-hjfKao08=g@mail.gmail.com>
 <20140725153210.47c09bfe@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="boHZdxlSbghjKFo0"
Content-Disposition: inline
In-Reply-To: <20140725153210.47c09bfe@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--boHZdxlSbghjKFo0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 03:32:10PM -0400, Rik van Riel wrote:
> Subject: sched: make update_sd_pick_busiest return true on a busier sd
>=20
> Currently update_sd_pick_busiest only identifies the busiest sd
> that is either overloaded, or has a group imbalance. When no
> sd is imbalanced or overloaded, the load balancer fails to find
> the busiest domain.
>=20
> This breaks load balancing between domains that are not overloaded,
> in the !SD_ASYM_PACKING case. This patch makes update_sd_pick_busiest
> return true when the busiest sd yet is encountered.
>=20
> Behaviour for SD_ASYM_PACKING does not seem to match the comment,
> but I have no hardware to test that so I have left the behaviour
> of that code unchanged.
>=20
> It is unclear what to do with the group_imb condition.
> Should group_imb override a busier load? If so, should we fix
> calculate_imbalance to return a sensible number when the "busiest"
> node found has a below average load? We probably need to fix
> calculate_imbalance anyway, to deal with an overloaded group that
> happens to have a below average load...

I think we want overloaded > group_imb > other. So prefer overloaded
groups, imbalanced groups if no overloaded and anything else if no
overloaded and imbalanced thingies.

If you look at the comment near sg_imbalanced(), in that case we want to
move tasks from the first group to the second, even though the second
group would be the heaviest.

enum group_type {
	group_other =3D 0,
	group_imbalanced,
	group_overloaded,
};

static enum group_type group_classify(struct sg_lb_stats *sgs)
{
	if (sgs->sum_nr_running > sgs->group_capacity_factor)
		return group_overloaded;

	if (sgs->group_imb)
		return group_imbalanced;

	return group_other;
}

>  /**
>   * update_sd_pick_busiest - return 1 on busiest group
>   * @env: The load balancing environment.
> @@ -5957,7 +5962,7 @@ static inline void update_sg_lb_stats(struct lb_env=
 *env,
>   * @sgs: sched_group statistics
>   *
>   * Determine if @sg is a busier group than the previously selected
> - * busiest group.
> + * busiest group.=20

We really need that extra trailing whitespace, yes? ;-)

>   * Return: %true if @sg is a busier group than the previously selected
>   * busiest group. %false otherwise.
> @@ -5967,13 +5972,17 @@ static bool update_sd_pick_busiest(struct lb_env =
*env,
>  				   struct sched_group *sg,
>  				   struct sg_lb_stats *sgs)
>  {

	if (group_classify(sgs) < group_classify(&sds->busiest_stats))
		return false;

>  	if (sgs->avg_load <=3D sds->busiest_stat.avg_load)
>  		return false;
> =20

> +	/* This is the busiest node. */
> +	if (!(env->sd->flags & SD_ASYM_PACKING))
>  		return true;
> =20
>  	/*

We could replace sg_lb_stats::group_imb with the above and avoid the
endless recomputation I suppose.

Also, we still need a little change to calculate_imbalance() where we
assume sum_nr_running > group_capacity_factor.

--boHZdxlSbghjKFo0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1l5tAAoJEHZH4aRLwOS62VIQALWzXB0hAzPDnnwBsaYfe9+7
yZbtu7xApt1CjX6KtnAGH2aRnBVwyh6TkOYS1DsAFqz7Wt3OC32YA+G6q+6THUSp
LoVYMTf7zaM54etIdkDlgjBgZibImYmNQfGxN46+w/GoBDeGJe02xTJklD92bP5s
27y42YJ2qvw16tT2cRfEeMToz5x/cxitz30Lny9GtBZBkVVlF49gJBL+rNujo7wu
Py+RiJg16KvzrDHQsaOySVKeTJPk2smSDK7tH/vExj6eTgAhsQGRmjbwW+dzS/EX
IjeXoVNxlORlZnfGsUMxVeOmdjn9Xg4VGPdt0IpDLEIbRSmdFxK8lhSZ0tloHVHl
trWXhCmkT42gApkCNOgpP/+jkI/kfameu7SKhVHwyLSFh1PGX2DG9ynsSn3sFva6
wbSpStZ2dSxys2a3yIvM38EaKA39tXDbahcczmGdzZO9AvaiHFluMZ/ze7p1bRds
ts0W2/ntfrZ6a7KZ9UDn65L2vSxk06HTYvboYRRfhZzt7jK4sha/Gz2bDSmJQsds
CgySTT0NJPBWUibriqK33k7fjW+5q6+Zb811EuymKqP9+2hHXW/3mZSioW+HaOom
XCbr5VRqxnHGs2wpYsjq2sPxW541XJfaVaU48Qsj5OrO5t2M7vkkoyVkAMZfZiHg
nA+WtVqMkERaRgoIFvIp
=zpUV
-----END PGP SIGNATURE-----

--boHZdxlSbghjKFo0--
