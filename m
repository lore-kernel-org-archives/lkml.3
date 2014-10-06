Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbaJFLml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:42:41 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:50831 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaJFLmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:42:39 -0400
Date: Mon, 6 Oct 2014 13:42:29 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 06/16] virtio_blk: drop config_enable
Message-ID: <20141006134229.45465bf7.cornelia.huck@de.ibm.com>
In-Reply-To: <1412525038-15871-7-git-send-email-mst@redhat.com>
References: <1412525038-15871-1-git-send-email-mst@redhat.com>
	<1412525038-15871-7-git-send-email-mst@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100611-2966-0000-0000-0000015CBB45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2014 19:07:07 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Now that virtio core ensures config changes don't
> arrive during probing, drop config_enable flag
> in virtio blk.
> On removal, flush is now sufficient to guarantee that
> no change work is queued.
> 
> This help simplify the driver, and will allow
> setting DRIVER_OK earlier without losing config
> change notifications.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/block/virtio_blk.c | 19 ++-----------------
>  1 file changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 0a58140..c8cf6a1 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c

> @@ -772,9 +766,7 @@ static void virtblk_remove(struct virtio_device *vdev)
>  	int refc;
> 
>  	/* Prevent config work handler from accessing the device. */

/* Common code ensures no further work will be queued. */

instead?

> -	mutex_lock(&vblk->config_lock);
> -	vblk->config_enable = false;
> -	mutex_unlock(&vblk->config_lock);
> +	flush_work(&vblk->config_work);
> 
>  	del_gendisk(vblk->disk);
>  	blk_cleanup_queue(vblk->disk->queue);

> @@ -806,10 +796,6 @@ static int virtblk_freeze(struct virtio_device *vdev)
>  	vdev->config->reset(vdev);
> 
>  	/* Prevent config work handler from accessing the device. */

dito on the comment

> -	mutex_lock(&vblk->config_lock);
> -	vblk->config_enable = false;
> -	mutex_unlock(&vblk->config_lock);
> -
>  	flush_work(&vblk->config_work);
> 
>  	blk_mq_stop_hw_queues(vblk->disk->queue);

