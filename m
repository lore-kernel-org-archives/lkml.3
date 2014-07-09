Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaGIK5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:57:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbaGIK5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:57:38 -0400
Date: Wed, 9 Jul 2014 12:57:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 04/12] sched: Allow all archs to set the power_orig
Message-ID: <20140709105721.GT19379@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-5-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hu4eBwDcaFkzFmlO"
Content-Disposition: inline
In-Reply-To: <1404144343-18720-5-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hu4eBwDcaFkzFmlO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 06:05:35PM +0200, Vincent Guittot wrote:
> power_orig is only changed for system with a SMT sched_domain level in or=
der to
> reflect the lower capacity of CPUs. Heterogenous system also have to refl=
ect an
> original capacity that is different from the default value.
>=20
> Create a more generic function arch_scale_cpu_power that can be also used=
 by
> non SMT platform to set power_orig.
>=20
> The weak behavior of arch_scale_cpu_power is the previous SMT one in orde=
r to
> keep backward compatibility in the use of power_orig.
>=20
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 148b277..f0bba5f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5614,6 +5614,20 @@ unsigned long __weak arch_scale_smt_capacity(struc=
t sched_domain *sd, int cpu)
>  	return default_scale_smt_capacity(sd, cpu);
>  }
> =20
> +unsigned long __weak arch_scale_cpu_capacity(struct sched_domain *sd, in=
t cpu)
> +{
> +	unsigned long weight =3D sd->span_weight;
> +
> +	if ((sd->flags & SD_SHARE_CPUCAPACITY) && weight > 1) {
> +		if (sched_feat(ARCH_CAPACITY))
> +			return arch_scale_smt_capacity(sd, cpu);
> +		else
> +			return default_scale_smt_capacity(sd, cpu);
> +	}
> +
> +	return SCHED_CAPACITY_SCALE;
> +}

The only caller of arch_scale_smt_capacity is now an arch_ function
itself; which makes it entirely redundant, no?

Also, sched_feat() and default_scale_smt_capability() aren't available
to arch implementations of this function and can thus not retain
semantics.

Seeing how we currently don't have any arch_scale_smt_capacity
implementations other than the default we can easily replace it entirely
with something like:

unsigned long __weak arch_scale_cpu_capacity()
{
	if ((sd->flags & SD_SHARE_CPUCAPACITY) && (sd->span_weight > 1))
		return sd->smt_gain / sd->span_weight;

	return SCHED_CAPACITY_SCALE;
}

Hmm?

--hu4eBwDcaFkzFmlO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTvSARAAoJEHZH4aRLwOS6oJoP/0L0STaq8ebcWKfr73W1UhmF
Lu7lget9ndH2Pi9pLCSOJwvqs3okR2r8+vWk7BEs2cRHqYoAtMHBF4el4IcDWT7y
ns9H5LsxgntfLUczMPvgKXj/EvQZ027RS1eUbYT1auEWZkFQ1X2Lbzyvk3Oz9DNT
W4f22sr28+FebgrKIGR3Vyi4GH+tf4fSJ+TOrtiSETTU64GqiV94Dh7b8RtpZcZf
otnXd7EkDQa/rzfq4UxV+w4Dl3XqdgcvjGupqiPRjO+E2h3ft4bwpOIPJBWELQnc
6mf/+LQAIQBeOwiy6wnytOMdrptY0H+s7u8qdwnffsYq8CtlRh1S5nA+Rwijo4be
egVAVbXFw0uX+PZmQOCRww+vVajlM6eytiM/KQJbtkAkPRe4clgNLlJgaxQCPcdx
/zv1+n5st/2MFY4XXZ8YSL3zz4HYiDz1Rhn7xIUNhZ+TwyiPUDyzMD7HSesTgJ1w
wJgfzgghstMme/zrh6QweWwIDOOPC2Z7cPh3ceY8F0KeUEn/zUpokwaw2gSE5gRo
06D9dCFqUuCNYZN2HCVFuXN1euzlngcWK5DpfyEhoL55ejTucOtoYW7jrqwMdo1o
MK+eygj3QiXt7Q5n20z49l0IoV0nJjs8WMapscJGN1haeXMHeXahKPhMrm+yrAWe
4DS6+aM6fbuBXJTgIQ+e
=S9GD
-----END PGP SIGNATURE-----

--hu4eBwDcaFkzFmlO--
