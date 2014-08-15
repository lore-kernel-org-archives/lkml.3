Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaHOSjE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 14:39:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaHOSjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 14:39:01 -0400
Date: Fri, 15 Aug 2014 20:36:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Frank Mayhar <fmayhar@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sanjay Rao <srao@redhat.com>, Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH RFC] time,signal: protect resource use statistics with
	seqlock
Message-ID: <20140815183630.GA22832@redhat.com>
References: <53EBADB1.2020403@redhat.com> <20140813184511.GA9663@redhat.com> <20140813170324.544aaf2d@cuia.bos.redhat.com> <20140814132239.GA24465@redhat.com> <20140814174849.GA5091@redhat.com> <1408079971.5536.37.camel@marge.simpson.net> <20140815062819.GY19379@twins.programming.kicks-ass.net> <20140815163651.GA19331@redhat.com> <20140815164953.GA20197@redhat.com> <53EE4278.8030909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EE4278.8030909@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, Rik van Riel wrote:
>
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 08/15/2014 12:49 PM, Oleg Nesterov wrote:
>
> > Just in case... Yes, sure, "seqlock_t stats_lock" is more scalable.
> > Just I do not know it's worth the trouble.
>
> If we don't know whether it is worth the trouble, it is probably best
> to stick to a well-known generic locking algorithm, instead of brewing
> our own and trying to maintain it.

Perhaps. I am obviously biased and can't judge ;) Plus, again, I do
understand that your approach has some advantages too.

> Now to see if this change to cputime_adjust does the trick :)
>
> +++ b/kernel/sched/cputime.c
> @@ -605,9 +605,12 @@ static void cputime_adjust(struct task_cputime *curr,
>  	 * If the tick based count grows faster than the scheduler one,
>  	 * the result of the scaling may go backward.
>  	 * Let's enforce monotonicity.
> +	 * Atomic exchange protects against concurrent cputime_adjust.
>  	 */
> - -	prev->stime = max(prev->stime, stime);
> - -	prev->utime = max(prev->utime, utime);
> +	while (stime > (rtime = ACCESS_ONCE(prev->stime)))
> +		cmpxchg(&prev->stime, rtime, stime);
> +	while (utime > (rtime = ACCESS_ONCE(prev->utime)))
> +		cmpxchg(&prev->utime, rtime, utime);

Yes, perhaps we need something like this in any case. To remind, at least
do_task_stat() calls task_cputime_adjusted() lockless, although we could
fix this separately.

But I do not think the change above is enough. With this change cputime_adjust()
can race with itself. Yes, this guarantees monotonicity even if it is called
lockless, but this can lead to "obviously inconsistent" numbers.

And I don't think we can ignore this. If we could, then we can remove the
scale_stime recalculation and change cputime_adjust() to simply do:

	static void cputime_adjust(struct task_cputime *curr,
				   struct cputime *prev,
				   cputime_t *ut, cputime_t *st)
	{
		/* enforce monotonicity */
		*ut = prev->stime = max(prev->stime, curr->stime);
		*st = prev->utime = max(prev->utime, curr->utime);
	}

Yes, we have this problem either way. And personally I think that this
"enforce monotonicity" logic is pointless, userspace could take care,
but it is too late to complain.

Oleg.

