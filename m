Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3LMPmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:42:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45913 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab3LMPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:42:22 -0500
Date: Fri, 13 Dec 2013 16:42:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] sched/rt: Fix rq's cpupri leak while enqueue/dequeue
 child RT entities
Message-ID: <20131213154211.GP21999@twins.programming.kicks-ass.net>
References: <49231385567953@web4m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49231385567953@web4m.yandex.ru>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 07:59:13PM +0400, Kirill Tkhai wrote:
> This patch touches RT group scheduling case.
> 
> Functions inc_rt_prio_smp() and dec_rt_prio_smp() change (global) rq's priority,
> while rt_rq passed to them may be not the top-level rt_rq. This is wrong, because
> changing of priority on a child level does not guarantee that the priority is
> the highest all over the rq. So, this leak makes RT balancing unusable.
> 
> The short example: the task having the highest priority among all rq's RT tasks
> (no one other task has the same priority) are waking on a throttle rt_rq.
> The rq's cpupri is set to the task's priority equivalent, but real
> rq->rt.highest_prio.curr is less.
> 
> The patch below fixes the problem.
> 
> It looks like all version have this bug, so I CC'ed stable mailing list.

Yeah, I think this is right.

cpupri stuff should indeed only be changed for the top level group.
