Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab3I2IqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:46:15 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:42388 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab3I2IqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:46:11 -0400
Date: Sun, 29 Sep 2013 16:46:07 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Cc: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH V2 0/2] Auto stop async-write on block device when device removed.
References: <201309171121559232246@gmail.com> <x49r4cfy4py.fsf@segfault.boston.devel.redhat.com> <201309241107330800706@gmail.com>, 
	<x4961tqwci6.fsf@segfault.boston.devel.redhat.com>
X-Priority: 3
X-GUID: FFE4548D-12B6-46EB-B0AA-F6AC7C029A2E
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309291646039330492@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8T8kaEc001435

>majianpeng <majianpeng@gmail.com> writes:
>
>>>majianpeng <majianpeng@gmail.com> writes:
>>>
>>>> For async-write on block device,if device removed,but the vfs don't know it.
>>>> It will continue to do.
>>>> Patch1 set size of inode of block device to zero when removed disk.By this,vfs know 
>>>> disk changed.
>>>> Path2 add size-check on blk_aio_write.If pos of write larger than size of inode,it will
>>>> return zero.So the user can check disk state.
>>>
>>>OK, so the basic problem is that __generic_file_aio_write will always
>>>return 0 after device removal, yes?  I'm not sure why that's a real
>>>issue, can you explain exactly why you're trying to change this?
>>>
>> At prenset, the __generic_file_aio_write don't return zero rather that the wanted size.
>> So the user can't know the disk removed. 
>> For example:
>> dd if=/dev/zero of=usb-disk bs=64k
>> When removed usb-disk, dd stoped until reached the endof usb-disk.
>
>Ah, right, it's just writing to the page cache.  I think the only reason
>you get more timely errors when doing the same thing to a file on a file
>system is that there is some synchronous metadata or journal I/O that
>will get EIO and result in the file system being set read-only.
>
>The bigger question is whether we want to change this long-standing
>behaviour of how our write-back cache works.  I don't know that it's
>really worth it, honestly.  If you want to ensure data is on disk, you
>open the file O_SYNC or you issue an fsync, and those calls will return
>an error for a removed block device.  So, I guess I'll ask the same
>question again: why are you looking at this?  Is there some application
>you care about that does buffered I/O to the block device and never does
>an fsync?
>
>> Using this patch, after removed disk, the aio-write will return zero.I
>> think the upper user will check.  (or if the size of block is zero, we
>> return -ENOSPC).
>>
>>>As for your patches, I don't think that putting the i_size_write into
>>>invalidate_partitions is a good idea.  Consider the case of rescanning
>>>partitions: you will always detect a size change now, which is not good.
>>>
>> Yes.But in func rescan_partitions, after invalidate_partitions it will
>> call check_disk_size_change to set size of block_device.
>
>The problem with doing an i_size_write of 0 inside of
>invalidate_partitions is that it isn't just called for the case where a
>device is removed.  A user can initiate a rescan of partitions.  In such
>a case, we don't want to evict all of the cached data for unchanged
>partitions.
>
>The call chain is like this:
>
>blkdev_ioctl
>blkdev_reread_part
>rescan_partitions
>check_disk_size_change
>
>Now look and see what check_disk_size_change will do when it finds out
>that the size has changed:
>
>void check_disk_size_change(struct gendisk *disk, struct block_device
>*bdev)
>{
>        loff_t disk_size, bdev_size;
>
>        disk_size = (loff_t)get_capacity(disk) << 9;
>        bdev_size = i_size_read(bdev->bd_inode);
>        if (disk_size != bdev_size) {
>                char name[BDEVNAME_SIZE];
>
>                disk_name(disk, 0, name);
>                printk(KERN_INFO
>                       "%s: detected capacity change from %lld to
>                %lld\n",
>                       name, bdev_size, disk_size);
>                i_size_write(bdev->bd_inode, disk_size);
>                flush_disk(bdev, false);  <=============
>        }
>}
>
>That will invalidate all of the metadata for any mounted file systems on
>the device.  Also, you'll get a big nasty warning if any files are dirty:
>
>                printk(KERN_WARNING "VFS: busy inodes on changed media or "
>                       "resized disk %s\n", name);
>
>And the reality is that we haven't changed anything, so there's no need
>for this.
Yes. How about those code:

diff --git a/block/genhd.c b/block/genhd.c
index 791f419..c279b34 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -634,6 +634,7 @@ void del_gendisk(struct gendisk *disk)
 {
        struct disk_part_iter piter;
        struct hd_struct *part;
+       struct block_device *bdev;
 
        disk_del_events(disk);
 
@@ -642,12 +643,25 @@ void del_gendisk(struct gendisk *disk)
                             DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
        while ((part = disk_part_iter_next(&piter))) {
                invalidate_partition(disk, part->partno);
+               bdev = bdget_disk(disk, part->partno);
+               if (bdev) {
+                       i_size_write(bdev->bd_inode, 0);
+                       bdput(bdev);
+               }
+
                delete_partition(disk, part->partno);
        }
        disk_part_iter_exit(&piter);
 
        invalidate_partition(disk, 0);
        set_capacity(disk, 0);
+
+       bdev = bdget_disk(disk, 0);
+       if (bdev) {
+               i_size_write(bdev->bd_inode, 0);
+               bdput(bdev);
+       }
+
        disk->flags &= ~GENHD_FL_UP;
 
        sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");

We only set inode to zero in del_gendisk.
>
>After looking at the code further, why do you even need to add the
>second patch?  generic_write_checks will check for a write past the end
>of the block device.
>
Yes, in generic_write_checks it will check size so patch2 don't need.

Thanks!
Jianpeng Ma
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
