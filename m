Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881Ab3BYXlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:41:12 -0500
Received: from mail4.sde.cz ([85.93.125.197]:52079 "EHLO zimbra.sde"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759817Ab3BYXlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:41:08 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] virtio-blk: emit udev event when device is resized
From: Milos Vyletel <milos.vyletel@sde.cz>
In-Reply-To: <20130225221238.GA10575@kroah.com>
Date: Mon, 25 Feb 2013 18:41:03 -0500
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mst@redhat.com
Content-Transfer-Encoding: 8BIT
Message-Id: <16100EF6-6C55-47ED-9BBB-2C3CAC8FA37A@sde.cz>
References: <1361473348-7660-1-git-send-email-milos.vyletel@sde.cz> <87y5ehfczy.fsf@rustcorp.com.au> <20130225221238.GA10575@kroah.com>
To: Greg KH <greg@kroah.com>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 25, 2013, at 5:12 PM, Greg KH <greg@kroah.com> wrote:

> On Fri, Feb 22, 2013 at 10:14:49AM +1030, Rusty Russell wrote:
>> Milos Vyletel <milos.vyletel@sde.cz> writes:
>> 
>>> When virtio-blk device is resized from host (using block_resize from QEMU) emit
>>> KOBJ_CHANGE uevent to notify guest about such change. This allows user to have
>>> custom udev rules which would take whatever action if such event occurs. As a
>>> proof of concept I've created simple udev rule that automatically resize
>>> filesystem on virtio-blk device.
>>> 
>>> ACTION=="change", KERNEL=="vd*", \
>>>        ENV{RESIZE}=="1", \
>>>        ENV{ID_FS_TYPE}=="ext[3-4]", \
>>>        RUN+="/sbin/resize2fs /dev/%k"
>>> ACTION=="change", KERNEL=="vd*", \
>>>        ENV{RESIZE}=="1", \
>>>        ENV{ID_FS_TYPE}=="LVM2_member", \
>>>        RUN+="/sbin/pvresize /dev/%k"
>> 
>> This looks fine to me, but I like to check with Greg before adding udev
>> callouts.... Greg?
> 
> Hm, I thought we were frowning apon running binaries from udev rules
> these days, especially ones that might have big consequences (like
> resizing a disk image) like this.
> 
> Kay, am I right?
> 
> We already emit KOBJECT_CHANGE events when block devices change, from
> within the block core code.  Why is the patch below needed instead of
> using these events that are already generated?  How are virtio block
> devices special?
> 
>> BTW, if this is good, it's good for stable IMHO.
> 
> What bug does it fix?
> 

It is not really a bug but it definitely is useful enhancement to have in stable too. I
can imagine lots of people can benefit from this.

Milos

> thanks,
> 
> greg k-h
> 
>> Cheers,
>> Rusty.
>> 
>>> Signed-off-by: Milos Vyletel <milos.vyletel@sde.cz>
>>> ---
>>> drivers/block/virtio_blk.c |    3 +++
>>> 1 files changed, 3 insertions(+), 0 deletions(-)
>>> 
>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>> index 8ad21a2..5990382 100644
>>> --- a/drivers/block/virtio_blk.c
>>> +++ b/drivers/block/virtio_blk.c
>>> @@ -539,6 +539,8 @@ static void virtblk_config_changed_work(struct work_struct *work)
>>> 	struct virtio_device *vdev = vblk->vdev;
>>> 	struct request_queue *q = vblk->disk->queue;
>>> 	char cap_str_2[10], cap_str_10[10];
>>> +	char event[] = "RESIZE=1";
>>> +	char *envp[] = { event, NULL };
>>> 	u64 capacity, size;
>>> 
>>> 	mutex_lock(&vblk->config_lock);
>>> @@ -568,6 +570,7 @@ static void virtblk_config_changed_work(struct work_struct *work)
>>> 
>>> 	set_capacity(vblk->disk, capacity);
>>> 	revalidate_disk(vblk->disk);
>>> +	kobject_uevent_env(&disk_to_dev(vblk->disk)->kobj, KOBJ_CHANGE, envp);
>>> done:
>>> 	mutex_unlock(&vblk->config_lock);
>>> }
>>> -- 
>>> 1.7.1

