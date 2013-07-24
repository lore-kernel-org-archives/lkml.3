Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3GXG34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:29:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:63689 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab3GXG3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:29:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,733,1367996400"; 
   d="asc'?scan'208";a="375076288"
Date: Wed, 24 Jul 2013 02:19:50 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Subject: Re: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
 parsing 'UC' errors.
Message-ID: <20130724061950.GB18995@gchen.bj.intel.com>
Mail-Followup-To: "Luck, Tony" <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
	"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
References: <0104420@agluck-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
In-Reply-To: <0104420@agluck-desk.sc.intel.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2013 at 01:34:42PM -0700, Luck, Tony wrote:
> Date: Tue, 23 Jul 2013 13:34:42 -0700
> From: "Luck, Tony" <tony.luck@intel.com>
> To: linux-kernel@vger.kernel.org
> Cc: Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
>  "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
> Subject: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when
>  parsing 'UC' errors.
>=20
> The 0x1000 bit of the MCACOD field of machine check MCi_STATUS
> registers is only defined for corrected errors (where it means
> that hardware may be filtering errors see SDM section 15.9.2.1).
>=20
> For uncorrected errors it may, or may not be set - so we should mask
> it out when checking for the architecturaly defined recoverable
> error signatures (see SDM 15.9.3.1 and 15.9.3.2)
>=20
> While fixing this - I also noticed a bug introduced by
>   commit 33d7885b594e169256daef652e8d3527b2298e75
>   x86/mce: Update MCE severity condition check
> where we were including MCACOD bits in the check for the
> unaffected thread(s) during a machine check.
>=20

This bug should exist in a long period. How about splitting
this patch into two? One is for updating definition; The other
is for bug fix. if so, the 1st patch can be sent to *stable*
tree.

> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/mce.h                | 3 ++-
>  arch/x86/kernel/cpu/mcheck/mce-severity.c | 8 ++++----
>  2 files changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> index fa5f71e..a528f28 100644
> --- a/arch/x86/include/asm/mce.h
> +++ b/arch/x86/include/asm/mce.h
> @@ -33,10 +33,11 @@
>  #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
>  #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
>  #define MCACOD		  0xffff     /* MCA Error Code */
> +#define MCACOD_UC	  0xefff     /* MCA Error Code - for UC errors */
> =20
>  /* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
>  #define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
> -#define MCACOD_SCRUBMSK	0xfff0
> +#define MCACOD_SCRUBMSK	0xeff0
>  #define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
>  #define MCACOD_DATA	0x0134	/* Data Load */
>  #define MCACOD_INSTR	0x0150	/* Instruction Fetch */
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/=
cpu/mcheck/mce-severity.c
> index e2703520..7f6ab4e 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -111,17 +111,17 @@ static struct severity {
>  #ifdef	CONFIG_MEMORY_FAILURE
>  	MCESEV(
>  		KEEP, "Action required but unaffected thread is continuable",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_A=
DDR),
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR, MCI_UC_SAR|MCI_ADDR),
>  		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
>  		),
>  	MCESEV(
>  		AR, "Action required: data load error in a user process",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_A=
DDR|MCACOD_DATA),
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD_UC, MCI_UC_SAR|MC=
I_ADDR|MCACOD_DATA),
>  		USER
>  		),
>  	MCESEV(
>  		AR, "Action required: instruction fetch error in a user process",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_A=
DDR|MCACOD_INSTR),
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD_UC, MCI_UC_SAR|MC=
I_ADDR|MCACOD_INSTR),
>  		USER
>  		),
>  #endif
> @@ -137,7 +137,7 @@ static struct severity {
>  		),
>  	MCESEV(
>  		AO, "Action optional: last level cache writeback error",
> -		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|MCACOD_L3WB)
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD_UC, MCI_UC_S|MCACOD_L3WB)
>  		),
>  	MCESEV(
>  		SOME, "Action optional: unknown MCACOD",
> --=20
> 1.8.1.4
>=20

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR73IGAAoJEI01n1+kOSLHHiYP/Rx6s9g23ss0LvW93ksxEoSi
UdYxK0e7U+1dzqcqNWyWkyrbo1tC2IdTQxCsgSwOP/HjnClNhiAEgo33N9mKz4WI
lq1BMn6ASX+wLL+4VsNKUhtRbv89MNTqL7jcaEPfk10GN9gTxXstI37SINP4Emry
bx4zwwGo1SDDfy7Q8IbP/v9aW375W9eN2NIWv/5H35C7uDiBqb/j10ChXWmztFKS
JC2q/XXt3qlCKxZWD33iaUtyQzmBlQt1PA5NwwIJXIiq6scualDvcc4v9AmNVK0Y
VDMosEjo+4j1X2/eJquD0qce9aPOCbEgL0CuAvEi9+XBywkR1GuDMyEX/1UTz/IL
Kg+3mEKQg22Bm1sLfrJP8ndiqUUZSGZUDzZ1wiz1cpx73KG6stkyd5yHm71qzE/6
nxPC6hz/xp/MRJlbYgIxmsUJUTvyIxxN+Lj1iu6esFx3se1QqqoE2f3X2n6J078K
7jelIGE0Lar5YkbXqNICk6Qj23/9Zfzre7MfmQmhj8yDxDhA1gpSgtuvJCK1q1Gf
nl/P9C82mCkbub0XwHt6U/tNU0gfn0w7LIttZhZRlvxmZPq1pPQ6tafKt3Xau+uh
30mKV63NbzYWrqoNccWsrGJnrnBTjGKXg7x6wIo2KFUqEPKSooN0zBmv19OJVFMo
ccOyqdykejHj2nT8MW8X
=E7Lv
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
