Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbaETOQC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:16:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41539 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaETOQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:16:00 -0400
Date: Tue, 20 May 2014 14:15:39 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael H. Warfield" <mhw@WittsEnd.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140520141539.GF26600@ubuntumail>
References: <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
 <20140515174254.GM21073@ubuntumail>
 <20140515221551.GB13306@kroah.com>
 <20140516014959.GD22591@ubuntumail>
 <20140516043532.GA14149@kroah.com>
 <87mwehgh5i.fsf@x220.int.ebiederm.org>
 <20140517160145.GA44802@ubuntu-hedt>
 <20140518024458.GB25613@mail.hallyn.com>
 <20140519132703.GA49509@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519132703.GA49509@ubuntu-hedt>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Seth Forshee (seth.forshee@canonical.com):
> On Sun, May 18, 2014 at 04:44:58AM +0200, Serge E. Hallyn wrote:
> > Quoting Seth Forshee (seth.forshee@canonical.com):
> > > On Fri, May 16, 2014 at 09:31:37PM -0700, Eric W. Biederman wrote:
> > > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > > > 
> > > > > On Fri, May 16, 2014 at 01:49:59AM +0000, Serge Hallyn wrote:
> > > > >> > I think having to pick and choose what device nodes you want in a
> > > > >> > container is a good thing.  Becides, you would have to do the same thing
> > > > >> > in the kernel anyway, what's wrong with userspace making the decision
> > > > >> > here, especially as it knows exactly what it wants to do much more so
> > > > >> > than the kernel ever can.
> > > > >> 
> > > > >> For 'real' devices that sounds sensible.  The thing about loop devices
> > > > >> is that we simply want to allow a container to say "give me a loop
> > > > >> device to use" and have it receive a unique loop device (or 3), without
> > > > >> having to pre-assign them.  I think that would be cleaner to do using
> > > > >> a pseudofs and loop-control device, rather than having to have a
> > > > >> daemon in userspace on the host farming those out in response to
> > > > >> some, I don't know, dbus request?
> > > > >
> > > > > I agree that loop devices would be nice to have in a container, and that
> > > > > the existing loop interface doesn't really lend itself to that.  So
> > > > > create a new type of thing that acts like a loop device in a container.
> > > > > But don't try to mess with the whole driver core just for a single type
> > > > > of device.
> > > > 
> > > > Yes. Something like devpts (without the newinstance option).  Built to
> > > > allow unprivileged users to create loopback devices.
> > > 
> > > That's where I started, and I've got code, so I guess I'll clean it up
> > > and send patches. If the stance is that only system-wide CAP_SYS_ADMIN
> > > gets to do privileged block device ioctls, including reading partitions
> > 
> > Sorry, where did that come from?  What Eric was referring to below is
> > the fs superblock readers not being trusted.  Maybe I glossed over another
> > email where it was mentioned?
> 
> You must have. Take a look at [1].
> 
> To repeat the point: the ioctl to reread partitions (along with several
> other block device ioctls) has a capable(CAP_SYS_ADMIN) check. We can't
> change this to an ns_capable check without at minimum the block layer
> knowing about the namespace associated with the block device. Ergo we

Which only means those changes are necessary :)

So far as I understand, a namespaced devtmpfs is nacked, but a loopfs
is interesting (and, depending on the implementation, acceptable).  That
necessarily includes the minimal blockdev changes to support it.

> can't reread paritions if this is done entirely within the loop driver
> via a psuedo fs.
> 
> [1] http://article.gmane.org/gmane.linux.kernel.containers.lxc.devel/8191
> 
