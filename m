Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaEPOGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:06:22 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46014 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbaEPOGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:06:15 -0400
Date: Fri, 16 May 2014 09:06:07 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
Message-ID: <20140516140607.GA23902@ubuntu-hedt>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Serge Hallyn <serge.hallyn@ubuntu.com>,
	Jens Axboe <axboe@kernel.dk>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
References: <20140515013245.GA1764@kroah.com>
 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
 <20140515031527.GA146352@ubuntu-hedt>
 <20140515040032.GA6702@kroah.com>
 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
 <20140515140856.GA17453@kroah.com>
 <20140515174254.GM21073@ubuntumail>
 <20140515221551.GB13306@kroah.com>
 <20140516014959.GD22591@ubuntumail>
 <20140516043532.GA14149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516043532.GA14149@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 09:35:32PM -0700, Greg Kroah-Hartman wrote:
> On Fri, May 16, 2014 at 01:49:59AM +0000, Serge Hallyn wrote:
> > > I think having to pick and choose what device nodes you want in a
> > > container is a good thing.  Becides, you would have to do the same thing
> > > in the kernel anyway, what's wrong with userspace making the decision
> > > here, especially as it knows exactly what it wants to do much more so
> > > than the kernel ever can.
> > 
> > For 'real' devices that sounds sensible.  The thing about loop devices
> > is that we simply want to allow a container to say "give me a loop
> > device to use" and have it receive a unique loop device (or 3), without
> > having to pre-assign them.  I think that would be cleaner to do using
> > a pseudofs and loop-control device, rather than having to have a
> > daemon in userspace on the host farming those out in response to
> > some, I don't know, dbus request?
> 
> I agree that loop devices would be nice to have in a container, and that
> the existing loop interface doesn't really lend itself to that.  So
> create a new type of thing that acts like a loop device in a container.
> But don't try to mess with the whole driver core just for a single type
> of device.

No matter what I don't think we get out of this without driver core
changes, whether this was done in loop or by creating something new.
Not unless the whole thing is punted to userspace, anyway.

The first problem is that many block device ioctls check for
CAP_SYS_ADMIN. Most of these might not ever be used on loop devices, I'm
not really sure. But loop does at minimum support partitions, and to get
that functionality in an unprivileged container at least the block layer
needs to know the namespace which has privileges for that device.

The second is that all block devices automatically appear in devtmpfs.
The scenario I'm concerned about is that the host could unknowingly use
a loop device exposed to a container, then the container could see data
from the host. So we either need a flag to tell the driver core not to
create a node in devtmpfs, or we need a privileged manager in userspace
to remove them (which kind of defeats the purpose). And it gets more
complicated when partition block devs are mixed in, because they can be
created without involvement from the driver - they would need to inherit
the "no devtmpfs node" property from their parent, and if the driver
uses a psuedo fs to create device nodes for userspace then it needs to
be informed about the partitions too so it can create those nodes.

So maybe we could get by without the privileged ioctls, as long as it
was understood that unprivileged containers can't do partitioning. But I
do think the devtmpfs problem would need to be addressed.

Thanks,
Seth
