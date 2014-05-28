Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaE1Ntu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:49:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33576 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbaE1Ntr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:49:47 -0400
Date: Wed, 28 May 2014 13:49:05 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Marian Marinov <mm@1h.com>,
        Andy Lutomirski <luto@amacapital.net>,
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
Message-ID: <20140528134905.GH6667@ubuntumail>
References: <53751FFA.5040103@nod.at>
 <20140515202628.GB25896@mail.hallyn.com>
 <CALCETrWE72G86QKVZT2aqWsEmjwOPwsWMUNz5-JkDvbqaGbrvw@mail.gmail.com>
 <20140520141931.GH26600@ubuntumail>
 <537F04BF.3000301@1h.com>
 <1400850960.2332.4.camel@dabdike>
 <20140524222535.GD4232@ubuntumail>
 <1401005530.2322.43.camel@dabdike.int.hansenpartnership.com>
 <20140525222443.GA18410@mail.hallyn.com>
 <1401260579.428.8.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401260579.428.8.camel@dabdike>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
> On Mon, 2014-05-26 at 00:24 +0200, Serge E. Hallyn wrote:
> > Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
> > > On Sat, 2014-05-24 at 22:25 +0000, Serge Hallyn wrote:
> > > > Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
> > > > > On Fri, 2014-05-23 at 11:20 +0300, Marian Marinov wrote:
> > > > > > On 05/20/2014 05:19 PM, Serge Hallyn wrote:
> > > > > > > Quoting Andy Lutomirski (luto@amacapital.net):
> > > > > > >> On May 15, 2014 1:26 PM, "Serge E. Hallyn" <serge@hallyn.com> wrote:
> > > > > > >>> 
> > > > > > >>> Quoting Richard Weinberger (richard@nod.at):
> > > > > > >>>> Am 15.05.2014 21:50, schrieb Serge Hallyn:
> > > > > > >>>>> Quoting Richard Weinberger (richard.weinberger@gmail.com):
> > > > > > >>>>>> On Thu, May 15, 2014 at 4:08 PM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > > > >>>>>>> Then don't use a container to build such a thing, or fix the build scripts to not do that :)
> > > > > > >>>>>> 
> > > > > > >>>>>> I second this. To me it looks like some folks try to (ab)use Linux containers for purposes where KVM
> > > > > > >>>>>> would much better fit in. Please don't put more complexity into containers. They are already horrible
> > > > > > >>>>>> complex and error prone.
> > > > > > >>>>> 
> > > > > > >>>>> I, naturally, disagree :)  The only use case which is inherently not valid for containers is running a
> > > > > > >>>>> kernel.  Practically speaking there are other things which likely will never be possible, but if someone 
> > > > > > >>>>> offers a way to do something in containers, "you can't do that in containers" is not an apropos response.
> > > > > > >>>>> 
> > > > > > >>>>> "That abstraction is wrong" is certainly valid, as when vpids were originally proposed and rejected,
> > > > > > >>>>> resulting in the development of pid namespaces.  "We have to work out (x) first" can be valid (and I can
> > > > > > >>>>> think of examples here), assuming it's not just trying to hide behind a catch-22/chicken-egg problem.
> > > > > > >>>>> 
> > > > > > >>>>> Finally, saying "containers are complex and error prone" is conflating several large suites of userspace
> > > > > > >>>>> code and many kernel features which support them.  Being more precise would, if the argument is valid, lend
> > > > > > >>>>> it a lot more weight.
> > > > > > >>>> 
> > > > > > >>>> We (my company) use Linux containers since 2011 in production. First LXC, now libvirt-lxc. To understand the
> > > > > > >>>> internals better I also wrote my own userspace to create/start containers. There are so many things which can
> > > > > > >>>> hurt you badly. With user namespaces we expose a really big attack surface to regular users. I.e. Suddenly a
> > > > > > >>>> user is allowed to mount filesystems.
> > > > > > >>> 
> > > > > > >>> That is currently not the case.  They can mount some virtual filesystems and do bind mounts, but cannot mount
> > > > > > >>> most real filesystems.  This keeps us protected (for now) from potentially unsafe superblock readers in the 
> > > > > > >>> kernel.
> > > > > > >>> 
> > > > > > >>>> Ask Andy, he found already lots of nasty things...
> > > > > > >> 
> > > > > > >> I don't think I have anything brilliant to add to this discussion right now, except possibly:
> > > > > > >> 
> > > > > > >> ISTM that Linux distributions are, in general, vulnerable to all kinds of shenanigans that would happen if an
> > > > > > >> untrusted user can cause a block device to appear.  That user doesn't need permission to mount it
> > > > > > > 
> > > > > > > Interesting point.  This would further suggest that we absolutely must ensure that a loop device which shows up in
> > > > > > > the container does not also show up in the host.
> > > > > > 
> > > > > > Can I suggest the usage of the devices cgroup to achieve that?
> > > > > 
> > > > > Not really ... cgroups impose resource limits, it's namespaces that
> > > > > impose visibility separations.  In theory this can be done with the
> > > > > device namespace that's been proposed; however, a simpler way is simply
> > > > > to rm the device node in the host and mknod it in the guest.  I don't
> > > > > really see host visibility as a huge problem: in a shared OS
> > > > > virtualisation it's not really possible securely to separate the guest
> > > > > from the host (only vice versa).
> > > > > 
> > > > > But I really don't think we want to do it this way.  Giving a container
> > > > > the ability to do a mount is too dangerous.  What we want to do is
> > > > > intercept the mount in the host and perform it on behalf of the guest as
> > > > > host root in the guest's mount namespace.  If you do it that way, it
> > > > 
> > > > That doesn't help the problem of guests being able to provide bad input
> > > > for (basically fuzz) the in-kernel filesystem code.  So apparently I'm
> > > > suffering a failure of the imagination - what problem exactly does it solve?
> > > 
> > > Well, there's two types of fuzzing, one is on sys_mount, which this
> > > would help with because the host filters the mount including all
> > > parameters and may even redo the mount (from direct to bind etc).
> > 
> > Sorry - I'm not *trying* to be dense, but am still not seeing it.
> > 
> > Let's assume that we continue to be strict about what a container may
> > mount - let's say they can only mount using loopdev from blockdev images.
> > They have to own the file, as well as the mount target.  Whatever they
> > do with sys_mount, the only danger I see is the one where the filesystem
> > data is bad and causes a DOS or privilege escalation in some bad fs
> > reading code in the kernel.
> > 
> > What else is there?  Are you thinking of the sys_mount flags?  I guess
> > the void *data?  (Though I see that as the same problem;  we're just
> > not trusting the fs code to deal with badly formed data)
> 
> OK, so the problem you're worrying about is allowing the user to modify
> a block device and then mount it?

That's half of the problem I'm worrying about.

The other half is what Andy mentioned earlier - having a container modify
a loop device and trick the host into mounting it (i.e. settingn its uuid
to the host's HOME)

> In that case, I agree, it doesn't
> matter who does the mount, because a hostile user is looking to exploit
> bad data on the device.  By and large, filesystems are tolerant to this
> type of fuzzing, but the strict solution is not to allow a container to
> mount any block devices it has direct access to.
> 
> James
> 
> 
