Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab3GJREZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:04:25 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:56142 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3GJREY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:04:24 -0400
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu <Valdis.Kletnieks@vt.edu> 0 pass
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: next-20130709 DMAR issues
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1373475702_3260P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Jul 2013 13:01:42 -0400
Message-ID: <29624.1373475702@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1373475702_3260P
Content-Type: text/plain; charset=us-ascii

Dell Latitude E6530.

Seeing a new error message crop up in next-0709 that wasn't there with 0703.
Particularly odd, last person to touch dmar.c was on 05/20/2013, so no smoking
guns there...

egrep -i 'dmar|linux ver' /var/log/messages  gives me:

Jul  9 21:47:15 turing-police kernel: [    0.000000] Linux version 3.10.0-next-20130703 (valdis@turing-police.cc.vt.edu) (gcc version 4.8.1 20130612 (Red Hat 4.8.1-2) (GCC) ) #99 SMP PREEMPT Wed Jul 3 17:40:09 EDT 2013
Jul  9 21:47:15 turing-police kernel: [    0.000000] ACPI: DMAR 00000000cb7fd298 00080 (v01 INTEL      SNB  00000001 INTL 00000001)
Jul  9 21:47:15 turing-police kernel: [    0.021530] dmar: Host address width 36
Jul  9 21:47:15 turing-police kernel: [    0.021536] dmar: DRHD base: 0x000000fed90000 flags: 0x1
Jul  9 21:47:15 turing-police kernel: [    0.021569] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 ecap f0105a
Jul  9 21:47:15 turing-police kernel: [    0.021576] dmar: RMRR base: 0x000000ce761000 end: 0x000000ce780fff
Jul  9 21:47:15 turing-police kernel: [    1.023235] DMAR: No ATSR found

That's what it usually says.  But now I have:

Jul 10 12:20:19 turing-police kernel: [    0.000000] Linux version 3.10.0-next-20130709 (valdis@turing-police.cc.vt.edu) (gcc version 4.8.1 20130612 (Red Hat 4.8.1-2) (GCC) ) #100 SMP PREEMPT Tue Jul 9 16:01:59 EDT 2013
Jul 10 12:20:19 turing-police kernel: [    0.000000] ACPI: DMAR 00000000cb7fd298 00080 (v01 INTEL      SNB  00000001 INTL 00000001)
Jul 10 12:20:19 turing-police kernel: [    0.021453] dmar: Host address width 36
Jul 10 12:20:19 turing-police kernel: [    0.021456] dmar: DRHD base: 0x000000fed90000 flags: 0x1
Jul 10 12:20:19 turing-police kernel: [    0.021485] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap c9008020660262 ecap f0105a
Jul 10 12:20:19 turing-police kernel: [    0.021487] dmar: RMRR base: 0x000000ce761000 end: 0x000000ce780fff
Jul 10 12:20:19 turing-police kernel: [    0.021575] dmar: DRHD: handling fault status reg 2
Jul 10 12:20:19 turing-police kernel: [    0.021583] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr ce71d000
Jul 10 12:20:19 turing-police kernel: [    0.021583] DMAR:[fault reason 06] PTE Read access is not set
Jul 10 12:20:19 turing-police kernel: [    1.034643] DMAR: No ATSR found

Now I have 3 extra messages talking about handling a fault status.  lspci says 00:1f.2 is:

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family 6-port SATA Controller [AHCI mode] (rev 04)

I found similar in a thread here: http://lkml.indiana.edu/hypermail/linux/kernel/1212.1/02319.html
which ended with Don Dutile saying:

"DMAR table does not have an entry for this device to this region.
Once the driver reconfigs/resets the device to stop polling bios-boot
cmd rings and use (new) OS (dma-mapped) rings, there's a period of time
during this transition that the hw is babbling away to an area that is no
longer mapped."

But I'm not convinced this is the same issue - why did it change between 0703 and 0709,
when I haven't updated the firmware. No relevant .config changes between the two, either.

If this doesn't ring any bells, I'l go do the bisect thing...

--==_Exmh_1373475702_3260P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUd2TdgdmEQWDXROgAQLJ9BAAuG3chvJ4sANi5ws/mNJAFiDVowSh047T
xwt7zI9DmGQSVrDXssHgeVMqSFvi2e4WFx7zLMGwxn3KaEVNAv2h/oHUx8X1z0vX
A4vCGSEPQ5BMjXkFac3M1wEMsdimAsAuoEQ2qOjhB6eapaW7MmzENc+XSGt5aK9w
WUW028rUE1KEQuvq8yGgUqPxgP666XTifvdZY1aIMtVxroyTSduxTmLiQ7dUWMDM
ZGHxGX3zzGlIDw+vsfDmhIXlzlwtWGuQEG6NbeMT1AzVIoRxpg05fKmogzGQr0dE
K//kgkVx+ec3ugLe8YVQdMbqi/YHyMArrKekEMolyuc11VD3w1hhfvKmLGOnSBKH
4s0aS3fwDc4zQS/O5IieQA6N/fS5osYeyKkmwhJ6oif0qG0rjMyeKwfB8XZs3FvU
jvs6u6/Y0n22SastUvsL0XK0heYf4R+jPgLzkpwrVsRgFcJhVLrqNgrJN43Xc8o2
6RsAMPKx8etrgDMk79n6UuBnLJSmI5IAeu/O8vS9sMq4WtRK2i5fEi4+TXa3fMxA
C6/FZiR3gtMcHkA5d5krBPOLaWslkyT8DDWWhpvIxrUqLunrth/QokRneaUoyRdA
tAoUhCzkwSqM7+PDy/05UoFRnUdgESrWSlwtEbvvlLFEkVvfqOMQP4UAjCpgmdxD
h4fHMWoF13w=
=ygyP
-----END PGP SIGNATURE-----

--==_Exmh_1373475702_3260P--
