Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbaJaWOI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:14:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaJaWOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:14:07 -0400
Date: Fri, 31 Oct 2014 23:13:40 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peter@hurleysoftware.com,
        rjw@rjwysocki.net, torvalds@linux-foundation.org, tglx@linutronix.de,
        eparis@redhat.com, umgwanakikbuti@gmail.com, marcel@holtmann.org,
        ebiederm@xmission.com, davem@davemloft.net, fengguang.wu@intel.com
Subject: Re: [PATCH 1/7] sched,wait: Fix a kthread race with wait_woken()
Message-ID: <20141031221340.GA28563@redhat.com>
References: <20141031111037.936236584@infradead.org> <20141031111549.492532161@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031111549.492532161@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31, Peter Zijlstra wrote:
>
> There is a race between kthread_stop() and the new wait_woken() that
> can result in a lack of progress.

Likewise, the user of wait_woken() can miss any other event which is
not associated with wq we are going to sleep on. Please see below.

> +static inline bool is_kthread_should_stop(void)
> +{
> +	return (current->flags & PF_KTHREAD) && kthread_should_stop();
> +}
>
>  /*
>   * DEFINE_WAIT_FUNC(wait, woken_wake_func);
> @@ -326,7 +331,7 @@ long wait_woken(wait_queue_t *wait, unsi
>  	 * woken_wake_function() such that if we observe WQ_FLAG_WOKEN we must
>  	 * also observe all state before the wakeup.
>  	 */
> -	if (!(wait->flags & WQ_FLAG_WOKEN))
> +	if (!(wait->flags & WQ_FLAG_WOKEN) && !is_kthread_should_stop())
>  		timeout = schedule_timeout(timeout);

Well yes, this is more straightforward than other hacks we discussed before.
But see above, this doesn't look flexible enough.

And. This assumes that the user must also check kthread_should_stop(),
otherwise the waiting loop becomes a busy-wait loop.

So I won't argue, but I still think it would be better to allow the user to
do set_task_state() by hand if it needs to check the additional conditions.

Oleg.

