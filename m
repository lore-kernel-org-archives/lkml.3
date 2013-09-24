Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3IXDHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 23:07:42 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35550 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3IXDHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 23:07:39 -0400
Date: Tue, 24 Sep 2013 11:07:34 +0800
From: majianpeng <majianpeng@gmail.com>
To: "Jeff Moyer" <jmoyer@redhat.com>
Cc: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH V2 0/2] Auto stop async-write on block device when device removed.
References: <201309171121559232246@gmail.com>, 
	<x49r4cfy4py.fsf@segfault.boston.devel.redhat.com>
X-Priority: 3
X-GUID: 46F2D491-3347-40D6-A70C-25F557B45431
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309241107330800706@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8O37lsK022964

>majianpeng <majianpeng@gmail.com> writes:
>
>> For async-write on block device,if device removed,but the vfs don't know it.
>> It will continue to do.
>> Patch1 set size of inode of block device to zero when removed disk.By this,vfs know 
>> disk changed.
>> Path2 add size-check on blk_aio_write.If pos of write larger than size of inode,it will
>> return zero.So the user can check disk state.
>
>OK, so the basic problem is that __generic_file_aio_write will always
>return 0 after device removal, yes?  I'm not sure why that's a real
>issue, can you explain exactly why you're trying to change this?
>
At prenset, the __generic_file_aio_write don't return zero rather that the wanted size.
So the user can't know the disk removed. 
For example:
dd if=/dev/zero of=usb-disk bs=64k
When removed usb-disk, dd stoped until reached the endof usb-disk.

Using this patch, after removed disk, the aio-write will return zero.I think the upper user will check.
(or if the size of block is zero, we return -ENOSPC).

>As for your patches, I don't think that putting the i_size_write into
>invalidate_partitions is a good idea.  Consider the case of rescanning
>partitions: you will always detect a size change now, which is not good.
>
Yes.But in func rescan_partitions, after invalidate_partitions it will call check_disk_size_change to set size of block_device.

Thanks!
Jianpeng Ma
>Cheers,
>Jeffÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
