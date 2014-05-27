Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaE0T5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:57:03 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45504 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaE0T5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:57:01 -0400
Date: Tue, 27 May 2014 12:56:57 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: block: flush queued bios when the process blocks
Message-ID: <20140527195657.GE2276@kmo>
References: <alpine.LRH.2.02.1405271059190.27492@file01.intranet.prod.int.rdu2.redhat.com>
 <5384AA79.4010206@kernel.dk>
 <alpine.LRH.2.02.1405271120390.31404@file01.intranet.prod.int.rdu2.redhat.com>
 <5384B26D.1000703@kernel.dk>
 <alpine.LRH.2.02.1405271222150.8745@file01.intranet.prod.int.rdu2.redhat.com>
 <20140527173306.GA12201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140527173306.GA12201@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 01:33:06PM -0400, Mike Snitzer wrote:
> On Tue, May 27 2014 at 12:26pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > On Tue, 27 May 2014, Jens Axboe wrote:
> > 
> > > On 2014-05-27 09:23, Mikulas Patocka wrote:
> > > 
> > > > The patch adds bio list flushing to the scheduler just besides plug
> > > > flushsing.
> > > 
> > > ... which is exactly why I'm commenting. It'd be great to avoid yet one more
> > > scheduler hook for this sort of thing.
> > > 
> > > -- 
> > > Jens Axboe
> > 
> > One could create something like schedule notifier chain, but I'm not sure 
> > if it is worth the complexity because of just two users. If more users 
> > come in the future, it could be generalized.
> 
> It could be that Jens is suggesting updating blk_needs_flush_plug() and
> blk_schedule_flush_plug() to be bio_list aware too (rather than train
> sched_submit_work() from this new bio_list)?
> 
> Somewhat awkward, but _could_ be made to work.

No...

I started on this ages and ages ago, but the patches were nowhere near ready to
go out.

What I'd do is rework the existing blk_plug to work in terms of bios, not
requests. This is a fair amount of work, and then make_request_fn() needs to be
able to take multiple bios at a time, but IIRC there were other simplifications
that fell out of this and this also means bio based drivers can take advantage
of plugging/batching.

Once this is done, you just... replace the bio list in generic_make_request()
with a plug. Boom, done.

(oh, and to avoid blowing the stack the scheduler/plug callback or whatever
needs to check the current stack usage and punt off to a per request_queue
workqueue, but that's easy enough).
