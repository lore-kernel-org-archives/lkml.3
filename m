Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3AKIqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 03:46:40 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:27786 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3AKIqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 03:46:38 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Gleb Natapov <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] VFIO-AER: Vfio-pci driver changes for supporting AER
Thread-Topic: [PATCH 1/2] VFIO-AER: Vfio-pci driver changes for supporting
 AER
Thread-Index: AQHN7jI7dpem711Q/kq5KDVD8qeBlJhBR8+AgAAUPYCAAm/DgA==
Date: Fri, 11 Jan 2013 08:45:54 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C901497684@G9W0717.americas.hpqcorp.net>
References: <F9E001219150CB45BEDC82A650F360C90149602F@G9W0717.americas.hpqcorp.net>
	 <1357753953.3224.769.camel@bling.home>
 <1357758299.3224.785.camel@bling.home>
In-Reply-To: <1357758299.3224.785.camel@bling.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.23]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0B8kgkv019562



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Wednesday, January 09, 2013 11:05 AM
> To: Pandarathil, Vijaymohan R
> Cc: Bjorn Helgaas; Gleb Natapov; kvm@vger.kernel.org; qemu-
> devel@nongnu.org; linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 1/2] VFIO-AER: Vfio-pci driver changes for supporting
> AER
> 
> On Wed, 2013-01-09 at 10:52 -0700, Alex Williamson wrote:
> > On Wed, 2013-01-09 at 06:26 +0000, Pandarathil, Vijaymohan R wrote:
> > > 	- New ioctl which is used to pass the eventfd that is signaled when
> > >           an error occurs in the vfio_pci_device
> > >
> > > 	- Register pci_error_handler for the vfio_pci driver
> > >
> > > 	- When the device encounters an error, the error handler registered
> by
> > >           the vfio_pci driver gets invoked by the AER infrastructure
> > >
> > > 	- In the error handler, signal the eventfd registered for the device.
> > >
> > > 	- This results in the qemu eventfd handler getting invoked and
> > >           appropriate action taken for the guest.
> > >
> > > Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> > > ---
> > >  drivers/vfio/pci/vfio_pci.c         | 29 +++++++++++++++++++++++++++++
> > >  drivers/vfio/pci/vfio_pci_private.h |  1 +
> > >  drivers/vfio/vfio.c                 |  8 ++++++++
> > >  include/linux/vfio.h                |  1 +
> > >  include/uapi/linux/vfio.h           |  9 +++++++++
> > >  5 files changed, 48 insertions(+)
> > >
> > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > > index 6c11994..4ae9526 100644
> > > --- a/drivers/vfio/pci/vfio_pci.c
> > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > @@ -207,6 +207,8 @@ static long vfio_pci_ioctl(void *device_data,
> > >  		if (vdev->reset_works)
> > >  			info.flags |= VFIO_DEVICE_FLAGS_RESET;
> > >
> > > +		info.flags |= VFIO_DEVICE_FLAGS_AER_NOTIFY;
> > > +
> >
> > This appears to be a PCI specific flag, so the name should include
> > _PCI_.  We also support non-PCIe devices and it seems like it would be
> > possible to not have AER support available, so shouldn't this be
> > conditional?

Will do that.

> >
> > >  		info.num_regions = VFIO_PCI_NUM_REGIONS;
> > >  		info.num_irqs = VFIO_PCI_NUM_IRQS;
> > >
> > > @@ -348,6 +350,19 @@ static long vfio_pci_ioctl(void *device_data,
> > >
> > >  		return ret;
> > >
> > > +	} else if (cmd == VFIO_DEVICE_SET_ERRFD) {
> > > +		int32_t fd = (int32_t)arg;
> > > +
> > > +		if (fd < 0)
> > > +			return -EINVAL;
> > > +
> > > +		vdev->err_trigger = eventfd_ctx_fdget(fd);
> > > +
> > > +		if (IS_ERR(vdev->err_trigger))
> > > +			return PTR_ERR(vdev->err_trigger);
> > > +
> > > +		return 0;
> > > +
> >
> > I'm not sure why we wouldn't describe this as just another interrupt
> > from the device and configure it via SET_IRQ.  This ioctl has very
> > limited use and doesn't follow any of the conventions of all the other
> > vfio ioctls.

I thought this was a fairly simple ioctl to implement this way. Moreover, 
there is no device interrupt involved. Let me know if you really want to 
model it as a SET_IRQ ioctl.

> >
> > >  	} else if (cmd == VFIO_DEVICE_RESET)
> > >  		return vdev->reset_works ?
> > >  			pci_reset_function(vdev->pdev) : -EINVAL;
> > > @@ -527,11 +542,25 @@ static void vfio_pci_remove(struct pci_dev *pdev)
> > >  	kfree(vdev);
> > >  }
> > >
> > > +static pci_ers_result_t vfio_err_detected(struct pci_dev *pdev,
> > > +				pci_channel_state_t state)
> > > +{
> > > +	struct vfio_pci_device *vdev = vfio_get_vdev(&pdev->dev);
> > > +
> > > +	eventfd_signal(vdev->err_trigger, 1);
> > > +	return PCI_ERS_RESULT_CAN_RECOVER;
> > > +}
> >
> > What if err_trigger hasn't been set?

Will fix that.

> >
> > > +
> > > +static const struct pci_error_handlers vfio_err_handlers = {
> > > +	.error_detected = vfio_err_detected,
> > > +};
> > > +
> > >  static struct pci_driver vfio_pci_driver = {
> > >  	.name		= "vfio-pci",
> > >  	.id_table	= NULL, /* only dynamic ids */
> > >  	.probe		= vfio_pci_probe,
> > >  	.remove		= vfio_pci_remove,
> > > +	.err_handler	= &vfio_err_handlers,
> > >  };
> > >
> > >  static void __exit vfio_pci_cleanup(void)
> > > diff --git a/drivers/vfio/pci/vfio_pci_private.h
> b/drivers/vfio/pci/vfio_pci_private.h
> > > index 611827c..daee62f 100644
> > > --- a/drivers/vfio/pci/vfio_pci_private.h
> > > +++ b/drivers/vfio/pci/vfio_pci_private.h
> > > @@ -55,6 +55,7 @@ struct vfio_pci_device {
> > >  	bool			bardirty;
> > >  	struct pci_saved_state	*pci_saved_state;
> > >  	atomic_t		refcnt;
> > > +	struct eventfd_ctx	*err_trigger;
> > >  };
> > >
> > >  #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
> > > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > > index 56097c6..5ed5a54 100644
> > > --- a/drivers/vfio/vfio.c
> > > +++ b/drivers/vfio/vfio.c
> > > @@ -693,6 +693,14 @@ void *vfio_del_group_dev(struct device *dev)
> > >  }
> > >  EXPORT_SYMBOL_GPL(vfio_del_group_dev);
> > >
> > > +void *vfio_get_vdev(struct device *dev)
> > > +{
> > > +	struct vfio_device *device = dev_get_drvdata(dev);
> > > +
> > > +	return device->device_data;
> > > +}
> > > +EXPORT_SYMBOL_GPL(vfio_get_vdev);
> > > +
> >
> > This is unsafe.  How do we know dev is a vfio device?  How do we keep
> > that drvdata valid while you're using it?  I think you want to export
> > the existing vfio_group_get_device() and vfio_device_put().  Thanks,
> 
> vfio_group_get_device() isn't quite what you want either since it
> assumes a reference count on the group.  You'll want something like
> vfio_add_group_dev() or vfio_dev_present(), perhaps moving the
> iommu_group_get -> vfio_group_get_from_iommu -> vfio_group_get_device
> into a helper function.  Thanks,

Thanks for the pointers. Will make the change.

Vijay

> 
> Alex
> 
> > >  /**
> > >   * VFIO base fd, /dev/vfio/vfio
> > >   */
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index ab9e862..3c97b03 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -45,6 +45,7 @@ extern int vfio_add_group_dev(struct device *dev,
> > >  			      void *device_data);
> > >
> > >  extern void *vfio_del_group_dev(struct device *dev);
> > > +extern void *vfio_get_vdev(struct device *dev);
> > >
> > >  /**
> > >   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 4758d1b..fa67213 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -147,6 +147,7 @@ struct vfio_device_info {
> > >  	__u32	flags;
> > >  #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports
> reset */
> > >  #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
> > > +#define VFIO_DEVICE_FLAGS_AER_NOTIFY (1 << 2)	/* Supports aer
> notify */
> > >  	__u32	num_regions;	/* Max region index + 1 */
> > >  	__u32	num_irqs;	/* Max IRQ index + 1 */
> > >  };
> > > @@ -288,6 +289,14 @@ struct vfio_irq_set {
> > >   */
> > >  #define VFIO_DEVICE_RESET		_IO(VFIO_TYPE, VFIO_BASE + 11)
> > >
> > > +/**
> > > + * VFIO_DEVICE_SET_ERRFD - _IO(VFIO_TYPE, VFIO_BASE + 12)
> > > + *
> > > + * Pass the eventfd to the vfio-pci driver for signalling any device
> > > + * error notifications
> > > + */
> > > +#define VFIO_DEVICE_SET_ERRFD		_IO(VFIO_TYPE, VFIO_BASE + 12)
> > > +
> > >  /*
> > >   * The VFIO-PCI bus driver makes use of the following fixed region and
> > >   * IRQ index mapping.  Unimplemented regions return a size of zero.
> >
> >
> 
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
