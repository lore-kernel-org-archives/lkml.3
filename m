Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540AbaJaPhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:37:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbaJaPhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:37:32 -0400
Date: Fri, 31 Oct 2014 16:37:27 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@arm.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>
Subject: Re: [PATCH 5/6] sched/dl: reschedule if successfully pull earlier
 deadline task
Message-ID: <20141031153727.GT23531@worktop.programming.kicks-ass.net>
References: <1414374067-7209-1-git-send-email-wanpeng.li@linux.intel.com>
 <1414374067-7209-5-git-send-email-wanpeng.li@linux.intel.com>
 <5452110C.40108@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5452110C.40108@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:21:00AM +0000, Juri Lelli wrote:
> Peter, is the task_on_rq_queued() check for cases in which p is not
> enqueued but its class changes after a setscheduler/rt_mutex_setprio?

Yes, in particular if the task wasn't on the rq we won't change the rq
by changing the class and therefore we don't need to attempt to pull.

---
commit da7a735e51f9622eb3e1672594d4a41da01d7e4f
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Mon Jan 17 17:03:27 2011 +0100

    sched: Fix switch_from_fair()
    
    When a task is taken out of the fair class we must ensure the vruntime
    is properly normalized because when we put it back in it will assume
    to be normalized.
    
    The case that goes wrong is when changing away from the fair class
    while sleeping. Sleeping tasks have non-normalized vruntime in order
    to make sleeper-fairness work. So treat the switch away from fair as a
    wakeup and preserve the relative vruntime.
    
    Also update sysrq-n to call the ->switch_{to,from} methods.
    
    Reported-by: Onkalo Samu <samu.p.onkalo@nokia.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    LKML-Reference: <new-submission>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
