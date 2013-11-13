Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155Ab3KMKUN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:20:13 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41631 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab3KMKUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:20:09 -0500
Message-ID: <5283524F.8030902@monstr.eu>
Date: Wed, 13 Nov 2013 11:19:59 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 15/17] microblaze: Convert from _fdt_start to __dtb_start
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-16-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1384285347-13506-16-git-send-email-geert@linux-m68k.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eggT6B9TKQTOK4FJvdd17fUJvQKEe2h93"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eggT6B9TKQTOK4FJvdd17fUJvQKEe2h93
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/12/2013 08:42 PM, Geert Uytterhoeven wrote:
> Kill the microblaze-specific __fdt_blob section, and start using
> .dtb.init.rodata from <asm-generic/sections.h> for built-in DTBs, like
> most other DT enabled architectures.
>=20
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: microblaze-uclinux@itee.uq.edu.au
> Cc: devicetree@vger.kernel.org
> ---
> Untested, but the resulting vmlinux after "make simpleImage.system" loo=
ks
> sane.
>=20
> QUESTION: The padding of the DTB is gone, is this OK?

Removing this kernel padding should be fine. I can't remember
why it was there from the beginning.

>=20
> TODO: Start using the DTB logic in scripts/Makefile.lib instead of
>       arch/microblaze/boot/dts/linked_dtb.S
>=20
>  arch/microblaze/boot/Makefile          |    2 +-
>  arch/microblaze/boot/dts/linked_dtb.S  |    2 +-
>  arch/microblaze/include/asm/sections.h |    4 +---
>  arch/microblaze/kernel/head.S          |    2 +-
>  arch/microblaze/kernel/setup.c         |    4 ++--
>  arch/microblaze/kernel/vmlinux.lds.S   |    8 --------
>  6 files changed, 6 insertions(+), 16 deletions(-)
>=20
> diff --git a/arch/microblaze/boot/Makefile b/arch/microblaze/boot/Makef=
ile
> index 8e211cc28dac..e4a99a22dab8 100644
> --- a/arch/microblaze/boot/Makefile
> +++ b/arch/microblaze/boot/Makefile
> @@ -23,7 +23,7 @@ quiet_cmd_cp =3D CP      $< $@$2
> =20
>  quiet_cmd_strip =3D STRIP   $@
>  	cmd_strip =3D $(STRIP) -K microblaze_start -K _end -K __log_buf \
> -				-K _fdt_start vmlinux -o $@
> +				-K __dtb_start vmlinux -o $@

I have started to discuss this change internally because our tools relate=
d
on this _fdt_start name.

> =20
>  UIMAGE_LOADADDR =3D $(CONFIG_KERNEL_BASE_ADDR)
> =20
> diff --git a/arch/microblaze/boot/dts/linked_dtb.S b/arch/microblaze/bo=
ot/dts/linked_dtb.S
> index 23345af3721f..bfc53b5795aa 100644
> --- a/arch/microblaze/boot/dts/linked_dtb.S
> +++ b/arch/microblaze/boot/dts/linked_dtb.S
> @@ -1,2 +1,2 @@
> -.section __fdt_blob,"a"
> +.section .dtb.init.rodata,"a"
>  .incbin "arch/microblaze/boot/dts/system.dtb"
> diff --git a/arch/microblaze/include/asm/sections.h b/arch/microblaze/i=
nclude/asm/sections.h
> index 1b281d3ea734..fb8ab0ba03fc 100644
> --- a/arch/microblaze/include/asm/sections.h
> +++ b/arch/microblaze/include/asm/sections.h
> @@ -16,8 +16,6 @@
>  # ifndef __ASSEMBLY__
>  extern char _ssbss[], _esbss[];
>  extern unsigned long __ivt_start[], __ivt_end[];
> -
> -extern u32 _fdt_start[], _fdt_end[];
> -
>  # endif /* !__ASSEMBLY__ */
> +
>  #endif /* _ASM_MICROBLAZE_SECTIONS_H */
> diff --git a/arch/microblaze/kernel/head.S b/arch/microblaze/kernel/hea=
d.S
> index 817b7eec95b6..6108889f0025 100644
> --- a/arch/microblaze/kernel/head.S
> +++ b/arch/microblaze/kernel/head.S
> @@ -94,7 +94,7 @@ big_endian:
>  	bnei	r11, no_fdt_arg			/* No - get out of here */
>  _prepare_copy_fdt:
>  	or	r11, r0, r0 /* incremment */
> -	ori	r4, r0, TOPHYS(_fdt_start)
> +	ori	r4, r0, TOPHYS(__dtb_start)
>  	ori	r3, r0, (0x8000 - 4)

If others is fine this 0x8000 is that hardcoded pad dtb size in lds file
and needs to be changed too.

Let me discuss this with others but if changing symbol name is fine
then we can fix just this problem and your patch is fine.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--eggT6B9TKQTOK4FJvdd17fUJvQKEe2h93
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKDUlAACgkQykllyylKDCEUYACeO0YLhfM8TXTIbDRMk1GRBL5h
IZ8An1bjkWMjgcy0aaxLJXF8q1HkRHwh
=EPVx
-----END PGP SIGNATURE-----

--eggT6B9TKQTOK4FJvdd17fUJvQKEe2h93--
