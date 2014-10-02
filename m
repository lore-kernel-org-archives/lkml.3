Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaJBJeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 05:34:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:55528 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaJBJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 05:34:12 -0400
Date: Thu, 2 Oct 2014 11:34:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Kirill Tkhai <ktkhai@parallels.com>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 1/3] sched/dl: Implement cancel_dl_timer() to use in
 switched_from_dl()
Message-ID: <20141002093408.GB2849@worktop.programming.kicks-ass.net>
References: <20140930210412.5258.35299.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930210412.5258.35299.stgit@localhost>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 01:04:22AM +0400, Kirill Tkhai wrote:
> From: Kirill Tkhai <ktkhai@parallels.com>
> 
> hrtimer_try_to_cancel() may bring a suprise, its call may fail.

Well, not really a surprise that, its a _try_ operation after all.

> raw_spin_lock(&rq->lock)
> ...                            dl_task_timer                 raw_spin_lock(&rq->lock)
> ...                               raw_spin_lock(&rq->lock)   ...
>    switched_from_dl()             ...                        ...
>       hrtimer_try_to_cancel()     ...                        ...
>    switched_to_fair()             ...                        ...
> ...                               ...                        ...
> ...                               ...                        ...
> raw_spin_unlock(&rq->lock)        ...                        (asquired)
> ...                               ...                        ...
> ...                               ...                        ...
> do_exit()                         ...                        ...
>    schedule()                     ...                        ...
>       raw_spin_lock(&rq->lock)    ...                        raw_spin_unlock(&rq->lock)
>       ...                         ...                        ...
>       raw_spin_unlock(&rq->lock)  ...                        raw_spin_lock(&rq->lock)
>       ...                         ...                        (asquired)
>       put_task_struct()           ...                        ...
>           free_task_struct()      ...                        ...
>       ...                         ...                        raw_spin_unlock(&rq->lock)
> ...                               (asquired)                 ...
> ...                               ...                        ...
> ...                               Surprise!!!                ...
> 
> So, let's implement 100% guaranteed way to cancel the timer and let's
> be sure we are safe even in very unlikely situations.
> 
> We do not create any problem with rq unlocking, because it already
> may happed below in pull_dl_task(). No problem with deadline tasks
> balancing too.

That doesn't sound right. pull_dl_task() is an entirely different
callchain than switched_from(). Now it might still be fine, but you
cannot compare it with pull_dl_task.
