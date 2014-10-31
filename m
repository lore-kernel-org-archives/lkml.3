Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbaJaIaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 04:30:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaJaIa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 04:30:28 -0400
Date: Fri, 31 Oct 2014 09:30:22 +0100
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: IO request merging
Message-ID: <20141031083022.GA24172@quack.suse.cz>
References: <20141016122740.GI6085@quack.suse.cz>
 <543FEDFF.2000105@kernel.dk>
 <20141030195614.GL28444@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030195614.GL28444@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 30-10-14 20:56:14, Jan Kara wrote:
> On Thu 16-10-14 10:10:39, Jens Axboe wrote:
> > On 10/16/2014 06:27 AM, Jan Kara wrote:
> > >   Hello,
> > > 
> > >   one of our customers was complaining that elv_attempt_insert_merge()
> > > merges two requests (via blk_attempt_req_merge()) without asking IO
> > > scheduler for permission (->elevator_allow_merge_fn() callback). Now for
> > > them this is a problem because of their custom IO scheduler but looking
> > > into the code this can result in somewhat suboptimal behavior for CFQ as
> > > well (merging two requests from different IO contexts, possibly merging
> > > sync & async request). What do others think about this?
> > > 
> > > Regarding possible fix, we cannot really call ->elevator_allow_merge_fn()
> > > because that assumes it is called from a context of a process submitting the
> > > passed bio. So we would need to create a separate allow merge callback for
> > > this.
>   Sorry for a delayed reply, I was asking the customer for some more
> details and it took them a while to get back to me...
> 
> > It would need a new (rq to rq) merge hook, if they have a custom IO
> > scheduler, they should submit a change to allow that kind of behaviour.
>   OK, but since they would be the only ones using the hook, I don't think
> upstream kernel would be that much interested in carrying it... That's why
> I was asking whether CFQ wouldn't use the hook as well. But from what you
> write below, I tend to agree that it would be an overkill for CFQ.
> 
> > Outside of potentially mixing sync and async IO (which seems like
> > something that should rarely/never happen), not sure I see a lot of
> > downsides. And that case could be explicitly checked in attempt_merge()
> > or blk_attempt_req_merge() without having to define a new hook to catch
> > that specific case. For the hook, cfq would lookup the io contexts and
> > compare, and basically disallow any merge that crosses a cfq io context
> > boundary. But given that I would only expect these types of merges to
> > happen very rarely, the sync vs async check would be good enough for me.
>   Yeah. So what is a real problem for their custom scheduler is when two
> requests with different IO priorities get merged (BTW, ioprio_best() has
> a bug which they found and I just submitted a patch to fix it). For some
> reason they don't want requests with different priorities merged (even if
> resulting priority is computed properly). And we don't want checks like
> this in generic code.
  Thinking about it a bit more - is it really that beneficial to merge
requests with different priorities? I wouldn't expect that to happen often
enough to bring significant improvement in request sizes. Or do you have
some usecase for that?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
