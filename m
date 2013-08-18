Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3HRQnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 12:43:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab3HRQnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 12:43:00 -0400
Date: Sun, 18 Aug 2013 18:36:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130818163639.GA20393@redhat.com>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com> <1376667753-29014-3-git-send-email-fweisbec@gmail.com> <20130816160201.GA31682@redhat.com> <20130816162056.GE24210@somewhere> <20130816162654.GA453@redhat.com> <20130816164626.GH24210@somewhere> <20130816164922.GA1573@redhat.com> <20130816171208.GJ24210@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130816171208.GJ24210@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16, Frederic Weisbecker wrote:
>
> On Fri, Aug 16, 2013 at 06:49:22PM +0200, Oleg Nesterov wrote:
> >
> > Personally I am fine either way.
>
> Me too.
>
> So my proposition is that we can keep the existing patches as they fix other distinct races

perhaps... but it would be nice to fix the "goes backward" problem.

This "race" is not theoretical, at least for get_cpu_iowait_time_us().
nr_iowait_cpu() can change from !0 to 0 very easily.

And just in case, note that get_cpu_idle_time_us() has the same problem
too, because it can also change from 0 to !0 although this case is much
less likely.

However, right now I do not see a simple solution. It seems that, if
get_cpu_idle_time_us() does ktime_add(ts->idle_sleeptime) it should
actually update ts->idle_sleeptime/entrytime to avoid these races
(the same for ->idle_sleeptime), but then we need the locking.

> (and we add fixes on what peterz just reported)

Do you mean his comments about 4/4 or I missed something else?

> Ah and I'll wait for
> your review first.

If only I could understand this code ;) It looks really simple and
I hope I can understand what it does. But not why. I simply can't
understand why idle/iowait are "mutually exclusive".

And if we do this,  then perhaps io_schedule() should do
"if (atomic_dec(&rq->nr_iowait)) update_iowait_sleeptime()" but
this means the locking again.

> Then if all goes well on the pull request we describe him the nr_iowait race and we let him
> choose what to do with that nr_iowait migration race:

OK, agreed.

> Or may be Peter could tell us as well. Peter, do you have a preference?

Yes, it would be nice to know what Peter thinks ;)

Oleg.

