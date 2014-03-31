Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbaCaQAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 12:00:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:19298 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751982AbaCaQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 12:00:07 -0400
Date: Mon, 31 Mar 2014 12:00:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: update_rq_clock() must skip ONE update
Message-ID: <20140331160003.GD19658@home.goodmis.org>
References: <1396164244.28950.15.camel@marge.simpson.net>
 <CA+55aFzGVLTiD5QVqZ6YK41b9n0SUxDGD3+yE9CuGJek2U-+MQ@mail.gmail.com>
 <1396239636.5361.57.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396239636.5361.57.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 06:20:36AM +0200, Mike Galbraith wrote:
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: 	Mike Galbraith <umgwanakikbuti@gmail.com>
> ---
>  kernel/sched/core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -118,7 +118,7 @@ void update_rq_clock(struct rq *rq)
>  {
>  	s64 delta;
>  

Mike,

If I understand this code correctly, skip_clock_update gets set to one,
where it should skip the next call to update_rq_clock(), but only the
next skip_clock_update(), and after that, it should resume calling it again.
Is that correct?

If so, can we add a comment here stating such. For example:

/*
 * rq->skip_clock_update gets set to "1" to skip the next clock update.
 * The following calls should continue to do the update unless
 * rq->skip_clock_update gets set to "1" again.
 */

?

-- Steve

> -	if (rq->skip_clock_update > 0)
> +	if (rq->skip_clock_update-- > 0)
>  		return;
>  
>  	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
