Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab3GQEyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 00:54:12 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:41210 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3GQEyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 00:54:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130717040616.GI11674@dastard>
References: <20130716015305.GB30569@redhat.com>
	<CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
	<20130716023847.GA31481@redhat.com>
	<CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
	<20130716060351.GE11674@dastard>
	<20130716193332.GB3572@sgi.com>
	<CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
	<20130716204335.GH11674@dastard>
	<CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
	<20130717040616.GI11674@dastard>
Date: Tue, 16 Jul 2013 21:54:09 -0700
X-Google-Sender-Auth: t3GI8daNOQqHK_Dq80lmOy-IHLA
Message-ID: <CA+55aFz5xw9Qi9Q6mwoCSud5eQh5u-QZ-xrY+TqgZPoKOgn6ew@mail.gmail.com>
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

On Tue, Jul 16, 2013 at 9:06 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> Right, and that's one of the biggest problems page based IO has - we
> can't serialise it against other IO and other page cache
> manipulation functions like hole punching. What happens when a
> splice read or mmap page fault races with a hole punch? You get
> stale data being left in the page cache because we can't serialise
> the page read with the page cache invalidation and underlying extent
> removal.

But Dave, that's *good*.

You call it "stale data".

I call it "the data was valid at some point".

This is what "splice()" is fundamentally all about.

Think of it this way: even if you are 100% serialized during the
"splice()" operation, what do you think happens afterwards?

Seriously, think it through.

That data is in a kernel buffer - the pipe. The fact that it was
serialized at the time of the original splice() doesn't make _one_
whit of a difference, because after the splice is over, the data still
sits around in that pipe buffer, and you're no longer serializing it.
Somebody else truncating the file or punching a hole in the file DOES
NOT MATTER. It's too late.

In other words, trying to "protect" against that kind of race is stupid.

You're missing the big picture because you're concentrating on the
details. Look beyond what happens inside XFS, and think about the
higher-level meaning of splice() itself.

So the only guarantee splice *should* give is entirely per-page. If
you think it gives any other serialization, you're fundamentally
wrong, because it *cannot*. See?

                     Linus
