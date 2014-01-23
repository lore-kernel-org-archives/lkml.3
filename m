Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaAWN1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:27:10 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40726 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaAWN1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:27:07 -0500
Date: Thu, 23 Jan 2014 05:28:29 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140123132829.GE889@kmo-pixel>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <20140123124753.GT30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123124753.GT30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 01:47:53PM +0100, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 02:18:52PM -0800, Kent Overstreet wrote:
> > > I do not get the comment near prepare to wait -- why does it matter if
> > > percpu_ida_free() flips a cpus_have_tags bit?
> > 
> > Did I write that comment? It is a crappy comment...
> > 
> > Ok, in userspace we'd be using condition variables here, but this is the kernel
> > so we need to carefully order putting ourselves on a waitlist, and checking the
> > condition that determines whether we wait, and on the wakeup end changing things
> > that affect that condition and doing the wakeup. steal_tags() is checking the
> > condition that goes with the prepare_to_wait(), that's all.
> 
> How about something like so?

I like it - my only concern is that your patch has the effect of calling
__alloc_global_tag() twice before sleeping on alloc failure - given that
we're also doing a prepare_to_wait() I'm not concerned about touching
the global freelist twice, but we're also calling steal_tags() twice and
that's potentially more expensive.

It should be ok, because I expect when steal_tags() is going to fail
most of the time it'll check the bitmap and not run the loop, but I
think there's enough room for pathological behaviour here to sleep on
it.

pool->lock is also going to be fairly badly contended in the worst case,
and that can get real bad real fast... now that I think about it we
probably want to avoid the __alloc_global_tag() double call just because
of that, pool->lock is going to be quite a bit more contended than the
waitlist lock just because fo the amount of work done under it.

though my old code was also calling prepare_to_wait() with pool->lock
held, which was dumb.
