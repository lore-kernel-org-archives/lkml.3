Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3AKTIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 14:08:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab3AKTIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 14:08:49 -0500
Date: Fri, 11 Jan 2013 16:48:38 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Gleb Natapov <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] VFIO-AER: Vfio-pci driver changes for supporting AER
Message-ID: <20130111184838.GB15113@amt.cnet>
References: <F9E001219150CB45BEDC82A650F360C90149602F@G9W0717.americas.hpqcorp.net>
 <1357753953.3224.769.camel@bling.home>
 <1357758299.3224.785.camel@bling.home>
 <F9E001219150CB45BEDC82A650F360C901497684@G9W0717.americas.hpqcorp.net>
 <1357919195.3224.818.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357919195.3224.818.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 08:46:35AM -0700, Alex Williamson wrote:
> On Fri, 2013-01-11 at 08:45 +0000, Pandarathil, Vijaymohan R wrote:
> > 
> > > -----Original Message-----
> > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > Sent: Wednesday, January 09, 2013 11:05 AM
> > > To: Pandarathil, Vijaymohan R
> > > Cc: Bjorn Helgaas; Gleb Natapov; kvm@vger.kernel.org; qemu-
> > > devel@nongnu.org; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> > > Subject: Re: [PATCH 1/2] VFIO-AER: Vfio-pci driver changes for supporting
> > > AER
> > > 
> > > On Wed, 2013-01-09 at 10:52 -0700, Alex Williamson wrote:
> > > > On Wed, 2013-01-09 at 06:26 +0000, Pandarathil, Vijaymohan R wrote:
> > > > > 	- New ioctl which is used to pass the eventfd that is signaled when
> > > > >           an error occurs in the vfio_pci_device
> > > > >
> > > > > 	- Register pci_error_handler for the vfio_pci driver
> > > > >
> > > > > 	- When the device encounters an error, the error handler registered
> > > by
> > > > >           the vfio_pci driver gets invoked by the AER infrastructure
> > > > >
> > > > > 	- In the error handler, signal the eventfd registered for the device.
> > > > >
> > > > > 	- This results in the qemu eventfd handler getting invoked and
> > > > >           appropriate action taken for the guest.
> > > > >
> > > > > Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> > > > > ---
> > > > >  drivers/vfio/pci/vfio_pci.c         | 29 +++++++++++++++++++++++++++++
> > > > >  drivers/vfio/pci/vfio_pci_private.h |  1 +
> > > > >  drivers/vfio/vfio.c                 |  8 ++++++++
> > > > >  include/linux/vfio.h                |  1 +
> > > > >  include/uapi/linux/vfio.h           |  9 +++++++++
> > > > >  5 files changed, 48 insertions(+)
> > > > >
> > > > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > > > > index 6c11994..4ae9526 100644
> > > > > --- a/drivers/vfio/pci/vfio_pci.c
> > > > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > > > @@ -207,6 +207,8 @@ static long vfio_pci_ioctl(void *device_data,
> > > > >  		if (vdev->reset_works)
> > > > >  			info.flags |= VFIO_DEVICE_FLAGS_RESET;
> > > > >
> > > > > +		info.flags |= VFIO_DEVICE_FLAGS_AER_NOTIFY;
> > > > > +
> > > >
> > > > This appears to be a PCI specific flag, so the name should include
> > > > _PCI_.  We also support non-PCIe devices and it seems like it would be
> > > > possible to not have AER support available, so shouldn't this be
> > > > conditional?
> > 
> > Will do that.
> > 
> > > >
> > > > >  		info.num_regions = VFIO_PCI_NUM_REGIONS;
> > > > >  		info.num_irqs = VFIO_PCI_NUM_IRQS;
> > > > >
> > > > > @@ -348,6 +350,19 @@ static long vfio_pci_ioctl(void *device_data,
> > > > >
> > > > >  		return ret;
> > > > >
> > > > > +	} else if (cmd == VFIO_DEVICE_SET_ERRFD) {
> > > > > +		int32_t fd = (int32_t)arg;
> > > > > +
> > > > > +		if (fd < 0)
> > > > > +			return -EINVAL;
> > > > > +
> > > > > +		vdev->err_trigger = eventfd_ctx_fdget(fd);
> > > > > +
> > > > > +		if (IS_ERR(vdev->err_trigger))
> > > > > +			return PTR_ERR(vdev->err_trigger);
> > > > > +
> > > > > +		return 0;
> > > > > +
> > > >
> > > > I'm not sure why we wouldn't describe this as just another interrupt
> > > > from the device and configure it via SET_IRQ.  This ioctl has very
> > > > limited use and doesn't follow any of the conventions of all the other
> > > > vfio ioctls.
> > 
> > I thought this was a fairly simple ioctl to implement this way. Moreover, 
> > there is no device interrupt involved. Let me know if you really want to 
> > model it as a SET_IRQ ioctl.
> 
> I'd like to see something else for sure.  We're trying to do AER
> piecemeal but this ioctl leaves no room for anything else.  Seems like a
> soon to be wasted ioctl number.  Note that there isn't even a de-assign
> interface, nor a flag to set to indicate de-assignment.  The SET_IRQ
> ioctl already handles these in a very similar way to how we'd want to
> handle it for error signaling.  It doesn't seem like that much of a
> stretch to me to include it there, but I'd also entertain other ideas.
> Thanks,
> 
> Alex

Yes it would be good to have a picture of the dependencies necessary to
implement passthrough, before introducing an incompatible interface.

