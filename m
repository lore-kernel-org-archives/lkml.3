Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3HVLKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:10:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51362 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3HVLKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:10:31 -0400
Date: Thu, 22 Aug 2013 13:10:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3] sched: Limit idle balance based on max cost per
 sched domain
Message-ID: <20130822111027.GJ31370@twins.programming.kicks-ass.net>
References: <1376991166.1753.8.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376991166.1753.8.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 02:32:46AM -0700, Jason Low wrote:
> Hi Peter,
> 
> So this is my sample implementation of the concept of matching the CPU's avg_idle 
> with the maximum time we ever spend in a new idle load balance for each domain.
> This is based on our previous patch which compares avg_idle with sd->avg_cost,
> but I replaced sd->avg_cost with sd->max_cost.
> 
> Since we are comparing avg_idle with sd->max_cost, the existing avg_idle would 
> not be accurate since it is limited based on migration_cost, so I increased the 
> max avg_idle to 25*sched_migration_cost.

One thing we can do is make that independent of sched_migration_cost and
stretch it dynamically to be 2*max_idle_balance_cost or somesuch. That
would avoid the magic number and make it work for machines that are much
'slower' than yours as well.

> Additionally, I updated avg_idle by 
> calling update_avg() first. Then if the avg_idle exceeds the max, the avg_idle 
> is set to the max. This is to prevent avg_idle from being set to the maximum 
> after 1 long idle.

Fully agreed, this is something we should do regardless -- for as long
as we preserve the avg_idle() machinery anyway :-)

> Since I have found idle balance to be beneficial when it is not failing to move 
> tasks, I was thinking we can also not skip newidle balance (regardless of what 
> avg_idle and max_cost are) if the previous attempt on the rq or domain 
> succeeded in moving tasks. I was also wondering if we should periodically reset
> the max cost. Both would require an extra field to be added to either the
> rq or domain structure though.

I think both ideas are good things to try; but I would like them to be
follow-up patches. I'm not worried too much about growing either
structures.

The thing you 'forgot' to mention is if this patch actually helps you
workload?
