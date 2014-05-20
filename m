Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaETAnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:43:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:53152 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaETAny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:43:54 -0400
Date: Tue, 20 May 2014 09:43:56 +0900 (JST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [patch 2/2] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
In-Reply-To: <20140515130435.24132d1b@gandalf.local.home>
Message-ID: <alpine.DEB.2.02.1405200936320.7325@ionos.tec.linutronix.de>
References: <20140514195705.618583609@linutronix.de> <20140514200104.670614672@linutronix.de> <20140515130435.24132d1b@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Steven Rostedt wrote:
> On Wed, 14 May 2014 20:03:27 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > In case the dead lock detector is enabled we follow the lock chain to
> > the end in rt_mutex_adjust_prio_chain, even if we could stop earlier
> > due to the priority/waiter constellation.
> 
> I'm assuming that we want to detect deadlocks for all futex calls
> even when CONFIG_DEBUG_RT_MUTEXES is set?
> 
> In kernel/locking/rtmutex_common.h:
> 
> #ifdef CONFIG_DEBUG_RT_MUTEXES
> # include "rtmutex-debug.h"
> #else
> # include "rtmutex.h"
> #endif
> 
> In kernel/locking/rtmutex.h:
> 
> #define debug_rt_mutex_detect_deadlock(w,d)             (d)
> 
> In kernel/locking/rtmutex.h:
> 
> static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
>                                                  int detect)
> {
>         return (waiter != NULL);
> }
> 
> Shouldn't that be: return detect || waiter != NULL;
> 

No. We do not care about whether the caller handed in detect or not.

> 
> I know this a separate issue from this patch series, but it's
> something that I just noticed.

It's not really intuitive. We might make the call sites hand in
constants. RTMUTEX_DETECT_DEADLOCK, RTMUTEX_IGNORE_DEADLOCK or
something like that and switch it depending on
CONFIG_DEBUG_RT_MUTEXES.

Thanks,

	tglx
