Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab3KMOVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:21:25 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:54313 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758977Ab3KMOVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:21:21 -0500
Message-ID: <52838AD8.8070404@monstr.eu>
Date: Wed, 13 Nov 2013 15:21:12 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        microblaze-uclinux@itee.uq.edu.au, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC 15/17] microblaze: Convert from _fdt_start to __dtb_start
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-16-git-send-email-geert@linux-m68k.org> <5283524F.8030902@monstr.eu> <5283814C.6040904@monstr.eu> <CAMuHMdWOCdEcDMpJgQ5tOMJ=ygqapvjy2NzGkc9Esk5gZZ57fw@mail.gmail.com>
In-Reply-To: <CAMuHMdWOCdEcDMpJgQ5tOMJ=ygqapvjy2NzGkc9Esk5gZZ57fw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="WpQLd4huC47g7cxADrL5j8evdptmLognG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WpQLd4huC47g7cxADrL5j8evdptmLognG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/13/2013 03:02 PM, Geert Uytterhoeven wrote:
> On Wed, Nov 13, 2013 at 2:40 PM, Michal Simek <monstr@monstr.eu> wrote:=

>>>> QUESTION: The padding of the DTB is gone, is this OK?
>>>
>>> Removing this kernel padding should be fine. I can't remember
>>> why it was there from the beginning.
>>
>> I know why is this here. The reason is process how dtb is passed
>> to the kernel via command line. head.S code just copy that dtb to
>> the same location where compiled-in dts is expected and kernel
>> doesn't need to care about position of dtb because this copy is
>> done without MMU. And the full kernel is covered by 2 tlbs and
>> we don't need to use another TLB for dtb mapping.
>>
>> It means pad matters a lot. Because u-boot ITS format doesn't use
>> simpleImage target but the kernel need to have a space for copying
>> dtb to this kernel location.
>>
>> Let me think about if there is an easy way to handle dtbs
>> which are passed from bootloader.
>=20
> You can add to asm-generic/sections.h:
>=20
> #ifndef ARCH_DTB_PADDING
> #define ARCH_DTB_PADDING
> #endif
>=20
> and change KERNEL_DTB() to:
>=20
> #define KERNEL_DTB()                                                   =
 \
>        STRUCT_ALIGN();                                                 =
\
>        VMLINUX_SYMBOL(__dtb_start) =3D .;                              =
  \
>        *(.dtb.init.rodata)                                             =
\
>        ARCH_DTB_PADDING                                \
>        VMLINUX_SYMBOL(__dtb_end) =3D .;
>=20
> Then microblaze can predefine ARCH_DTB_PADDING in its
> <asm/sections.h>.
>=20
> Still, it will crash badly if the external DTB is larger than
> ARCH_DTB_PADDING.

yes but the question is if our bootflow is correct or not.
Because the problem is still with ARCH_DTB_PADDING value.
In past we have extended this padding from 16k to 32k.

We are setting up one tlb for early console and we can just do the same
for dtb and fix kernel for this cases. Then we don't need to waste
of memory for allocating space for dtb.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--WpQLd4huC47g7cxADrL5j8evdptmLognG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlKDitgACgkQykllyylKDCF6eQCcC7s/qEvdog7zPURzdu0XOzRP
nKwAnAli6/4A2SfZcUkHDKSSecm+QxPz
=G4mX
-----END PGP SIGNATURE-----

--WpQLd4huC47g7cxADrL5j8evdptmLognG--
