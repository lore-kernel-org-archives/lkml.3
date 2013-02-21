Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739Ab3BYVa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:30:27 -0500
Received: from ozlabs.org ([203.10.76.45]:45987 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757943Ab3BYVaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:30:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Milos Vyletel <milos.vyletel@sde.cz>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, mst@redhat.com,
        Milos Vyletel <milos.vyletel@sde.cz>, "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] virtio-blk: emit udev event when device is resized
In-Reply-To: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz>
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 22 Feb 2013 10:14:49 +1030
Message-ID: <87y5ehfczy.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milos Vyletel <milos.vyletel@sde.cz> writes:

> When virtio-blk device is resized from host (using block_resize from QEMU) emit
> KOBJ_CHANGE uevent to notify guest about such change. This allows user to have
> custom udev rules which would take whatever action if such event occurs. As a
> proof of concept I've created simple udev rule that automatically resize
> filesystem on virtio-blk device.
>
> ACTION=="change", KERNEL=="vd*", \
>         ENV{RESIZE}=="1", \
>         ENV{ID_FS_TYPE}=="ext[3-4]", \
>         RUN+="/sbin/resize2fs /dev/%k"
> ACTION=="change", KERNEL=="vd*", \
>         ENV{RESIZE}=="1", \
>         ENV{ID_FS_TYPE}=="LVM2_member", \
>         RUN+="/sbin/pvresize /dev/%k"

This looks fine to me, but I like to check with Greg before adding udev
callouts.... Greg?

BTW, if this is good, it's good for stable IMHO.

Cheers,
Rusty.

> Signed-off-by: Milos Vyletel <milos.vyletel@sde.cz>
> ---
>  drivers/block/virtio_blk.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 8ad21a2..5990382 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -539,6 +539,8 @@ static void virtblk_config_changed_work(struct work_struct *work)
>  	struct virtio_device *vdev = vblk->vdev;
>  	struct request_queue *q = vblk->disk->queue;
>  	char cap_str_2[10], cap_str_10[10];
> +	char event[] = "RESIZE=1";
> +	char *envp[] = { event, NULL };
>  	u64 capacity, size;
>  
>  	mutex_lock(&vblk->config_lock);
> @@ -568,6 +570,7 @@ static void virtblk_config_changed_work(struct work_struct *work)
>  
>  	set_capacity(vblk->disk, capacity);
>  	revalidate_disk(vblk->disk);
> +	kobject_uevent_env(&disk_to_dev(vblk->disk)->kobj, KOBJ_CHANGE, envp);
>  done:
>  	mutex_unlock(&vblk->config_lock);
>  }
> -- 
> 1.7.1
