Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3IXNzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:55:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab3IXNzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:55:01 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2 0/2] Auto stop async-write on block device when device removed.
References: <201309171121559232246@gmail.com>
	<x49r4cfy4py.fsf@segfault.boston.devel.redhat.com>
	<201309241107330800706@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 24 Sep 2013 09:54:57 -0400
In-Reply-To: <201309241107330800706@gmail.com> (majianpeng@gmail.com's message
	of "Tue, 24 Sep 2013 11:07:34 +0800")
Message-ID: <x4961tqwci6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

majianpeng <majianpeng@gmail.com> writes:

>>majianpeng <majianpeng@gmail.com> writes:
>>
>>> For async-write on block device,if device removed,but the vfs don't know it.
>>> It will continue to do.
>>> Patch1 set size of inode of block device to zero when removed disk.By this,vfs know 
>>> disk changed.
>>> Path2 add size-check on blk_aio_write.If pos of write larger than size of inode,it will
>>> return zero.So the user can check disk state.
>>
>>OK, so the basic problem is that __generic_file_aio_write will always
>>return 0 after device removal, yes?  I'm not sure why that's a real
>>issue, can you explain exactly why you're trying to change this?
>>
> At prenset, the __generic_file_aio_write don't return zero rather that the wanted size.
> So the user can't know the disk removed. 
> For example:
> dd if=/dev/zero of=usb-disk bs=64k
> When removed usb-disk, dd stoped until reached the endof usb-disk.

Ah, right, it's just writing to the page cache.  I think the only reason
you get more timely errors when doing the same thing to a file on a file
system is that there is some synchronous metadata or journal I/O that
will get EIO and result in the file system being set read-only.

The bigger question is whether we want to change this long-standing
behaviour of how our write-back cache works.  I don't know that it's
really worth it, honestly.  If you want to ensure data is on disk, you
open the file O_SYNC or you issue an fsync, and those calls will return
an error for a removed block device.  So, I guess I'll ask the same
question again: why are you looking at this?  Is there some application
you care about that does buffered I/O to the block device and never does
an fsync?

> Using this patch, after removed disk, the aio-write will return zero.I
> think the upper user will check.  (or if the size of block is zero, we
> return -ENOSPC).
>
>>As for your patches, I don't think that putting the i_size_write into
>>invalidate_partitions is a good idea.  Consider the case of rescanning
>>partitions: you will always detect a size change now, which is not good.
>>
> Yes.But in func rescan_partitions, after invalidate_partitions it will
> call check_disk_size_change to set size of block_device.

The problem with doing an i_size_write of 0 inside of
invalidate_partitions is that it isn't just called for the case where a
device is removed.  A user can initiate a rescan of partitions.  In such
a case, we don't want to evict all of the cached data for unchanged
partitions.

The call chain is like this:

blkdev_ioctl
blkdev_reread_part
rescan_partitions
check_disk_size_change

Now look and see what check_disk_size_change will do when it finds out
that the size has changed:

void check_disk_size_change(struct gendisk *disk, struct block_device
*bdev)
{
        loff_t disk_size, bdev_size;

        disk_size = (loff_t)get_capacity(disk) << 9;
        bdev_size = i_size_read(bdev->bd_inode);
        if (disk_size != bdev_size) {
                char name[BDEVNAME_SIZE];

                disk_name(disk, 0, name);
                printk(KERN_INFO
                       "%s: detected capacity change from %lld to
                %lld\n",
                       name, bdev_size, disk_size);
                i_size_write(bdev->bd_inode, disk_size);
                flush_disk(bdev, false);  <=============
        }
}

That will invalidate all of the metadata for any mounted file systems on
the device.  Also, you'll get a big nasty warning if any files are dirty:

                printk(KERN_WARNING "VFS: busy inodes on changed media or "
                       "resized disk %s\n", name);

And the reality is that we haven't changed anything, so there's no need
for this.

After looking at the code further, why do you even need to add the
second patch?  generic_write_checks will check for a write past the end
of the block device.

Cheers,
Jeff
