Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3ANP7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 10:59:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab3ANP7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 10:59:00 -0500
Message-ID: <50F42B3E.7090602@canonical.com>
Date: Mon, 14 Jan 2013 16:58:54 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Matthew Garrett <mjg@redhat.com>, Andre Przywara <andre.przywara@amd.com>
Subject: kernel 3.7+ cpufreq regression on AMD system running as dom0
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigF0955269A1F8B9EBFD2FFEFF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF0955269A1F8B9EBFD2FFEFF
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Starting with kernel v3.7 the following commit added a quirk
to obtain the real frequencies of certain AMD systems:

commit f594065faf4f9067c2283a34619fc0714e79a98d
Author: Matthew Garrett <mjg@redhat.com>
Date:   Tue Sep 4 08:28:06 2012 +0000

    ACPI: Add fixups for AMD P-state figures

When running bare-metal, on my Opteron 6128 test box results
in the frequencies remaining effectively unchanged:
[    5.475735] P0: MSR(hi,lo): 8000015c-50004004
[    5.479049] P0: fid=3D0x4, did=3D0x0, freq: 2000 -> 2000
[    5.484001] P1: MSR(hi,lo): 8000014c-50004a4e
[    5.487314] P1: fid=3D0xe, did=3D0x1, freq: 1500 -> 1500
[    5.492272] P2: MSR(hi,lo): 80000141-50005048
[    5.495584] P2: fid=3D0x8, did=3D0x1, freq: 1200 -> 1200
[    5.500540] P3: MSR(hi,lo): 80000138-50005844
[    5.503853] P3: fid=3D0x4, did=3D0x1, freq: 1000 -> 1000
[    5.508812] P4: MSR(hi,lo): 80000131-50005c40
[    5.512125] P4: fid=3D0x0, did=3D0x1, freq: 800 -> 800

However running as dom0 under Xen 4.2, reading this MSR returns
null:
[   11.613068] P0: MSR(hi,lo): 00000000-00000000
[   11.613074] P0: fid=3D0x0, did=3D0x0, freq: 2000 -> 1600
[   11.613078] P1: MSR(hi,lo): 00000000-00000000
[   11.613081] P1: fid=3D0x0, did=3D0x0, freq: 1500 -> 1600
[   11.613085] P2: MSR(hi,lo): 00000000-00000000
[   11.613088] P2: fid=3D0x0, did=3D0x0, freq: 1200 -> 1600
[   11.613091] P3: MSR(hi,lo): 00000000-00000000
[   11.613094] P3: fid=3D0x0, did=3D0x0, freq: 1000 -> 1600
[   11.613098] P4: MSR(hi,lo): 00000000-00000000
[   11.613101] P4: fid=3D0x0, did=3D0x0, freq: 800 -> 1600

And this results in Xen failing to change the governor:
  "(XEN) Fail change to ondemand governor"

I suppose this ultimately requires some support in the hypervisor
to pass through the real values. But since this is at least on my
combination of Xen 4.2 + kernel v3.7+ and AMD family 0x10 CPU a
regression compared to older kernels, I wonder whether the following
change might be something that should go into mainline:

--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -340,6 +340,9 @@ static void amd_fixup_frequency(struct acpi_processor=
_px *px
        if ((boot_cpu_data.x86 =3D=3D 0x10 && boot_cpu_data.x86_model < 1=
0)
            || boot_cpu_data.x86 =3D=3D 0x11) {
                rdmsr(MSR_AMD_PSTATE_DEF_BASE + index, lo, hi);
+               /* Bit 63 indicates whether contents are valid */
+               if (!(hi & 0x8000000))
+                       return;
                fid =3D lo & 0x3f;
                did =3D (lo >> 6) & 7;
                if (boot_cpu_data.x86 =3D=3D 0x10)

I tested something similar (so hopefully I have not failed on slapping
together a cleaned up version), which did resolve the problem.

-Stefan

Reference: https://bugs.launchpad.net/bugs/1078619


--------------enigF0955269A1F8B9EBFD2FFEFF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJQ9Cs+AAoJEOhnXe7L7s6jFuwQAOfoTP12CQ+wkhBdFM/tRpgX
E0WuhTjsNyVKS/4dUe13o/GIZl9BSD9yktSUhgD25204K/x/RDP7156ggWD2Yg7G
gd71EPPXSkFd6HhET+aTJ21dJvf0FZjpiVUFb8X4Ty9NVbpkAksamB8Czidc8sdJ
Z9/XnZ9vPlRMhhw55dpmX55XwQOl3GtsmDhqPQ3iOFxyyXgr4yzKZaZB2gGgjWUB
NMFoV1Sec/qvH16IDGc7rUtGe6hVb0BMf8mFhoAMVOy67GZ4qSdnOPjz9HHIL9W7
ylm5u5u79VuiukVL8E1mJFJObAZlzCvxlZ1V2l7PSG4u8cYMmwB6skmdIeTXDP0T
1a2NzRqStpjfMvP6NzOY6EzhlihG+VAWvHYiP9Sp1LmImcxsj0e7s+Uvrsr2DBCN
3jC9Uor63EeYKHREVBS9jdb7eJJL25u3pY3kT0jNlD5ClwBp3XXoMf+qE1Es4Zm8
EzrPMnVlCLT5d7n1HoWoyWI+Yr6tFFJCHVkvYCkxNfEuJTmAZArM44AkvbXT+X6V
dvExer9/0hMU+cLUoc1IKSfYL51NXwzNr2PWr/aF6dqv4I0NR6TaDwSz6GlyouHi
q47k7qPDXtICcMq1WGDhBjrpEIx1gN521CldNjGjyifdNjNafOZWSi4mxwflfDmI
KzcuxURiOOKIFFOqdL+8
=pz6j
-----END PGP SIGNATURE-----

--------------enigF0955269A1F8B9EBFD2FFEFF--
