Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaKILwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 06:52:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789AbaKILwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 06:52:31 -0500
Date: Sun, 9 Nov 2014 13:52:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Fam Zheng <famz@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Jason Wang <jasowang@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] virtio-pci: Reset device on shutdown
Message-ID: <20141109115222.GA6831@redhat.com>
References: <1415525945-7324-1-git-send-email-famz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415525945-7324-1-git-send-email-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 05:39:05PM +0800, Fam Zheng wrote:
> This fixes a hanging issue during guest shutdown.
> 
> The device is left enabled even though we removed it and disabled msix
> during shutdown. If the virtio device happens to get a new event right
> at this point, seeing msix is disabled, it may try to notify us with an
> IRQ, which is totally unexpected thus will not be handled. In this
> case the guest hangs.
> 
> Let's reset the device so that it will not generate any interrupts.
> 
> Link: https://bugzilla.redhat.com/show_bug.cgi?id=1128424
> Cc: Ulrich Obergfell <uobergfe@redhat.com>
> Signed-off-by: Fam Zheng <famz@redhat.com>

This needs some careful thought.

vp_reset isn't safe unless there's a guarantee that
nothing is accessing the device at the same time,
which normally needs coordination with the function-specific
driver.

For example, for virtio net, you will notice that on remove path we
do unregister_netdev before reset for this reason.

What guarantees it in this case?


> ---
>  drivers/virtio/virtio_pci.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> index d34ebfa..cd7be6f 100644
> --- a/drivers/virtio/virtio_pci.c
> +++ b/drivers/virtio/virtio_pci.c
> @@ -743,6 +743,14 @@ out:
>  	return err;
>  }
>  
> +static void virtio_pci_shutdown(struct pci_dev *pci_dev)
> +{
> +	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
> +
> +	vp_reset(&vp_dev->vdev);
> +}
> +
> +
>  static void virtio_pci_remove(struct pci_dev *pci_dev)
>  {
>  	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
> @@ -794,6 +802,7 @@ static struct pci_driver virtio_pci_driver = {
>  	.id_table	= virtio_pci_id_table,
>  	.probe		= virtio_pci_probe,
>  	.remove		= virtio_pci_remove,
> +	.shutdown	= virtio_pci_shutdown,
>  #ifdef CONFIG_PM_SLEEP
>  	.driver.pm	= &virtio_pci_pm_ops,
>  #endif
> -- 
> 1.9.3
