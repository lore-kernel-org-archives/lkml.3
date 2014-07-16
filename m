Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaGQFYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 01:24:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:62453 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaGQFYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 01:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,676,1400050800"; 
   d="scan'208";a="457981447"
Date: Thu, 17 Jul 2014 05:22:02 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: bsegall@google.com
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "umgwanakikbuti@gmail.com" <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH 2/2 v3] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140716212202.GB2901@intel.com>
References: <1405475447-7783-1-git-send-email-yuyang.du@intel.com>
 <1405475447-7783-3-git-send-email-yuyang.du@intel.com>
 <20140716154614.GP26542@e103034-lin>
 <xm26lhrtw2xo.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xm26lhrtw2xo.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 11:53:23AM -0700, bsegall@google.com wrote:
> Morten Rasmussen <morten.rasmussen@arm.com> writes:
> 
> > On Wed, Jul 16, 2014 at 02:50:47AM +0100, Yuyang Du wrote:
> >
> > [...]
> >
> >> +/*
> >> + * Update load_avg of the cfs_rq along with its own se. They should get
> >> + * synchronized: group se's load_avg is used for task_h_load calc, and
> >> + * group cfs_rq's load_avg is used for task_h_load (and update_cfs_share
> >> + * calc).
> >> + */
> >> +static inline int update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
> >>  {
> >> -       long old_contrib = se->avg.load_avg_contrib;
> >> +       int decayed;
> >> 
> >> -       if (entity_is_task(se)) {
> >> -               __update_task_entity_contrib(se);
> >> -       } else {
> >> -               __update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
> >> -               __update_group_entity_contrib(se);
> >> +       if (atomic_long_read(&cfs_rq->removed_load_avg)) {
> >> +               long r = atomic_long_xchg(&cfs_rq->removed_load_avg, 0);
> >> +               cfs_rq->avg.load_avg = subtract_until_zero(cfs_rq->avg.load_avg, r);
> >> +               r *= LOAD_AVG_MAX;
> >> +               cfs_rq->avg.load_sum = subtract_until_zero(cfs_rq->avg.load_sum, r);
> >>         }
> >> 
> >> -       return se->avg.load_avg_contrib - old_contrib;
> >> -}
> >> +       decayed = __update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
> >> +#ifndef CONFIG_64BIT
> >> +       if (cfs_rq->avg.last_update_time != cfs_rq->load_last_update_time_copy)
> >> +               sa_q->last_update_time_copy = sa_q->last_update_time;
> >
> > to make it build. But I'm not convinced that this synchronization is
> > right.
> >
> > First let me say that I'm not an expert on synchronization. It seems to
> > me that there is nothing preventing reordering of the writes in
> > __update_load_avg() which sets cfs_rq->avg.last_update_time and the
> > update of cfs_rq->avg.load_last_update_time_copy.
> 
> You're correct, this needs to be if(...) { smp_wmb(); copy = time; },
> the same as update_min_vruntime.

Ok, I will get the barrier back. Thanks, Morten and Ben.

Yuyang
