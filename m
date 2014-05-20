Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaETB33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 21:29:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:43113 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751146AbaETB31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 21:29:27 -0400
Message-ID: <1400549356.10728.22.camel@pippen.local.home>
Subject: Re: [patch 2/2] rtmutex: Avoid pointless requeueing in the deadlock
 detection chain walk
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Mon, 19 May 2014 21:29:16 -0400
In-Reply-To: <alpine.DEB.2.02.1405200936320.7325@ionos.tec.linutronix.de>
References: <20140514195705.618583609@linutronix.de>
	 <20140514200104.670614672@linutronix.de>
	 <20140515130435.24132d1b@gandalf.local.home>
	 <alpine.DEB.2.02.1405200936320.7325@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-20 at 09:43 +0900, Thomas Gleixner wrote:
>  In kernel/locking/rtmutex.h:
> > 
> > static inline int debug_rt_mutex_detect_deadlock(struct rt_mutex_waiter *waiter,
> >                                                  int detect)
> > {
> >         return (waiter != NULL);
> > }
> > 
> > Shouldn't that be: return detect || waiter != NULL;
> > 
> 
> No. We do not care about whether the caller handed in detect or not.

Bah, you're right. I was getting confused between try_to_take_rt_mutex()
and task_blocks_on_rt_mutex(). The former passes in a NULL waiter when
taking the first time, but it's the task_blocks_on_rt_mutex() that does
the test, and yes, the waiter is never NULL when boosting.

I may send you a patch to add comments to these little idiosyncrasies.

> 
> > 
> > I know this a separate issue from this patch series, but it's
> > something that I just noticed.
> 
> It's not really intuitive. We might make the call sites hand in
> constants. RTMUTEX_DETECT_DEADLOCK, RTMUTEX_IGNORE_DEADLOCK or
> something like that and switch it depending on
> CONFIG_DEBUG_RT_MUTEXES.

Yes it is confusing. I use to know this code really well, and now over
the years, it's not something to look at quickly and produce a
comprehensive response. The sad part is, I looked at it quite a bit
before sending my response and I still got confused :-p

-- Steve



