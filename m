Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaDYHZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:25:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50877 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaDYHZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:25:15 -0400
Message-ID: <535A0DD7.4080204@monstr.eu>
Date: Fri, 25 Apr 2014 09:25:11 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Microblaze image hanging in qemu with 3.15-rc
References: <20140422172356.GA15672@roeck-us.net> <53575074.6010602@monstr.eu> <5357C246.7050604@roeck-us.net> <5357CA6B.1070101@monstr.eu> <20140423154533.GA15644@roeck-us.net> <5358AC50.7020308@monstr.eu> <535913E1.70509@roeck-us.net>
In-Reply-To: <535913E1.70509@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RfhrHbLRf7aUJF3ve4NVcwrxHvf7R5K66"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RfhrHbLRf7aUJF3ve4NVcwrxHvf7R5K66
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/24/2014 03:38 PM, Guenter Roeck wrote:
> On 04/23/2014 11:16 PM, Michal Simek wrote:
>> On 04/23/2014 05:45 PM, Guenter Roeck wrote:
>>> On Wed, Apr 23, 2014 at 04:12:59PM +0200, Michal Simek wrote:
>>>> On 04/23/2014 03:38 PM, Guenter Roeck wrote:
>>>>> On 04/22/2014 10:32 PM, Michal Simek wrote:
>>>>>> Hi Guenter,
>>>>>>
>>>>>>
>>>>>> On 04/22/2014 07:23 PM, Guenter Roeck wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> when trying to run a microblaze image with 3.15-rc1 or 3.15-rc2 i=
n qemu,
>>>>>>> I get the following hangup. This used to work with earlier kernel=
s
>>>>>>> with the same configuration.
>>>>>>>
>>>>>>> Is this a known problem, or is something wrong with my configurat=
ion
>>>>>>> or with my qemu command line ?
>>>>>>
>>>>>> Is this BE/LE version? Which qemu do you use?
>>>>>
>>>>> BE.
>>>>>
>>>>> file vmlinux:
>>>>>
>>>>> vmlinux: ELF 32-bit MSB  executable, version 1 (SYSV), statically l=
inked, BuildID[sha1]=3D5e1872c08df2956eddaed6fc1f6528a8540375b7, not stri=
pped
>>>>>
>>>>> qemu-system-microblaze --version:
>>>>>
>>>>> QEMU emulator version 1.7.0, Copyright (c) 2003-2008 Fabrice Bellar=
d
>>>>>
>>>>> gcc --version:
>>>>>
>>>>> microblaze-linux-gcc (GCC) 4.8.0
>>>>> Copyright (C) 2013 Free Software Foundation, Inc.
>>>>> This is free software; see the source for copying conditions.  Ther=
e is NO
>>>>> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR =
PURPOSE.
>>>>>
>>>>>> There is endian autodetection in timer and intc driver
>>>>>> which can caused this problem.
>>>>>>
>>>>> Is this new code ? I didn't see the problem in 3.13 (same compile o=
ptions,
>>>>> same configuration, same compiler, same qemu version).
>>>>
>>>> yes it was added to 3.15-rc1.
>>>>
>>>> Try to rever this one
>>>> a66a626 microblaze: Use asm-generic/io.h
>>>>
>>>> but the problem is probably here because you are not getting proper
>>>> reaction from qemu model.
>>>> a1715bb microblaze: Make timer driver endian aware
>>>> 1aa1243 microblaze: Make intc driver endian aware
>>>>
>>>> I have tested it on the latest petalinux qemu and there shouldn't be=

>>>> any problem.
>>>>
>>> Hi Michal,
>>>
>>> qemu 2.0.0 still has the problem. Bisect points to
>>>
>>> commit a66a626538af65cbfc611e2b2fce500ed3f24518
>>> Author: Michal Simek <michal.simek@xilinx.com>
>>> Date:   Thu Feb 7 15:12:24 2013 +0100
>>>
>>>      microblaze: Use asm-generic/io.h
>>>
>>> as the culprit, so you were right on the money. Reverting this commit=

>>> fixes the problem.
>>
>> yep. But it is just side effect of previous two commits I have mention=
ed.
>> Can you just please check if you are setting up correct IO functions?
>>
>>     write_fn =3D timer_write32;
>>     read_fn =3D timer_read32;
>>
>>     write_fn(TCSR_MDT, timer_baseaddr + TCSR0);
>>     if (!(read_fn(timer_baseaddr + TCSR0) & TCSR_MDT)) {
>>         write_fn =3D timer_write32_be;
>>         read_fn =3D timer_read32_be;
>>     }
>> git
>>
>=20
> The read returns 0x1, so the access functions are not updated. If I cha=
nge the code
> to force the update to the _be versions, the calibration loop still han=
gs (obviously,
> because then the result is 0x01000000, which is really wrong).

It means in model there is missing masking that upper bits in register
and model is just wrong.

HW behaviour

U-Boot-PetaLinux> md 41c00000
41c00000: 000000d2 000124f8 000023cb 00000000    .....$...#......
41c00010: 00000000 00000000 00000000 00000000    ................
41c00020: 000000d2 000124f8 000075b6 00000000    .....$...u......
41c00030: 00000000 00000000 00000000 00000000    ................
41c00040: 000000d2 000124f8 0000c7a4 00000000    .....$..........
41c00050: 00000000 00000000 00000000 00000000    ................
41c00060: 000000d2 000124f8 000119a8 00000000    .....$..........
41c00070: 00000000 00000000 00000000 00000000    ................
41c00080: 000000d2 000124f8 0000469b 00000000    .....$...F......
41c00090: 00000000 00000000 00000000 00000000    ................
41c000a0: 000000d2 000124f8 00009893 00000000    .....$..........
41c000b0: 00000000 00000000 00000000 00000000    ................
41c000c0: 000000d2 000124f8 0000ea8e 00000000    .....$..........
41c000d0: 00000000 00000000 00000000 00000000    ................
41c000e0: 000000d2 000124f8 0000178f 00000000    .....$..........
41c000f0: 00000000 00000000 00000000 00000000    ................
U-Boot-PetaLinux> mw 41c00010 10000000
U-Boot-PetaLinux> md 41c00000
41c00000: 000000d2 000124f8 00002e68 00000000    .....$..h.......
41c00010: 00000000 00000000 00000000 00000000    ................
41c00020: 000000d2 000124f8 00008052 00000000    .....$..R.......
41c00030: 00000000 00000000 00000000 00000000    ................
41c00040: 000000d2 000124f8 0000d245 00000000    .....$..E.......
41c00050: 00000000 00000000 00000000 00000000    ................
41c00060: 000000d2 000124f8 000123b7 00000000    .....$...#......
41c00070: 00000000 00000000 00000000 00000000    ................
41c00080: 000000d2 000124f8 0000513d 00000000    .....$..=3DQ......
41c00090: 00000000 00000000 00000000 00000000    ................
41c000a0: 000000d2 000124f8 0000a333 00000000    .....$..3.......
41c000b0: 00000000 00000000 00000000 00000000    ................
41c000c0: 000000d2 000124f8 0000f52e 00000000    .....$..........
41c000d0: 00000000 00000000 00000000 00000000    ................
41c000e0: 000000d2 000124f8 0000222a 00000000    .....$..*"......
41c000f0: 00000000 00000000 00000000 00000000    ................
U-Boot-PetaLinux>

QEMU behaviour:
U-Boot-PetaLinux> mw 41c00010 1
U-Boot-PetaLinux> md 41c00000
41c00000: 000000d2 000124f8 0000cfbb 00000000    .....$..........
41c00010: 00000001 00000000 ffffffff 00000000    ................
41c00020: 00000000 00000000 00000000 00000000    ................
41c00030: 00000000 00000000 00000000 00000000    ................
41c00040: 00000000 00000000 00000000 00000000    ................
41c00050: 00000000 00000000 00000000 00000000    ................
41c00060: 00000000 00000000 00000000 00000000    ................
41c00070: 00000000 00000000 00000000 00000000    ................
41c00080: 00000000 00000000 00000000 00000000    ................
41c00090: 00000000 00000000 00000000 00000000    ................
41c000a0: 00000000 00000000 00000000 00000000    ................
41c000b0: 00000000 00000000 00000000 00000000    ................
41c000c0: 00000000 00000000 00000000 00000000    ................
41c000d0: 00000000 00000000 00000000 00000000    ................
41c000e0: 00000000 00000000 00000000 00000000    ................
41c000f0: 00000000 00000000 00000000 00000000    ................
U-Boot-PetaLinux> mw 41c00010 0
U-Boot-PetaLinux> md 41c00000
41c00000: 000000d2 000124f8 00007362 00000000    .....$..bs......
41c00010: 00000000 00000000 ffffffff 00000000    ................
41c00020: 00000000 00000000 00000000 00000000    ................
41c00030: 00000000 00000000 00000000 00000000    ................
41c00040: 00000000 00000000 00000000 00000000    ................
41c00050: 00000000 00000000 00000000 00000000    ................
41c00060: 00000000 00000000 00000000 00000000    ................
41c00070: 00000000 00000000 00000000 00000000    ................
41c00080: 00000000 00000000 00000000 00000000    ................
41c00090: 00000000 00000000 00000000 00000000    ................
41c000a0: 00000000 00000000 00000000 00000000    ................
41c000b0: 00000000 00000000 00000000 00000000    ................
41c000c0: 00000000 00000000 00000000 00000000    ................
41c000d0: 00000000 00000000 00000000 00000000    ................
41c000e0: 00000000 00000000 00000000 00000000    ................
41c000f0: 00000000 00000000 00000000 00000000    ................
U-Boot-PetaLinux> mw 41c00010 10000000
U-Boot-PetaLinux> md 41c00000
41c00000: 000000d2 000124f8 0000e937 00000000    .....$..7.......
41c00010: 10000000 00000000 ffffffff 00000000    ................
41c00020: 00000000 00000000 00000000 00000000    ................
41c00030: 00000000 00000000 00000000 00000000    ................
41c00040: 00000000 00000000 00000000 00000000    ................
41c00050: 00000000 00000000 00000000 00000000    ................
41c00060: 00000000 00000000 00000000 00000000    ................
41c00070: 00000000 00000000 00000000 00000000    ................
41c00080: 00000000 00000000 00000000 00000000    ................
41c00090: 00000000 00000000 00000000 00000000    ................
41c000a0: 00000000 00000000 00000000 00000000    ................
41c000b0: 00000000 00000000 00000000 00000000    ................
41c000c0: 00000000 00000000 00000000 00000000    ................
41c000d0: 00000000 00000000 00000000 00000000    ................
41c000e0: 00000000 00000000 00000000 00000000    ................
41c000f0: 00000000 00000000 00000000 00000000    ................
U-Boot-PetaLinux> QEMU: Terminated

It should be pretty easy to fix it in timer_write function like this.

diff --git a/hw/timer/xilinx_timer.c b/hw/timer/xilinx_timer.c
index 6113b97..3ff1da9 100644
--- a/hw/timer/xilinx_timer.c
+++ b/hw/timer/xilinx_timer.c
@@ -169,7 +169,7 @@ timer_write(void *opaque, hwaddr addr,
             if (value & TCSR_TINT)
                 value &=3D ~TCSR_TINT;

-            xt->regs[addr] =3D value;
+            xt->regs[addr] =3D value & 0x7ff;
             if (value & TCSR_ENT)
                 timer_enable(xt);
             break;


>>> Assuming this is in fact a problem with qemu, can you point me to a s=
et
>>> of qemu patches necessary to fix it ? Also, do you know if there are =
plans
>>> to send the patches upstream ? I don't find anything related in the q=
emu
>>> repository (though of course I may have missed it).
>>
>> Yes, it should be qemu issue. I am not aware about particular qemu pat=
ches
>> but you can try to use https://github.com/Xilinx/qemu
>> but now sure if Peter updating this repository.
>>
> Last commit in that repository is from a year ago, so it looks like he =
doesn't
> update it.

That's too bad. :-(


>> Anyway if you look at code above and I expect that the problem is just=

>> that autodetection is broken in your qemu it should be pretty simple
>> to fix it.
>>
> Not sure I understand what you'd expect qemu to return in this case,
> and why it worked previously. Any idea ?

Look at logs above and you will understand that.
It is just trying to write one bit in register. If it is written
correctly then you are using proper endianness. If not, you should use
different one.
Someone also pointed that maybe it is worth to also write the same bit
with BE helper functions and check it to ensure that IP is working
well.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--RfhrHbLRf7aUJF3ve4NVcwrxHvf7R5K66
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNaDdgACgkQykllyylKDCGRNgCgjBqUWO1Jk4XII31NEG3cdmU5
2ZkAnii6kGpqYWkUtMZu1rwaPo6urM0B
=ImSS
-----END PGP SIGNATURE-----

--RfhrHbLRf7aUJF3ve4NVcwrxHvf7R5K66--
