Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204AbaDADKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:10:20 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58955 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaDADKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:10:18 -0400
Message-ID: <1396321814.5324.27.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 01 Apr 2014 05:10:14 +0200
In-Reply-To: <20140331160003.GD19658@home.goodmis.org>
References: <1396164244.28950.15.camel@marge.simpson.net>
	 <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
	 <1396239636.5361.57.camel@marge.simpson.net>
	 <20140331160003.GD19658@home.goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-31 at 12:00 -0400, Steven Rostedt wrote: 
> On Mon, Mar 31, 2014 at 06:20:36AM +0200, Mike Galbraith wrote:
> > 
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
> > ---
> >  kernel/sched/core.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -118,7 +118,7 @@ void update_rq_clock(struct rq *rq)
> >  {
> >  	s64 delta;
> >  
> 
> Mike,
> 
> If I understand this code correctly, skip_clock_update gets set to one,
> where it should skip the next call to update_rq_clock(), but only the
> next skip_clock_update(), and after that, it should resume calling it again.
> Is that correct?

Yeah, it's supposed to prevent us from doing back to back fastpath
update + math for no good reason.  Actually, decrement isn't perfect,
simple set/clear is.. iff we are really headed to schedule() RSN.  Tick
time clear would bound error too.

Maybe it should just die as more potential trouble than it's worth.  It
has saved a pile of fastpath cycles, losing those again would be a
shame.  Accounting doesn't need to be perfect (is the enemy of good),
but it does need to be a guaranteed good.

-Mike

