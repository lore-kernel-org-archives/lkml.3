Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaE1Rp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:45:29 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:60063 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaE1Rp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:45:27 -0400
Message-ID: <1401298778.10661.10.camel@canyon.ip6.wittsend.com>
Subject: Re: [RFC PATCH 0/2] Loop device psuedo filesystem
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, Marian Marinov <mm@1h.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Michael J Coss <michael.coss@alcatel-lucent.com>
Date: Wed, 28 May 2014 13:39:38 -0400
In-Reply-To: <CALCETrX1vGeCCoJaq4Mket7sR5T17GgvNj5tS9GL3FVDOoYZew@mail.gmail.com>
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
	 <CALCETrUZO42qk7GFcNOT8+aMRXvPLiAUOv6FH33Fx6o1XrNVxg@mail.gmail.com>
	 <20140528073220.GA19433@ubuntu-mba51>
	 <CALCETrX1vGeCCoJaq4Mket7sR5T17GgvNj5tS9GL3FVDOoYZew@mail.gmail.com>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Q/VopGgO4CXjUIFsA2pr"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4SHdfvX006160
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1401903585.83935@1dOw5Q20ErIKHzODhjVSNg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q/VopGgO4CXjUIFsA2pr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-05-28 at 09:10 -0700, Andy Lutomirski wrote:
> On Wed, May 28, 2014 at 12:32 AM, Seth Forshee
> <seth.forshee@canonical.com> wrote:
> > On Tue, May 27, 2014 at 03:19:15PM -0700, Andy Lutomirski wrote:
> >> On Tue, May 27, 2014 at 2:58 PM, Seth Forshee
> >> <seth.forshee@canonical.com> wrote:
> >> > I'm posting these patches in response to the ongoing discussion of l=
oop
> >> > devices in containers at [1].
> >> >
> >> > The patches implement a psuedo filesystem for loop devices, which wi=
ll
> >> > allow use of loop devices in containters using standard utilities. U=
nder
> >> > normal use a loopfs mount will initially contain a single device nod=
e
> >> > for loop-control which can be used to request and release loop devic=
es.
> >> > Any devices allocated via this node will automatically appear in tha=
t
> >> > loopfs mount (and in devtmpfs) but not in any other loopfs mounts.
> >> > CAP_SYS_ADMIN in the userns of the process which performed the mount=
 is
> >> > allowed to perform privileged loop ioctls on these devices.
> >> >
> >> > Alternately loopfs can be mounted with the hostmount option, intende=
d
> >> > for mounting /dev/loop in the host. This is the default mount for an=
y
> >> > devices not created via loop-control in a loopfs mount (e.g. devices
> >> > created during driver init, devices created via /dev/loop-control, e=
tc).
> >> > This is only available to system-wide CAP_SYS_ADMIN.
> >> >
> >> > I still have some testing to do on these patches, but they work at
> >> > minimum for simple use cases. It's possible to use an unmodified los=
etup
> >> > if it's new enough to know about loop-control, with a couple of cave=
ats:
> >> >
> >> >  * /dev/loop-control must be symlinked to /dev/loop/loop-control
> >> >  * In some cases losetup attempts to use /dev/loopN when the device =
node
> >> >    is at /dev/loop/N. For example, 'losetup -f disk.img' fails.
> >> >
> >> > Device nodes for loop partitions are not created in loopfs. These
> >> > devices are created by the generic block layer, and the loop driver =
has
> >> > no way of knowing when they are created, so some kind of hook into t=
he
> >> > driver will be needed to support this.
> >>
> >> This is entertaining and a bit terrifying :)
> >>
> >> ISTM that what you've done is to create a way for per-userns devices
> >> to live in a special filesystem and for userns containers to
> >> instantiate those devices by offloading all the hard work to the
> >> kernel.
> >>
> >> What if we generalized this?
> >>
> >> For example, we could add a concept of ephemeral devices.  An
> >> ephemeral device is a device that can be referenced by an inode with a
> >> guarantee that the inode will *never* accidentally point to a
> >> different device [1].  Then we add a concept of the userns that owns a
> >> struct device.
> >>
> >> To make this safe, we'll need to make sure that old host udev will not
> >> see non-init-userns devices, ever.  This is easy enough to do, but
> >> doing it elegantly might take some design work.
> >
> > To do this wouldn't we need a generic way to know which namespace a
> > device goes with? Greg has clearly stated that he doesn't want to do
> > this.

> This is IMO silly.  If Greg doesn't want any kind of namespaces in the
> device core, then sticking considerably more complicated namespaces
> into the *loop* driver is just absurd.

Maybe so, maybe no, but it is what it is.  Greg K-H has been very clear
and emphatic on this topic.  He made it clear at LinuxPlumbers in NOLA
last year and he made it clear in this thread.  He did admit to some use
cases which several of us presented and he did say he would be open to
patches in this limited case, which is what Seth is presenting.  This is
working within the confines he has defined.  We'll take what we can get.

> >> To make this useful, we'll need a way for things inside user
> >> namespaces to create the device nodes.  I can imagine at least three
> >> ways to make this work.
> >>
> >> a) Allow mknod on a tmpfs created by a particular userns to succeed if
> >> the targetting struct device is owned by that userns or a child and if
> >> the caller is ns_capable(CAP_MKNOD).
> >> b) Create a new filesystem that has some special ioctl or whatever to =
do it.
> >> c) Have real per-user-ns devtmpfs.
> >>
> >> Now, to get loop working in a userns, we need a way for the userns (or
> >> the host!) to create a new loop-control device owned by that userns
> >> and we need to tweak the loop driver to make the created loop devices
> >> be owned by the userns.
> >
> > The patches I posted previously more or less did this using per-ns
> > devtmpfs, aside from the ephimeral part. The feedback was "just do it i=
n
> > loop," so I sent these to facilitate discussing this option with
> > something concrete. I personally still like the per-ns devtmpfs
> > approach, but that's been nacked.

> The ephemeral part might not be needed using devtmpfs if devtmpfs can
> guarantee that the device nodes go away if the device goes away.  I
> don't know whether it can make that guarantee.

> > (a) might be interesting, but I'd expect the same objections to be
> > raised as for (c). And it seems to me that (b) is just a alternate
> > interface for (a).

> True.

> >> (Note: I'm deliberately ignoring the fact that just doing this for
> >> loop seems to be almost entirely useless right now: you still can't
> >> mount the things.)

> > You could also argue that it's useless to be able to mount things if yo=
u
> > have no block device on which to mount them. We have to start somewhere=
.

> True.

> But if we take this particular route, then I can imagine a real mess
> when someone wants to mount a non-loop device, and we get stuck on how
> to expose the device node.  Sigh.

Then we deal with that horse when we have to make him sing.  One way or
the other, we're trying to moving forward.

> --Andy

Regards,
Mike
--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-Q/VopGgO4CXjUIFsA2pr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU4YfWsDrlnVnRif/AQivgAf/anH+0vtkPoy/2UWclw7Og0ZMyzDk2FFb
LK+DiVMXZnQzVY9blLSVrZcx3PidXrUwzH6asO84TD7vY+gBYcneOjZtiOvhLyyq
hXKTWR9kjKT8F5We6dS/QwLLXnOcTcEjU3waehGIukeWIHmyg3T4Gfjuf5vuOuDD
lWD704xjleAY5SzGVf0kVd4X2hQLc1kTf/Szs6GxQAjEvEVOnldCkbO5gs4FHBjP
HfqFz0S+lPiv6afUMQhWBnrXRRS3vKbfEvGvaedMvFt5jXoO/0zzBACGyglMqK+/
Q6NeSqokRyNY6IfCyMjZRcGRSm+ag1znoDnrUOOoPQXSPaoVQJzS9Q==
=VUz7
-----END PGP SIGNATURE-----

--=-Q/VopGgO4CXjUIFsA2pr--

