Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaKCP3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:29:31 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42354 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaKCP31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:29:27 -0500
Date: Mon, 3 Nov 2014 16:29:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, kamalesh@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v8 07/10] sched: replace capacity_factor by usage
Message-ID: <20141103152900.GJ12706@worktop.programming.kicks-ass.net>
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org>
 <1414745252-4895-8-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414745252-4895-8-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 09:47:29AM +0100, Vincent Guittot wrote:
> @@ -6414,11 +6399,12 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>  	 */
>  	if (busiest->group_type == group_overloaded &&
>  	    local->group_type   == group_overloaded) {
> -		load_above_capacity =
> -			(busiest->sum_nr_running - busiest->group_capacity_factor);
> -
> -		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_CAPACITY_SCALE);
> -		load_above_capacity /= busiest->group_capacity;
> +		load_above_capacity = busiest->sum_nr_running *
> +					SCHED_LOAD_SCALE;
> +		if (load_above_capacity > busiest->group_capacity)
> +			load_above_capacity -= busiest->group_capacity;
> +		else
> +			load_above_capacity = ~0UL;
>  	}
>  
>  	/*

It seems to me we no longer have need to assume each task contributes
SCHED_LOAD_SCALE, do we?

But as it stands I tihnk this patch already does too much -- it could do
with a splitting, but let me stare at is a wee bit more.
