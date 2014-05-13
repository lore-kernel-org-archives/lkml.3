Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaEMFrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 01:47:39 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:2442 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750797AbaEMFrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 01:47:37 -0400
X-IronPort-AV: E=Sophos;i="4.97,1040,1389715200"; 
   d="scan'208";a="30437130"
Message-ID: <5371B2D9.8060405@cn.fujitsu.com>
Date: Tue, 13 May 2014 13:51:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 1/3] rtmutex: Add missing deadlock check
References: <20140512190438.314125476@linutronix.de> <20140512201700.999660035@linutronix.de>
In-Reply-To: <20140512201700.999660035@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Thomas,

I think this patch is just a workaround, it is not the proper fix.
you need a updated deadlock-check mechanism:

- (old) skip the check when top_waiter != task_top_pi_waiter(task)
+ (new) skip the check when top_waiter->prio > task->prio

	/*
	 * Drop out, when the task has no waiters. Note,
	 * top_waiter can be NULL, when we are in the deboosting
	 * mode!
	 */
	if (top_waiter && (!task_has_pi_waiters(task) ||
			   top_waiter != task_top_pi_waiter(task)))
		goto out_unlock_pi;


(also need to update the code in other places respectively)

On 05/13/2014 04:45 AM, Thomas Gleixner wrote:
>  	/*
> +	 * Deadlock check for the following scenario:
> +	 *
> +	 * T holds lock L and has waiters
> +	 * T locks L again, but does not end up as it's own top waiter

ABBA problem (TA TB TC TD are of the same priority)

TA holds lock LA, and try to lock LB which TC already has waited on
TB holds lock LB, and try to lock LA which TD already has waited on

I think this check can't detect it IIUC.

> +	 *
> +	 * So we would drop out at the next check without noticing.
> +	 *
> +	 * Note, we need to check for orig_waiter as it might be NULL
> +	 * when deboosting!
> +	 */
> +	if (orig_waiter && orig_waiter->task == rt_mutex_owner(lock)) {

when non-first-loop, it is already checked.

> +		ret = deadlock_detect ? -EDEADLK : 0;
> +		goto out_unlock_pi;
> +	}

I considered you blamed to me.
I would feel better if you directly blamed to me.

Thanks
Lai
