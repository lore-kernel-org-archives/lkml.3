Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaF2ID6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 04:03:58 -0400
Received: from forward7.mail.yandex.net ([77.88.61.37]:58070 "EHLO
	forward7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaF2IDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 04:03:53 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Jun 2014 04:03:53 EDT
X-Yandex-Uniq: 414d194f-6957-4af7-b325-2fc31fbd8e4f
Authentication-Results: smtp7.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <53AFC6FD.5070508@yandex.ru>
Date: Sun, 29 Jun 2014 11:57:49 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Subject: Re: [PATCH] sched: Transform resched_task() into resched_curr()
References: <20140629072059.GA18636@rhlx01.hs-esslingen.de>
In-Reply-To: <20140629072059.GA18636@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andreas,

On 29.06.2014 11:20, Andreas Mohr wrote:
> Hi,
> 
> I cannot speak too much about scheduler specifics, but from a structural POV
> I'm unsure about such a change (into this direction).
> 
> We seem to be going from a nicely fine-grained function
> (task-struct-specific, and thus operating on task scope alone,
> except for interesting lockdep_assert_held() outer-env validation-only parts)
> to one which has a *broader* scope (namely, wholly rq-parameterized),
> thus now drawing the rq dependency into the equation:
> this patch introduces access to rq->curr specifics *within
> function implementation* (as the first measure within a function,
> which in itself might be considered a smell),
> and it needlessly widens the scope of concerns of this handler
> by now enabling full access to any rq struct members there -
> we'll then end up with the next guy introducing
> some strange dependency on other rq parts within this handler
> which that guy would not have been tempted to do in the first place
> if it had remained strictly task-based......
> 
> I'd wager that the size benefit possibly dominantly stems from
> getting rid of rq->curr indirection lookup at the many user call sites.
> Thus it might be a good idea
> to instead create a non-inlined resched_curr() wrapper
> which merely forwards to resched_task(),
> to have the currently strictly task-focussed (pun intended ;) approach
> of resched_task() properly preserved.
> 
> Generally spoken, this incident and the "interesting" status quo
> of very often doing an open-coded rq->curr lookup when calling resched_task()
> could prompt a rethinking of relationship of task vs. rq,
> since by clearing up (and focussing on) design intentions,
> one could "automatically" end up
> with more elegant and thus better function implementations.

resched_curr(rq) means "to reschedule current task of the rq". It does
not reschedule rq itself.

We already have resched_cpu(), which has cpu agrument, and it's not
a task. I think this is just a similar case and we won't have any
problems because of this.

We only can reschedule the current task, and the patch underlines that fact.

> 
> 
> Thank you for your activities in the scheduler area!
> 
> Andreas Mohr
> 

Thanks,
Kirill
