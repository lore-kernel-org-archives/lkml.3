Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab3JEXmt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 19:42:49 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64710 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3JEXmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 19:42:47 -0400
Date: Sat, 05 Oct 2013 18:42:44 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <8761tctwhg.fsf@xmission.com> (from ebiederm@xmission.com on
	Fri Oct  4 19:03:23 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1381016564.1974.163@driftwood>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-EYcgr5HRjsOGILDa/+T1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-EYcgr5HRjsOGILDa/+T1
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10/04/2013 07:03:23 PM, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
>=20
> > On Fri, Oct 4, 2013 at 3:41 PM, Eric W. Biederman =20
> <ebiederm@xmission.com> wrote:
> >>
> >> After thinking about it removing the restrictions on mount points
> >> appears safe, because it is just plain dumb to have a mount point
> >> in a directory that is not restricted to root only modifications.
> >>
> >> This is a change in user visible semantics, so I want to be very =20
> careful
> >> about this.  Are there any reasons to not make this change?
> >
> > At least one worry: people are very used to 'rmdir()' not removing
> > empty directories, and I've written code myself that just does an
> > 'rmdir()' without worrying about it. I think git has code like =20
> "remove
> > file, then try to remove directory file is in, and recurse until it
> > fails or you hit the top of tree". And it all depends on knowing =20
> that
> > rmdir() is harmless, and returns the appropriate error when the
> > directory isn't empty.
> >
> > And you're now changing that. If it's a mount-point, the rmdir just
> > succeeds, afaik.
> >
> > Does anybody care? I dunno. But it looks like a _big_ semantic =20
> change.
>=20
> Which is definitley why I am asking and being careful.
>=20
> > That said, I like the _concept_ of being able to remove a =20
> mount-point
> > and the mount just goes away. But I do think that for sanity sake, =20
> it
> > should have something like "if one of the mounts is in the current
> > namespace, return -EBUSY". IOW, the patch-series would make the VFS
> > layer _able_ to remove mount-points, but a normal rmdir() when
> > something is mounted in that namespace would fail in order to give
> > legacy behavior.
> >
> > Hmm?
>=20
> In principle I have no problems tweaking rmdir to check for that case.
>=20
> At the same time the real reason that this is safe is that mount =20
> points
> are almost always part of trusted paths to important files and you =20
> just
> don't mess with those paths.
>=20
> So tweaking rmdir to fail would be more about making stupid mistakes
> like running "rm -rf /" fail than it would be about security or
> correctness.

If you do an rm -rf descending through a mount point, it's going to =20
delete the contents of the mount point before _trying_ to unlink the =20
mount point, which may be bad for the thing you mounted. Then there's =20
the fun corner case of "the directory wasn't empty before it was =20
mounted on, and umounting revealed the overmounted files, so the unlink =20
fails for that reason even after magic umount".

Doing rmdir on a non-empty directory won't delete it if it _isn't_ a =20
mount point, and presumably we require write access to directories to =20
mount on them, so in what ways is this different than another user =20
mucking about with my files asynchronously?

Oh, attached is a dumb "zapchroot" script I've been using for years to =20
unlink all mount points under a given directory, taking advantage of =20
the fact that mount points are appended to the end of the list so if =20
you unlink from the end to the front you should get the sub-mounts =20
before the parent mounts (modulo mount --move not reordering the list, =20
but that's uncommon).

Recently I noticed some kernels where chroot does _not_ trim the paths =20
so that the paths you see in /proc/mounts are relevant to the current =20
chroot but instead have all sorts of crap you can't access with no way =20
to know what it's talking about. That was sad, I need to go figure out =20
if that was distro breakage or vanilla breakage...

Rob=

--=-EYcgr5HRjsOGILDa/+T1
Content-Type: application/x-shellscript; name=zapchroot
Content-Disposition: attachment; filename=zapchroot
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCiMgQ29weXJpZ2h0IDIwMTAgUm9iIExhbmRsZXkgPHJvYkBsYW5kbGV5Lm5l
dD4gbGljZW5zZWQgdW5kZXIgR1BMdjIKCmlmIFsgIiQxIiA9PSAiLWQiIF0KdGhlbgogIERFTEVU
RT0xCiAgc2hpZnQKZmkKCiMgQ2xlYW4gdXAgYSBjaHJvb3QgZGlyZWN0b3J5CgpaQVA9JChyZWFk
bGluayAtZiAiJDEiIDI+L2Rldi9udWxsKQoKaWYgWyAhIC1kICIkWkFQIiBdCnRoZW4KICBlY2hv
ICJ1c2FnZTogemFwY2hyb290IFstZF0gZGlybmFtZSIKICBleGl0IDEKZmkKCmk9IiQocmVhZGxp
bmsgLWYgIiQocHdkKSIpIgppZiBbICIkWkFQIiA9PSAiJHtpOjA6JHsjWkFQfX0iIF0KdGhlbgog
IGVjaG8gIlNhbml0eSBjaGVjayBmYWlsZWQ6IGN3ZCBpcyB1bmRlciB6YXBkaXIiID4mMgogIGV4
aXQgMQpmaQoKIyBJdGVyYXRlIHRocm91Z2ggdGhlIHNlY29uZCBlbnRyeSBvZiAvcHJvYy9tb3Vu
dHMgaW4gcmV2ZXJzZSBvcmRlcgoKZm9yIGkgaW4gJChhd2sgJ3twcmludCAkMn0nIC9wcm9jL21v
dW50cyB8IHRhYykKZG8KICAjIERlLWVzY2FwZSBvY3RhbCB2ZXJzaW9ucyBvZiBzcGFjZSwgdGFi
LCBiYWNrc2xhc2gsIG5ld2xpbmUuLi4KICBpPSQoZWNobyAtZSAiJGkiKQoKICAjIFNraXAgZW50
cmllcyB0aGF0IGFyZW4ndCB1bmRlciBvdXIgY2hyb290CiAgWyAiJFpBUCIgIT0gIiR7aTowOiR7
I1pBUH19IiBdICYmIGNvbnRpbnVlCgogIGVjaG8gIlVtb3VudGluZzogJGkiCiAgdW1vdW50ICIk
aSIKZG9uZQo=

--=-EYcgr5HRjsOGILDa/+T1--
