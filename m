Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364Ab3DBJuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:50:23 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45435 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265Ab3DBJuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:50:21 -0400
X-AuditID: 9c930179-b7b2aae000000518-32-515aa9dba1a7
Date: Tue, 2 Apr 2013 18:50:34 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 2/5] sched: factor out code to should_we_balance()
Message-ID: <20130402095034.GG16699@lge.com>
References: <1364457537-15114-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1364457537-15114-3-git-send-email-iamjoonsoo.kim@lge.com>
 <1364890206.16858.6.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364890206.16858.6.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Tue, Apr 02, 2013 at 10:10:06AM +0200, Peter Zijlstra wrote:
> On Thu, 2013-03-28 at 16:58 +0900, Joonsoo Kim wrote:
> > Now checking that this cpu is appropriate to balance is embedded into
> > update_sg_lb_stats() and this checking has no direct relationship to
> > this
> > function.
> > 
> > There is not enough reason to place this checking at
> > update_sg_lb_stats(),
> > except saving one iteration for sched_group_cpus.
> 
> Its only one iteration if there's only 2 groups, but there can be more
> than 2, take any desktop Intel i7, it will have 4-8 cores, each with
> HT; thus the CPU domain will have 4-8 groups.
> 
> And note that local_group is always the first group of a domain, so
> we'd stop the balance at the first group and avoid touching the other
> 3-7, avoiding touching cachelines on 6-14 cpus.
> 
> So this short-cut does make sense.. its not pretty, granted, but
> killing it doesn't seem right.

It seems that there is some misunderstanding about this patch.
In this patch, we don't iterate all groups. Instead, we iterate on
cpus of local sched_group only. So there is no penalty you mentioned.

In summary, net effect is below.

* For cpus which are not proper to balance,
Reduce function call,
Reduce memset

* For cpus which should balance
Extra one iteration on cpus of local sched_group in should_we_balance()
Reduce some branch, so expect better optimization

Thanks.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
