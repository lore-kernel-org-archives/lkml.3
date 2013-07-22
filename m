Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab3GVM6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 08:58:43 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:63736 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab3GVM6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 08:58:40 -0400
Message-ID: <51ED2C74.7050502@monstr.eu>
Date: Mon, 22 Jul 2013 14:58:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: scatterlist: sg_set_buf() argument must be in linear mapping
 (sha1: ac4e97abce9b80c020e7113325f49e58b7b15e3f)
References: <51E64C6B.3080306@monstr.eu> <87siz7xt4z.fsf@rustcorp.com.au>
In-Reply-To: <87siz7xt4z.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2HHXCTQVSIMWCKBISEJNA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2HHXCTQVSIMWCKBISEJNA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

+ Ohad

On 07/22/2013 03:47 AM, Rusty Russell wrote:
> Michal Simek <monstr@monstr.eu> writes:
>> Hi Rusty and Jens,
>>
>> I am getting problem with your patch which you have added to the kerne=
l.
>> The problem is with my arm zynq remoteproc driver where
>> I use dma_declare_coherent_memory() to specify memory for remoteproc
>> which is ioremap to the vmalloc area.
>>
>> Based on that buf addr is not inside ram even this coherent memory is =
in ram.
>> That's why virt_addr_valid(buf) is failing.
>=20
> But sg_set_buf() calls virt_to_page(buf).  So does that work?
>=20
> I would think calling sg_set_page() directly would be what you want
> here...

Let me take some code from virtio_rpmsg_bus.c to show that problematic pa=
rt.

bufs_va =3D dma_alloc_coherent(vdev->dev.parent->parent,
				RPMSG_TOTAL_BUF_SPACE,
				&vrp->bufs_dma, GFP_KERNEL);
vrp->rbufs =3D bufs_va;
for (i =3D 0; i < RPMSG_NUM_BUFS / 2; i++) {
	struct scatterlist sg;
	void *cpu_addr =3D vrp->rbufs + i * RPMSG_BUF_SIZE;

	sg_init_one(&sg, cpu_addr, RPMSG_BUF_SIZE);
}


dma_alloc_coherent returns ioremaped ram address and sg_init_one()
is checking if addr is valid.

It is no problem to call instead of sg_init_one()
	sg_init_table(sg, 1);
	sg_set_page(sg, virt_to_page(cpu_addr), RPMSG_BUF_SIZE, offset_in_page(c=
pu_addr));


But my question is if SG lists have to be used just for memory which is n=
ot remapped.

Ohad: Can you see similar problem with your remoteproc drivers when DEBUG=
_SG is enabled?

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2HHXCTQVSIMWCKBISEJNA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHtLH0ACgkQykllyylKDCEWrQCeOhou5zxBuUSTbzcKd5oMsE7q
AsAAn1SgWn43ypk0Lz1OzunIquMcrpMh
=wCkN
-----END PGP SIGNATURE-----

------enig2HHXCTQVSIMWCKBISEJNA--
