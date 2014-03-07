Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaCGUSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:18:44 -0500
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62914 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbaCGUSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:18:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140307040028.GA17965@thunk.org>
References: <CAMbOQaUW7K=FBESVeo=BOXfYU6cuqthjnmMR6jmeNFnx8PcvuQ@mail.gmail.com>
	<CAMbOQaU-jX8Dvmjj_iQJGBhDesMyFj02epaROFfW+ae+BDg_tA@mail.gmail.com>
	<20140307040028.GA17965@thunk.org>
Date: Sat, 8 Mar 2014 01:48:42 +0530
Message-ID: <CAMbOQaUDWGBHLAjFzVSZtU3NJzu5mgcpm34g=dARADDaZB9Ryw@mail.gmail.com>
Subject: Re: Reporting a bug - Memory corruption in Linux kernel
From: Nilesh More <nilesh99999@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Theodore for your quick reply.

To make few things clear, USB drive has FAT file system in it. And the
ext4 file system is of internal sdcard present in android device. The
ext4 corruption in /data partition occurs when USB drive is
hotplugged/hotunplugged. The bug may repro with first hotplug or with
couple of hotplug/unplugs.

The main concern here is even if USB drive is corrupted, that should
not result into the native file system corruption.

Today, I digged in further to see if I can get some more clues.
Following are my findngs -

1. When the USB is hotplugged, in the call stack of add_disk( ),
while registering disk blkdev_get(bdev, FMODE_READ, NULL) gets called
which I guess scans the partition table, initializes part array and
registers the partitions in the driver model.

2. To release the ownership of bdev obtained in step#1,
blkdev_put(bdev, FMODE_READ) is called. This invalidates the pages
cached for bdev in above blkdev_get call by first doing a writeback of
these pages to disk.

3. Now if I prevent the invalidate page call in step# 2, I see that
ext4 file system remains intact without any correction. That suggests,
some part of cached pages obtained in step#1 blkdev_get call is
already being used by ext4 file system and once these pages are
invalidated we have a corruption in ext4 file system.

My query now is, has anybody seen similar kind of issue before ? Could
this be a known bug ?

Thank you,
Nilesh


On Fri, Mar 7, 2014 at 9:30 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Fri, Mar 07, 2014 at 01:39:45AM +0530, Nilesh More wrote:
>> Hi all,
>>
>> I am working on android bug wherein directory entries of ext4 file
>> system get corrupted when USB is hotplugged (with auto mount support
>> enabled).
>>
>> The logs as below:
>> [ 413.607849] usb 2-1.1: USB disconnect, device number 12
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> Hot plugged or hot unplugged?  It looks like the problem is that the
> block device disappeared out from under ext4.  Maybe you have a flaky
> SD/MMC drive (i.e., funky contacts, etc.)?  Or maybe when you plug in
> one USB device, the eMMC device where you have the mounted file system
> disappeared?
>
>> If I prevent kill_bdev from invalidating pages, I see a No-Repro for
>> this bug. Also there are no prints saying invalid access to FAT
>> entry(which were present when bug reproduces). Earlier we had no-repro
>> when added delay(1) before _getblk.
>>
>> This points out to the loss of sync between _getblk and kill_bdev and
>> ALSO looks like kill_bdev inadvertently invalidates pages which are
>> Ext4 owned.
>
> This looks like it's much more of a hardware issue than a software
> issue.  If you are plugging in a USB device, you should *not* be
> getting a USB disconnect message.  And the fact that the pages being
> used by ext4 are getting invalidated would be consistent with the
> theory that the USB device on which the ext4 file system was on is
> somehow getting disconnected, per the message in you've shown in the
> logs.
>
>                                                 - Ted
