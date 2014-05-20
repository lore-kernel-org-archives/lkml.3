Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067AbaETUIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 16:08:34 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:53273 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaETUId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 16:08:33 -0400
Date: Tue, 20 May 2014 22:08:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 5/5] workqueue: Allow modifying low level unbound
 workqueue cpumask
Message-ID: <20140520200828.GG17741@localhost.localdomain>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <1400257015-28222-6-git-send-email-fweisbec@gmail.com>
 <20140516205050.GM5379@htj.dyndns.org>
 <20140520193253.GF17741@localhost.localdomain>
 <20140520195656.GA5586@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520195656.GA5586@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 03:56:56PM -0400, Tejun Heo wrote:
> > > Hmmm... but there's nothing which makes rolling back more likely to
> > > succeed compared to the original applications.  It's gonna allocate
> > > more pwqs.  Triggering WARN_ON_ONCE() seems weird.
> > 
> > Yeah but that's the least we can do. If we fail to even recover the old cpumask,
> > the user should know about the half state fail.
> 
> I'm failing to see how it'd be better than just going through applying
> the new mask if we're likely to end up with half-updated states
> anyway.  What's the point of another layer of best effort logic which
> is more likely to fail?

If the error is -ENOMEM then yeah, but any other error wants rollback.

> > But it's going to imply fun with double linked list of struct pwq_allocation_object
> > and stuff. Or maybe an array. This reminds be a bit generate_sched_domains(). It's
> > not going to be _that_ simple nor pretty :)
> 
> Is it tho?  Don't we just need to keep a separate staging copy of
> prepared pwq_tbl?  The commit stage can be pwq_tbl installation.
> Looks like it shouldn't be too much of problem.  Am I missing
> something?

Sure, that still need an iteration array/list of pre-allocated objects.
Expect at least one more hundred lines.

> 
> > > 2. Proper error handling is hard.  Just do pr_warn() on each failure
> > >    and continue to try to apply and always return 0.
> > > 
> > > If #1 isn't too complicated (would it be?), it'd be the better option;
> > > otherwise, well, #2 should work most of the time, eh?
> > 
> > Yeah I think #2 should be way enough 99% of the time :)
> 
> Yeah, if #1 gets too hairy, #2 can be a reluctant option but if #1 is
> doable without too much complication, I'd much prefer proper error
> handling.

I can try yeah.
