Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3HZLtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:49:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34931 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab3HZLtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:49:11 -0400
Date: Mon, 26 Aug 2013 13:46:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 04/10] sched, fair: Shrink sg_lb_stats and play memset
 games
Message-ID: <20130826114643.GJ31370@twins.programming.kicks-ass.net>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.310264395@infradead.org>
 <CAPM31R+xvAeD6401cZKNOzS4yZhcTLL-4kWbDVpYsamnMixMKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31R+xvAeD6401cZKNOzS4yZhcTLL-4kWbDVpYsamnMixMKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 03:15:57AM -0700, Paul Turner wrote:
> > +static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
> > +{
> > +       /*
> > +        * struct sd_lb_stats {
> > +        *         struct sched_group *       busiest;             //     0  8
> > +        *         struct sched_group *       this;                //     8  8
> > +        *         long unsigned int          total_load;          //    16  8
> > +        *         long unsigned int          total_pwr;           //    24  8
> > +        *         long unsigned int          avg_load;            //    32  8
> > +        *         struct sg_lb_stats {
> > +        *                 long unsigned int  avg_load;            //    40  8
> > +        *                 long unsigned int  group_load;          //    48  8
> > +        *                 ...
> > +        *         } busiest_stat;                                 //    40 56
> > +        *         struct sg_lb_stats         this_stat;           //    96 56
> > +        *
> > +        *         // size: 152, cachelines: 3, members: 7
> > +        *         // last cacheline: 24 bytes
> > +        * };
> > +        *
> > +        * Skimp on the clearing to avoid duplicate work. We can avoid clearing
> > +        * this_stat because update_sg_lb_stats() does a full clear/assignment.
> > +        * We must however clear busiest_stat::avg_load because
> > +        * update_sd_pick_busiest() reads this before assignment.
> > +        */
> 
> Does gcc seriously not get this right if we just write:
>   sds->busiest = NULL;
>   sds->local = NULL;
>   ....
> 
> etc.?

There's a thought ;-) How about something like this?

 sds = (struct sd_lb_stats){
 	.busiest = NULL,
	.local = NULL,

	.busiest_stat = {
		.avg_load = 0,
	},
 };

C99 named initializers should ignore all unmentioned fields, and I think
we don't actually touch any of the other fields unless something is set.

