Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab3GWMMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:12:19 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63062 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3GWMMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:12:17 -0400
Message-ID: <51EE7319.408@monstr.eu>
Date: Tue, 23 Jul 2013 14:12:09 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: scatterlist: sg_set_buf() argument must be in linear mapping
 (sha1: ac4e97abce9b80c020e7113325f49e58b7b15e3f)
References: <51E64C6B.3080306@monstr.eu> <87siz7xt4z.fsf@rustcorp.com.au> <51ED2C74.7050502@monstr.eu> <87ppua9feh.fsf@rustcorp.com.au> <20130723103704.GS24642@n2100.arm.linux.org.uk>
In-Reply-To: <20130723103704.GS24642@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2JKADNTBITLJSCJXSAXFK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2JKADNTBITLJSCJXSAXFK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/23/2013 12:37 PM, Russell King - ARM Linux wrote:
> On Tue, Jul 23, 2013 at 12:00:30PM +0930, Rusty Russell wrote:
>> Michal Simek <monstr@monstr.eu> writes:
>>> Let me take some code from virtio_rpmsg_bus.c to show that problemati=
c part.
>>>
>>> bufs_va =3D dma_alloc_coherent(vdev->dev.parent->parent,
>>> 				RPMSG_TOTAL_BUF_SPACE,
>>> 				&vrp->bufs_dma, GFP_KERNEL);
>>> vrp->rbufs =3D bufs_va;
>>> for (i =3D 0; i < RPMSG_NUM_BUFS / 2; i++) {
>>> 	struct scatterlist sg;
>>> 	void *cpu_addr =3D vrp->rbufs + i * RPMSG_BUF_SIZE;
>>>
>>> 	sg_init_one(&sg, cpu_addr, RPMSG_BUF_SIZE);
>>> }
>>
>> Hmm.  Looking at arch/arm/include/asm/memory.h:
>>
>> #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
>> #define virt_addr_valid(kaddr)	((unsigned long)(kaddr) >=3D PAGE_OFFSE=
T && (unsigned long)(kaddr) < (unsigned long)high_memory)
>>
>> pfn_to_page in ARM seems to be the asm-generic one, which depends on
>> CONFIG_SPARSEMEM/CONFIG_DISCONTIGMEM/CONFIG_FLATMEM etc.
>>
>> Perhaps virt_addr_valid() is wrong for your config?  It's pretty clear=

>> that you shouldn't call virt_to_page() on something for which
>> !virt_addr_valid().
>=20
> The above code fragment is just wrong.  You can't make any assumptions =
about
> the memory returned from dma_alloc_coherent(), because:
>=20
> - On x86, it is kernel direct mapped memory, where things like
>   virt_to_phys(cpuaddr) will work fine with it.
>=20
> - On any architecture which needs to remap memory to make it coherent
>   with the DMA device, the key word there is "remap" - it's not kernel
>   direct mapped memory, and virt_to_phys(cpuaddr) on it is illegal.
>=20
> The only valid operation with scatterlists and such memory returned fro=
m
> dma_alloc_coherent() is:
>=20
> 	sg_dma_address(sg) =3D dma_address;
> 	sg_dma_len(sg) =3D dma_length;
>=20
> and not to use the virtual address(es) at all in the scatterlist.  And
> it is very very important to realise that you must not mix the streamin=
g
> and coherent DMA APIs - you must never pass coherent memory into the
> dma_map_* functions.

Ohad: This code is probably yours and you know the whole history of it.
Can you please comment it?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2JKADNTBITLJSCJXSAXFK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHucx4ACgkQykllyylKDCHUFgCgiX1ivcYplmCyYUqW7ZujXr1q
VmcAnRa9oYDA8E+red3Igf8+CvPN7J7F
=IiEC
-----END PGP SIGNATURE-----

------enig2JKADNTBITLJSCJXSAXFK--
