Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaFJBFE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:05:04 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:48739 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932337AbaFJBFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:05:00 -0400
Date: Mon, 9 Jun 2014 21:04:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 6/7] rtmutex: Cleanup deadlock detector debug logic
Message-ID: <20140609210458.10c4ac8d@gandalf.local.home>
In-Reply-To: <20140609202336.431063114@linutronix.de>
References: <20140609201118.387571774@linutronix.de>
	<20140609202336.431063114@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2014 20:28:10 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The conditions under which deadlock detection is conducted are unclear
> and undocumented.
> 
> Add constants instead of using 0/1 and provide a selection function
> which hides the additional debug dependency from the calling code.
> 
> Add comments where needed.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  kernel/locking/rtmutex-debug.c  |    5 +-
>  kernel/locking/rtmutex-debug.h  |    7 ++--
>  kernel/locking/rtmutex.c        |   69 +++++++++++++++++++++++++++-------------
>  kernel/locking/rtmutex.h        |    7 +++-
>  kernel/locking/rtmutex_common.h |   15 ++++++++
>  5 files changed, 75 insertions(+), 28 deletions(-)
> 
> Index: tip/kernel/locking/rtmutex-debug.c
> ===================================================================
> --- tip.orig/kernel/locking/rtmutex-debug.c
> +++ tip/kernel/locking/rtmutex-debug.c
> @@ -66,12 +66,13 @@ void rt_mutex_debug_task_free(struct tas
>   * the deadlock. We print when we return. act_waiter can be NULL in
>   * case of a remove waiter operation.
>   */
> -void debug_rt_mutex_deadlock(int detect, struct rt_mutex_waiter *act_waiter,
> +void debug_rt_mutex_deadlock(enum rtmutex_chainwalk chwalk,
> +			     struct rt_mutex_waiter *act_waiter,
>  			     struct rt_mutex *lock)
>  {
>  	struct task_struct *task;
>  
> -	if (!debug_locks || detect || !act_waiter)
> +	if (!debug_locks || chwalk || !act_waiter)

I know this will probably get a little verbose, but chwalk isn't very
descriptive. Perhaps change this to:

	if (!debug_locks || chwalk == RT_MUTEX_FULL_CHAINWALK ||
	    !act_waiter)

To cut down on the verbosity, we could add helper macros:

#define chwalk_is_full(chwalk)	((chwalk) == RT_MUTEX_FULL_CHAINWALK)
#define chwalk_is_min(chwalk)   ((chwalk) == RT_MUTEX_MIN_CHAINWALK)

And then the above would simply be:

	if (!debug_locks || chwalk_is_full(chwalk) || !act_waiter)

And put this throughout.

-- Steve

