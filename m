Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab3KRXyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 18:54:21 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:55749 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3KRXyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 18:54:18 -0500
MIME-Version: 1.0
In-Reply-To: <528A6AD4.7080702@kernel.dk>
References: <1384780302-25009-1-git-send-email-akinobu.mita@gmail.com>
	<528A6AD4.7080702@kernel.dk>
Date: Tue, 19 Nov 2013 08:54:18 +0900
Message-ID: <CAC5umyj7Uy=j8OyYB5oLEwQYSWPnXrjsUL2L_mO2udzMiSsbfg@mail.gmail.com>
Subject: Re: [PATCH] bio: fix argument of __bio_add_page() for max_sectors > 0xffff
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/19 Jens Axboe <axboe@kernel.dk>:
> On 11/18/2013 06:11 AM, Akinobu Mita wrote:
>> The data type of max_sectors and max_hw_sectors in queue settings are
>> unsigned int.  But these values are passed to __bio_add_page() as an
>> argument whose data type is unsigned short.  In the worst case such as
>> max_sectors is 0x10000, bio_add_page() can't add a page and IOs can't
>> proceed.
>
> Thanks, added. Even at 512b sectors, 0xffff sectors would be a huuuuge
> page. So I don't think we'd ever see this bug hit, iirc huge pages are
> still broken down for IO. But it's better to be safe...

I hit this when I was trying to change the data type of max_sectors in
scsi host settings from 16-bit to 32-bit.

BTW, I found that BLKSECTGET only returns 16-bit of max_sectors.  Should
we need the change like below?

        case BLKSECTGET:
-               return put_ushort(arg, queue_max_sectors(bdev_get_queue(bdev)));
+               max_sectors = min(0xffff,
+                                 queue_max_sectors(bdev_get_queue(bdev)));
+               return put_ushort(arg, max_sectors);
