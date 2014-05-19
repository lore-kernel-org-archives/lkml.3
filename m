Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaESNLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:11:39 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48037 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbaESNLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:11:36 -0400
Date: Mon, 19 May 2014 15:12:33 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] sched/dl: Fix race between dl_task_timer() and
 sched_setaffinity()
Message-Id: <20140519151233.5043b749361e1b384f1e5562@gmail.com>
In-Reply-To: <20140516213003.10384.7946.stgit@localhost>
References: <20140516213003.10384.7946.stgit@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2014 01:30:03 +0400
Kirill Tkhai <tkhai@yandex.ru> wrote:

> The race is in unlocked task_rq() access. In pair with parallel
> call of sched_setaffinity() it may be a reason of corruption
> of internal rq's data.
> 

Sure, the thing can happen!

> Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
> CC: Juri Lelli <juri.lelli@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@redhat.com>
> Cc: <stable@vger.kernel.org> # v3.14
> ---
>  kernel/sched/deadline.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 800e99b..ffb023a 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -513,9 +513,16 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
>  						     struct sched_dl_entity,
>  						     dl_timer);
>  	struct task_struct *p = dl_task_of(dl_se);
> -	struct rq *rq = task_rq(p);
> +	struct rq *rq;

We could maybe add a comment here, in line with what we have below, to
document why we need this.

Thanks,

- Juri

> +again:
> +	rq = task_rq(p);
>  	raw_spin_lock(&rq->lock);
>  
> +	if (unlikely(rq != task_rq(p))) {
> +		raw_spin_unlock(&rq->lock);
> +		goto again;
> +	}
> +
>  	/*
>  	 * We need to take care of a possible races here. In fact, the
>  	 * task might have changed its scheduling policy to something
> 
