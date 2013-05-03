Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763199Ab3ECLI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 07:08:58 -0400
Received: from static.52.99.9.5.clients.your-server.de ([5.9.99.52]:51738 "EHLO
	mail1.project-insanity.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762302Ab3ECLI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 07:08:57 -0400
Date: Fri, 3 May 2013 11:07:05 +0000
From: Jonas Heinrich <onny@project-insanity.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "H. Peter Anvin" <hpa@zytor.com>, len.brown@intel.com, pavel@ucw.cz,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Subject: Re: [Bisected] 3.7-rc1 can't resume (still present in 3.9)
Message-ID: <20130503110705.GA3828@onny.Speedport_W_700V>
References: <20130218155439.GA902@onny>
 <1682771.1PVxk2VyJS@vostro.rjw.lan>
 <20130502203229.GA433@onny.intranet.entropia.de>
 <1487368.CBCgti1nd5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <1487368.CBCgti1nd5@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05-03 01:29, Rafael J. Wysocki wrote:
> On Thursday, May 02, 2013 08:32:30 PM Jonas Heinrich wrote:
> > On 05-02 02:45, Rafael J. Wysocki wrote:
> > > On Wednesday, May 01, 2013 11:55:10 AM H. Peter Anvin wrote:
> > > > On 05/01/2013 11:51 AM, Jonas Heinrich wrote:
> > > > > Well, you could give me instructions on how to debug this (I'll d=
o=20
> > > > > everything ;)) or I could ship you the Thinkpad T43. I guess this
> > > > > would worth the effort since this bug is somehow critical.
> > > > >=20
> > > > > Best regards, Jonas
> > > >=20
> > > > I'll put together a debug patch unless I can trick Rafael into doing
> > > > it first...
> > >=20
> > > I'm afraid that code has changed quite a bit since I looked at it las=
t time.
> > > [Jarkko Sakkinen seems to have worked on it lately, CCed.]
> > >=20
> > > Jonas, I wonder what happens if you drop the first hunk of the patch =
(it just
> > > uses a different register, which shouldn't matter)?  Does it still he=
lp then?
> >=20
> > Hello Rafel, first of all, thank you for helping me out :)
> > You're right, the patch still solves the suspend bug, after removing th=
e first=20
> > hunk of the patch and applying it (see attachement:
> > suspendfix_first_hunk_dropped.patch).
> >=20
> > >=20
> > > If so, there are still a few things you can do to it, e.g:
> > > (1) drop the
> > >=20
> > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
> > > -       jnc     1f
> > >=20
> >=20
> > Still works :) (used suspendfix_1.patch)
> >=20
> > > lines,
> > > (2) drop the
> > >=20
> > > -       btl     $WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
> > > -       jnc     1f
> > >=20
> > > lines,
> >=20
> > Still works :) (used suspendfix_2.patch)
> >=20
> > > (3) drop the
> > >=20
> > > +       jecxz   1f
> > >=20
> >=20
> > Still works :) (used suspendfix_3.patch)
> >=20
> > > line,
> > > (4) drop the
> > >=20
> > > +       movl    %eax, %ecx
> > > +       orl     %edx, %ecx
> > > +       jz      1f
> > >=20
> >=20
> > At this point, the bug reoccurs (used suspendfix_4.patch)!=20
> > But that doesn't mean these lines are the only critical, because the mo=
re
> > minimal patch
> >=20
> > @@ -119,6 +119,9 @@
> >         jnc     1f
> >         movl    pmode_efer, %eax
> >         movl    pmode_efer + 4, %edx
> > +       movl    %eax, %ecx
> > +       orl     %edx, %ecx
> > +       jz      1f
> >         movl    $MSR_EFER, %ecx
> >         wrmsr
> >  1:
> >=20
> >=20
> > with removing this part
> >=20
> > -       movl    pmode_cr4, %eax
> > -       movl    %eax, %cr4
> > +       movl    pmode_cr4, %ecx
> > +       movl    %ecx, %cr4
> >=20
> > also doesn't fix the issue (see suspendfix_5.patch).
> >=20
> > > lines and see what the minimal patch needed for things to work again =
is.
> > >=20
> >=20
> > So the most minimal working patch is suspendfix_3.patch.
>=20
> Thanks for doing that detective work!
>=20
> The only explanation of why this particular patch can help that seems via=
ble to
> us at the moment is that we have a memory corruption in the code region m=
odified
> by it and the patch simply changes the alignment of the instructions that=
 don't
> get corrupted.
>=20
> It looks like this may be verified by putting a bunch of nops into the re=
gion
> in question, so can you please check if the attached patch helps too?

Unfortunately, your attached patch doesn't seem to fix the bug.=20
Hope you still have some ideas to address this issue :)

- Jonas
>=20
> Rafael
>=20
>=20
> --=20
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJRg5pZAAoJEPFqEBdQ3ykkQ9YIAJqVgXhBXB4Kh+WremOH5s6Y
RIAG6qPwuIXKUxza8GathpA6a5YNQiv1ZaptZKHFEemVQaiVP9KfgSy6ILupo44I
T8lUlUpmpVDHpiZrAMSsRkrGgkvUFa1Yy+T8QcSZY7bYFLNBoO9cVdE9GqdyAOyB
vIBJ2a/FbrB5RsZjEYAyv2vJXDZKJ8+zziysWjI/iKPDpshhMyemGVJS92wfuo5n
iarKx3GxFGg2fh4u9xgrzfiMHzZUX8XW1g9z1SCBS9hgL2N5GZUVJbNCJYDKjcKO
XbnhxOPJBsnsDryso+HTCaldgWqEV33r0b1gj87ksyxwhd86DpWTr3VFYlCGXZE=
=k/hR
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
