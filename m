Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab3HLLB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 07:01:26 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39269 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab3HLLBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 07:01:23 -0400
Date: Mon, 12 Aug 2013 16:30:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Jason Low <jason.low2@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com, "Bui, Tuan" <tuan.d.bui@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Makphaibulchoke, Thavatchai" <thavatchai.makpahibulchoke@hp.com>,
        "Bueso, Davidlohr" <davidlohr.bueso@hp.com>
Subject: Re: [PATCH] sched: Give idle_balance() a break when it does not move
 tasks.
Message-ID: <20130812110045.GA1925@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1376296970.1795.9.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1376296970.1795.9.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081211-4834-0000-0000-00000A12A098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	/*
> @@ -5298,6 +5300,8 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  			continue;
> 
>  		if (sd->flags & SD_BALANCE_NEWIDLE) {
> +			load_balance_attempted = true;
> +
>  			/* If we've pulled tasks over stop searching: */
>  			pulled_task = load_balance(this_cpu, this_rq,
>  						   sd, CPU_NEWLY_IDLE, &balance);
> @@ -5322,6 +5326,10 @@ void idle_balance(int this_cpu, struct rq *this_rq)
>  		 */
>  		this_rq->next_balance = next_balance;
>  	}
> +
> +	/* Give idle balance on this CPU a break when it isn't moving tasks */
> +	if (load_balance_attempted && !pulled_task)
> +		this_rq->next_newidle_balance = jiffies + (HZ / 100);
>  }

Looks reasonable. However should we do this per sd and not per rq. i.e
move the next_newidle_balance to sched_domain. So if we find a
load_balance in newly_idle context that wasn't successful, we skip
load_balance for that sd in the next newly idle balance.

-- 
Thanks and Regards
Srikar Dronamraju

