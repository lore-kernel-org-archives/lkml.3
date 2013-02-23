Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab3BWNUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 08:20:25 -0500
Received: from static.52.99.9.5.clients.your-server.de ([5.9.99.52]:53793 "EHLO
	mail1.project-insanity.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758946Ab3BWNUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 08:20:23 -0500
Date: Sat, 23 Feb 2013 13:18:56 +0000
From: Jonas Heinrich <onny@project-insanity.org>
To: "H. Peter Anvin" <hpa@zytor.com>, len.brown@intel.com, pavel@ucw.cz,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume
Message-ID: <20130223131856.GA682@onny>
References: <20130218155439.GA902@onny>
 <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
thank you for your replay and the effort you invest in helping me out
with this problem.
Today, I further debuged the problem and reverted this part of your commit
(without understanding the actual code):

diff --git a/arch/x86/realmode/rm/wakeup_asm.S b/arch/x86/realmode/rm/wakeu=
p_asm.S
index 8905166..e56479e 100644
--- a/arch/x86/realmode/rm/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -110,15 +119,15 @@  ENTRY(wakeup_start)
 	movl	pmode_cr3, %eax
 	movl	%eax, %cr3
=20
-	movl	pmode_cr4, %ecx
-	jecxz	1f
-	movl	%ecx, %cr4
+	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
+	jz	1f
+	movl	pmode_cr4, %eax
+	movl	%eax, %cr4
 1:
+	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
+	jz	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
-	movl	%eax, %ecx
-	orl	%edx, %ecx
-	jz	1f
 	movl	$MSR_EFER, %ecx
 	wrmsr
 1:

I applied this change to the current 3.8 kernel and it worked!
If you need more test results, just send me patches and I'll try them :)

Best regards,
Jonas

On 02-18 08:21, H. Peter Anvin wrote:
> I might be able to get my hands on a T43 later this week and see if I can=
 reproduce this.  This patch seems more plausible, at least... but still pu=
zzling.
>=20
> Jonas Heinrich <onny@project-insanity.org> wrote:
>=20
> >On 02-17 21:40, Rafael J. Wysocki wrote:
> >> Does the commit immediately preceding this one behave correctly?
> >Strangely the preceding commit works well, so I bisected the kernel
> >again, this time more carefully and I've got a different result!
> >(see bisect_log attachement).
> >It seems to be commit 73201dbec64aebf6b0dca855b523f437972dc7bb=20
> >(https://patchwork.kernel.org/patch/1511921/).
> >Someone on LKML already reported an issue with this commit
> >(https://lkml.org/lkml/2012/10/18/228) , but Peter
> >Anvins patch got already applied in newer versions.
> >Reverting this patch with the recent git clone seems to be difficult
> >because it already has too much dependencies.
> >
> >Additionally I've included dmesg dumps of the last good and the bad
> >kernel version.
> >
> >On 02-17 12:52, H. Peter Anvin wrote:
> >> T43 is quite old... which might have exposed unique bugs.  How
> >reliable is the failure?  Even one misidentified commit results in git
> >bisect giving garbage.
> >It affects really all versions after that commit and the failure
> >happens
> >every time I try to resume my notebook.
> >
> >Best regards,
> >Jonas
>=20
> --=20
> Sent from my mobile phone. Please excuse brevity and lack of formatting.

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJRKMHAAAoJEPFqEBdQ3ykkzecH/0YxUy+E/todBhZ5vNiigm4I
JeeKzlm8O6Khpdlnelt/aj8VkPjXaJfR1P7/NdwCdUQJk1bXAK904Sf+F2uvL1yN
m/wtmn3l417OGJXSIhd23K5PFwYjxeJ0q7i/A53CGq6E+3Gv1hM1t3zrPPGkwa+p
Rov5cM3mL8f7gicY5IR4BjEb7AFW2KnD6LPBz7zPNobIYSbdawNivdP/p0Q670kG
wDCPwu3SY2VPb3yr5Jtyj4efsw8L3FGd5l9RZmuwRsEbpBB2Zr9a6yXPZyPRDQ7B
Sdfkn0ZH0ZlQD3Pnaf2CE5Zj/7dSuS/1DpnI9LiXyw4Eh+dQQz9Zh+4c04vjFrY=
=GkNc
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
