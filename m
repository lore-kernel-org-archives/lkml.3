Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767AbaIOW1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:27:13 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:62235 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749AbaIOW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:27:09 -0400
MIME-Version: 1.0
In-Reply-To: <x49d2awr1ez.fsf@segfault.boston.devel.redhat.com>
References: <cover.1410810247.git.milosz@adfin.com>
	<x49d2awr1ez.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 15 Sep 2014 18:27:07 -0400
Message-ID: <CANP1eJF7b3RFd4NdyCfsFuf9uyhrahVqJkDHs81nd2ZvVDwzSg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        michael.kerrisk@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

This patchset creates a new read (readv2/preadv2) syscall(s) that take
a extra flag argument (kind of like recvmsg). What it doesn't do is
change the current behavior of of the O_NONBLOCK, if the file is
open() with O_NONBLOCK flag. It shouldn't break any existing
applications since you have to opt into using this by using the new
syscall.

I don't have a preference either way if we should create a new flag or
re-use O_NONBLOCK the flag. Instead, I'm hoping to get some consensus
here from senior kernel developers like yourself. Maybe a RWF_NONBLOCK
(I'm stealing from eventfd, EFD_NONBLOCK).

As a side note, I noticed that EFD_NONBLOCK, SFD_NONBLOCK, etc... all
alias to the value of O_NONBLOCK and there's a bunch of bug checks in
the code like this:
BUILD_BUG_ON(EFD_NONBLOCK != O_NONBLOCK);

Thanks,
- Milosz

On Mon, Sep 15, 2014 at 5:58 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi, Milosz,
>
> I CC'd Michael Kerrisk, in case he has any opinions on the matter.
>
> Milosz Tanski <milosz@adfin.com> writes:
>
>> This patcheset introduces an ability to perform a non-blocking read from
>> regular files in buffered IO mode. This works by only for those filesystems
>> that have data in the page cache.
>>
>> It does this by introducing new syscalls new syscalls readv2/writev2 and
>> preadv2/pwritev2. These new syscalls behave like the network sendmsg, recvmsg
>> syscalls that accept an extra flag argument (O_NONBLOCK).
>
> I thought you were going to introduce a new flag instead of using
> O_NONBLOCK for this.  I dug up an old email that suggested that enabling
> O_NONBLOCK for regular files (well, a device node in this case) broke a
> cd ripping or burning application.  I also found this old bugzilla,
> which states that squid would fail to start, and that gqview was also
> broken:
>   https://bugzilla.redhat.com/show_bug.cgi?id=136057
>
> More generally, do you expect the open(2) of a regular file with
> O_NONBLOCK to perform the same way as a pipe, fifo, or device (namely,
> that the open itself won't block)?  Should O_NONBLOCK affect writes to
> regular files?  What do you think the return value from poll and friends
> should be when a file is opened in this manner (probably not important,
> as poll always returns data ready on regular files)?  Also consider
> whether you want the O_NONBLOCK behaviour for mandatory file locks in
> your use case (or any other, for that matter).  If you issue a read and
> it returns -EAGAIN, should it be up to the application to kick off I/O
> to ensure it makes progress?
>
> I don't think O_NONBLOCK is the right flag.  What you're really
> specifying is a flag that prevents I/O in the read path, and nowhere
> else.  As such, I'd feel much better about this if we defined a new flag
> (O_NONBLOCK_READ maybe?  No, that's too verbose.).
>
> In summary, I like the idea, but I worry about overloading O_NONBLOCK.
>
> Cheers,
> Jeff



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
