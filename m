Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3EFPGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:06:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49479 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab3EFPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:06:16 -0400
Date: Mon, 6 May 2013 17:04:28 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: Alex Shi <alex.shi@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 6/7] sched: consider runnable load average in
 move_tasks
Message-ID: <20130506150428.GD15446@dyad.programming.kicks-ass.net>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-7-git-send-email-alex.shi@intel.com>
 <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 01:53:44AM -0700, Paul Turner wrote:
> On Sun, May 5, 2013 at 6:45 PM, Alex Shi <alex.shi@intel.com> wrote:
> > Except using runnable load average in background, move_tasks is also
> > the key functions in load balance. We need consider the runnable load
> > average in it in order to the apple to apple load comparison.
> >
> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> > ---
> >  kernel/sched/fair.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 0bf88e8..790e23d 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -3966,6 +3966,12 @@ static unsigned long task_h_load(struct task_struct *p);
> >
> >  static const unsigned int sched_nr_migrate_break = 32;
> >
> > +static unsigned long task_h_load_avg(struct task_struct *p)
> > +{
> > +       return div_u64(task_h_load(p) * (u64)p->se.avg.runnable_avg_sum,
> > +                       p->se.avg.runnable_avg_period + 1);
> 
> Similarly, I think you also want to at least include blocked_load_avg here.

I'm puzzled, this is an entity weight. Entity's don't have blocked_load_avg.

The purpose here is to compute the amount of weight that's being moved by this
task; to subtract from the imbalance.
