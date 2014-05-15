Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaEOREi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:04:38 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:23228 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752392AbaEOREh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:04:37 -0400
Date: Thu, 15 May 2014 13:04:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch 2/2] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
Message-ID: <20140515130435.24132d1b@gandalf.local.home>
In-Reply-To: <20140514200104.670614672@linutronix.de>
References: <20140514195705.618583609@linutronix.de>
	<20140514200104.670614672@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 20:03:27 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> In case the dead lock detector is enabled we follow the lock chain to
> the end in rt_mutex_adjust_prio_chain, even if we could stop earlier
> due to the priority/waiter constellation.

I'm assuming that we want to detect deadlocks for all futex calls
even when CONFIG_DEBUG_RT_MUTEXES is set?

In kernel/locking/rtmutex_common.h:

#ifdef CONFIG_DEBUG_RT_MUTEXES
# include "rtmutex-debug.h"
#else
# include "rtmutex.h"
#endif

In kernel/locking/rtmutex.h:

#define debug_rt_mutex_detect_deadlock(w,d)             (d)

In kernel/locking/rtmutex.h:

static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
                                                 int detect)
{
        return (waiter != NULL);
}

Shouldn't that be: return detect || waiter != NULL;

?

I know this a separate issue from this patch series, but it's
something that I just noticed.

> 
> But once we are not longer the top priority waiter in a certain step

"we are no longer the top"

> or the task holding the lock has already the same priority then there
> is no point in dequeing and enqueing along the lock chain as there is
> no change at all.
> 
> So stop the queueing at this point.

I'll continue reviewing the patch.

-- Steve
