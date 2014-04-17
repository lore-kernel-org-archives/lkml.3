Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbaDQKJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:09:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57830 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaDQKJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:09:20 -0400
Date: Thu, 17 Apr 2014 12:09:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race on
 idle time stats
Message-ID: <20140417100906.GP13658@twins.programming.kicks-ass.net>
References: <53465F54.708@jp.fujitsu.com>
 <534660D2.1080505@jp.fujitsu.com>
 <20140415101910.GN11096@twins.programming.kicks-ass.net>
 <534E2422.1040706@jp.fujitsu.com>
 <20140417100519.GF11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417100519.GF11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:05:19PM +0200, Peter Zijlstra wrote:
> +static inline void iowait_start(struct rq *rq)
> +{
> +	raw_spin_lock(&rq->iowait_lock);
> +	rq->nr_iowait++;
> +	raw_spin_unlock(&rq->iowait_lock);
> +	current->in_iowait = 1;
> +}
> +
> +static inline void iowait_stop(struct rq *rq)
> +{
> +	current->in_iowait = 0;
> +	raw_spin_lock(&rq->iowait_lock);
> +	rq->nr_iowait--;
> +	if (!rq->nr_iowait && rq != this_rq())
> +		rq->last_iowait = ktime_get();
> +	raw_spin_unlock(&rq->iowait_lock);
> +}

We could actually use lockref here...
