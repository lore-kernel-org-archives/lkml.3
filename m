Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3HUCUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:20:04 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59996 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3HUCUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:20:02 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-96-521423cfaf9d
Date: Wed, 21 Aug 2013 11:20:02 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 04/10] sched, fair: Shrink sg_lb_stats and play memset
 games
Message-ID: <20130821022002.GC6142@lge.com>
References: <20130819160058.539049611@infradead.org>
 <20130819160425.310264395@infradead.org>
 <20130821020829.GA6142@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821020829.GA6142@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:08:29AM +0900, Joonsoo Kim wrote:
> On Mon, Aug 19, 2013 at 06:01:02PM +0200, Peter Zijlstra wrote:
> > +static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
> > +{
> > +	/*
> > +	 * struct sd_lb_stats {
> > +	 *	   struct sched_group *       busiest;             //     0  8
> > +	 *	   struct sched_group *       this;                //     8  8
> > +	 *	   long unsigned int          total_load;          //    16  8
> > +	 *	   long unsigned int          total_pwr;           //    24  8
> > +	 *	   long unsigned int          avg_load;            //    32  8
> > +	 *	   struct sg_lb_stats {
> > +	 *		   long unsigned int  avg_load;            //    40  8
> > +	 *		   long unsigned int  group_load;          //    48  8
> > +	 *	           ...
> > +	 *	   } busiest_stat;                                 //    40 56
> > +	 *	   struct sg_lb_stats	      this_stat;	   //    96 56
> > +	 *
> > +	 *	   // size: 152, cachelines: 3, members: 7
> > +	 *	   // last cacheline: 24 bytes
> > +	 * };
> > +	 *
> > +	 * Skimp on the clearing to avoid duplicate work. We can avoid clearing
> > +	 * this_stat because update_sg_lb_stats() does a full clear/assignment.
> > +	 * We must however clear busiest_stat::avg_load because
> > +	 * update_sd_pick_busiest() reads this before assignment.
> > +	 */
> > +	memset(sds, 0, offsetof(struct sd_lb_stats, busiest_stat.group_load));
> 
> Hello, Peter.
> 
> IMHO, this is so tricky.
> With below change, we can simply do 'offsetof(struct sd_lb_stats, busiest_stat)'.
> 
> @@ -4546,7 +4546,7 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>                                    struct sched_group *sg,
>                                    struct sg_lb_stats *sgs)
>  {
> -       if (sgs->avg_load <= sds->busiest_stat.avg_load)
> +       if (!sds->busiest && sgs->avg_load <= sds->busiest_stat.avg_load)
>                 return false;
>  
>         if (sgs->sum_nr_running > sgs->group_capacity)
> 

Sorry, instead of !sds->busiest, it should be sds->busiest. :)

Thanks.

