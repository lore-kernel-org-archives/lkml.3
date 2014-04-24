Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751718AbaDXGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:16:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:65459 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaDXGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:16:54 -0400
Message-ID: <5358AC50.7020308@monstr.eu>
Date: Thu, 24 Apr 2014 08:16:48 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Microblaze image hanging in qemu with 3.15-rc
References: <20140422172356.GA15672@roeck-us.net> <53575074.6010602@monstr.eu> <5357C246.7050604@roeck-us.net> <5357CA6B.1070101@monstr.eu> <20140423154533.GA15644@roeck-us.net>
In-Reply-To: <20140423154533.GA15644@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="haq0Ig7VTCvvwxuOiEQEwSPUFq3NGhxV0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--haq0Ig7VTCvvwxuOiEQEwSPUFq3NGhxV0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/23/2014 05:45 PM, Guenter Roeck wrote:
> On Wed, Apr 23, 2014 at 04:12:59PM +0200, Michal Simek wrote:
>> On 04/23/2014 03:38 PM, Guenter Roeck wrote:
>>> On 04/22/2014 10:32 PM, Michal Simek wrote:
>>>> Hi Guenter,
>>>>
>>>>
>>>> On 04/22/2014 07:23 PM, Guenter Roeck wrote:
>>>>> Hi all,
>>>>>
>>>>> when trying to run a microblaze image with 3.15-rc1 or 3.15-rc2 in =
qemu,
>>>>> I get the following hangup. This used to work with earlier kernels
>>>>> with the same configuration.
>>>>>
>>>>> Is this a known problem, or is something wrong with my configuratio=
n
>>>>> or with my qemu command line ?
>>>>
>>>> Is this BE/LE version? Which qemu do you use?
>>>
>>> BE.
>>>
>>> file vmlinux:
>>>
>>> vmlinux: ELF 32-bit MSB  executable, version 1 (SYSV), statically lin=
ked, BuildID[sha1]=3D5e1872c08df2956eddaed6fc1f6528a8540375b7, not stripp=
ed
>>>
>>> qemu-system-microblaze --version:
>>>
>>> QEMU emulator version 1.7.0, Copyright (c) 2003-2008 Fabrice Bellard
>>>
>>> gcc --version:
>>>
>>> microblaze-linux-gcc (GCC) 4.8.0
>>> Copyright (C) 2013 Free Software Foundation, Inc.
>>> This is free software; see the source for copying conditions.  There =
is NO
>>> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PU=
RPOSE.
>>>
>>>> There is endian autodetection in timer and intc driver
>>>> which can caused this problem.
>>>>
>>> Is this new code ? I didn't see the problem in 3.13 (same compile opt=
ions,
>>> same configuration, same compiler, same qemu version).
>>
>> yes it was added to 3.15-rc1.
>>
>> Try to rever this one
>> a66a626 microblaze: Use asm-generic/io.h
>>
>> but the problem is probably here because you are not getting proper
>> reaction from qemu model.
>> a1715bb microblaze: Make timer driver endian aware
>> 1aa1243 microblaze: Make intc driver endian aware
>>
>> I have tested it on the latest petalinux qemu and there shouldn't be
>> any problem.
>>
> Hi Michal,
>=20
> qemu 2.0.0 still has the problem. Bisect points to
>=20
> commit a66a626538af65cbfc611e2b2fce500ed3f24518
> Author: Michal Simek <michal.simek@xilinx.com>
> Date:   Thu Feb 7 15:12:24 2013 +0100
>=20
>     microblaze: Use asm-generic/io.h
>=20
> as the culprit, so you were right on the money. Reverting this commit
> fixes the problem.

yep. But it is just side effect of previous two commits I have mentioned.=

Can you just please check if you are setting up correct IO functions?

	write_fn =3D timer_write32;
	read_fn =3D timer_read32;

	write_fn(TCSR_MDT, timer_baseaddr + TCSR0);
	if (!(read_fn(timer_baseaddr + TCSR0) & TCSR_MDT)) {
		write_fn =3D timer_write32_be;
		read_fn =3D timer_read32_be;
	}
git

> Assuming this is in fact a problem with qemu, can you point me to a set=

> of qemu patches necessary to fix it ? Also, do you know if there are pl=
ans
> to send the patches upstream ? I don't find anything related in the qem=
u
> repository (though of course I may have missed it).

Yes, it should be qemu issue. I am not aware about particular qemu patche=
s
but you can try to use https://github.com/Xilinx/qemu
but now sure if Peter updating this repository.

Anyway if you look at code above and I expect that the problem is just
that autodetection is broken in your qemu it should be pretty simple
to fix it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--haq0Ig7VTCvvwxuOiEQEwSPUFq3NGhxV0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNYrFEACgkQykllyylKDCHZUQCZAYaLeaG7yMZTYMSqzwidwhnZ
tNUAn1LO2zONzx8G7j08Q99suF34aMAE
=tAze
-----END PGP SIGNATURE-----

--haq0Ig7VTCvvwxuOiEQEwSPUFq3NGhxV0--
