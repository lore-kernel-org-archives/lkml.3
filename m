Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026Ab3IDGDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 02:03:05 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18358 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3IDGDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 02:03:04 -0400
Message-ID: <1378274579.3004.9.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v4 3/3] sched: Periodically decay max cost of idle
 balance
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        pjt@google.com, preeti@linux.vnet.ibm.com, akpm@linux-foundation.org,
        mgorman@suse.de, riel@redhat.com, aswin@hp.com, scott.norton@hp.com,
        srikar@linux.vnet.ibm.com
Date: Tue, 03 Sep 2013 23:02:59 -0700
In-Reply-To: <20130830102941.GF10002@twins.programming.kicks-ass.net>
References: <1377806736-3752-1-git-send-email-jason.low2@hp.com>
	 <1377806736-3752-4-git-send-email-jason.low2@hp.com>
	 <20130830101817.GE10002@twins.programming.kicks-ass.net>
	 <20130830102941.GF10002@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 12:29 +0200, Peter Zijlstra wrote:
>  	rcu_read_lock();
>  	for_each_domain(cpu, sd) {
> +		/*
> +		 * Decay the newidle max times here because this is a regular
> +		 * visit to all the domains. Decay ~0.5% per second.
> +		 */
> +		if (time_after(jiffies, sd->next_decay_max_lb_cost)) {
> +			sd->max_newidle_lb_cost =
> +				(sd->max_newidle_lb_cost * 254) / 256;

I initially picked 0.5%, but after trying it out, it appears to decay very
slowing when the max is at a high value. Should we increase the decay a
little bit more? Maybe something like:

sd->max_newidle_lb_cost = (sd->max_newidle_lb_cost * 63) / 64;

> +		/*
> +		 * Stop the load balance at this level. There is another
> +		 * CPU in our sched group which is doing load balancing more
> +		 * actively.
> +		 */
> +		if (!continue_balancing) {

Is "continue_balancing" named "balance" in older kernels?

Here are the AIM7 results with the other 2 patches + this patch with the
slightly higher decay value.

----------------------------------------------------------------
workload     | % improvement   | % improvement  | % improvement
             | with patch      | with patch     | with patch
             | 1100-2000 users | 200-1000 users | 10-100 users
----------------------------------------------------------------
alltests     |  +9.2%          |  +5.2%         |  +0.3%
----------------------------------------------------------------
compute      |  +0.0%          |  -0.9%         |  +0.6%
----------------------------------------------------------------
custom       | +18.6%          | +15.3%         |  +7.0%
----------------------------------------------------------------
disk         |  +4.0%          | +16.5%         |  +7.1%
----------------------------------------------------------------
fserver      | +64.8%          | +27.5%         |  -0.6%
----------------------------------------------------------------
high_systime | +15.1%          |  +7.9%         |  +0.0%
----------------------------------------------------------------
new_fserver  | +51.0%          | +20.1%         |  -1.3%
----------------------------------------------------------------
shared       |  +6.3%          |  +8.8%         |  +2.8%
----------------------------------------------------------------


