Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbbADLMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 06:12:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbbADLMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 06:12:50 -0500
Date: Sun, 4 Jan 2015 13:12:40 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "open list:VIRTIO CORE, NET..." 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 1/2] virtio_pci: double free and invalid memory access of
 device vqs
Message-ID: <20150104111240.GA4336@redhat.com>
References: <1420228060-18721-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420228060-18721-1-git-send-email-sasha.levin@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 02:47:39PM -0500, Sasha Levin wrote:
> Device VQs were getting freed twice: once in every devices removal functions,
> and then again in virtio_pci_legacy_remove().
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

I see.  This used to be harmless because it used to be idempotent,
and safe to call any number of times.

I think your patch is right for 3.20:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

but for 3.19 I'd prefer a more conservative approach of making
del_vqs idempotent again.

I'll post a patch like this shortly.


> ---
>  drivers/virtio/virtio_pci_legacy.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
> index 6c76f0f..913ca23 100644
> --- a/drivers/virtio/virtio_pci_legacy.c
> +++ b/drivers/virtio/virtio_pci_legacy.c
> @@ -298,7 +298,6 @@ void virtio_pci_legacy_remove(struct pci_dev *pci_dev)
>  
>  	unregister_virtio_device(&vp_dev->vdev);
>  
> -	vp_del_vqs(&vp_dev->vdev);
>  	pci_iounmap(pci_dev, vp_dev->ioaddr);
>  	pci_release_regions(pci_dev);
>  	pci_disable_device(pci_dev);
> -- 
> 1.7.10.4
