Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639Ab3BYOzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:55:25 -0500
Received: from mail4.sde.cz ([85.93.125.197]:41162 "EHLO zimbra.sde"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759541Ab3BYOzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:55:21 -0500
Date: Mon, 25 Feb 2013 15:54:56 +0100 (CET)
From: Milos Vyletel <milos.vyletel@sde.cz>
To: Asias He <asias@redhat.com>
Cc: linux-kernel@vger.kernel.org, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Message-ID: <2042715078.26369.1361804096841.JavaMail.root@sde.cz>
In-Reply-To: <512B1637.5060107@redhat.com>
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz> <512B1637.5060107@redhat.com>
Subject: Re: [PATCH] virtio-blk: emit udev event when device is resized
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [199.72.20.10]
X-Mailer: Zimbra 8.0.2_GA_5569 (ZimbraWebClient - FF16 (Win)/8.0.2_GA_5569)
Thread-Topic: virtio-blk: emit udev event when device is resized
Thread-Index: l+tZXbJ3KAsIhlpQ/yFFZvZIRcxm/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On 02/22/2013 03:02 AM, Milos Vyletel wrote:
> > When virtio-blk device is resized from host (using block_resize from QEMU)
> > emit
> > KOBJ_CHANGE uevent to notify guest about such change. This allows user to
> > have
> > custom udev rules which would take whatever action if such event occurs. As
> > a
> > proof of concept I've created simple udev rule that automatically resize
> > filesystem on virtio-blk device.
> > 
> > ACTION=="change", KERNEL=="vd*", \
> >         ENV{RESIZE}=="1", \
> >         ENV{ID_FS_TYPE}=="ext[3-4]", \
> >         RUN+="/sbin/resize2fs /dev/%k"
> > ACTION=="change", KERNEL=="vd*", \
> >         ENV{RESIZE}=="1", \
> >         ENV{ID_FS_TYPE}=="LVM2_member", \
> >         RUN+="/sbin/pvresize /dev/%k"
> > 
> > Signed-off-by: Milos Vyletel <milos.vyletel@sde.cz>
> > ---
> >  drivers/block/virtio_blk.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> > index 8ad21a2..5990382 100644
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -539,6 +539,8 @@ static void virtblk_config_changed_work(struct
> > work_struct *work)
> >  	struct virtio_device *vdev = vblk->vdev;
> >  	struct request_queue *q = vblk->disk->queue;
> >  	char cap_str_2[10], cap_str_10[10];
> > +	char event[] = "RESIZE=1";
> > +	char *envp[] = { event, NULL };
> 
> event is not used again. Why not just
> 
> char *envp[] = { "RESIZE=1", NULL };
> 

You're right. This works too. I was looking at other modules in kernel
how they do it and this was commonly used. Take a look at block/genhd.c
media_change_notify_thread() function which does similar thing.

> 
> >  	u64 capacity, size;
> >  
> >  	mutex_lock(&vblk->config_lock);
> > @@ -568,6 +570,7 @@ static void virtblk_config_changed_work(struct
> > work_struct *work)
> >  
> >  	set_capacity(vblk->disk, capacity);
> >  	revalidate_disk(vblk->disk);
> > +	kobject_uevent_env(&disk_to_dev(vblk->disk)->kobj, KOBJ_CHANGE, envp);
> >  done:
> >  	mutex_unlock(&vblk->config_lock);
> >  }
> > 
> 
> I tried the following with your automatically resize udev rules.
> 
> (qemu) block_resize vd0 500
> Check the fs size in guest, it is 500Mb
> 
> (qemu) block_resize vd0 1200
> Check the fs size in guest, it is still 500Mb
> 
> Can you try resizing multiple times? Does it work?

Yep, works for me. After each block_resize call I get udev event. I
was running udevadm monitor at that time. I've also tried running
udevd in debug mode and even if I try to bump size twice in a row
I get two separate udev events and resize2fs is triggered. 

[root@host ~]# lvresize -f -L +100M /dev/vgguests/evd2 && \
virsh blockresize resize vdb 1 && \
lvresize -f -L +100M /dev/vgguests/evd2 && \
virsh blockresize resize vdb 1
  Rounding size to boundary between physical extents: 128.00 MiB
  Extending logical volume evd2 to 31.38 GiB
  Logical volume evd2 successfully resized
Block device 'vdb' is resized
  Rounding size to boundary between physical extents: 128.00 MiB
  Extending logical volume evd2 to 31.50 GiB
  Logical volume evd2 successfully resized
Block device 'vdb' is resized

On guest I get this (from udevd --debug)
...
1361804003.724025 [4438] util_run_program: '/sbin/resize2fs /dev/vdb' started
1361804003.725215 [4438] util_run_program: '/sbin/resize2fs' (stderr) 'resize2fs 1.41.12 (17-May-2010)'
1361804004.129329 [4437] event_queue_insert: seq 2073 queued, 'change' 'block'
1361804006.577235 [4438] util_run_program: '/sbin/resize2fs' (stdout) 'Filesystem at /dev/vdb is mounted on /mnt/backup; on-line resizing required'
1361804006.577251 [4438] util_run_program: '/sbin/resize2fs' (stdout) 'old desc_blocks = 2, new_desc_blocks = 2'
1361804006.577254 [4438] util_run_program: '/sbin/resize2fs' (stdout) 'Performing an on-line resize of /dev/vdb to 8224768 (4k) blocks.'
1361804006.577257 [4438] util_run_program: '/sbin/resize2fs' (stdout) 'The filesystem on /dev/vdb is now 8224768 blocks long.'
1361804006.577260 [4438] util_run_program: '/sbin/resize2fs' (stdout) ''
1361804006.577544 [4438] util_run_program: '/sbin/resize2fs /dev/vdb' returned with exitcode 0
...
1361804006.702659 [4438] util_run_program: '/sbin/resize2fs /dev/vdb' started
1361804006.703841 [4438] util_run_program: '/sbin/resize2fs' (stderr) 'resize2fs 1.41.12 (17-May-2010)'
1361804009.343332 [4438] util_run_program: '/sbin/resize2fs' (stdout) 'Filesystem at /dev/vdb is mounted on /mnt/backup; on-line resizing required'
1361804009.343351 [4438] util_run_program: '/sbin/resize2fs' (stdout) 'old desc_blocks = 2, new_desc_blocks = 2'
1361804009.343356 [4438] util_run_program: '/sbin/resize2fs' (stdout) 'Performing an on-line resize of /dev/vdb to 8257536 (4k) blocks.'
1361804009.343362 [4438] util_run_program: '/sbin/resize2fs' (stdout) 'The filesystem on /dev/vdb is now 8257536 blocks long.'
1361804009.343367 [4438] util_run_program: '/sbin/resize2fs' (stdout) ''
1361804009.343727 [4438] util_run_program: '/sbin/resize2fs /dev/vdb' returned with exitcode 0
1361804009.343740 [4438] udev_watch_begin: adding watch on '/dev/vdb'

Milos
