Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3IYBdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:33:03 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37265 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab3IYBc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:32:59 -0400
Date: Wed, 25 Sep 2013 09:32:55 +0800
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
X-GUID: 50ECDD14-01EF-4500-BB0D-89C7F8722062
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309250932532670454@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8P1XAXX001195

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
Yes
>The bigger question is whether we want to change this long-standing
>behaviour of how our write-back cache works.  I don't know that it's
>really worth it, honestly.  If you want to ensure data is on disk, you
>open the file O_SYNC or you issue an fsync, and those calls will return
>an error for a removed block device.  So, I guess I'll ask the same
>question again: why are you looking at this?  Is there some application
>you care about that does buffered I/O to the block device and never does
>an fsync?
>
Yes, for my company, we used our filesystem in userspace on block-device.
For the performance, we used buffer-wrtite not sync-write.
For my workload, we allow user to remove disk whether disk working or not.
Now, we check the state of disk from /proc/partitions at the same interval.

This patchset don't change write-back cache works.It only let vfs know the state of lower-device.
I think it make a sense.

Thanks!
Jianpeng Maÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
