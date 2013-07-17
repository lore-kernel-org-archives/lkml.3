Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902Ab3GQEGZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 00:06:25 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:43905 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab3GQEGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 00:06:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjscAPoV5lF5LK4r/2dsb2JhbABagwY0gmysCwKOUYUwBAGBDBd0giMBAQUnExwjEAgDGAklDwUlAyETiA+1WxaOO4EdB4N6A5dbkU6DJCo
Date: Wed, 17 Jul 2013 14:06:16 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Myers <bpm@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>, xfs@oss.sgi.com
Subject: Re: splice vs execve lockdep trace.
Message-ID: <20130717040616.GI11674@dastard>
References: <20130716015305.GB30569@redhat.com>
 <CA+55aFyLbqJp0-=7=HOF9sKGOHwsa7A7-V76b8tbsnra8Z2=-w@mail.gmail.com>
 <20130716023847.GA31481@redhat.com>
 <CA+55aFxiGXht8+Dox=C2ezYYf1yMaLAzMYr40j=+peP8j5Ha6w@mail.gmail.com>
 <20130716060351.GE11674@dastard>
 <20130716193332.GB3572@sgi.com>
 <CA+55aFzTBUKStdZu1GhKoiYc2knybhiaUFr2By98QYew_STE=A@mail.gmail.com>
 <20130716204335.GH11674@dastard>
 <CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwHMQd-VDeTDh-gm3jyj+5+FSoAHOeU47mwU-mKtEj9RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 02:02:12PM -0700, Linus Torvalds wrote:
> On Tue, Jul 16, 2013 at 1:43 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > Yes - IO is serialised based on the ip->i_iolock, not i_mutex. We
> > don't use i_mutex for many things IO related, and so internal
> > locking is needed to serialise against stuff like truncate, hole
> > punching, etc, that are run through non-vfs interfaces.
> 
> Umm. But the page IO isn't serialized by i_mutext *either*. You don't
> hold it across page faults. In fact you don't even take it at all
> across page faults.

Right, and that's one of the biggest problems page based IO has - we
can't serialise it against other IO and other page cache
manipulation functions like hole punching. What happens when a
splice read or mmap page fault races with a hole punch? You get
stale data being left in the page cache because we can't serialise
the page read with the page cache invalidation and underlying extent
removal.

Indeed, why do you think we've been talking about VFS-level IO range
locking for the past year or more, and had a discussion session at
LSF/MM this year on it? i.e. this:

http://lwn.net/Articles/548939/

So forget about this "we don't need no steenkin' IO serialisation"
concept - it's fundamentally broken.

FWIW, hole punching in XFS takes the i_iolock in exclusive
mode, and hence serialises correctly against splice. IOWs, there is
a whole class of splice read data corruption race conditions that
XFS is not susceptible to but....

> *Every* other local filesystem uses generic_file_splice_read() with
> just a single
> 
>      .splice_read = generic_file_splice_read,

... and so they all are broken in a nasty, subtle way....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
