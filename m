Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067Ab3GPVCS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:02:18 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:54938 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320Ab3GPVCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130716204335.GH11674@dastard>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard>
	<20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
Date: Tue, 16 Jul 2013 14:02:12 -0700
X-Google-Sender-Auth: EsUysDh-p2Ez6DwSWC3L1pZHWJ0
Message-ID: <CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
Subject: Re: splice vs execve lockdep trace.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 1:43 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Yes - IO is serialised based on the ip->i_iolock, not i_mutex. We
> don't use i_mutex for many things IO related, and so internal
> locking is needed to serialise against stuff like truncate, hole
> punching, etc, that are run through non-vfs interfaces.

Umm. But the page IO isn't serialized by i_mutext *either*. You don't
hold it across page faults. In fact you don't even take it at all
across page faults.

That's kind of my point. splice is about the page IO, and it's
serialized purely by the page lock. And then "->readpage()" will get
whatever IO mutex in order to do that right, but think about the case
where things are already in the page cache. There's no reason for any
serialization what-so-ever.

So this isn't about i_mutex. At all.

> Read isn't the problem - it's write that's the deadlock issue...

I agree, and I think your patches are needed, as I said in that email
you replied to. But due to this issue, I was looking at the XFS splice
support, and the read-side splice support seems inefficient and overly
complex. I'm not seeing why it needs that i_iolock.

And no, this really has nothing to do with i_mutex. Go look at
generic_file_splice_read(). There's no i_mutex there at all. It's more
like a series of magic page-faults without the actual page table
actions. Which is kind of the whole point of splice - zero-copy
without bothering with page table setup/teardown.

Now, it's perfectly possible that XFS really needs some odd locking
here, but your reply about i_mutex makes me think that you did it
because you were confused about what it actually wants.

*Every* other local filesystem uses generic_file_splice_read() with
just a single

     .splice_read = generic_file_splice_read,

in the file ops initializer.  Sure, nfs and ocfs2 wrap things like xfs
does, but they basically do it to revalidate their caches.

                     Linus
