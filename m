Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaIWQGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:06:08 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37345 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbaIWQGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:06:05 -0400
MIME-Version: 1.0
In-Reply-To: <1411468217-18130-1-git-send-email-mst@redhat.com>
References: <1411468217-18130-1-git-send-email-mst@redhat.com>
Date: Tue, 23 Sep 2014 09:06:03 -0700
Message-ID: <CAG7+5M3=5cNQWH53i7qXLH0tm4qJEgu+_HCDpmAKF3P3knJHHQ@mail.gmail.com>
Subject: Re: [PATCH RFC] virtio_pci: fix virtio spec compliance on restore
From: Eric Northup <digitaleric@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>, stable@vger.kernel.org,
        lf-virt <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 3:32 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On restore, virtio pci does the following:
> + set features
> + init vqs etc - device can be used at this point!
> + set ACKNOWLEDGE,DRIVER and DRIVER_OK status bits
>
> This is in violation of the virtio spec, which
> requires the following order:
> - ACKNOWLEDGE
> - DRIVER
> - init vqs
> - DRIVER_OK
>
> Cc: stable@vger.kernel.org
> Cc: Amit Shah <amit.shah@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Lightly tested.
> Will repost as non-RFC once testing is done, sending
> out now for early flames/comments.
>
> Thanks!
>
>  drivers/virtio/virtio_pci.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index 58f7e45..58cbf6e 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -785,6 +785,7 @@ static int virtio_pci_restore(struct device *dev)
>         struct pci_dev *pci_dev = to_pci_dev(dev);
>         struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
>         struct virtio_driver *drv;
> +       unsigned status = 0;
>         int ret;
>
>         drv = container_of(vp_dev->vdev.dev.driver,
> @@ -795,14 +796,41 @@ static int virtio_pci_restore(struct device *dev)
>                 return ret;
>
>         pci_set_master(pci_dev);
> +       /* We always start by resetting the device, in case a previous
> +        * driver messed it up. */
> +       vp_reset(&vp_dev->vdev);

This should happen before enabling PCI bus mastering.

> +
> +       /* Acknowledge that we've seen the device. */
> +       status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
> +       vp_set_status(&vp_dev->vdev, status);
> +
> +       /* Maybe driver failed before freeze.
> +        * Restore the failed status, for debugging. */
> +       status |= vp_dev->saved_status & VIRTIO_CONFIG_S_FAILED;
> +       vp_set_status(&vp_dev->vdev, status);
> +
> +       if (!drv)
> +               return 0;
> +
> +       /* We have a driver! */
> +       status |= VIRTIO_CONFIG_S_DRIVER;
> +       vp_set_status(&vp_dev->vdev, status);
> +
>         vp_finalize_features(&vp_dev->vdev);
>
> -       if (drv && drv->restore)
> -               ret = drv->restore(&vp_dev->vdev);
> +       if (!drv->restore)
> +               return 0;
> +
> +       ret = drv->restore(&vp_dev->vdev);
> +       if (ret) {
> +               status |= VIRTIO_CONFIG_S_FAILED;
> +               vp_set_status(&vp_dev->vdev, status);
> +               return ret;
> +       }
>
>         /* Finally, tell the device we're all set */
> -       if (!ret)
> -               vp_set_status(&vp_dev->vdev, vp_dev->saved_status);
> +       status |= VIRTIO_CONFIG_S_DRIVER_OK;
> +       vp_set_status(&vp_dev->vdev, status);
>
>         return ret;
>  }
> --
> MST
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
