Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab3BDQ5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:57:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab3BDQ5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:57:53 -0500
Message-ID: <1359997059.11144.446.camel@bling.home>
Subject: Re: [PATCH v3 3/3] QEMU-AER: Qemu changes to support AER for
 VFIO-PCI devices
From: Alex Williamson <alex.williamson@redhat.com>
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Blue Swirl <blauwirbel@gmail.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Feb 2013 09:57:39 -0700
In-Reply-To: <F9E001219150CB45BEDC82A650F360C9014AAF07@G9W0717.americas.hpqcorp.net>
References: <F9E001219150CB45BEDC82A650F360C9014AAF07@G9W0717.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-02-03 at 14:10 +0000, Pandarathil, Vijaymohan R wrote:
> 	- Create eventfd per vfio device assigned to a guest and register an
>           event handler
> 
> 	- This fd is passed to the vfio_pci driver through the SET_IRQ ioctl
> 
> 	- When the device encounters an error, the eventfd is signalled
>           and the qemu eventfd handler gets invoked.
> 
> 	- In the handler decide what action to take. Current action taken
>           is to terminate the guest.
> 
> Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
>  hw/vfio_pci.c              | 105 +++++++++++++++++++++++++++++++++++++++++++++
>  linux-headers/linux/vfio.h |   1 +
>  2 files changed, 106 insertions(+)
> 
> diff --git a/hw/vfio_pci.c b/hw/vfio_pci.c
> index c51ae67..4e2f768 100644
> --- a/hw/vfio_pci.c
> +++ b/hw/vfio_pci.c
> @@ -130,6 +130,8 @@ typedef struct VFIODevice {
>      QLIST_ENTRY(VFIODevice) next;
>      struct VFIOGroup *group;
>      bool reset_works;
> +    EventNotifier err_notifier;
> +    bool pci_aer;

Re-order these for alignment please.  ie:

    struct VFIOGroup *group;
    EventNotifier err_notifier;
    bool reset_works;
    bool pci_aer;

>  } VFIODevice;
>  
>  typedef struct VFIOGroup {
> @@ -1922,6 +1924,106 @@ static void vfio_put_device(VFIODevice *vdev)
>      }
>  }
>  
> +static void vfio_err_notifier_handler(void *opaque)
> +{
> +    VFIODevice *vdev = opaque;
> +
> +    if (!event_notifier_test_and_clear(&vdev->err_notifier)) {
> +        return;
> +    }
> +
> +    /*
> +     * TBD. Retrieve the error details and decide what action
> +     * needs to be taken. One of the actions could be to pass
> +     * the error to the guest and have the guest driver recover
> +     * from the error. This requires that PCIe capabilities be
> +     * exposed to the guest. At present, we just terminate the
> +     * guest to contain the error.
> +     */
> +
> +    error_report("%s (%04x:%02x:%02x.%x)"
> +        "Unrecoverable error detected... Terminating guest\n",
> +        __func__, vdev->host.domain, vdev->host.bus,
> +        vdev->host.slot, vdev->host.function);
> +
> +    hw_error("(%04x:%02x:%02x.%x) Unrecoverable device error\n",
> +        vdev->host.domain, vdev->host.bus,
> +        vdev->host.slot, vdev->host.function);
> +
> +    return;

As Blue Swirl mentions, these returns at the end of void functions are
unnecessary.

> +}
> +
> +static void vfio_register_err_notifier(VFIODevice *vdev)
> +{
> +    int ret;
> +    int argsz;
> +    struct vfio_irq_set *irq_set;
> +    int32_t *pfd;
> +
> +    if (event_notifier_init(&vdev->err_notifier, 0)) {
> +        error_report("vfio: Warning: Unable to init event notifier for error detection\n");
> +        return;
> +    }
> +
> +    argsz = sizeof(*irq_set) + sizeof(*pfd);
> +
> +    irq_set = g_malloc0(argsz);
> +    irq_set->argsz = argsz;
> +    irq_set->flags = VFIO_IRQ_SET_DATA_EVENTFD |
> +                     VFIO_IRQ_SET_ACTION_TRIGGER;
> +    irq_set->index = VFIO_PCI_ERR_IRQ_INDEX;
> +    irq_set->start = 0;
> +    irq_set->count = 1;
> +    pfd = (int32_t *)&irq_set->data;
> +
> +    *pfd = event_notifier_get_fd(&vdev->err_notifier);
> +    qemu_set_fd_handler(*pfd, vfio_err_notifier_handler, NULL, vdev);
> +
> +    ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, irq_set);
> +    if (ret) {
> +        DPRINTF("vfio: Error notification not supported for the device\n");

We should know this already though, right?  Where's our call to
VFIO_DEVICE_GET_IRQ_INFO for this index?  I'd expect that should happen
in vfio_get_device where it can set some flag true, then this function
would exit immediately if that flag isn't set.  Then by the time we're
here, it's a legitimate error_report if we think this should work and
doesn't.

> +        qemu_set_fd_handler(*pfd, NULL, NULL, vdev);
> +        event_notifier_cleanup(&vdev->err_notifier);
> +        g_free(irq_set);
> +        return;
> +    }
> +    g_free(irq_set);
> +    vdev->pci_aer = 1;

bool, so set to true or false.

> +    return;
> +}
> +static void vfio_unregister_err_notifier(VFIODevice *vdev)
> +{
> +    int argsz;
> +    struct vfio_irq_set *irq_set;
> +    int32_t *pfd;
> +    int ret;
> +
> +    if (!vdev->pci_aer) {
> +        return;
> +    }
> +
> +    argsz = sizeof(*irq_set) + sizeof(*pfd);
> +
> +    irq_set = g_malloc0(argsz);
> +    irq_set->argsz = argsz;
> +    irq_set->flags = VFIO_IRQ_SET_DATA_EVENTFD |
> +                     VFIO_IRQ_SET_ACTION_TRIGGER;
> +    irq_set->index = VFIO_PCI_ERR_IRQ_INDEX;
> +    irq_set->start = 0;
> +    irq_set->count = 1;
> +    pfd = (int32_t *)&irq_set->data;
> +    *pfd = -1;
> +
> +    ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, irq_set);
> +    if (ret) {
> +        DPRINTF("vfio: Failed to de-assign error fd: %d\n", ret);

This is also a legitimate error_report.  In general, if kernel vfio-pci
does or doesn't support a non-critical feature, that's a DPRINTF.  If
it's told us the feature is there and something doesn't work while
setting it up, that's an error_report.  Thanks,

Alex

> +    }
> +    g_free(irq_set);
> +    qemu_set_fd_handler(event_notifier_get_fd(&vdev->err_notifier),
> +                        NULL, NULL, vdev);
> +    event_notifier_cleanup(&vdev->err_notifier);
> +    return;
> +}
>  static int vfio_initfn(PCIDevice *pdev)
>  {
>      VFIODevice *pvdev, *vdev = DO_UPCAST(VFIODevice, pdev, pdev);
> @@ -2032,6 +2134,8 @@ static int vfio_initfn(PCIDevice *pdev)
>          }
>      }
>  
> +    vfio_register_err_notifier(vdev);
> +
>      return 0;
>  
>  out_teardown:
> @@ -2049,6 +2153,7 @@ static void vfio_exitfn(PCIDevice *pdev)
>      VFIODevice *vdev = DO_UPCAST(VFIODevice, pdev, pdev);
>      VFIOGroup *group = vdev->group;
>  
> +    vfio_unregister_err_notifier(vdev);
>      pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
>      vfio_disable_interrupts(vdev);
>      if (vdev->intx.mmap_timer) {
> diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
> index f787b72..6b20849 100644
> --- a/linux-headers/linux/vfio.h
> +++ b/linux-headers/linux/vfio.h
> @@ -310,6 +310,7 @@ enum {
>  	VFIO_PCI_INTX_IRQ_INDEX,
>  	VFIO_PCI_MSI_IRQ_INDEX,
>  	VFIO_PCI_MSIX_IRQ_INDEX,
> +	VFIO_PCI_ERR_IRQ_INDEX,
>  	VFIO_PCI_NUM_IRQS
>  };
>  



