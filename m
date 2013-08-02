Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3HBIUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 04:20:35 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:31935 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab3HBIUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 04:20:31 -0400
Message-ID: <1375431605.8749.34.camel@j-VirtualBox>
Subject: Re: [RFC PATCH] sched: Reduce overestimating avg_idle
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, KML <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 01:20:05 -0700
In-Reply-To: <20130731095306.GY3008@twins.programming.kicks-ass.net>
References: <1375263472.3922.26.camel@j-VirtualBox>
	 <20130731095306.GY3008@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-31 at 11:53 +0200, Peter Zijlstra wrote:

> No they're quite unrelated. I think you can measure the max time we've
> ever spend in newidle balance and use that to clip the values.

So I tried using the rq's max newidle balance cost to compare with the
average and used sysctl_migration_cost as the initial/default max. One
thing I noticed when running this on 8 socket machine was that the max
idle balance cost was a lot higher during around boot time compared to
after boot time. Not sure if IRQ/NMI/SMI was the cause of this. A
temporary "fix" I made was to reset the max idle balance costs every 2
minutes.

> Similarly, I've thought about how we updated the sd->avg_cost in the
> previous patches and wondered if we should not track max_cost.
> 
> The 'only' down-side I could come up with is that its all ran from
> SoftIRQ context which means IRQ/NMI/SMI can all stretch/warp the time it
> takes to actually do the idle balance.

Another thing that I thought of was that max idle balance cost may also
vary based on the workload that is running. So running a workload in
which there are shorter idle balances after running a workload that has
longer idle balances may sometimes cause it to make use of a higher idle
balance cost. But I guess it is okay if we're trying to reduce
overrunning the average.

Jason

