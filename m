Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbbASWH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 17:07:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbbASWHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 17:07:24 -0500
Message-ID: <1421705231.31046.191.camel@decadent.org.uk>
Subject: Re: [PATCH][v3.2] Revert: x86, 64bit, mm: Mark data/bss/brk to nx
From: Ben Hutchings <ben@decadent.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 19 Jan 2015 22:07:11 +0000
In-Reply-To: <20150119164926.168e8101@gandalf.local.home>
References: <20150119164926.168e8101@gandalf.local.home>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-dJ7YrZOmZ6FwwijFklr7"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dJ7YrZOmZ6FwwijFklr7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-19 at 16:49 -0500, Steven Rostedt wrote:
> Testing v3.2-rt I found that after merging the latest v3.2 stable tree,
> hotplug stopped working. I tested the latest v3.2 stable, and it was
> not working there either. I bisected it down to:
>=20
> commit e105c8187b7101e8a8a54ac0218c9d9c9463c636
> Author: Yinghai Lu <yinghai@kernel.org>
> Date:   Thu Jan 24 12:20:13 2013 -0800
>=20
>     x86, 64bit, mm: Mark data/bss/brk to nx
>    =20
>     commit 72212675d1c96f5db8ec6fb35701879911193158 upstream.
>=20
> Simply doing:
>=20
>  # echo 0 > /sys/devices/system/cpu/cpu1/online
>  # echo 1 > /sys/devices/system/cpu/cpu1/online
>=20
> caused the system to reboot.
>=20
> After reverting that commit, hotplug works again on the v3.2 stable
> tree.

Yes, I know this needs fixing.  It also broke suspend/resume on SMP
machines since that involves offlining and onlining CPUs 1-n.

Ben.

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 266f71719e42..783eba48d00c 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -778,7 +778,6 @@ void mark_rodata_ro(void)
>  	unsigned long text_end =3D PAGE_ALIGN((unsigned long) &__stop___ex_tabl=
e);
>  	unsigned long rodata_end =3D PAGE_ALIGN((unsigned long) &__end_rodata);
>  	unsigned long data_start =3D (unsigned long) &_sdata;
> -	unsigned long all_end;
> =20
>  	printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
>  	       (end - start) >> 10);
> @@ -787,8 +786,8 @@ void mark_rodata_ro(void)
>  	kernel_set_to_readonly =3D 1;
> =20
>  	/*
> -	 * The rodata/data/bss/brk section (but not the kernel text!)
> -	 * should also be not-executable.
> +	 * The rodata section (but not the kernel text!) should also be
> +	 * not-executable.
>  	 *
>  	 * We align all_end to PMD_SIZE because the existing mapping
>  	 * is a full PMD. If we would align _brk_end to PAGE_SIZE we
> @@ -798,8 +797,7 @@ void mark_rodata_ro(void)
>  	 * Any PMD which was setup after the one which covers _brk_end
>  	 * has been zapped already via cleanup_highmem().
>  	 */
> -	all_end =3D roundup((unsigned long)_brk_end, PMD_SIZE);
> -	set_memory_nx(rodata_start, (all_end - rodata_start) >> PAGE_SHIFT);
> +	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
> =20
>  	rodata_test();
> =20

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.

--=-dJ7YrZOmZ6FwwijFklr7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVL2AFOe/yOyVhhEJAQqsMg//Y3bwMnEuiwf5JC52NmWjVIChniQ9NWA7
S+AWbT2I9rJHpuo9ppdRIEMvcFHfcaDQY1icHwFp6A6PNgJNSfZbE4yuEXD+J3sd
/DV6q9yxA5GNXbNX+iOa8SK6qD+O5S2O3VWOLWIle3W7ZB0g+WUIB0ulIjVL+l5F
jPUTulCRnB7L4jq5oO74VkbAGKuu1Qo5e620m/mcaVAXXaBrC0BwafDtwCOpJPdx
YTogLAYY1l0fIN/0j9gE4NzP2YxbCBs4SAfosCGOEhl8SG2pTl2UsLaN5YiypKYa
t5r8Id83QPl65ZBfGflmSt+fg/6sGSSwJTY79X2AfxFgUwLsQJ5NUsDnZaCapNe4
P6VcGQPNqNFhqT4EqZn399KxmzWJlrV4ydD2EZQCZS+ZkwA3ODVOpIZZUlJxTQIl
Adqpn6VXBqwsUIiB2b8Ng8cX2srADPqm6YvaSv/BLXDqS3MNYV64+gF2HHxImTGp
82/yZWM+gFgiLa31IUervCOn3FQnfI78UFd4W5iKNTEA2kp+peoUzqAI/gvYSCI/
n9kjnc1+VUBraXblWcRMbmBmDCNq21gichFnNdRoDG0MtgCesyLWImqtyYEqt3/X
gVCi1YLEoxhoYO6go5H18TJVRypVzdDQpgB9Uk2FLqsBUw+8zBSUwP1loG3bDGYn
ZAuDWsAjnXs=
=Ajfa
-----END PGP SIGNATURE-----

--=-dJ7YrZOmZ6FwwijFklr7--
