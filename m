Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816Ab3GPUSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:18:11 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:52418 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933497Ab3GPUSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130716193332.GB3572@sgi.com>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard>
	<20130716193332.GB3572@sgi.com>
Date: Tue, 16 Jul 2013 13:18:06 -0700
X-Google-Sender-Auth: r29f09rx7uhQZojc3E0-PTPVg18
Message-ID: <CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
Subject: Re: splice vs execve lockdep trace.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ben Myers <bpm@sgi.com>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 12:33 PM, Ben Myers <bpm@sgi.com> wrote:
>> >
>> > And looking more at that, I'm actually starting to think this is an
>> > XFS locking problem. XFS really should not call back to splice while
>> > holding the inode lock.

.. that was misleading, normally "inode lock" would be i_lock, but
here I meant the XFS-specific i_iolock.

But you clearly picked up on it:

> CPU0                            CPU1                            CPU2
> ----                            ----                            ----
> lock(&sig->cred_guard_mutex);
>                                 lock(&pipe->mutex/1);
>                                                                 lock(&(&ip->io_lock)->mr_lock);
> lock(&(&ip->io_lock)->mr_lock);
>                                 lock(&sig->cred_guard_mutex);
>                                                                 lock(&pipe->mutex/1);

Yup.

> I agree that fixing this in XFS seems to be the most reasonable plan,
> and Dave's approach looks ok to me.  Seems like patch 1 should go
> through Al's tree, but we'll also need to commit it to the xfs tree
> prerequisite to patch 2.

Btw, is there some reason why XFS couldn't just use
generic_file_splice_read() directly?

I'm not arguing against Dave's patches, since the splice_write case
would seem to want them regardless, but I'm not even seeing why XFS
couldn't just avoid the locking for the splice_read case entirely..And
the generic file-splice read function does all that read-ahead stuff
and should actually be better for performance. And because it does it
from the page cache, it can avoid the locking issues (because it gets
the splice pipe lock later, just holding on to the page references).

And splice has mmap semantics - the whole point of splice is about
moving pages around, after all - so I *think* your current
"xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);" is actually over-serialization.
The pages will be shared by the pipe buffers anyway, so splicing by
definition doesn't imply full data serialization (because the reading
of the data itself will happen much later).

So the per-page serialization done by readpage() should already be
sufficient, no?

I dunno. Maybe there's something I'm missing. XFS does seem to wrap
all the other generic functions in that lock too, but since mmap() etc
clearly have to be able to get things one page at a time (without any
wrapping at higher layers), I'm just wondering whether splice_read
might not be able to avoid it.

                     Linus
