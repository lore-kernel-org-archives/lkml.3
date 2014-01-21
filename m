Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbaAUQGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:06:21 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:49909 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbaAUQGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:06:19 -0500
Message-ID: <1390319905.20232.38.camel@bobble.lax.corp.google.com>
Subject: Crash in elevator_dispatch_fn() (e.g. deadline_dispatch()) when
 changing elevators.
From: Frank Mayhar <fmayhar@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Date: Tue, 21 Jan 2014 07:58:25 -0800
In-Reply-To: <20140118143145.GD3640@htj.dyndns.org>
References: <1389995976.20232.27.camel@bobble.lax.corp.google.com>
	 <20140118143145.GD3640@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-18 at 09:31 -0500, Tejun Heo wrote:
> Hello, Frank.
> 
> On Fri, Jan 17, 2014 at 01:59:36PM -0800, Frank Mayhar wrote:
> > After investigation, it's clear that the elevator switch code is trying
> > to quiesce the request queue and sets the bypass flag.  Unfortunately,
> > scsi_mode_sense() and friends call blk_execute_rq() directly, which pays
> > no attention to said flag.
> 
> Ouch.
> 
> > In fact, the bypass flag, as far as I can tell, is only checked in the
> > blk_cgroup.c, in blkg_lookup() and blkg_lookup_create().
> 
> Hmmm?  IIRC the main place is in __get_request().  If the queue is
> bypassing, the request doesn't get REQ_ELVPRIV which basically
> indicates that the request shouldn't go through elevator.  I don't
> think that part is broken even for scsi_execute_rq() - it uses
> blk_get_request() which should handle it properly.
> 
> > So my question is:  Is this a simple oversight?  Should blk_execute_rq()
> 
> Yeah, it's a bug.  It's not supposed to crash like that.

Clearly. :-)

> > care about the bypass flag?  Should it perhaps hold off the I/O until
> > the bypass flag is cleared?  Since at that level it has nothing to do
> > with cgroups I kinda don't think so but I'm still trying to get my head
> > around how all this stuff goes together.
> 
> The cgroup part isn't really relevant.  That's just because cgroup
> also uses bypassing to quiesce the queue when it's changing blkcg
> policies.  The thing relevant to the elveator is the check in
> __get_request().
> 
> Hmm.... the culprit is that we don't have any check in the dispatch
> path.  It doesn't really matter who's calling blk_peek_request(), that
> function is called as part of all request dispatches and should never
> crash.  I think the only reason we haven't noticed yet is because
> calling evelator dispatch_fn doesn't crash in most cases even if the
> elevator isn't in fully working condition.
> 
> Probably what we need is replacing blk_queue_dying() with
> blk_queue_bypass() test in __elv_next_request() before invoking the
> elevator dispatch function.

Replacing?  Or adding to?  Is BYPASS always set when DYING is set?  (My
guess is not but I haven't done an exhaustive analysis.)  So the
relevant code snippet in __elv_next_request() would be:
		if (unlikely(blk_queue_dying(q)) ||
		    unlikely(blk_queue_bypass(q)) ||
		    !q->elevator->type->ops.elevator_dispatch_fn(q, 0))
			return NULL;

> Can you please reply w/ Jens and lkml cc'd with the original
> description and my response?  No reason to keep this private.

Sure, doing so.  I just wanted to make sure my understanding was correct
before bringing others into it.

> Thanks a lot for the report!

No problem.  Thanks for the quick response.  Sorry for my
three-day-weekend-delayed reply. :-)


Jens, others, my original email follows:

> Hey, Tejun.  I have a question about stuff going on in the block layer
> that's not quite as straightforward as one might wish.  We have a
> situation in which we need to use something other than the CFQ I/O
> scheduler so after we create a block device (iSCSI, as it happens) we
> switch it to use the deadline scheduler.  Unfortunately we've run into a
> crash when we do this in which a request completion (in some cases) or a
> sync I/O (in others) calls blk_peek_request() which in turn calls
> __elv_next_request() which in its turn calls
> q->elevator->type->ops.elevator_dispatch_fn(), which happens at the
> point of the call be deadline_dispatch_requests(), which promptly falls
> over because we're in the middle of the elevator switch and
> q->elevator->elevator_data is NULL.
> 
> After investigation, it's clear that the elevator switch code is trying
> to quiesce the request queue and sets the bypass flag.  Unfortunately,
> scsi_mode_sense() and friends call blk_execute_rq() directly, which pays
> no attention to said flag.
> 
> In fact, the bypass flag, as far as I can tell, is only checked in the
> blk_cgroup.c, in blkg_lookup() and blkg_lookup_create().
> 
> So my question is:  Is this a simple oversight?  Should blk_execute_rq()
> care about the bypass flag?  Should it perhaps hold off the I/O until
> the bypass flag is cleared?  Since at that level it has nothing to do
> with cgroups I kinda don't think so but I'm still trying to get my head
> around how all this stuff goes together.
> 
> Any hints would be _greatly_ appreciated.  Thanks!
-- 
Frank Mayhar
310-460-4042

