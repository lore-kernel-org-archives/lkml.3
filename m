Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649Ab3ANRIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:08:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab3ANRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:08:50 -0500
Message-ID: <50F43B9D.8030300@canonical.com>
Date: Mon, 14 Jan 2013 18:08:45 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Andre Przywara <andre@andrep.de>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [Xen-devel] kernel 3.7+ cpufreq regression on AMD system running
 as dom0
References: <50F42B3E.7090602@canonical.com> <20130114163445.GA4867@liondog.tnic>
In-Reply-To: <20130114163445.GA4867@liondog.tnic>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigB78B72C49A1981AA090304AE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB78B72C49A1981AA090304AE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14.01.2013 17:34, Borislav Petkov wrote:
> On Mon, Jan 14, 2013 at 04:58:54PM +0100, Stefan Bader wrote:
>> Starting with kernel v3.7 the following commit added a quirk
>> to obtain the real frequencies of certain AMD systems:
>>
>> commit f594065faf4f9067c2283a34619fc0714e79a98d
>> Author: Matthew Garrett <mjg@redhat.com>
>> Date:   Tue Sep 4 08:28:06 2012 +0000
>>
>>     ACPI: Add fixups for AMD P-state figures
>>
>> When running bare-metal, on my Opteron 6128 test box results
>> in the frequencies remaining effectively unchanged:
>> [    5.475735] P0: MSR(hi,lo): 8000015c-50004004
>> [    5.479049] P0: fid=3D0x4, did=3D0x0, freq: 2000 -> 2000
>> [    5.484001] P1: MSR(hi,lo): 8000014c-50004a4e
>> [    5.487314] P1: fid=3D0xe, did=3D0x1, freq: 1500 -> 1500
>> [    5.492272] P2: MSR(hi,lo): 80000141-50005048
>> [    5.495584] P2: fid=3D0x8, did=3D0x1, freq: 1200 -> 1200
>> [    5.500540] P3: MSR(hi,lo): 80000138-50005844
>> [    5.503853] P3: fid=3D0x4, did=3D0x1, freq: 1000 -> 1000
>> [    5.508812] P4: MSR(hi,lo): 80000131-50005c40
>> [    5.512125] P4: fid=3D0x0, did=3D0x1, freq: 800 -> 800
>>
>> However running as dom0 under Xen 4.2, reading this MSR returns
>> null:
>> [   11.613068] P0: MSR(hi,lo): 00000000-00000000
>> [   11.613074] P0: fid=3D0x0, did=3D0x0, freq: 2000 -> 1600
>> [   11.613078] P1: MSR(hi,lo): 00000000-00000000
>> [   11.613081] P1: fid=3D0x0, did=3D0x0, freq: 1500 -> 1600
>> [   11.613085] P2: MSR(hi,lo): 00000000-00000000
>> [   11.613088] P2: fid=3D0x0, did=3D0x0, freq: 1200 -> 1600
>> [   11.613091] P3: MSR(hi,lo): 00000000-00000000
>> [   11.613094] P3: fid=3D0x0, did=3D0x0, freq: 1000 -> 1600
>> [   11.613098] P4: MSR(hi,lo): 00000000-00000000
>> [   11.613101] P4: fid=3D0x0, did=3D0x0, freq: 800 -> 1600
>>
>> And this results in Xen failing to change the governor:
>>   "(XEN) Fail change to ondemand governor"
>>
>> I suppose this ultimately requires some support in the hypervisor
>> to pass through the real values. But since this is at least on my
>> combination of Xen 4.2 + kernel v3.7+ and AMD family 0x10 CPU a
>> regression compared to older kernels, I wonder whether the following
>> change might be something that should go into mainline:
>>
>> --- a/drivers/acpi/processor_perflib.c
>> +++ b/drivers/acpi/processor_perflib.c
>> @@ -340,6 +340,9 @@ static void amd_fixup_frequency(struct acpi_proces=
sor_px *px
>>         if ((boot_cpu_data.x86 =3D=3D 0x10 && boot_cpu_data.x86_model =
< 10)
>>             || boot_cpu_data.x86 =3D=3D 0x11) {
>>                 rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
>> +               /* Bit 63 indicates whether contents are valid */
>> +               if (!(hi & 0x8000000))
>> +                       return;
>=20
> I don't think that's the right change - this is fixing baremetal so tha=
t
> it works on xen. And besides, this code was in powernow-k8 before so I'=
m
> wondering why did it work then.

This actually only started to work when the xen-processor module got intr=
oduced
to provide acpi information to the hypervisor. If I remember correctly
powernow-k8 did fail.
For the way I did the fix: the AMD BIOS docs seemed to indicate that even=
 for
bare metal bit 63 would say whether the values are valid. So I thought th=
is is a
nice coincidence that under Xen with all 0 this matches that special case=
=2E.. ;)

-Stefan

>=20
>>                 fid =3D lo & 0x3f;
>>                 did =3D (lo >> 6) & 7;
>>                 if (boot_cpu_data.x86 =3D=3D 0x10)
>>
>> I tested something similar (so hopefully I have not failed on slapping=

>> together a cleaned up version), which did resolve the problem.
>>
>> -Stefan
>>
>> Reference: https://bugs.launchpad.net/bugs/1078619
>=20
> Adding the new Andre. :-) Andre, what did we do for powernow-k8 on xen
> so that the F10h 50MHz steps quirk would work?
>=20
> Thanks.
>=20



--------------enigB78B72C49A1981AA090304AE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJQ9DudAAoJEOhnXe7L7s6j/CcQAOdwm+g+KdXThGLQacU7TJXY
xsXyN0THthbiM4+p3RH3oTRXqy9Mvb0AyopUJzN0O7ZyZjyuEiO/VgW6GmsCovPr
USOJdPhQek85AKRdgPDABlKgBggEsJpBDQYQMmVnhHo8zUl0q3NsfP3RzGzbiJdz
MygW0H0W4OWwhJJ0losVL8/3rNUvZmbhhCHYMNmDtHzUnj0Fam+mSQm/CWm6i6m0
IdOe5bHao7RkMnNF1zUppaDElKU8WqqIbSyjXXGwm9LK5Z7BebgtnIc9eqjla9Ye
J6LNr9ayaa54sJbRB2sB/t6TYx/jYTFfTKcI4aFp6ln1jUNcX8p6igncsEfZUnkV
jSKo61MkA6JuU0JTkJP4TjsAjm6g4HhJ2yb7bp9EmPxB60OwOMW9Eza+vzseGw4q
qPSJ8pxB/U8tOjRhpv5PbTRHcxGiNp1hRmSEpukGsciBtAIfs7Uy+zWFdARksxg2
xmpMZhRB5mDXro633JycAgFNNk0+DGJKQrcIuoj6tNc2gSN4adtjsyBvKjrC+pvC
STMYCFtIRl20oHkKxvPJluXMIGtCuVdm045ivs9gC3z43QrNEk698HzaWIWuEK3x
tz2qMMmuFWtipMqUQegx76jUd7AVLo0F1mikslcYugVmmRKX44xR4qnxhX/z/9yt
BbfD4dMpx51Fql3VXCQq
=amjn
-----END PGP SIGNATURE-----

--------------enigB78B72C49A1981AA090304AE--
