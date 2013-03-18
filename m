Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3CRTcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:32:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6517 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3CRTcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:32:23 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=bGeQnFoGQusA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=mxv2HPhRFNcA:10 a=VwQbUJbxAAAA:8 a=Vl498xH2DZN-PoZfw4oA:9 a=QEXdDO2ut3YA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363635140.28194.10.camel@gandalf.local.home>
Subject: Re: [PATCH] scheduler: convert BUG_ON()s in try_to_wake_up_local()
 to WARN_ON_ONCE()s
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Date: Mon, 18 Mar 2013 15:32:20 -0400
In-Reply-To: <20130318192234.GD3042@htj.dyndns.org>
References: <20130318192234.GD3042@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 12:22 -0700, Tejun Heo wrote:
> try_to_wake_up_local() should only be invoked to wake up another task
> in the same runqueue and BUG_ON()s are used to enforce the rule.
> Missing try_to_wake_up_local() can stall workqueue execution but such
> stalls are likely to be finite either by another work item being
> queued or the one blocked getting unblocked.  There's no reason to
> trigger BUG while holding rq lock crashing the whole system.
> 
> Convert BUG_ON()s in try_to_wake_up_local() to WARN_ON_ONCE()s.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/sched/core.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 7f12624..a2eda4d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1498,8 +1498,10 @@ static void try_to_wake_up_local(struct task_struct *p)
>  {
>  	struct rq *rq = task_rq(p);
>  
> -	BUG_ON(rq != this_rq());
> -	BUG_ON(p == current);
> +	if (WARN_ON_ONCE(rq != this_rq()) ||
> +	    WARN_ON_ONCE(p == current))
> +		return;
> +
>  	lockdep_assert_held(&rq->lock);
>  
>  	if (!raw_spin_trylock(&p->pi_lock)) {


