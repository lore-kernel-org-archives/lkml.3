Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbaDVUBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:01:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:56028 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbaDVT6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:58:30 -0400
Date: Tue, 22 Apr 2014 15:23:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] sched/core: Skip wakeup when task is already running.
Message-ID: <20140422132353.GK11182@twins.programming.kicks-ass.net>
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com>
 <51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com>
 <20140415135326.GV11096@twins.programming.kicks-ass.net>
 <534E59FC.2090001@cn.fujitsu.com>
 <535658DB.2090801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535658DB.2090801@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 08:56:11PM +0900, Dongsheng Yang wrote:

> >On 04/15/2014 10:53 PM, Peter Zijlstra wrote:
> >>On Tue, Apr 15, 2014 at 09:32:53PM +0900, Dongsheng Yang wrote:
> >>
> >>How can you get there with ->state == RUNNING? try_to_wake_up*() bail
> >>when !(->state & state).

> Hi Peter, after some more investigation, I think I got the problem, which is
> that
> some other task set p->state to TASK_RUNNING without holding p->pi_lock.

That would be a plain bug, you're only ever allowed setting your own
->state, never someone else's. That is:

  for (;;) {
    set_current_state(TASK_INTERRUPTIBLE);
    if (cond)
      break;
    schedule();
  }
  __set_current_state(TASK_RUNNING);

Is the 'normal' way of blocking, and that is very much only touching its
own state. And in the above you cannot trigger the case you're seeing,
because the ->state = TASK_RUNNING, at the end, is _after_ its already
running, so we've completed the wakeup.

So I think you've spotted something rotten and we should catch/fix that.

Your backtrace only shows where we find ->state == TASK_RUNNING, not
where it became such.
