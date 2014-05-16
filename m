Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbaEPSyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:54:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbaEPSy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:54:29 -0400
Date: Fri, 16 May 2014 11:57:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Serge Hallyn <serge.hallyn@ubuntu.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140516185749.GA5131@kroah.com>
References: <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
 <20140515031527.GA146352@ubuntu-hedt>
 <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
 <20140515174254.GM21073@ubuntumail>
 <20140515221551.GB13306@kroah.com>
 <20140516014959.GD22591@ubuntumail>
 <20140516043532.GA14149@kroah.com>
 <20140516140607.GA23902@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516140607.GA23902@ubuntu-hedt>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 09:06:07AM -0500, Seth Forshee wrote:
> On Thu, May 15, 2014 at 09:35:32PM -0700, Greg Kroah-Hartman wrote:
> > On Fri, May 16, 2014 at 01:49:59AM +0000, Serge Hallyn wrote:
> > > > I think having to pick and choose what device nodes you want in a
> > > > container is a good thing.  Becides, you would have to do the same thing
> > > > in the kernel anyway, what's wrong with userspace making the decision
> > > > here, especially as it knows exactly what it wants to do much more so
> > > > than the kernel ever can.
> > > 
> > > For 'real' devices that sounds sensible.  The thing about loop devices
> > > is that we simply want to allow a container to say "give me a loop
> > > device to use" and have it receive a unique loop device (or 3), without
> > > having to pre-assign them.  I think that would be cleaner to do using
> > > a pseudofs and loop-control device, rather than having to have a
> > > daemon in userspace on the host farming those out in response to
> > > some, I don't know, dbus request?
> > 
> > I agree that loop devices would be nice to have in a container, and that
> > the existing loop interface doesn't really lend itself to that.  So
> > create a new type of thing that acts like a loop device in a container.
> > But don't try to mess with the whole driver core just for a single type
> > of device.
> 
> No matter what I don't think we get out of this without driver core
> changes, whether this was done in loop or by creating something new.
> Not unless the whole thing is punted to userspace, anyway.
> 
> The first problem is that many block device ioctls check for
> CAP_SYS_ADMIN. Most of these might not ever be used on loop devices, I'm
> not really sure. But loop does at minimum support partitions, and to get
> that functionality in an unprivileged container at least the block layer
> needs to know the namespace which has privileges for that device.

That's fine, you should have those permissions in a container if you
want to do something like that on a loop device, right?

> The second is that all block devices automatically appear in devtmpfs.
> The scenario I'm concerned about is that the host could unknowingly use
> a loop device exposed to a container, then the container could see data
> from the host.

I don't think that's a real issue, the host should know not to do that.

> So we either need a flag to tell the driver core not to create a node
> in devtmpfs, or we need a privileged manager in userspace to remove
> them (which kind of defeats the purpose). And it gets more complicated
> when partition block devs are mixed in, because they can be created
> without involvement from the driver - they would need to inherit the
> "no devtmpfs node" property from their parent, and if the driver uses
> a psuedo fs to create device nodes for userspace then it needs to be
> informed about the partitions too so it can create those nodes.

I don't think that will be needed.  Root in a host can do whatever it
wants in the containers, so mixing up block devices is the least of the
issues involved :)

> So maybe we could get by without the privileged ioctls, as long as it
> was understood that unprivileged containers can't do partitioning. But I
> do think the devtmpfs problem would need to be addressed.

I don't think unpriviliged containers should be able to do partitioning.
An unpriviliged user can't do that, so why should a container be any
different?

thanks,

greg k-h
