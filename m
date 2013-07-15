Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab3GOVvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 17:51:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104Ab3GOVvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 17:51:12 -0400
Message-ID: <1373925066.8441.272.camel@ul30vt.home>
Subject: Re: [Qemu-devel] [PATCH] QEMU-AER: Qemu changes to support AER for
 VFIO-PCI devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
Cc: gleb@redhat.com, bhelgaas@google.com, blauwirbel@gmail.com,
        lance.oritz@hp.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Jul 2013 15:51:06 -0600
In-Reply-To: <1373788124-64423-1-git-send-email-vijaymohan.pandarathil@hp.com>
References: <1373788124-64423-1-git-send-email-vijaymohan.pandarathil@hp.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-07-14 at 01:48 -0600, Vijay Mohan Pandarathil wrote:
> Add support for error containment when a VFIO device assigned to a KVM
> guest encounters an error. This is for PCIe devices/drivers that support AER
> functionality. When the host OS is notified of an error in a device either
> through the firmware first approach or through an interrupt handled by the AER
> root port driver, the error handler registered by the vfio-pci driver gets
> invoked. The qemu process is signaled through an eventfd registered per
> VFIO device by the qemu process. In the eventfd handler, qemu decides on
> what action to take. In this implementation, guest is brought down to
> contain the error.
> 
> The kernel patches for the above functionality has been already accepted.
> 
> This is a refresh of the QEMU patch which was reviewed earlier. 
> http://marc.info/?l=linux-kernel&m=136281557608087&w=2
> This patch has the same contents and has been built after refreshing 
> to latest upstream and after the linux headers have been updated in qemu.
> 
> 	- Create eventfd per vfio device assigned to a guest and register an
>           event handler
> 
> 	- This fd is passed to the vfio_pci driver through the SET_IRQ ioctl
> 
> 	- When the device encounters an error, the eventfd is signalled
>           and the qemu eventfd handler gets invoked.
> 
> 	- In the handler decide what action to take. Current action taken
>           is to stop the guest.
> 
> Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
> ---
>  hw/misc/vfio.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 123 insertions(+)

Applied.  Thanks,

Alex

> diff --git a/hw/misc/vfio.c b/hw/misc/vfio.c
> index 540c377..414c999 100644
> --- a/hw/misc/vfio.c
> +++ b/hw/misc/vfio.c
> @@ -158,6 +158,7 @@ typedef struct VFIODevice {
>      PCIHostDeviceAddress host;
>      QLIST_ENTRY(VFIODevice) next;
>      struct VFIOGroup *group;
> +    EventNotifier err_notifier;
>      uint32_t features;
>  #define VFIO_FEATURE_ENABLE_VGA_BIT 0
>  #define VFIO_FEATURE_ENABLE_VGA (1 << VFIO_FEATURE_ENABLE_VGA_BIT)
> @@ -165,6 +166,7 @@ typedef struct VFIODevice {
>      uint8_t pm_cap;
>      bool reset_works;
>      bool has_vga;
> +    bool pci_aer;
>  } VFIODevice;
>  
>  typedef struct VFIOGroup {
> @@ -2781,6 +2783,7 @@ static int vfio_get_device(VFIOGroup *group, const char *name, VFIODevice *vdev)
>  {
>      struct vfio_device_info dev_info = { .argsz = sizeof(dev_info) };
>      struct vfio_region_info reg_info = { .argsz = sizeof(reg_info) };
> +    struct vfio_irq_info irq_info = { .argsz = sizeof(irq_info) };
>      int ret, i;
>  
>      ret = ioctl(group->fd, VFIO_GROUP_GET_DEVICE_FD, name);
> @@ -2924,6 +2927,18 @@ static int vfio_get_device(VFIOGroup *group, const char *name, VFIODevice *vdev)
>  
>          vdev->has_vga = true;
>      }
> +    irq_info.index = VFIO_PCI_ERR_IRQ_INDEX;
> +
> +    ret = ioctl(vdev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
> +    if (ret) {
> +        /* This can fail for an old kernel or legacy PCI dev */
> +        DPRINTF("VFIO_DEVICE_GET_IRQ_INFO failure ret=%d\n", ret);
> +        ret = 0;
> +    } else if (irq_info.count == 1) {
> +        vdev->pci_aer = true;
> +    } else {
> +        error_report("vfio: Warning: Could not enable error recovery for the device\n");
> +    }
>  
>  error:
>      if (ret) {
> @@ -2946,6 +2961,112 @@ static void vfio_put_device(VFIODevice *vdev)
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
> +     * exposed to the guest. For now, we just terminate the
> +     * guest to contain the error.
> +     */
> +
> +    error_report("%s (%04x:%02x:%02x.%x)"
> +        "Unrecoverable error detected...\n"
> +        "Please collect any data possible and then kill the guest",
> +        __func__, vdev->host.domain, vdev->host.bus,
> +        vdev->host.slot, vdev->host.function);
> +
> +    vm_stop(RUN_STATE_IO_ERROR);
> +}
> +
> +/*
> + * Registers error notifier for devices supporting error recovery.
> + * If we encounter a failure in this function, we report an error
> + * and continue after disabling error recovery support for the
> + * device.
> + */
> +static void vfio_register_err_notifier(VFIODevice *vdev)
> +{
> +    int ret;
> +    int argsz;
> +    struct vfio_irq_set *irq_set;
> +    int32_t *pfd;
> +
> +    if (!vdev->pci_aer) {
> +        return;
> +    }
> +
> +    if (event_notifier_init(&vdev->err_notifier, 0)) {
> +        error_report("vfio: Warning: Unable to init event notifier for error detection\n");
> +        vdev->pci_aer = false;
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
> +        error_report("vfio: Failed to set up error notification\n");
> +        qemu_set_fd_handler(*pfd, NULL, NULL, vdev);
> +        event_notifier_cleanup(&vdev->err_notifier);
> +        vdev->pci_aer = false;
> +    }
> +    g_free(irq_set);
> +}
> +
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
> +        error_report("vfio: Failed to de-assign error fd: %d\n", ret);
> +    }
> +    g_free(irq_set);
> +    qemu_set_fd_handler(event_notifier_get_fd(&vdev->err_notifier),
> +                        NULL, NULL, vdev);
> +    event_notifier_cleanup(&vdev->err_notifier);
> +}
> +
>  static int vfio_initfn(PCIDevice *pdev)
>  {
>      VFIODevice *pvdev, *vdev = DO_UPCAST(VFIODevice, pdev, pdev);
> @@ -3078,6 +3199,7 @@ static int vfio_initfn(PCIDevice *pdev)
>      }
>  
>      add_boot_device_path(vdev->bootindex, &pdev->qdev, NULL);
> +    vfio_register_err_notifier(vdev);
>  
>      return 0;
>  
> @@ -3097,6 +3219,7 @@ static void vfio_exitfn(PCIDevice *pdev)
>      VFIODevice *vdev = DO_UPCAST(VFIODevice, pdev, pdev);
>      VFIOGroup *group = vdev->group;
>  
> +    vfio_unregister_err_notifier(vdev);
>      pci_device_set_intx_routing_notifier(&vdev->pdev, NULL);
>      vfio_disable_interrupts(vdev);
>      if (vdev->intx.mmap_timer) {



