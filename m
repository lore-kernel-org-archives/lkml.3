Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507AbaEYWYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 18:24:46 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:54685
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaEYWYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 18:24:45 -0400
Date: Mon, 26 May 2014 00:24:43 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Marian Marinov <mm@1h.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Michael H. Warfield" <mhw@wittsend.com>,
        Arnd Bergmann <arnd@arndb.de>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140525222443.GA18410@mail.hallyn.com>
References: <CAFLxGvwfbVdLUq0NrSrQNYH+bTzYLuCE2moooHH319qRfDkS6Q@mail.gmail.com>
 <20140515195010.GA22317@ubuntumail>
 <53751FFA.5040103@nod.at>
 <20140515202628.GB25896@mail.hallyn.com>
 <CALCETrWE72G86QKVZT2aqWsEmjwOPwsWMUNz5-JkDvbqaGbrvw@mail.gmail.com>
 <20140520141931.GH26600@ubuntumail>
 <537F04BF.3000301@1h.com>
 <1400850960.2332.4.camel@dabdike>
 <20140524222535.GD4232@ubuntumail>
 <1401005530.2322.43.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401005530.2322.43.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
> On Sat, 2014-05-24 at 22:25 +0000, Serge Hallyn wrote:
> > Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
> > > On Fri, 2014-05-23 at 11:20 +0300, Marian Marinov wrote:
> > > > On 05/20/2014 05:19 PM, Serge Hallyn wrote:
> > > > > Quoting Andy Lutomirski (luto@amacapital.net):
> > > > >> On May 15, 2014 1:26 PM, "Serge E. Hallyn" <serge@hallyn.com> wrote:
> > > > >>> 
> > > > >>> Quoting Richard Weinberger (richard@nod.at):
> > > > >>>> Am 15.05.2014 21:50, schrieb Serge Hallyn:
> > > > >>>>> Quoting Richard Weinberger (richard.weinberger@gmail.com):
> > > > >>>>>> On Thu, May 15, 2014 at 4:08 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > >>>>>>> Then don't use a container to build such a thing, or fix the build scripts to not do that :)
> > > > >>>>>> 
> > > > >>>>>> I second this. To me it looks like some folks try to (ab)use Linux containers for purposes where KVM
> > > > >>>>>> would much better fit in. Please don't put more complexity into containers. They are already horrible
> > > > >>>>>> complex and error prone.
> > > > >>>>> 
> > > > >>>>> I, naturally, disagree :)  The only use case which is inherently not valid for containers is running a
> > > > >>>>> kernel.  Practically speaking there are other things which likely will never be possible, but if someone 
> > > > >>>>> offers a way to do something in containers, "you can't do that in containers" is not an apropos response.
> > > > >>>>> 
> > > > >>>>> "That abstraction is wrong" is certainly valid, as when vpids were originally proposed and rejected,
> > > > >>>>> resulting in the development of pid namespaces.  "We have to work out (x) first" can be valid (and I can
> > > > >>>>> think of examples here), assuming it's not just trying to hide behind a catch-22/chicken-egg problem.
> > > > >>>>> 
> > > > >>>>> Finally, saying "containers are complex and error prone" is conflating several large suites of userspace
> > > > >>>>> code and many kernel features which support them.  Being more precise would, if the argument is valid, lend
> > > > >>>>> it a lot more weight.
> > > > >>>> 
> > > > >>>> We (my company) use Linux containers since 2011 in production. First LXC, now libvirt-lxc. To understand the
> > > > >>>> internals better I also wrote my own userspace to create/start containers. There are so many things which can
> > > > >>>> hurt you badly. With user namespaces we expose a really big attack surface to regular users. I.e. Suddenly a
> > > > >>>> user is allowed to mount filesystems.
> > > > >>> 
> > > > >>> That is currently not the case.  They can mount some virtual filesystems and do bind mounts, but cannot mount
> > > > >>> most real filesystems.  This keeps us protected (for now) from potentially unsafe superblock readers in the 
> > > > >>> kernel.
> > > > >>> 
> > > > >>>> Ask Andy, he found already lots of nasty things...
> > > > >> 
> > > > >> I don't think I have anything brilliant to add to this discussion right now, except possibly:
> > > > >> 
> > > > >> ISTM that Linux distributions are, in general, vulnerable to all kinds of shenanigans that would happen if an
> > > > >> untrusted user can cause a block device to appear.  That user doesn't need permission to mount it
> > > > > 
> > > > > Interesting point.  This would further suggest that we absolutely must ensure that a loop device which shows up in
> > > > > the container does not also show up in the host.
> > > > 
> > > > Can I suggest the usage of the devices cgroup to achieve that?
> > > 
> > > Not really ... cgroups impose resource limits, it's namespaces that
> > > impose visibility separations.  In theory this can be done with the
> > > device namespace that's been proposed; however, a simpler way is simply
> > > to rm the device node in the host and mknod it in the guest.  I don't
> > > really see host visibility as a huge problem: in a shared OS
> > > virtualisation it's not really possible securely to separate the guest
> > > from the host (only vice versa).
> > > 
> > > But I really don't think we want to do it this way.  Giving a container
> > > the ability to do a mount is too dangerous.  What we want to do is
> > > intercept the mount in the host and perform it on behalf of the guest as
> > > host root in the guest's mount namespace.  If you do it that way, it
> > 
> > That doesn't help the problem of guests being able to provide bad input
> > for (basically fuzz) the in-kernel filesystem code.  So apparently I'm
> > suffering a failure of the imagination - what problem exactly does it solve?
> 
> Well, there's two types of fuzzing, one is on sys_mount, which this
> would help with because the host filters the mount including all
> parameters and may even redo the mount (from direct to bind etc).

Sorry - I'm not *trying* to be dense, but am still not seeing it.

Let's assume that we continue to be strict about what a container may
mount - let's say they can only mount using loopdev from blockdev images.
They have to own the file, as well as the mount target.  Whatever they
do with sys_mount, the only danger I see is the one where the filesystem
data is bad and causes a DOS or privilege escalation in some bad fs
reading code in the kernel.

What else is there?  Are you thinking of the sys_mount flags?  I guess
the void *data?  (Though I see that as the same problem;  we're just
not trusting the fs code to deal with badly formed data)

> If you're thinking the system can be compromised by fuzzing within the
> filesystem, then yes, I agree, but it's the same vulnerability an
> unvirtualised host would have, so I don't necessarily see it as our
> problem.
> 
> The problem vectored mount solves is the one of not wanting root in the
> container to have unfettered access to sys_mount because it allows the
> host to vet all calls and execute the ones it likes in the context of
> real root (possibly after modifying the parameters).
> 
> James
> 
