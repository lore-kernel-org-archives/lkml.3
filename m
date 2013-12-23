Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab3LWHbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 02:31:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:22623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab3LWHbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 02:31:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,535,1384329600"; 
   d="asc'?scan'208";a="454417609"
Date: Mon, 23 Dec 2013 02:12:40 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Michel Lespinasse <walken@google.com>,
        Andi Kleen <ak@linux.intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@Intel.com,
        tony.luck@Intel.com, ruiv.wang@gmail.com
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v3]
Message-ID: <20131223071240.GA18274@gchen.bj.intel.com>
Mail-Followup-To: Prarit Bhargava <prarit@redhat.com>,
	linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Michel Lespinasse <walken@google.com>,
	Andi Kleen <ak@linux.intel.com>,
	Seiji Aguchi <seiji.aguchi@hds.com>,
	Yang Zhang <yang.z.zhang@Intel.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	janet.morgan@Intel.com, tony.luck@Intel.com, ruiv.wang@gmail.com
References: <1387554609-9823-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1387554609-9823-1-git-send-email-prarit@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2013 at 10:50:09AM -0500, Prarit Bhargava wrote:
> +int check_vectors(void)
> +{
> +	int irq, cpu;
> +	unsigned int vector, this_count, count;
> +	struct irq_desc *desc;
> +	struct irq_data *data;
> +	struct cpumask *affinity;
> +
> +	this_count =3D 0;
> +	for (vector =3D FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
> +		irq =3D __this_cpu_read(vector_irq[vector]);
> +		if (irq >=3D 0) {
> +			desc =3D irq_to_desc(irq);
> +			data =3D irq_desc_get_irq_data(desc);
> +			affinity =3D data->affinity;
> +			if (irq_has_action(irq) || !irqd_is_per_cpu(data) ||
This line looks weird. Why counter will be increased once the irq has
action? Do you mean

if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
    !cpumask_subset(affinity, cpu_online_mask))


> +			    !cpumask_subset(affinity, cpu_online_mask))
It looks like cpu_online_mask will be updated until cpu_disable_common
is called, but your check_vectors is called before that.

[...]
>  {
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 85dc05a..7ac6654 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1312,6 +1312,12 @@ void cpu_disable_common(void)
> =20
>  int native_cpu_disable(void)
>  {
> +	int ret;
> +
> +	ret =3D check_vectors();
> +	if (ret)
> +		return ret;
> +
>  	clear_local_APIC();
> =20
>  	cpu_disable_common();
> --=20
> 1.7.9.3
>=20

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSt+JnAAoJEI01n1+kOSLHW1YP/0HHnS1kUXPDCGanV/KqbU78
hNnKVq6HkmKOPtIMKbdtXyn2gOELshIE8CvVTs1H+RLgTNZESgeY6yONGpYdbA/i
xl3Sh7OsI0C0/4o1PNnXsKmU7IaeKqHtg8dcPGUmXRXfuSGJVvLv1snxphNzBMrJ
RwgXRNUIoTP0nx3fStg+I1Z5wJ5xJ1toisv1lUnCFl13rv/rLt2RtH1Zp09K63Qm
WpHcq2b7arFBfXyPaZXVSZptY0PFqH+9ImsP+mIpooLdIAxBe1e/XXgVmylGg2h9
3e/fs4MdyU1N4IsR9sCWNCNhirsDxZ5Mf9Mylx7o54mMNO873XC49tBTaNyfVwdR
aQqiLfef26dM9nvWjSsj2NHFYKwZ6M31cazeRpIJe76aH4qOjeII3c+cTCjfiQTh
zTPZyD/wz47fqcygWPGZm1mr/Ee+IL9fYvhMisuFWJoVb/s5ys9j94d8cPknkGiy
CeDmkpgIX5ygizLRzdhnAmhJb39pDODogJc83CqJDjWF+wVvzOliKvVWsyR+30X+
mxsIWCgWhjtjIbEENFivfhae8LDOcGdnPuJeW9P6nvIAEwQd38WQLdcWUxGWsr+8
fPDfIW1vaoyDz5M9fM4NZZ4eA3er2cmrb+NA2H+MnSUnxDAXirYqIuNwri43bVeo
4ObPcWq6glus2U2x2sih
=wU1+
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
