Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaAOULH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 15:11:07 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:65020 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaAOULB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 15:11:01 -0500
MIME-Version: 1.0
In-Reply-To: <20140115033854.18253.62934.stgit@bling.home>
References: <20140115033854.18253.62934.stgit@bling.home>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 15 Jan 2014 13:10:39 -0700
Message-ID: <CAErSpo5545u1pHoDnAs-F=xgdLYs+xu_XtSixDi1+UcGj2zPVg@mail.gmail.com>
Subject: Re: [PATCH v2] vfio-pci: Use pci "try" reset interface
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 8:45 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> PCI resets will attempt to take the device_lock for any device to be
> reset.  This is a problem if that lock is already held, for instance
> in the device remove path.  It's not sufficient to simply kill the
> user process or skip the reset if called after .remove as a race could
> result in the same deadlock.  Instead, we handle all resets as "best
> effort" using the PCI "try" reset interfaces.  This prevents the user
> from being able to induce a deadlock by triggering a reset.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>
> v2: Update error message to make it clear that device reset failed
>     and change back to pr_warn to make sure it's visible.  I'll
>     address whether dev_warn would be more appropriate in future
>     updates.
>
> Bjorn, if this looks good and you don't mind, please take this in
> through your tree so that it syncs with the introduction of the
> pci_try_reset interfaces.  Thanks!

I applied this to pci/reset (along with the try_reset implementation)
and pushed it to my "next" branch, thanks!

>  drivers/vfio/pci/vfio_pci.c |   29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 6ab71b9..2319d20 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -139,25 +139,14 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
>         pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
>
>         /*
> -        * Careful, device_lock may already be held.  This is the case if
> -        * a driver unbind is blocked.  Try to get the locks ourselves to
> -        * prevent a deadlock.
> +        * Try to reset the device.  The success of this is dependent on
> +        * being able to lock the device, which is not always possible.
>          */
>         if (vdev->reset_works) {
> -               bool reset_done = false;
> -
> -               if (pci_cfg_access_trylock(pdev)) {
> -                       if (device_trylock(&pdev->dev)) {
> -                               __pci_reset_function_locked(pdev);
> -                               reset_done = true;
> -                               device_unlock(&pdev->dev);
> -                       }
> -                       pci_cfg_access_unlock(pdev);
> -               }
> -
> -               if (!reset_done)
> -                       pr_warn("%s: Unable to acquire locks for reset of %s\n",
> -                               __func__, dev_name(&pdev->dev));
> +               int ret = pci_try_reset_function(pdev);
> +               if (ret)
> +                       pr_warn("%s: Failed to reset device %s (%d)\n",
> +                               __func__, dev_name(&pdev->dev), ret);
>         }
>
>         pci_restore_state(pdev);
> @@ -514,7 +503,7 @@ static long vfio_pci_ioctl(void *device_data,
>
>         } else if (cmd == VFIO_DEVICE_RESET) {
>                 return vdev->reset_works ?
> -                       pci_reset_function(vdev->pdev) : -EINVAL;
> +                       pci_try_reset_function(vdev->pdev) : -EINVAL;
>
>         } else if (cmd == VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) {
>                 struct vfio_pci_hot_reset_info hdr;
> @@ -684,8 +673,8 @@ reset_info_exit:
>                                                     &info, slot);
>                 if (!ret)
>                         /* User has access, do the reset */
> -                       ret = slot ? pci_reset_slot(vdev->pdev->slot) :
> -                                    pci_reset_bus(vdev->pdev->bus);
> +                       ret = slot ? pci_try_reset_slot(vdev->pdev->slot) :
> +                                    pci_try_reset_bus(vdev->pdev->bus);
>
>  hot_reset_release:
>                 for (i--; i >= 0; i--)
>
