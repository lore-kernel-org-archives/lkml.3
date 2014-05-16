Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaEPPnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:43:49 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:52889 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaEPPnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:43:46 -0400
Date: Fri, 16 May 2014 10:43:38 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: Jens Axboe <axboe@kernel.dk>, Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140516154338.GB23902@ubuntu-hedt>
Mail-Followup-To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>,
	Jens Axboe <axboe@kernel.dk>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20140515031527.GA146352@ubuntu-hedt>
 <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
 <20140515174254.GM21073@ubuntumail>
 <20140515221551.GB13306@kroah.com>
 <20140516014959.GD22591@ubuntumail>
 <20140516043532.GA14149@kroah.com>
 <20140516140607.GA23902@ubuntu-hedt>
 <1400254108.3540.5.camel@canyon.ip6.wittsend.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400254108.3540.5.camel@canyon.ip6.wittsend.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:28:28AM -0400, Michael H. Warfield wrote:
> On Fri, 2014-05-16 at 09:06 -0500, Seth Forshee wrote:
> > On Thu, May 15, 2014 at 09:35:32PM -0700, Greg Kroah-Hartman wrote:
> > > On Fri, May 16, 2014 at 01:49:59AM +0000, Serge Hallyn wrote:
> > > > > I think having to pick and choose what device nodes you want in a
> > > > > container is a good thing.  Becides, you would have to do the same thing
> > > > > in the kernel anyway, what's wrong with userspace making the decision
> > > > > here, especially as it knows exactly what it wants to do much more so
> > > > > than the kernel ever can.
> > > > 
> > > > For 'real' devices that sounds sensible.  The thing about loop devices
> > > > is that we simply want to allow a container to say "give me a loop
> > > > device to use" and have it receive a unique loop device (or 3), without
> > > > having to pre-assign them.  I think that would be cleaner to do using
> > > > a pseudofs and loop-control device, rather than having to have a
> > > > daemon in userspace on the host farming those out in response to
> > > > some, I don't know, dbus request?
> > > 
> > > I agree that loop devices would be nice to have in a container, and that
> > > the existing loop interface doesn't really lend itself to that.  So
> > > create a new type of thing that acts like a loop device in a container.
> > > But don't try to mess with the whole driver core just for a single type
> > > of device.
> 
> > No matter what I don't think we get out of this without driver core
> > changes, whether this was done in loop or by creating something new.
> > Not unless the whole thing is punted to userspace, anyway.
> 
> > The first problem is that many block device ioctls check for
> > CAP_SYS_ADMIN. Most of these might not ever be used on loop devices, I'm
> > not really sure. But loop does at minimum support partitions, and to get
> > that functionality in an unprivileged container at least the block layer
> > needs to know the namespace which has privileges for that device.
> 
> Woa!  Time out...  Sorry, this will be an off topic aside.
> 
> Loop devices support partitions?  I'd love to know how that works.  I've
> tried several times in the past to do that but it's failed every time.
> I haven't been able to find any how-to in the past.  This article was
> just a couple of years ago (after the last time I tried this):
> 
> http://madduck.net/blog/2006.10.20:loop-mounting-partitions-from-a-disk-image/
> 
> This guy didn't use partitions directly but used the offset to the
> mount, which is what I had to use.  Everything I found always referred
> to using mount offsets in order to mount partitions within a loop
> device.

It's controlled by the loop.max_part module parameter. It defaults to 0,
which means no partition support. For any value > 0 max_part will be the
maximum available partition number, after rounding it up to the nearest
power of 2 minus 1 (so max_part=5 gives you up to 8 partitions,
max_part=8 gives you up to 16, etc).
