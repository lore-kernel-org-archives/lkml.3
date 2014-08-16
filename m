Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543AbaHPOO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 10:14:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaHPOO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 10:14:26 -0400
Date: Sat, 16 Aug 2014 16:11:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        umgwanakikbuti@gmail.com, fweisbec@gmail.com,
        akpm@linux-foundation.org, srao@redhat.com, lwoodman@redhat.com,
        atheurer@redhat.com
Subject: Re: [PATCH 2/3] time,signal: protect resource use statistics with
	seqlock
Message-ID: <20140816141159.GA8709@redhat.com>
References: <1408133138-22048-1-git-send-email-riel@redhat.com> <1408133138-22048-3-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408133138-22048-3-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, riel@redhat.com wrote:
>
> --- a/kernel/sched/cputime.c
> +++ b/kernel/sched/cputime.c
> @@ -288,18 +288,31 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
>  	struct signal_struct *sig = tsk->signal;
>  	cputime_t utime, stime;
>  	struct task_struct *t;
> -
> -	times->utime = sig->utime;
> -	times->stime = sig->stime;
> -	times->sum_exec_runtime = sig->sum_sched_runtime;
> +	unsigned int seq, nextseq;
>
>  	rcu_read_lock();
> -	for_each_thread(tsk, t) {
> -		task_cputime(t, &utime, &stime);
> -		times->utime += utime;
> -		times->stime += stime;
> -		times->sum_exec_runtime += task_sched_runtime(t);
> -	}
> +	/* Attempt a lockless read on the first round. */
> +	nextseq = 0;
> +	do {
> +		seq = nextseq;
> +		read_seqbegin_or_lock(&sig->stats_lock, &seq);
> +		times->utime = sig->utime;
> +		times->stime = sig->stime;
> +		times->sum_exec_runtime = sig->sum_sched_runtime;
> +
> +		for_each_thread(tsk, t) {
> +			task_cputime(t, &utime, &stime);
> +			times->utime += utime;
> +			times->stime += stime;
> +			times->sum_exec_runtime += task_sched_runtime(t);
> +		}
> +		/*
> +		 * If a writer is currently active, seq will be odd, and
> +		 * read_seqbegin_or_lock will take the lock.
> +		 */
> +		nextseq = raw_read_seqcount(&sig->stats_lock.seqcount);
> +	} while (need_seqretry(&sig->stats_lock, seq));
> +	done_seqretry(&sig->stats_lock, seq);
>  	rcu_read_unlock();
>  }

Rik, I do not understand why did you silently ignore my comments about
this change twice ;)

Please see

	http://marc.info/?l=linux-kernel&m=140802271907396
	http://marc.info/?l=linux-kernel&m=140811486607850

I still do not think that the read_seqbegin_or_lock logic is correct,
in a sense that unless I missed something it does not guarantee the
forward progress.

Oleg.

