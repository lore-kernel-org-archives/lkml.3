Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3BCQUm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:20:42 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:40599 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3BCQUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:20:39 -0500
MIME-Version: 1.0
In-Reply-To: <F9E001219150CB45BEDC82A650F360C9014AAF02@G9W0717.americas.hpqcorp.net>
References: <F9E001219150CB45BEDC82A650F360C9014AAF02@G9W0717.americas.hpqcorp.net>
From: Blue Swirl <blauwirbel@gmail.com>
Date: Sun, 3 Feb 2013 16:20:18 +0000
Message-ID: <CAAu8pHuEDvoA1rt7mddubuOAPsp79AA7u0NDxLNyO9sfWJX0+w@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] VFIO-AER: Vfio-pci driver changes for supporting AER
To: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Ortiz, Lance E" <lance.oritz@hp.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 3, 2013 at 2:10 PM, Pandarathil, Vijaymohan R
<vijaymohan.pandarathil@hp.com> wrote:
>         - New VFIO_SET_IRQ ioctl option to pass the eventfd that is signaled when
>           an error occurs in the vfio_pci_device
>
>         - Register pci_error_handler for the vfio_pci driver
>
>         - When the device encounters an error, the error handler registered by
>           the vfio_pci driver gets invoked by the AER infrastructure
>
>         - In the error handler, signal the eventfd registered for the device.
>
>         - This results in the qemu eventfd handler getting invoked and
>           appropriate action taken for the guest.
>
> Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
>  drivers/vfio/pci/vfio_pci.c         | 43 ++++++++++++++++++++++++++++++++++++-
>  drivers/vfio/pci/vfio_pci_intrs.c   | 30 ++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_private.h |  1 +
>  include/uapi/linux/vfio.h           |  1 +
>  4 files changed, 74 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index b28e66c..818b1ed 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -196,7 +196,9 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
>
>                         return (flags & PCI_MSIX_FLAGS_QSIZE) + 1;
>                 }
> -       }
> +       } else if (irq_type == VFIO_PCI_ERR_IRQ_INDEX)
> +               if (pci_is_pcie(vdev->pdev))
> +                       return 1;
>
>         return 0;
>  }
> @@ -302,6 +304,16 @@ static long vfio_pci_ioctl(void *device_data,
>                 if (info.argsz < minsz || info.index >= VFIO_PCI_NUM_IRQS)
>                         return -EINVAL;
>
> +               switch (info.index) {
> +               case VFIO_PCI_INTX_IRQ_INDEX ... VFIO_PCI_MSIX_IRQ_INDEX:
> +                       break;
> +               case VFIO_PCI_ERR_IRQ_INDEX:
> +                       if (pci_is_pcie(vdev->pdev))
> +                               break;

I don't know what is the policy in Linux kernel for this, but I'd add
a comment about fall through here.

> +               default:
> +                       return -EINVAL;
> +               }
> +
>                 info.flags = VFIO_IRQ_INFO_EVENTFD;
>
>                 info.count = vfio_pci_get_irq_count(vdev, info.index);
> @@ -538,11 +550,40 @@ static void vfio_pci_remove(struct pci_dev *pdev)
>         kfree(vdev);
>  }
>
> +static pci_ers_result_t vfio_pci_aer_err_detected(struct pci_dev *pdev,
> +                                                 pci_channel_state_t state)
> +{
> +       struct vfio_pci_device *vpdev;
> +       void *vdev;
> +
> +       vdev = vfio_device_get_from_dev(&pdev->dev);
> +       if (vdev == NULL)
> +               return PCI_ERS_RESULT_DISCONNECT;
> +
> +       vpdev = vfio_device_data(vdev);
> +       if (vpdev == NULL) {
> +               vfio_device_put(vdev);
> +               return PCI_ERS_RESULT_DISCONNECT;
> +       }
> +
> +       if (vpdev->err_trigger)
> +               eventfd_signal(vpdev->err_trigger, 1);
> +
> +       vfio_device_put(vdev);
> +
> +       return PCI_ERS_RESULT_CAN_RECOVER;
> +}
> +
> +static struct pci_error_handlers vfio_err_handlers = {
> +       .error_detected = vfio_pci_aer_err_detected,
> +};
> +
>  static struct pci_driver vfio_pci_driver = {
>         .name           = "vfio-pci",
>         .id_table       = NULL, /* only dynamic ids */
>         .probe          = vfio_pci_probe,
>         .remove         = vfio_pci_remove,
> +       .err_handler    = &vfio_err_handlers,
>  };
>
>  static void __exit vfio_pci_cleanup(void)
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 3639371..83035b1 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -745,6 +745,29 @@ static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
>         return 0;
>  }
>
> +static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
> +                                   unsigned index, unsigned start,
> +                                   unsigned count, uint32_t flags, void *data)
> +{
> +       int32_t fd = *(int32_t *)data;
> +
> +       if ((index != VFIO_PCI_ERR_IRQ_INDEX) ||
> +           !(flags & VFIO_IRQ_SET_DATA_EVENTFD))
> +               return -EINVAL;
> +
> +       if (fd == -1) {
> +               if (vdev->err_trigger)
> +                       eventfd_ctx_put(vdev->err_trigger);
> +               vdev->err_trigger = NULL;
> +               return 0;
> +       } else if (fd >= 0) {
> +               vdev->err_trigger = eventfd_ctx_fdget(fd);
> +               if (IS_ERR(vdev->err_trigger))
> +                       return PTR_ERR(vdev->err_trigger);
> +               return 0;
> +       } else
> +               return -EINVAL;
> +}
>  int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
>                             unsigned index, unsigned start, unsigned count,
>                             void *data)
> @@ -779,6 +802,13 @@ int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
>                         break;
>                 }
>                 break;
> +       case VFIO_PCI_ERR_IRQ_INDEX:
> +               switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
> +               case VFIO_IRQ_SET_ACTION_TRIGGER:
> +                       if (pci_is_pcie(vdev->pdev))
> +                               func = vfio_pci_set_err_trigger;
> +                       break;
> +               }
>         }
>
>         if (!func)
> diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> index 611827c..daee62f 100644
> --- a/drivers/vfio/pci/vfio_pci_private.h
> +++ b/drivers/vfio/pci/vfio_pci_private.h
> @@ -55,6 +55,7 @@ struct vfio_pci_device {
>         bool                    bardirty;
>         struct pci_saved_state  *pci_saved_state;
>         atomic_t                refcnt;
> +       struct eventfd_ctx      *err_trigger;
>  };
>
>  #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 4758d1b..7d50af4 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -310,6 +310,7 @@ enum {
>         VFIO_PCI_INTX_IRQ_INDEX,
>         VFIO_PCI_MSI_IRQ_INDEX,
>         VFIO_PCI_MSIX_IRQ_INDEX,
> +       VFIO_PCI_ERR_IRQ_INDEX,
>         VFIO_PCI_NUM_IRQS
>  };
>
> --
> 1.7.11.3
>
