Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbaGWQSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:18:39 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:37352 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250AbaGWQSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:18:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5umygiEpKBsHQ+OvKvw8pRD1DO0fCPA29qs=kNRho35xkt_g@mail.gmail.com>
References: <1405606659-3802-1-git-send-email-akinobu.mita@gmail.com>
	<x49pph325wj.fsf@segfault.boston.devel.redhat.com>
	<CAC5umygiEpKBsHQ+OvKvw8pRD1DO0fCPA29qs=kNRho35xkt_g@mail.gmail.com>
Date: Thu, 24 Jul 2014 01:18:36 +0900
Message-ID: <CAC5umyg04M27xH5GSwhyVW8W4RPyFROYo4EbgxnrQ2RRqo_gaA@mail.gmail.com>
Subject: Re: [PATCH] block_dev: implement readpages() to optimize sequential read
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-18 8:14 GMT+09:00 Akinobu Mita <akinobu.mita@gmail.com>:
> 2014-07-18 3:31 GMT+09:00 Jeff Moyer <jmoyer@redhat.com>:
>> Akinobu Mita <akinobu.mita@gmail.com> writes:
>>
>>> Sequential read from a block device is expected to be equal or faster
>>> than from the file on a filesystem.  But it is not correct due to the
>>> lack of effective readpages() in the address space operations for
>>> block device.
>>
>> Ah, a trip down memory lane.  ;-)  Here's a thread showing issues with
>> the last time this was proposed (by me, incidentally):
>>
>> https://lkml.org/lkml/2009/6/2/480
>>
>> At the very least, we need to see numbers on a real device, and see it
>> booted on something with >4k page size before taking this back in.
>
> Thanks for the information.  First, I'll try to reproduce the >4k page
> size issue with qemu with the architecture which can support 64k page.

I can reproduce the issue which attempts to access beyond end of
device, and it turns out that this can be reproducible on 4K page
system, too.

This problem only happens when reading a partition which is being
mounted by the filesystem at the same time.  The filesystem sets
the blocksize to a multiple of the logical block size by set_blocksize()
while it is mounted.  If the end of the partition is not aligned on
the new blocksize, reading the end of the partition causes access
beyond end of device.

So this patch is incomplete, and some guard check code is required in
mpage_readpages() or altenative solution is needed.
