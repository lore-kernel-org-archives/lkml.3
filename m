Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbaAUWTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:19:01 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44194 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbaAUWS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:18:56 -0500
Date: Tue, 21 Jan 2014 14:18:52 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140121221852.GT9037@kmo>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120113415.GE30183@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 12:34:15PM +0100, Peter Zijlstra wrote:
> On Mon, Jan 20, 2014 at 03:44:44AM +0000, Nicholas A. Bellinger wrote:
> > From: Kent Overstreet <kmo@daterainc.com>
> > 
> > This patch changes percpu_ida_alloc() + callers to accept task state
> > bitmask for prepare_to_wait() for code like target/iscsi that needs
> > it for interruptible sleep, that is provided in a subsequent patch.
> > 
> > It now expects TASK_UNINTERRUPTIBLE when the caller is able to sleep
> > waiting for a new tag, or TASK_RUNNING when the caller cannot sleep,
> > and is forced to return a negative value when no tags are available.
> > 
> > v2 changes:
> >   - Include blk-mq + tcm_fc + vhost/scsi + target/iscsi changes
> >   - Drop signal_pending_state() call
> 
> Urgh, you made me look at percpu_ida... steal_tags() does a
> for_each_cpus() with IRQs disabled. This mean you'll disable IRQs for
> multiple ticks on SGI class hardware. That is a _very_ long time indeed.

It's not that bad in practice - the looping is limited by the number of other
CPUs that actually have tags on their freelists - i.e. the CPUs that have
recently been using that block device or whatever the percpu_ida is for. And we
loop while cpu_have_tags is greater than some threshold (there's another debate
about that) - the intention is not to steal tags unless too many other CPUs have
tags on their local freelists.

That said, for huge SGI class hardware I think you'd want the freelists to not
be percpu, but rather be per core or something - that's probably a reasonable
optimization for most hardware anyways.

> Then there's alloc_global_tags() vs alloc_local_tags(), one gets an
> actual tag, while the other only moves tags about -- semantic mismatch.

Yeah, kind of. It is doing allocation, but not the same sort of allocation.

> I do not get the comment near prepare to wait -- why does it matter if
> percpu_ida_free() flips a cpus_have_tags bit?

Did I write that comment? It is a crappy comment...

Ok, in userspace we'd be using condition variables here, but this is the kernel
so we need to carefully order putting ourselves on a waitlist, and checking the
condition that determines whether we wait, and on the wakeup end changing things
that affect that condition and doing the wakeup. steal_tags() is checking the
condition that goes with the prepare_to_wait(), that's all.
