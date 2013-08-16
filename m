Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab3HPQkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:40:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab3HPQkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:40:46 -0400
Date: Fri, 16 Aug 2013 18:33:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130816163355.GA766@redhat.com>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-3-git-send-email-fweisbec@gmail.com> <20130816160201.GA31682@redhat.com> <20130816163217.GF24210@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816163217.GF24210@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Frederic Weisbecker wrote:
>
> On Fri, Aug 16, 2013 at 06:02:01PM +0200, Oleg Nesterov wrote:
> >
> > Unless I missread this patch, this is still racy a bit.
> >
> > Suppose it is called on CPU_0 and cpu == 1. Suppose that
> > ts->idle_active == T and nr_iowait_cpu(cpu) == 1.
> >
> > So we return iowait_sleeptime + delta.
> >
> > Suppose that we call get_cpu_iowait_time_us() again. By this time
> > the task which incremented ->nr_iowait can be woken up on another
> > CPU, and it can do atomic_dec(rq->nr_iowait). So the next time
> > we return iowait_sleeptime, and this is not monotonic again.
> >
> > No?
>
> OTOH, io_schedule() does:
>
>       atomic_inc(&rq->nr_iowait);
>       schedule();
>       atomic_dec(&rq->nr_iowait);
>
> How do we handle that when the task is migrated after it goes to sleep?

or even before it goes to sleep. This is what I meant.

> I don't either see that iowait tasks can't be migrated.

But probably this is fine? This is just the non-precise accounting.

But otoh, I agree. The whole idea about per-cpu nr_iowait looks a
bit strange.

Oleg.

