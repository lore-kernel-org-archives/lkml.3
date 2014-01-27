Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaA0Rp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:45:58 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57126 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbaA0Rp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:45:56 -0500
Message-ID: <52E69B4E.5010604@monstr.eu>
Date: Mon, 27 Jan 2014 18:45:50 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Q] block / zynq: DMA bouncing
References: <Pine.LNX.4.64.1401271549280.23931@axis700.grange> <20140127170230.GQ15937@n2100.arm.linux.org.uk>
In-Reply-To: <20140127170230.GQ15937@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="psfDn8357tFfbwPx9sTIOSl80hd4qo1Sh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--psfDn8357tFfbwPx9sTIOSl80hd4qo1Sh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/27/2014 06:02 PM, Russell King - ARM Linux wrote:
> On Mon, Jan 27, 2014 at 04:13:56PM +0100, Guennadi Liakhovetski wrote:
>> I'm working on an MMC driver with a DMA capability. All has been worki=
ng=20
>> well, until at some point I've got a bus error, when the mmc driver ha=
d=20
>> been handed in a buffer at 0x3000 physical RAM address. The reason is,=
=20
>> that on Zynq arch bus masters cannot access RAM below 0x80000. Therefo=
re=20
>> my question: how shall I configure this in software?
>=20
> You're going to run into all sorts of problems here.  Normally, the
> DMA-able memory is limited to the first N bytes of memory, not "you mus=
t
> avoid the first N bytes of memory".
>=20
> Linux has it hard-coded into the memory subsystems that the DMA zone
> is from the start of memory to N, the normal zone is from N to H, and
> high memory is from H upwards - and allocations for high can fall back
> to normal, which can fall back to DMA but not the other way around.
>=20
> Short of permanently reserving the first 0x80000 bytes of memory, I'm
> not sure that there's much which can be done.  You may wish to talk to
> the MM gurus to see whether there's a modern alternative.

We use memblock_reserve for allocation of this space in .reserse phase.
Look at git.xilinx.com - linux repo arch/arm/mach-zynq/common.c

/**
 * zynq_memory_init() - Initialize special memory
 *
 * We need to stop things allocating the low memory as DMA can't work in
 * the 1st 512K of memory.  Using reserve vs remove is not totally clear =
yet.
 */
static void __init zynq_memory_init(void)
{
	/*
	 * Reserve the 0-0x4000 addresses (before page tables and kernel)
	 * which can't be used for DMA
	 */
	if (!__pa(PAGE_OFFSET))
		memblock_reserve(0, 0x4000);
}

DT_MACHINE_START(XILINX_EP107, "Xilinx Zynq Platform")
=2E..
	.reserve	=3D zynq_memory_init,
=2E..
MACHINE_END


I have checked why we are reserving just 0 - 0x4000 when kernel starts fr=
om 0x8000
and maybe Russell can help me with this better.
I got answer that using memblock_reserve was recommended in past for that=
=2E

Why 0x4000? IRC Linux for ARM is using space for any purpose.
Russell knows this much better than I.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--psfDn8357tFfbwPx9sTIOSl80hd4qo1Sh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLmm04ACgkQykllyylKDCFoCgCeO5yXI3VHTixlijgLBiIgKBy1
UM8AnRqCfEqkFm4+MBNNlEcLCvdh7ERP
=4lEk
-----END PGP SIGNATURE-----

--psfDn8357tFfbwPx9sTIOSl80hd4qo1Sh--
