Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaF2HVI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 03:21:08 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41242 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbaF2HVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 03:21:06 -0400
Date: Sun, 29 Jun 2014 09:20:59 +0200
From: Andreas Mohr <andi@lisas.de>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, tkhai@yandex.ru,
        mingo@redhat.com
Subject: Re: [PATCH] sched: Transform resched_task() into resched_curr()
Message-ID: <20140629072059.GA18636@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I cannot speak too much about scheduler specifics, but from a structural POV
I'm unsure about such a change (into this direction).

We seem to be going from a nicely fine-grained function
(task-struct-specific, and thus operating on task scope alone,
except for interesting lockdep_assert_held() outer-env validation-only parts)
to one which has a *broader* scope (namely, wholly rq-parameterized),
thus now drawing the rq dependency into the equation:
this patch introduces access to rq->curr specifics *within
function implementation* (as the first measure within a function,
which in itself might be considered a smell),
and it needlessly widens the scope of concerns of this handler
by now enabling full access to any rq struct members there -
we'll then end up with the next guy introducing
some strange dependency on other rq parts within this handler
which that guy would not have been tempted to do in the first place
if it had remained strictly task-based......

I'd wager that the size benefit possibly dominantly stems from
getting rid of rq->curr indirection lookup at the many user call sites.
Thus it might be a good idea
to instead create a non-inlined resched_curr() wrapper
which merely forwards to resched_task(),
to have the currently strictly task-focussed (pun intended ;) approach
of resched_task() properly preserved.

Generally spoken, this incident and the "interesting" status quo
of very often doing an open-coded rq->curr lookup when calling resched_task()
could prompt a rethinking of relationship of task vs. rq,
since by clearing up (and focussing on) design intentions,
one could "automatically" end up
with more elegant and thus better function implementations.


Thank you for your activities in the scheduler area!

Andreas Mohr
