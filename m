Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513Ab3BYHo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 02:44:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab3BYHoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 02:44:24 -0500
Message-ID: <512B1637.5060107@redhat.com>
Date: Mon, 25 Feb 2013 15:43:51 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Milos Vyletel <milos.vyletel@sde.cz>
CC: linux-kernel@vger.kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-blk: emit udev event when device is resized
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz>
In-Reply-To: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 03:02 AM, Milos Vyletel wrote:
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
> 
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

event is not used again. Why not just

char *envp[] = { "RESIZE=1", NULL };


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
> 

I tried the following with your automatically resize udev rules.

(qemu) block_resize vd0 500
Check the fs size in guest, it is 500Mb

(qemu) block_resize vd0 1200
Check the fs size in guest, it is still 500Mb

Can you try resizing multiple times? Does it work?

-- 
Asias
