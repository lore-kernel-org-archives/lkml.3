Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926Ab3ICVGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:06:38 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:38423 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760742Ab3ICVGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:06:36 -0400
Message-ID: <1378242394.3460.37.camel@j-VirtualBox>
Subject: Re: [PATCH v4 2/3] sched: Consider max cost of idle balance per
 sched domain
From: Jason Low <jason.low2@hp.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        efault@gmx.de, pjt@google.com, preeti@linux.vnet.ibm.com,
        akpm@linux-foundation.org, mgorman@suse.de, riel@redhat.com,
        aswin@hp.com, scott.norton@hp.com
Date: Tue, 03 Sep 2013 14:06:34 -0700
In-Reply-To: <20130902065446.GV1720@linux.vnet.ibm.com>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
	 <1377806736-3752-3-git-send-email-jason.low2@hp.com>
	 <20130902065446.GV1720@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 12:24 +0530, Srikar Dronamraju wrote:
> If we face a runq lock contention, then domain_cost can go up.
> The runq lock contention could be temporary, but we carry the domain
> cost forever (i.e till the next reboot).  How about averaging the cost +
> penalty for unsuccessful balance.
> 
> Something like 
> 			domain_cost = sched_clock_cpu(smp_processor_id()) - t0;
> 			if (!pulled_task)
> 				domain_cost *= 2;
> 		
> 			sd->max_newidle_lb_cost += domain_cost;
> 			sd->max_newidle_lb_cost /= 2;
> 				
> 				
> Maybe the name could then change to avg_newidle_lb_cost.
> 
> > +
> > +			curr_cost += domain_cost;
> >  		}
> > 

We tried keeping track of the avg in the v2 patch. It didn't really help
reduce the contention in idle balancing and we needed to also reduce
avg_idle by a factor of 10-20+ when comparing it to
avg_idle_balance_cost in order to get the good performance boosts.

One potential explanation why is that avg idle balance cost can often
have a large variation. That would make both computing the avg_idle and
comparing avg_idle with avg idle balance cost to not really be
consistent.

I think using the max allows us to keep the cost at a more constant rate
so that we can more meaningfully compare avg_idle with respect to "idle
balance cost". It also helps reduce the chance avg_idle overruns the
balance cost. Patch 3 reduces the max cost so that the value isn't kept
until the next reboot.

