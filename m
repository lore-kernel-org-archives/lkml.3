Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab3KSHPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 02:15:42 -0500
Received: from smtp.citrix.com ([66.165.176.89]:9919 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab3KSHPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 02:15:37 -0500
X-IronPort-AV: E=Sophos;i="4.93,727,1378857600"; 
   d="asc'?scan'208";a="75832039"
Message-ID: <1384845330.19880.11.camel@Abyss>
Subject: Re: [Xen-devel] [PATCH v2 1/2] xen: vnuma support for PV guests
 running as domU
From: Dario Faggioli <dario.faggioli@citrix.com>
To: Elena Ufimtseva <ufimtseva@gmail.com>
CC: <xen-devel@lists.xenproject.org>, <akpm@linux-foundation.org>,
        <wency@cn.fujitsu.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <mingo@redhat.com>, <david.vrabel@citrix.com>, <hpa@zytor.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        <stefano.stabellini@eu.citrix.com>, <ian.campbell@citrix.com>
Date: Tue, 19 Nov 2013 08:15:30 +0100
In-Reply-To: <1384806350-12651-2-git-send-email-ufimtseva@gmail.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
	 <1384806350-12651-2-git-send-email-ufimtseva@gmail.com>
Organization: Citrix Ltd
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-fkLng1eV+LX6+YtZMNDH"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
MIME-Version: 1.0
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-fkLng1eV+LX6+YtZMNDH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On lun, 2013-11-18 at 15:25 -0500, Elena Ufimtseva wrote:
> Signed-off-by: Elena Ufimtseva <ufimtseva@gmail.com>

> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index 96ab2c0..de9deab 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -13,7 +13,7 @@ CFLAGS_mmu.o			:=3D $(nostackp)
>  obj-y		:=3D enlighten.o setup.o multicalls.o mmu.o irq.o \
>  			time.o xen-asm.o xen-asm_$(BITS).o \
>  			grant-table.o suspend.o platform-pci-unplug.o \
> -			p2m.o
> +			p2m.o vnuma.o
> =20
>  obj-$(CONFIG_EVENT_TRACING) +=3D trace.o

I think David said something about this during last round (going
fetchin'-cuttin'-pastin' it):

"
    obj-$(CONFIG_NUMA) +=3D vnuma.o

    Then you can remove the #ifdef CONFIG_NUMA from xen/vnuma.c
"
=20
> diff --git a/arch/x86/xen/vnuma.c b/arch/x86/xen/vnuma.c

> +/*=20
> + * Called from numa_init if numa_off =3D 0;
                            ^ if numa_off =3D 1 ?

> + * we set numa_off =3D 0 if xen_vnuma_supported()
> + * returns true and its a domU;
> + */
> +int __init xen_numa_init(void)
> +{

> +	if (nr_nodes > num_possible_cpus()) {
> +		pr_debug("vNUMA: Node without cpu is not supported in this version.\n"=
);
> +		goto out;
> +	}
> +
This is a super-minor thing, but I wouldn't say "in this version". It
makes people think that there will be a later version where that will be
supported, which we don't know. :-)

> +	/*
> +	 * Set a dummy node and return success.  This prevents calling any
> +	 * hardware-specific initializers which do not work in a PV guest.
> +	 * Taken from dummy_numa_init code.
> +	 */
>
This is a lot better... Thanks! :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-fkLng1eV+LX6+YtZMNDH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iEYEABECAAYFAlKLEBIACgkQk4XaBE3IOsTEVQCZAd4GRhGj+38k5jQbmcrc8ScD
LPQAnRfAxdldrFgb67DtlGBhotTN3ZsZ
=e5Kr
-----END PGP SIGNATURE-----

--=-fkLng1eV+LX6+YtZMNDH--
