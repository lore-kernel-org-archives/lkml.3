Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab3LTDbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:31:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab3LTDbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:31:45 -0500
Message-ID: <1387510289.30327.79.camel@bling.home>
Subject: Re: [PATCH v2] misc: Reserve minor for VFIO
From: Alex Williamson <alex.williamson@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk,
        arnd@arndb.de, Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Thu, 19 Dec 2013 20:31:29 -0700
In-Reply-To: <20131220023820.GG25322@phenom.dumpdata.com>
References: <20131218204024.30540.55302.stgit@bling.home>
	 <20131218210141.GA11267@kroah.com> <52B21B7E.1020307@zytor.com>
	 <20131220023820.GG25322@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 21:38 -0500, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 18, 2013 at 02:02:38PM -0800, H. Peter Anvin wrote:
> > On 12/18/2013 01:01 PM, Greg KH wrote:
> > > On Wed, Dec 18, 2013 at 01:56:32PM -0700, Alex Williamson wrote:
> > >> VFIO currently allocates it's own dynamic chardev range, reserving the
> > >> first minor for the control part of the interface (/dev/vfio/vfio) and
> > >> the remainder for VFIO groups (/dev/vfio/$GROUP).  This works, but it
> > >> doesn't support auto loading.  For instance when libvirt checks for
> > >> VFIO support it looks for /dev/vfio/vfio, which currently doesn't
> > >> exist unless the vfio module is loaded.  By converting the control
> > >> device to a misc driver and reserving a static minor, we can enable
> > >> auto loading.
> 
> Why not have libvirt or systemctl try to load vfio first? If it does
> not work it would error out.

Kay Sievers made a pass through the kernel a while back adding devname
support to a number of drivers to "remove a bunch of pretty useless init
scripts and modprobes from init scripts".  So I believe this to be the
preferred approach for systemd.  Besides, the init scripts don't know if
the feature is actually being used, so it's a waste to blindly load the
module because you've installed qemu or libvirt.

libvirt also has little interest in loading the module themselves and
frowned on the approach of them loading the module when I proposed it.
VFIO also has scope beyond libvirt, so solving it there only addresses
one use case, granted it's currently the most prevalent use case of
VFIO.

A number of other drivers have adopted the devname model for
auto-loading, kvm, vhost, fuse, dm, tun, ppp, etc, so why not use it
here too?

> Or perhaps make the loading of modules in /dev/vfio automatic? I thought
> it was based on the name?

I don't think I understand the question, this is an effort to do that
for /dev/vfio/vfio.  I don't wish to force this module to be statically
loaded into the kernel, it's only used by a small fraction of users.  To
support autoloading udev needs to know a static major/minor for the
device entry.  It cannot be done with only a name.  I posted a companion
patch to this last week that converts VFIO's control interface to a misc
driver with this static minor to accomplish that.  Thanks,

Alex

> > >>
> > >> Reserving the minor is a prerequist to that conversion.  Minor 196
> > >> is unused by anything currently in the kernel.
> > >>
> > >> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > >> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > >> ---
> > >>
> > >> v2: Plea for ack edition
> > >>
> > >> As Alan suspected, there's been no response from device@lanana.org,
> > >> so there's probably nobody monitoring it anymore.  I've done due
> > >> diligence looking at all the callers of misc_register() in linux-next
> > >> and cannot find any conflicts with minor 196.  If anyone wants to toss
> > >> me an ack or sign-off I'll be happy to bring this in through my vfio
> > >> tree, otherwise I'd appreciate if someone wants to take it directly.
> > >> Thanks!
> > >>
> > >>  Documentation/devices.txt  |    1 +
> > >>  include/linux/miscdevice.h |    1 +
> > >>  2 files changed, 2 insertions(+)
> > > 
> > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > 
> > I think Alan Cox was the last person to man <device@lanana.org>... Alan,
> > are you still doing that?  (Otherwise patching the file in the Linux
> > kernel tree seems eminently sensible... there really isn't any need to
> > reserve numbers for out-of-tree drivers anymore.  Just another perk of
> > being in-tree.)
> > 
> > 	-hpa
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


