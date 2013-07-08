Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab3GHKB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 06:01:28 -0400
Received: from static.52.99.9.5.clients.your-server.de ([5.9.99.52]:43045 "EHLO
	mail1.project-insanity.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304Ab3GHKB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 06:01:26 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jul 2013 06:01:26 EDT
Date: Mon, 8 Jul 2013 09:50:43 +0000
From: Jonas Heinrich <onny@project-insanity.org>
To: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        len.brown@intel.com, pavel@ucw.cz, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
Message-ID: <20130708095042.GA20797@onny.Speedport_W_700V>
References: <20130218155439.GA902@onny>
 <1487368.CBCgti1nd5@vostro.rjw.lan>
 <20130503110705.GA3828@onny.Speedport_W_700V>
 <201305031515.55595.jarkko.sakkinen@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <201305031515.55595.jarkko.sakkinen@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05-03 15:15, Jarkko Sakkinen wrote:
> Hi
>=20
> On Friday, May 03, 2013 02:07:05 PM Jonas Heinrich wrote:
> > On 05-03 01:29, Rafael J. Wysocki wrote:
> > > On Thursday, May 02, 2013 08:32:30 PM Jonas Heinrich wrote:
> > > > On 05-02 02:45, Rafael J. Wysocki wrote:
> > > > > On Wednesday, May 01, 2013 11:55:10 AM H. Peter Anvin wrote:
> > > > > > On 05/01/2013 11:51 AM, Jonas Heinrich wrote:
> > > > > > > Well, you could give me instructions on how to debug this (I'=
ll
> > > > > > > do everything ;)) or I could ship you the Thinkpad T43. I gue=
ss
> > > > > > > this would worth the effort since this bug is somehow critica=
l.
> > > > > > >=20
> > > > > > > Best regards, Jonas
> > > > > >=20
> > > > > > I'll put together a debug patch unless I can trick Rafael into
> > > > > > doing it first...
> > > > >=20
> > > > > I'm afraid that code has changed quite a bit since I looked at it
> > > > > last time. [Jarkko Sakkinen seems to have worked on it lately,
> > > > > CCed.]
> > > > >=20
> > > > > Jonas, I wonder what happens if you drop the first hunk of the pa=
tch
> > > > > (it just uses a different register, which shouldn't matter)?  Does
> > > > > it still help then?
> > > >=20
> > > > Hello Rafel, first of all, thank you for helping me out :)
> > > > You're right, the patch still solves the suspend bug, after removing
> > > > the first hunk of the patch and applying it (see attachement:
> > > > suspendfix_first_hunk_dropped.patch).
> > > >=20
> > > > > If so, there are still a few things you can do to it, e.g:
> > > > > (1) drop the
> > > > >=20
> > > > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
> > > > > -       jnc     1f
> > > >=20
> > > > Still works :) (used suspendfix_1.patch)
> > > >=20
> > > > > lines,
> > > > > (2) drop the
> > > > >=20
> > > > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
> > > > > -       jnc     1f
> > > > >=20
> > > > > lines,
> > > >=20
> > > > Still works :) (used suspendfix_2.patch)
> > > >=20
> > > > > (3) drop the
> > > > >=20
> > > > > +       jecxz   1f
> > > >=20
> > > > Still works :) (used suspendfix_3.patch)
> > > >=20
> > > > > line,
> > > > > (4) drop the
> > > > >=20
> > > > > +       movl    %eax, %ecx
> > > > > +       orl     %edx, %ecx
> > > > > +       jz      1f
> > > >=20
> > > > At this point, the bug reoccurs (used suspendfix_4.patch)!
> > > > But that doesn't mean these lines are the only critical, because the
> > > > more minimal patch
> > > >=20
> > > > @@ -119,6 +119,9 @@
> > > >=20
> > > >         jnc     1f
> > > >         movl    pmode_efer, %eax
> > > >         movl    pmode_efer + 4, %edx
> > > >=20
> > > > +       movl    %eax, %ecx
> > > > +       orl     %edx, %ecx
> > > > +       jz      1f
> > > >=20
> > > >         movl    $MSR_EFER, %ecx
> > > >         wrmsr
> > > > =20
> > > >  1:
> > > > with removing this part
> > > >=20
> > > > -       movl    pmode_cr4, %eax
> > > > -       movl    %eax, %cr4
> > > > +       movl    pmode_cr4, %ecx
> > > > +       movl    %ecx, %cr4
> > > >=20
> > > > also doesn't fix the issue (see suspendfix_5.patch).
> > > >=20
> > > > > lines and see what the minimal patch needed for things to work ag=
ain
> > > > > is.
> > > >=20
> > > > So the most minimal working patch is suspendfix_3.patch.
> > >=20
> > > Thanks for doing that detective work!
> > >=20
> > > The only explanation of why this particular patch can help that seems
> > > viable to us at the moment is that we have a memory corruption in the
> > > code region modified by it and the patch simply changes the alignment=
 of
> > > the instructions that don't get corrupted.
> > >=20
> > > It looks like this may be verified by putting a bunch of nops into the
> > > region in question, so can you please check if the attached patch hel=
ps
> > > too?
> >=20
> > Unfortunately, your attached patch doesn't seem to fix the bug.
> > Hope you still have some ideas to address this issue :)
>=20
> Kind of had to experiment with this since I don't have access to
> T43. Did you already try:
>=20
> - EFER handling only is reverted as it was before 73201dbe.
> - CR4 handling only is reverted as it was before 73201dbe.
Hi Jarkko,
thank you for your response!
Can you please be more specific about that instruction? I don't really
know what to do, sorry :/

@Rafael: Bug still present in kernel 3.10 final :(

- Jonas

>=20
> Thanks.
>=20
> /Jarkko
>=20
> >=20
> > - Jonas
> >=20
> > > Rafael

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAEBAgAGBQJR2otyAAoJEPFqEBdQ3ykkQe4H/0tNJVVU7QKUQm1FnXhe6IoD
IOYM2obdQNuSZdwnWJunv8TjkPJruC9Bh5y7h37E6bEqc4Yv4BGs12sqFbNRi1iQ
xCnCJLXfLid1F6CIdUGp0H+xzk9iGHQ66h/k1KuSRd+bXw15sB04i87sD31qwZg2
ANFuSRmHVsSXEHCWWA3lCHhTfIkq58Qq5RqELM4kIWAiGnz05gSiFLlp6tXkSldR
9pBn8CpjYnLFaBcTyXXJaWVIR1+gKtOCF/e8BzPe8XHrvkOjetA4M5mocrwwQkWE
HTacBgnVUtnEa70vyV7WcKH0A/LyBk9dfBoMrXOMHKYcISzhBiVMvNz7cN4XBSo=
=X3P3
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
