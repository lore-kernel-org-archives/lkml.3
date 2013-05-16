Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3EPMWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab3EPMWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:22:53 -0400
Message-ID: <5194CF99.8070501@redhat.com>
Date: Thu, 16 May 2013 06:22:49 -0600
From: Eric Blake <eblake@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: P??draig Brady <P@draigBrady.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: allow empty symlink targets
References: <1358427833-3847-1-git-send-email-P@draigBrady.com> <50F8252C.2060404@draigBrady.com> <519381D8.5080206@draigBrady.com> <20130515220335.GV25399@ZenIV.linux.org.uk>
In-Reply-To: <20130515220335.GV25399@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.5.1
OpenPGP: url=http://people.redhat.com/eblake/eblake.gpg
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2ILRGFWVRSNKMASQTJOJF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2ILRGFWVRSNKMASQTJOJF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/15/2013 04:03 PM, Al Viro wrote:
> On Wed, May 15, 2013 at 01:38:48PM +0100, P??draig Brady wrote:
>>>> In today's Austin Group meeting, I was tasked to open a new bug that=

>>>> would state specifically how the empty symlink is resolved; the inte=
nt
>>>> is to allow both Solaris behavior (current directory) and BSD behavi=
or
>>>> (ENOENT).  Meanwhile, everyone was in agreement that the Linux kerne=
l
>>>> has a bug for rejecting the creation of an empty symlink, but once t=
hat
>>>> bug is fixed, then Linux can choose either Solaris or BSD behavior f=
or
>>>> how to resolve such a symlink.
>=20
> Austin Group Is At It Again, Demands at 11...
>=20
> Would you mind explaining who's "everyone" and why would we possibly
> want to honour that agreement of yours?

That was "everyone" on the phone call at that particular Austin Group
meeting where the bug was discussed, and "everyone" that subscribes to
the Austin Group mailing list but raised no further objections during
the 30-day window when the resolution to the bug was discussed.

>  Functionality in question is
> utterly pointless, seeing that semantics of such symlinks is OS-depende=
nt
> anyway *and* that blanket refusal to traverse such beasts is a legitima=
te
> option.  What's the point in allowing to create them in the first place=
?

The point was that POSIX has _always_ required the ability to create an
empty symlink.  For example, going back to POSIX 2001 (SUSv3):

http://pubs.opengroup.org/onlinepubs/009695399/functions/symlink.html
"The symlink() function shall create a symbolic link called path2 that
contains the string pointed to by path1 ( path2 is the name of the
symbolic link created, path1 is the string contained in the symbolic link=
)."
"The string pointed to by path1 shall be treated only as a character
string and shall not be validated as a pathname."
"[ENOENT]
    A component of path2 does not name an existing file or path2 is an
empty string."
http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap03.html
"3.367 String A contiguous sequence of bytes terminated by and including
the first null byte."

The wording is similar in POSIX 2008 (SUSv4, and untouched in POSIX
2013, released earlier this year as a technical corrigendum against
POSIX 2008).  Nothing in there says that path1 cannot be an empty
string.  An empty path1 must not be interpreted as an impossible file
name, so there should be no reason that symlink() cannot create it.
ENOENT is only permitted to be returned for a failure on path2, not on
path1.  Likewise, nothing in the POSIX standard says that readlink()
cannot return 0 as a valid length on an empty symlink.

The bug mentioned earlier in this thread
(http://austingroupbugs.net/view.php?id=3D649) was NOT about whether
creating an empty symlink should be allowed, but about what POSIX later
requires when encountering such an empty symlink during pathname
resolution.  Yes, to describe that behavior, you first have to create an
empty symlink - but all POSIX-certified OS have always allowed you to do
so; where they differed was on what happens when you stat() the symlink.
 The previous POSIX wording implied that dereferencing through an empty
symlink required you to start lookup traversal from the root directory,
which didn't match either existing behavior (traversal from the current
directory [Solaris], or failing with ENOENT [BSD]); so the bug was about
fixing the wording of pathname resolution to match existing practice for
systems that already easily permit empty symlinks - the behavior of
Linux was not considered during that bug fix only because we could not
easily test what Linux would do in that case due to the earlier problem
with symlink() non-compliance.

As I was on that particular phone call, I can also state that at the
time the bug was discussed, another argument was also raised: since it
is possible to create an empty symlink in other OS, and then mount that
filesystem under Linux, the Linux kernel ALREADY has to decide what to
do when dereferencing an empty symlink.  This is not as easy to set up,
so it was not tested when developing the bug fix for the stat() issue.
But the comments during the phone call were that the Linux behavior of
preventing the creation of an empty symlink on the grounds that "a
future stat() might have issues" were treated as a strawman argument,
since Linux would already have to deal with empty symlinks when mounting
a foreign file system.  Furthermore, the discussion focused on the text
I quoted above that shows that Linux has already been at odds with what
POSIX has already required for many years, and no one at the time was
willing to change that behavior without good reason.  In short, Linux
has ALWAYS had a POSIX-compliance bug with regards to its refusal to
create an empty symlink, and the bug mentioned above does not change
that fact, it only changed the standard to have a more sensible
requirement on what happens when dereferencing an empty symlink.

If you would like to file a bug against POSIX requesting that the next
version of POSIX permit implementations to reject an empty path1 in the
symlink() call on the grounds that you are unable to fix the Linux
kernel symlink() behavior to comply with existing POSIX wording, be my
guest.  The bug process is open, and anyone can file a bug, although I
don't know that I want to do it on your behalf.  Here's where you would
do it: http://austingroupbugs.net/

At the end of the day, I personally don't care whether you fix the Linux
kernel symlink() to allow empty symlinks, or successfully argue for a
bug fix against POSIX to permit the existing Linux symlink() behavior.
I'd love to see for Linux obtain POSIX certification someday, and either
of those two courses of action would get us closer.  Meanwhile, I know
there are enough other issues in the kernel (implementing O_SEARCH, for
example) that it will be a long time before we ever get a POSIX
certification of a Linux system.  And as long as Linux doesn't have
POSIX certification, corner cases like non-compliance with a requirement
that has been around for more than 12 years won't make life any harder
for people that already have to be aware that not all the world is POSIX.=


--=20
Eric Blake   eblake redhat com    +1-919-301-3266
Libvirt virtualization library http://libvirt.org


------enig2ILRGFWVRSNKMASQTJOJF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Public key at http://people.redhat.com/eblake/eblake.gpg
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCAAGBQJRlM+ZAAoJEKeha0olJ0NqmNoIAKzwzl7VD276Nt7PuFsgS732
FenuHrSkV6NB1goGnrP6TaWKO1s4ZHGwzqe7Vo9ErVsnP9eRzQHMtPV5Q92Sd4NU
i2mR0ZOxWmGsTvWxXWhzwZ2ntANE1Qtb22E4EHhpalGkiK2d5jmlJ0qS6yk/mset
uc8HL2v9SZlXdAgW/TE8XLpkzQ3JbA+GRGCAHhaQW47cfvoMEIGeiqWGG2+4oL7L
EAOWKQTNQhIkigfuvqt8oymVvcPtNas4SCjsZNHfY1P8snumnNSiqrsqN3uGIToR
GTva+YcYWTR5L3j50xOLqxm7NkvlotvUldbYZP0UE5HZR5/lAYo0Re1pVNOWzfk=
=M6oH
-----END PGP SIGNATURE-----

------enig2ILRGFWVRSNKMASQTJOJF--
