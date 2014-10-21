Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaJUOyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:54:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:52198 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJUOyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:54:38 -0400
Date: Tue, 21 Oct 2014 16:54:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [RESEND PATCH 2/3 v5] sched: Rewrite per entity runnable load
 average tracking
Message-ID: <20141021145435.GA23531@worktop.programming.kicks-ass.net>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
 <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 10:21:56AM +0800, Yuyang Du wrote:
>  /*
> + * Updating tg's load_avg is necessary before update_cfs_share (which is done)
> + * and effective_load (which is not done because it is too costly).
>   */
> +static inline void update_tg_load_avg(struct cfs_rq *cfs_rq)
>  {
> +	long delta = cfs_rq->avg.load_avg - cfs_rq->tg_load_avg_contrib;
>  
> +	if (abs(delta) > cfs_rq->tg_load_avg_contrib / 64) {
> +		atomic_long_add(delta, &cfs_rq->tg->load_avg);
> +		cfs_rq->tg_load_avg_contrib = cfs_rq->avg.load_avg;
>  	}
>  }

In the thread here: lkml.kernel.org/r/1409094682.29189.23.camel@j-VirtualBox
there are concerns about the error bounds of such constructs. We can
basically 'leak' nr_cpus * threshold, which is potentially a very large
number.

Do we want to introduce the force updated to combat this?

