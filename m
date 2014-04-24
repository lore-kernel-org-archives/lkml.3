Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaDXQxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:53:46 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:7062 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbaDXQxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:53:45 -0400
X-Greylist: delayed 55370 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 12:53:45 EDT
Message-ID: <1398358417.3509.11.camel@j-VirtualBox>
Subject: Re: [PATCH 1/3] sched, balancing: Update rq->max_idle_balance_cost
 whenever newidle balance is attempted
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, daniel.lezcano@linaro.org,
        alex.shi@linaro.org, efault@gmx.de, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com, aswin@hp.com, chegu_vinod@hp.com
Date: Thu, 24 Apr 2014 09:53:37 -0700
In-Reply-To: <20140424124438.GT13658@twins.programming.kicks-ass.net>
References: <1398303035-18255-1-git-send-email-jason.low2@hp.com>
	 <1398303035-18255-2-git-send-email-jason.low2@hp.com>
	 <5358E417.8090503@linux.vnet.ibm.com>
	 <20140424120415.GS11096@twins.programming.kicks-ass.net>
	 <20140424124438.GT13658@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-24 at 14:44 +0200, Peter Zijlstra wrote:
> On Thu, Apr 24, 2014 at 02:04:15PM +0200, Peter Zijlstra wrote:
> > On Thu, Apr 24, 2014 at 03:44:47PM +0530, Preeti U Murthy wrote:
> > > What about the update of next_balance field? See the code snippet below.
> > > This will also be skipped as a consequence of the commit e5fc6611 right?
> > > 
> > > 	   if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
> > >                  /*
> > >                   * We are going idle. next_balance may be set based on
> > >                   * a busy processor. So reset next_balance.
> > >                   */
> > >                  this_rq->next_balance = next_balance;
> > >          }
> > > 
> > > Also the comment in the above snippet does not look right to me.
> > > It says "we are going idle" but the condition checks for pulled_task.
> > 
> > Yeah, that's odd indeed. Ingo did that back in dd41f596cda0d, I suspect
> > its an error, but..
> > 
> > So I think that should become !pulled_task || time_after().
> 
> Hmm, no, I missed that the for_each_domain() loop pushes next_balance
> ahead if it did a balance on the domain.
> 
> So it actually makes sense and the comment is wrong, but then you're
> also right that we want to not skip that.

Hi Preeti, Peter,

So I thought that the original rationale (commit 1bd77f2d) behind
updating rq->next_balance in idle_balance() is that, if we are going
idle (!pulled_task), we want to ensure that the next_balance gets
calculated without the busy_factor.

If the rq is busy, then rq->next_balance gets updated based on
sd->interval * busy_factor. However, when the rq goes from "busy"
to idle, rq->next_balance might still have been calculated under
the assumption that the rq is busy. Thus, if we are going idle, we
would then properly update next_balance without the busy factor
if we update when !pulled_task.

