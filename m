Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab3EBUe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:34:29 -0400
Received: from static.52.99.9.5.clients.your-server.de ([5.9.99.52]:51236 "EHLO
	mail1.project-insanity.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932210Ab3EBUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:34:27 -0400
Date: Thu, 2 May 2013 20:32:30 +0000
From: Jonas Heinrich <onny@project-insanity.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>
Cc: len.brown@intel.com, pavel@ucw.cz, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
Message-ID: <20130502203229.GA433@onny.intranet.entropia.de>
References: <20130218155439.GA902@onny>
 <20130501185104.GC488@onny>
 <5181650E.1060805@zytor.com>
 <1682771.1PVxk2VyJS@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zx4FCpZtqtKETZ7O"
Content-Disposition: inline
In-Reply-To: <1682771.1PVxk2VyJS@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zx4FCpZtqtKETZ7O
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05-02 02:45, Rafael J. Wysocki wrote:
> On Wednesday, May 01, 2013 11:55:10 AM H. Peter Anvin wrote:
> > On 05/01/2013 11:51 AM, Jonas Heinrich wrote:
> > > Well, you could give me instructions on how to debug this (I'll do=20
> > > everything ;)) or I could ship you the Thinkpad T43. I guess this
> > > would worth the effort since this bug is somehow critical.
> > >=20
> > > Best regards, Jonas
> >=20
> > I'll put together a debug patch unless I can trick Rafael into doing
> > it first...
>=20
> I'm afraid that code has changed quite a bit since I looked at it last ti=
me.
> [Jarkko Sakkinen seems to have worked on it lately, CCed.]
>=20
> Jonas, I wonder what happens if you drop the first hunk of the patch (it =
just
> uses a different register, which shouldn't matter)?  Does it still help t=
hen?

Hello Rafel, first of all, thank you for helping me out :)
You're right, the patch still solves the suspend bug, after removing the fi=
rst=20
hunk of the patch and applying it (see attachement:
suspendfix_first_hunk_dropped.patch).

>=20
> If so, there are still a few things you can do to it, e.g:
> (1) drop the
>=20
> -       btl     $WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
> -       jnc     1f
>=20

Still works :) (used suspendfix_1.patch)

> lines,
> (2) drop the
>=20
> -       btl     $WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
> -       jnc     1f
>=20
> lines,

Still works :) (used suspendfix_2.patch)

> (3) drop the
>=20
> +       jecxz   1f
>=20

Still works :) (used suspendfix_3.patch)

> line,
> (4) drop the
>=20
> +       movl    %eax, %ecx
> +       orl     %edx, %ecx
> +       jz      1f
>=20

At this point, the bug reoccurs (used suspendfix_4.patch)!=20
But that doesn't mean these lines are the only critical, because the more
minimal patch

@@ -119,6 +119,9 @@
        jnc     1f
        movl    pmode_efer, %eax
        movl    pmode_efer + 4, %edx
+       movl    %eax, %ecx
+       orl     %edx, %ecx
+       jz      1f
        movl    $MSR_EFER, %ecx
        wrmsr
 1:


with removing this part

-       movl    pmode_cr4, %eax
-       movl    %eax, %cr4
+       movl    pmode_cr4, %ecx
+       movl    %ecx, %cr4

also doesn't fix the issue (see suspendfix_5.patch).

> lines and see what the minimal patch needed for things to work again is.
>=20

So the most minimal working patch is suspendfix_3.patch.

> Thanks,
> Rafael

Thank you and best regards,
Jonas

>=20
>=20
> --=20
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="suspendfix_first_hunk_dropped.patch"
Content-Transfer-Encoding: quoted-printable

--- a/arch/x86/realmode/rm/wakeup_asm.S	2013-04-29 02:36:01.000000000 +0200
+++ b/arch/x86/realmode/rm/wakeup_asm.S	2013-05-01 11:42:07.359999895 +0200
@@ -110,15 +110,15 @@
 	movl	pmode_cr3, %eax
 	movl	%eax, %cr3
=20
-	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
-	jnc	1f
-	movl	pmode_cr4, %eax
-	movl	%eax, %cr4
+	movl	pmode_cr4, %ecx
+	jecxz	1f
+	movl	%ecx, %cr4
 1:
-	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
-	jnc	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
+	movl	%eax, %ecx
+	orl	%edx, %ecx
+	jz	1f
 	movl	$MSR_EFER, %ecx
 	wrmsr
 1:

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="suspendfix_1.patch"
Content-Transfer-Encoding: quoted-printable

--- a/arch/x86/realmode/rm/wakeup_asm.S 2013-05-02 17:20:25.266667541 +0200
+++ b/arch/x86/realmode/rm/wakeup_asm.S	2013-05-02 17:22:51.880000874 +0200
@@ -112,13 +112,15 @@
=20
 	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
 	jnc	1f
-	movl	pmode_cr4, %eax
-	movl	%eax, %cr4
+	movl	pmode_cr4, %ecx
+	jecxz	1f
+	movl	%ecx, %cr4
 1:
-	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
-	jnc	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
+	movl	%eax, %ecx
+	orl	%edx, %ecx
+	jz	1f
 	movl	$MSR_EFER, %ecx
 	wrmsr
 1:

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="suspendfix_2.patch"
Content-Transfer-Encoding: quoted-printable

--- a/arch/x86/realmode/rm/wakeup_asm.S	2013-05-02 17:20:25.266667541 +0200
+++ b/arch/x86/realmode/rm/wakeup_asm.S	2013-05-02 18:54:49.176667541 +0200
@@ -112,13 +112,17 @@
=20
 	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
 	jnc	1f
-	movl	pmode_cr4, %eax
-	movl	%eax, %cr4
+	movl	pmode_cr4, %ecx
+	jecxz	1f
+	movl	%ecx, %cr4
 1:
 	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
 	jnc	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
+	movl	%eax, %ecx
+	orl	%edx, %ecx
+	jz	1f
 	movl	$MSR_EFER, %ecx
 	wrmsr
 1:

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="suspendfix_3.patch"
Content-Transfer-Encoding: quoted-printable

--- a/arch/x86/realmode/rm/wakeup_asm.S.org	2013-05-02 17:20:25.266667541 +=
0200
+++ b/arch/x86/realmode/rm/wakeup_asm.S	2013-05-02 19:56:58.083334207 +0200
@@ -112,13 +112,16 @@
=20
 	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
 	jnc	1f
-	movl	pmode_cr4, %eax
-	movl	%eax, %cr4
+	movl	pmode_cr4, %ecx
+	movl	%ecx, %cr4
 1:
 	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
 	jnc	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
+	movl	%eax, %ecx
+	orl	%edx, %ecx
+	jz	1f
 	movl	$MSR_EFER, %ecx
 	wrmsr
 1:

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="suspendfix_4.patch"
Content-Transfer-Encoding: quoted-printable

--- a/arch/x86/realmode/rm/wakeup_asm.S	2013-05-02 17:20:25.266667541 +0200
+++ b/arch/x86/realmode/rm/wakeup_asm.S	2013-05-02 20:43:40.623334207 +0200
@@ -112,8 +112,8 @@
=20
 	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
 	jnc	1f
-	movl	pmode_cr4, %eax
-	movl	%eax, %cr4
+	movl	pmode_cr4, %ecx
+	movl	%ecx, %cr4
 1:
 	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
 	jnc	1f

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="suspendfix_5.patch"

--- a/arch/x86/realmode/rm/wakeup_asm.S	2013-05-02 17:20:25.266667541 +0200
+++ b/arch/x86/realmode/rm/wakeup_asm.S	2013-05-02 21:44:57.973334207 +0200
@@ -119,6 +119,9 @@
 	jnc	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
+	movl	%eax, %ecx
+	orl	%edx, %ecx
+	jz	1f
 	movl	$MSR_EFER, %ecx
 	wrmsr
 1:

--ew6BAiZeqk4r7MaW--

--zx4FCpZtqtKETZ7O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJRgs1dAAoJEPFqEBdQ3ykkb9oIAJW15ieog4MZ2y5BSImrfAxg
rb7LYp165znGIVUPCWL2qw1wrxsGRhmBudvtB83G5x+pFqAMhSj9eD6lwJ8j37DG
xkwm3GIPxDmLkCRvNN/dvVS2FrrvPoyPeAiK9MVrWfn22IBdox3s/Lsr0Ji16+So
9XIDtTEZRaOuif6A7/NjIJmYKuBv9PYu7zlxtcbPHm4WwTE3zn0NL0F4Y+/vYDMv
eD6d8pENZqXOf06o8IXa5ADv43WeF272hfpqSb7IMY2gHoK68lx4s9CrtCy9m4IJ
H+GUfJ+RmR66uQJ627mHfUn/1ZP6QDhqdvKJE2e/qfLy61pUOU/SLyQJa0g5O+8=
=quAG
-----END PGP SIGNATURE-----

--zx4FCpZtqtKETZ7O--
