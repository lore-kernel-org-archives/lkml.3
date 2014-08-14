Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaHNNZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 09:25:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbaHNNZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 09:25:07 -0400
Date: Thu, 14 Aug 2014 15:22:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
	seqlock
Message-ID: <20140814132239.GA24465@redhat.com>
References: <20140812142539.01851e52@annuminas.surriel.com> <20140812191218.GA15210@redhat.com> <53EA94DD.5040900@redhat.com> <20140813172230.GA6296@redhat.com> <20140813133526.1eb5526f@cuia.bos.redhat.com> <20140813180807.GA8098@redhat.com> <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813170324.544aaf2d@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13, Rik van Riel wrote:
>
> On Wed, 13 Aug 2014 20:45:11 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > That said, it is not that I am really sure that seqcount_t in ->signal
> > is actually worse, not to mention that this is subjective anyway. IOW,
> > I am not going to really fight with your approach ;)
>
> This is what it looks like, on top of your for_each_thread series
> from yesterday:

OK, lets forget about alternative approach for now. We can reconsider
it later. At least I have to admit that seqlock is more straighforward.

> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -646,6 +646,7 @@ struct signal_struct {
>  	 * Live threads maintain their own counters and add to these
>  	 * in __exit_signal, except for the group leader.
>  	 */
> +	seqlock_t stats_lock;

Ah. Somehow I thought that you were going to use seqcount_t and fallback
to taking ->siglock if seqcount_retry, but this patch adds the "full blown"
seqlock_t.

OK, I won't argue, this can make the seqbegin_or_lock simpler...

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

Almost cosmetic nit, but afaics this patch expands the rcu critical section
for no reason. We only need rcu_read_lock/unlock around for_each_thread()
below.

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

Hmm. It seems that read_seqbegin_or_lock() is not used correctly. I mean,
this code still can livelock in theory. Just suppose that anoter CPU does
write_seqlock/write_sequnlock right after read_seqbegin_or_lock(). In this
case "seq & 1" will be never true and thus "or_lock" will never happen.

IMO, this should be fixed. Either we should guarantee the forward progress
or we should not play with read_seqbegin_or_lock() at all. This code assumes
that sooner or later "nextseq = raw_read_seqcount()" should return the odd
counter, but in theory this can never happen.

And if we want to fix this we do not need 2 counters, just we need to set
"seq = 1" manually after need_seqretry() == T. Say, like __dentry_path() does.
(but unlike __dentry_path() we do not need to worry about rcu_read_unlock so
the code will be simpler).

I am wondering if it makes sense to introduce

	bool read_seqretry_or_lock(const seqlock_t *sl, int *seq)
	{
		if (*seq & 1) {
			read_sequnlock_excl(lock);
			return false;
		}
	
		if (!read_seqretry(lock, *seq))
			return false;
	
		*seq = 1;
		return true;
	}

Oleg.

