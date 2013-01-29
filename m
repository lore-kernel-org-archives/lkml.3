Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3A2NYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:24:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab3A2NYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:24:35 -0500
Message-ID: <1359465870.11144.345.camel@bling.home>
Subject: Re: [PATCH v2 2/3] VFIO-AER: Vfio-pci driver changes for supporting
 AER
From: Alex Williamson <alex.williamson@redhat.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 29 Jan 2013 06:24:30 -0700
In-Reply-To: <1359401504.11144.304.camel@bling.home>
References: <F9E001219150CB45BEDC82A650F360C9014A7BDA@G9W0717.americas.hpqcorp.net>
	 <1359401504.11144.304.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 12:31 -0700, Alex Williamson wrote:
> On Mon, 2013-01-28 at 09:54 +0000, Pandarathil, Vijaymohan R wrote:
> >  	- New VFIO_SET_IRQ ioctl option to pass the eventfd that is signalled when
> >           an error occurs in the vfio_pci_device
> > 
> > 	- Register pci_error_handler for the vfio_pci driver
> > 
> > 	- When the device encounters an error, the error handler registered by
> >           the vfio_pci driver gets invoked by the AER infrastructure
> > 
> > 	- In the error handler, signal the eventfd registered for the device.
> > 
> > 	- This results in the qemu eventfd handler getting invoked and
> >           appropriate action taken for the guest.
> > 
> > Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         | 44 ++++++++++++++++++++++++++++++++++++-
> >  drivers/vfio/pci/vfio_pci_intrs.c   | 32 +++++++++++++++++++++++++++
> >  drivers/vfio/pci/vfio_pci_private.h |  1 +
> >  include/uapi/linux/vfio.h           |  3 +++
> >  4 files changed, 79 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index b28e66c..ff2a078 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -196,7 +196,9 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
> >  
> >  			return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
> >  		}
> > -	}
> > +	} else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX)
> > +		if (pci_is_pcie(vdev->pdev))
> > +			return 1;
> >  
> >  	return 0;
> >  }
> > @@ -223,9 +225,18 @@ static long vfio_pci_ioctl(void *device_data,
> >  		if (vdev->reset_works)
> >  			info.flags |= VFIO_DEVICE_FLAGS_RESET;
> >  
> > +		if (pci_is_pcie(vdev->pdev)) {
> > +			info.flags |= VFIO_DEVICE_FLAGS_PCI_AER;
> > +			info.flags |= VFIO_DEVICE_FLAGS_PCI_AER_NOTIFY;
> 
> Not sure this second flag should be AER specific or if it's even needed,
> see below for more comments on this.
> 
> > +		}
> > +
> >  		info.num_regions = VFIO_PCI_NUM_REGIONS;
> >  		info.num_irqs = VFIO_PCI_NUM_IRQS;
> >  
> > +		/* Expose only implemented IRQs */
> > +		if (!(info.flags & VFIO_DEVICE_FLAGS_PCI_AER_NOTIFY))
> > +			info.num_irqs--;
> 
> I'm having second thoughts on this, see further below.
> 
> > +
> >  		return copy_to_user((void __user *)arg, &info, minsz);
> >  
> >  	} else if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> > @@ -302,6 +313,10 @@ static long vfio_pci_ioctl(void *device_data,
> >  		if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
> >  			return -EINVAL;
> >  
> > +		if ((info.index == VFIO_PCI_ERR_IRQ_INDEX) &&
> > +		     !pci_is_pcie(vdev->pdev))
> > +			return -EINVAL;
> > +
> 
> Perhaps we could incorporate the index test above this too?
> 
> switch (info.index) {
> case VFIO_PCI_INTX_IRQ_INDEX: ... VFIO_PCI_MSIX_IRQ_INDEX:
> 	break;
> case VFIO_PCI_ERR_IRQ_INDEX:
> 	if (pci_is_pcie(vdev->pdev))
> 		break;
> default:
> 	return -EINVAL;
> }
> 
> This is more similar to how I've re-written the same for the proposed
> VGA/legacy I/O support.
> 
> >  		info.flags = VFIO_IRQ_INFO_EVENTFD;
> >  
> >  		info.count = vfio_pci_get_irq_count(vdev, info.index);
> > @@ -538,11 +553,38 @@ static void vfio_pci_remove(struct pci_dev *pdev)
> >  	kfree(vdev);
> >  }
> >  
> > +static pci_ers_result_t vfio_err_detected(struct pci_dev *pdev,
> > +				pci_channel_state_t state)
> 
> This is actually AER specific, right?  So perhaps it should be
> vfio_pci_aer_err_detected?
> 
> Also, please follow existing whitespace usage throughout, tabs followed
> by spaces to align function parameter wrap.
> 
> > +{
> > +	struct vfio_pci_device *vpdev;
> > +	void *vdev;
> 
> struct vfio_device *vdev;
> 
> > +
> > +	vdev = vfio_device_get_from_dev(&pdev->dev);
> > +	if (vdev == NULL)
> > +		return PCI_ERS_RESULT_DISCONNECT;
> > +
> > +	vpdev = vfio_device_data(vdev);
> > +	if (vpdev == NULL)
> > +		return PCI_ERS_RESULT_DISCONNECT;
> > +
> > +	if (vpdev->err_trigger)
> > +		eventfd_signal(vpdev->err_trigger, 1);
> > +
> > +	vfio_device_put_vdev(vdev);
> > +
> > +	return PCI_ERS_RESULT_CAN_RECOVER;
> > +}
> > +
> > +static const struct pci_error_handlers vfio_err_handlers = {
> > +	.error_detected = vfio_err_detected,
> > +};
> > +
> >  static struct pci_driver vfio_pci_driver = {
> >  	.name		= "vfio-pci",
> >  	.id_table	= NULL, /* only dynamic ids */
> >  	.probe		= vfio_pci_probe,
> >  	.remove		= vfio_pci_remove,
> > +	.err_handler	= &vfio_err_handlers,
> >  };
> >  
> >  static void __exit vfio_pci_cleanup(void)
> > diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> > index 3639371..f003e08 100644
> > --- a/drivers/vfio/pci/vfio_pci_intrs.c
> > +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> > @@ -745,6 +745,31 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
> >  	return 0;
> >  }
> >  
> > +static int vfio_pci_set_err_eventfd(struct vfio_pci_device *vdev,
> > +				    unsigned index, unsigned start,
> > +				    unsigned count, uint32_t flags, void *data)
> 
> 
> Rename to vfio_pci_set_err_trigger?  The other functions mostly only
> support eventfd too.
> 
> > +{
> > +	if ((index == VFIO_PCI_ERR_IRQ_INDEX) &&
> > +	    (flags & VFIO_IRQ_SET_DATA_EVENTFD)   &&
> > +	    pci_is_pcie(vdev->pdev)) {
> 
> It would clean up the indentation to have this be:
> 
>         if (!supported stuff)
>         	return -EINVAL;
>         
>         do stuff
> 
> Testing the index seems overly paranoid here given the caller.  The
> caller is also already testing pci_is_pcie.
> 
> Why not support DATA_NONE and DATA_BOOL?  It would be useful loopback
> testing for userspace to be able to trigger an AER notification.
> 
> > +
> > +		int32_t fd = *(int32_t *)data;
> > +
> > +		if (fd == -1) {
> > +			if (vdev->err_trigger)
> > +				eventfd_ctx_put(vdev->err_trigger);
> > +			vdev->err_trigger = NULL;
> > +			return 0;
> > +		} else if (fd >= 0) {
> > +			vdev->err_trigger = eventfd_ctx_fdget(fd);
> > +			if (IS_ERR(vdev->err_trigger))
> > +				return PTR_ERR(vdev->err_trigger);
> > +			return 0;
> > +		} else
> > +			return -EINVAL;
> > +	}
> > +	return -EINVAL;
> > +}
> >  int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
> >  			    unsigned index, unsigned start, unsigned count,
> >  			    void *data)
> > @@ -779,6 +804,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
> >  			break;
> >  		}
> >  		break;
> > +	case VFIO_PCI_ERR_IRQ_INDEX:
> > +		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> > +		case VFIO_IRQ_SET_ACTION_TRIGGER:
> > +			if (pci_is_pcie(vdev->pdev))
> > +				func = vfio_pci_set_err_eventfd;
> > +			break;
> > +		}
> >  	}
> >  
> >  	if (!func)
> > diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> > index 611827c..daee62f 100644
> > --- a/drivers/vfio/pci/vfio_pci_private.h
> > +++ b/drivers/vfio/pci/vfio_pci_private.h
> > @@ -55,6 +55,7 @@ struct vfio_pci_device {
> >  	bool			bardirty;
> >  	struct pci_saved_state	*pci_saved_state;
> >  	atomic_t		refcnt;
> > +	struct eventfd_ctx	*err_trigger;
> >  };
> >  
> >  #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 4758d1b..e81eb4d 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -147,6 +147,8 @@ struct vfio_device_info {
> >  	__u32	flags;
> >  #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
> >  #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
> > +#define VFIO_DEVICE_FLAGS_PCI_AER	(1 << 2) /* AER capable */
> > +#define VFIO_DEVICE_FLAGS_PCI_AER_NOTIFY (1 << 3) /* Supports aer notify */
> >
> >  	__u32	num_regions;	/* Max region index + 1 */
> >  	__u32	num_irqs;	/* Max IRQ index + 1 */
>                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This part of the vfio spec has been causing me trouble.  We discussed it
> a bit offline, but I'd appreciate any feedback from you or the broader
> community.  num_foo indicates a count, however the comment clearly
> states this is a max index.  With the VGA patches I've been playing with
> using them as a count where userspace would probe indexes until it finds
> num_foo implemented (ie. INFO_IRQ/REGION returns >=0).  I guess the
> original intention was was to probe up to num_foo-1 and unavailable
> indexes return <0.  Looking at it again, this seems like the more
> deterministic approach.  For instance, if we add LEGACY_IOPORT and
> LEGACY_MMIO regions at index 8 & 9, then ERR region at index 10, it's
> easier for userspace to know to stop searching at index 10 instead of
> probing indexes it may not understand trying to find the full count.
> Does that sound right?
> 
> So Vijay, please don't shot me for changing my mind, but I'm inclined to
> think you were probably right that DEVICE_INFO should just return
> num_irqs = VFIO_PCI_NUM_IRQS regardless of whether ERR_IRQ_INDEX is
> supported.  However IRQ_INFO should still return <0 if the device is not
> pcie.  It seems like this also means that we don't need flags indicating
> which indexes are present as that duplicates simply looking for them.
> 
> Which flags do we actually need then?  Should the AER flag be a device
> flag or is supporting AER error reporting a feature of
> VFIO_PCI_ERR_IRQ_INDEX and should therefore be reported as a flag there?
> So far REGION_INFO and IRQ_INFO flags only report capabilities of the
> item and not it's purpose, but so far all the regions and irqs have very
> fixed purposes.
> 
> I'm inclined to think that a LEGACY_IOPORT region reporting that it
> supports VGA IOPORT space 3b0 and 3c0 makes more sense than a general
> device VGA flag and inferring 3b0 & 3c0 based on the existence of a
> LEGACY_IOPORT region.
> 
> If we put flags on INFO_REGION and INFO_IRQ, where do they go?  We've
> got a u32 on each for flags.  We could split that and define bits >=16
> are for type specific flags and <16 are generic.  We could also define a
> generic flag indicating a type specific flag field is present.
> region_info already has a reserved u32 for alignment that could fill
> this roll, irq_info would need to add a field.  Perhaps something like:
> 
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -176,8 +176,9 @@ struct vfio_region_info {
>  #define VFIO_REGION_INFO_FLAG_READ     (1 << 0) /* Region supports read */
>  #define VFIO_REGION_INFO_FLAG_WRITE    (1 << 1) /* Region supports write */
>  #define VFIO_REGION_INFO_FLAG_MMAP     (1 << 2) /* Region supports mmap */
> +#define VFIO_REGION_INFO_TYPE_FLAGS    (1 << 3)
>         __u32   index;          /* Region index */
> -       __u32   resv;           /* Reserved for alignment */
> +       __u32   type_flags;     /* Type specific feature flags */
>         __u64   size;           /* Region size (bytes) */
>         __u64   offset;         /* Region offset from start of device fd */
>  };
> @@ -222,8 +223,10 @@ struct vfio_irq_info {
>  #define VFIO_IRQ_INFO_MASKABLE         (1 << 1)
>  #define VFIO_IRQ_INFO_AUTOMASKED       (1 << 2)
>  #define VFIO_IRQ_INFO_NORESIZE         (1 << 3)
> +#define VFIO_IRQ_INFO_TYPE_FLAGS       (1 << 4)
>         __u32   index;          /* IRQ index */
>         __u32   count;          /* Number of IRQs within this index */
> +       __u32   type_flags;     /* Type specific feature flags */
>  };
>  #define VFIO_DEVICE_GET_IRQ_INFO       _IO(VFIO_TYPE, VFIO_BASE + 9)
>  
> We'd then have something like
> 
> #define VFIO_PCI_ERR_IRQ_TYPE_AER	(1 << 0)
> 
> and
> 
> #define VFIO_PCI_LEGACY_IOPORT_REGION_TYPE_VGA_3b0	(1 << 0)
> #define VFIO_PCI_LEGACY_IOPORT_REGION_TYPE_VGA_3c0	(1 << 1)
> #define VFIO_PCI_LEGACY_MMIO_REGION_TYPE_VGA_a0000	(1 << 0)
> 
> #define VFIO_PCI_ERR_REGION_TYPE_AER	(1 << 0)

Hmm, maybe IRQs don't need a type_flag.  For VGA we're exposing a region
and describing implemented sections within the region.  For IRQs, we
have practically a limitless space.  Perhaps that means this IRQ should
just be PCI_AER_EVENT_IRQ and if ever we need a different error
reporting IRQ we'll add a new index.  This way we don't have to add a
new field to irq_info and try to unnecessarily generalize a single
index.

I'll need to think about VGA though, we have the same (practically)
limitless index range there as well, but in the kernel side
implementation we used fixed sized segments into the device fd to know
which region is being accessed.  This isn't visible to userspace, so
we're free to change it.  If we did that, we might expose the specific
regions as separate indexes rather than try to generalize them into
reusable "legacy" ranges.  Again, comments welcome.  Thanks,

Alex

> 
> What do you think?  It would be useful to prototype these with both AER
> and VGA before committing.  Thanks,
> 
> Alex
> 
> >  };
> > @@ -310,6 +312,7 @@ enum {
> >  	VFIO_PCI_INTX_IRQ_INDEX,
> >  	VFIO_PCI_MSI_IRQ_INDEX,
> >  	VFIO_PCI_MSIX_IRQ_INDEX,
> > +	VFIO_PCI_ERR_IRQ_INDEX,
> >  	VFIO_PCI_NUM_IRQS
> >  };
> >  
> 
> 



