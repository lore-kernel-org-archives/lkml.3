Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250Ab3DAQt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 12:49:57 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:54930 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759208Ab3DAQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 12:49:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130401162800.GB21522@ZenIV.linux.org.uk>
References: <1364817485-19676-1-git-send-email-anatol.pomozov@gmail.com>
	<20130401162800.GB21522@ZenIV.linux.org.uk>
Date: Mon, 1 Apr 2013 09:49:54 -0700
Message-ID: <CAOMFOmWC48MycYCd+Q_4JG-9GGc08F1RNnc0phJgVzi41dRy1A@mail.gmail.com>
Subject: Re: [PATCH] loop: prevent bdev freeing while device in use
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        sqazi@google.com, Guo Chao <yan@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Apr 1, 2013 at 9:28 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Apr 01, 2013 at 04:58:05AM -0700, Anatol Pomozov wrote:
>>               lo->lo_flags |= LO_FLAGS_PARTSCAN;
>>       if (lo->lo_flags & LO_FLAGS_PARTSCAN)
>>               ioctl_by_bdev(bdev, BLKRRPART, 0);
>> +
>> +     /* bdev lifecycle is defined by its bd_inode (see
>> +      * struct bdev_inode usage). In case of loop device we need to make
>> +      * sure that bdev deallocation will not happen between loop_set_fd()
>> +      * and loop_clr_fd() invocations. To do this we need to hold
>> +      * bdev inode here and put it later in loop_clr_fd().
>> +      */
>> +     ihold(bdev->bd_inode);
>
> That's open-coded bdgrab()

Done. It also requires EXPORTING bdgrab.

The test still passes.

>
>> +     if (bdev) {
>> +             BUG_ON(atomic_read(&bdev->bd_inode->i_count) < 2);
>> +             iput(bdev->bd_inode);
>
> ... and that - bdput() (I'd drop that BUG_ON())
