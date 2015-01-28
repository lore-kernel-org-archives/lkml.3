Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760646AbbA1UfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:35:19 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:51484 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760590AbbA1UfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:35:16 -0500
Date: Wed, 28 Jan 2015 16:46:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 4/4] sched: Account PREEMPT_ACTIVE context as atomic
Message-ID: <20150128154637.GI23038@twins.programming.kicks-ass.net>
References: <1422404652-29067-1-git-send-email-fweisbec@gmail.com>
 <1422404652-29067-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422404652-29067-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 01:24:12AM +0100, Frederic Weisbecker wrote:
> PREEMPT_ACTIVE implies non-preemptible context and thus atomic context
> despite what in_atomic*() APIs reports about it. These functions
> shouldn't ignore this value like they are currently doing.
> 
> It appears that these APIs were ignoring PREEMPT_ACTIVE in order to
> ease the check in schedule_debug(). Meanwhile it is sufficient to rely
> on PREEMPT_ACTIVE in order to disable preemption in __schedule().
> 
> So lets fix the in_atomic*() APIs and simplify the preempt count ops
> on __schedule() callers.

So what I think the history is here is that PREEMPT_ACTIVE is/was seen
as a flag, protecting recursion, not so much a preempt-disable.

By doing this, you loose that separation.

Note that (at least on x86) we have another flag in the preempt count.

And I don't think the generated code really changes, the only difference
is the value added/subtracted and that's an encoded immediate I think.
