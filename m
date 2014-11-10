Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaKJKeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:34:04 -0500
Received: from mout.web.de ([212.227.15.14]:50663 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbaKJKeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:34:03 -0500
Message-ID: <54609479.8010203@web.de>
Date: Mon, 10 Nov 2014 11:33:29 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: AMR: sun7i: CPU hotplug support?
References: <545FC215.7010802@web.de> <20141109231744.GC2989@lukather> <5460554A.1060701@web.de> <5460766B.8070000@web.de> <546082A8.60401@arm.com> <5460870C.9010109@web.de> <54608ADC.4050500@arm.com>
In-Reply-To: <54608ADC.4050500@arm.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="enc8KfLQviMOfnqEs12XWxGnIiKFVH0NJ"
X-Provags-ID: V03:K0:oUIrp4lJ1SfIzs6SZHJv495/UqwdUnPbCRmeyb6UhPBItloxMck
 L1SpBCYdS7kjbsOPD13OrgcMDZETN5olkm+Wha0WUwIs+HHQNTa2teK0A2kScIN89ge+LaQ
 JLs7ojujANWnEMSDZAOBSNUdeYIW4ya0ammuP7iF0lqG5/gkT+PVnWGPYO1THz4c1G4FNRy
 iYZfQwNzq9OOX6NoF1HiA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--enc8KfLQviMOfnqEs12XWxGnIiKFVH0NJ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2014-11-10 10:52, Marc Zyngier wrote:
> On 10/11/14 09:36, Jan Kiszka wrote:
>> On 2014-11-10 10:17, Marc Zyngier wrote:
>>> On 10/11/14 08:25, Jan Kiszka wrote:
>>>> On 2014-11-10 07:03, Jan Kiszka wrote:
>>>>> On 2014-11-10 00:17, Maxime Ripard wrote:
>>>>>> Hi Jan,
>>>>>>
>>>>>> On Sun, Nov 09, 2014 at 08:35:49PM +0100, Jan Kiszka
>>>>>> wrote:
>>>>>>> did anyone already happen to look into enabling CPU
>>>>>>> hotplug for the Allwinner A20 in upstream? I'm currently
>>>>>>> running the sunxi-next branch on Banana Pi, and echo 0 >
>>>>>>> .../cpu1/online just hangs the system. The old 3.4
>>>>>>> LeMaker kernel works fine in this regard. I can try to
>>>>>>> look into details and port things over, just want to
>>>>>>> avoid duplicate efforts.
>>>>>>
>>>>>> Having hotplug support would indeed be very welcome.
>>>>>>
>>>>>> However, it should be done in u-boot, through PSCI, and not
>>>>>> in the kernel itself.
>>>>>>
>>>>>> As far as I'm aware, no one worked actively on it, beside
>>>>>> some WIP commit from Marc a while ago:
>>>>>> https://git.kernel.org/cgit/linux/kernel/git/maz/u-boot.git/commit=
/?h=3Dwip/psci&id=3D45379c0f9cf812f0f62722f4015ec907fa5dc144
>>>>>
>>>>>
>>>>>>
>>>
>>>>>>
> OK - I guess I will need a little guidance in then: Is there a good
>>>>> reference board to study and to derive from? And maybe also:
>>>>> What is missing or not working in that u-boot branch? If I
>>>>> get this interface right, I just takes some device tree bits
>>>>> to enable this for the kernel afterward, correct?
>>>>
>>>> Started to play with that patch in naive ways: CPU0 locks up
>>>> when offlining CPU1 - unless I disable the FIQ signal from
>>>> CPU1. Then it "works", both offlining and onlining again.
>>>> However, I suspect that this only parks CPU1 in wfi and does
>>>> not do anything interesting to it.
>>>
>>> Here's how this is supposed to work: - CPU1 sends a FIQ to CPU0,
>>> bringing it into secure mode. - CPU0 then kills CPU1 by doing the
>>> magic incantations on the power controller
>>>
>>> What is missing here is all the cache cleaning before signalling
>>> CPU0. If you add that, things should look a lot better (patches
>>> welcome).
>=20
>> Unsure about this, or maybe this was too simplistic: I added calls
>> to u-boot's flush_dcache_all and invalidate_icache_all (right
>> after disabling the cache, just like the vendor kernel does), but
>> CPU0 still locks up. I suspect there is still a bug in the FIQ
>> handling. There is also a suspicious single "@" printed on the
>> console. I'll play with the FIQ handler a bit.
>=20
> The '@' is just my own debug stuff, and might be causing issues too.
>=20
> Now, you have to realise that by the time you call into this code,
> u-boot itself is long gone. Only the tiny bit of code dealing with
> PSCI still lives in a bank of static, secure memory. So calling into
> u-boot for anything is doomed. You need to actually put the code
> inside the PSCI backend.

OK - seems like quite a bit of code needs to be pulled over...

Meanwhile I'm still starring at psci_fiq_enter:
	...
	movw	r8, #(GICC_BASE & 0xffff)
	movt	r8, #(GICC_BASE >> 16)
	ldr	r9, [r8, #GICC_IAR]
	movw	r10, #0x3ff
	movt	r10, #0
	cmp	r9, r10
	bne	out1
	movw	r10, #0x3fe
	cmp	r9, r10
	bne	out1
	...

How can GICC_IAR be 0x3ff and 0x3fe at the same time? These tests seems
bogus. What was the actual intention here?

Jan


--enc8KfLQviMOfnqEs12XWxGnIiKFVH0NJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlRglHkACgkQitSsb3rl5xQB0wCg75JuDKq8Jdw9r6JIrt4uhRLw
u44AnA3aqM+O/VdDwFEzdhrhjDDcanmH
=dTGg
-----END PGP SIGNATURE-----

--enc8KfLQviMOfnqEs12XWxGnIiKFVH0NJ--
