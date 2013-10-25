Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3JYIo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 04:44:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:61592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000Ab3JYIo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 04:44:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="398442086"
Message-ID: <1382690669.4970.4.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: [PATCH] futex: Remove the owner check when waking task in
 handle_futex_death
From: Darren Hart <dvhart@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: zhang.yi20@zte.com.cn, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
In-Reply-To: <alpine.DEB.2.02.1310241231350.4983@ionos.tec.linutronix.de>
References: <OFCEFEC0A7.CD482CBA-ON48257BF2.000535D1-48257BF2.00066AD1@zte.com.cn>
	 <alpine.DEB.2.02.1310241231350.4983@ionos.tec.linutronix.de>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Oct 2013 09:44:29 +0100
Mime-Version: 1.0
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 14:47 +0200, Thomas Gleixner wrote:
> On Thu, 26 Sep 2013, zhang.yi20@zte.com.cn wrote:
> > Task processes all its owned robust futex when it is exiting,
> > to ensure the futexes can be taken by other tasks.
> > 
> > Though this can not work good in sometimes.
> > Think about this scene：
> > 1. A robust mutex is shared for two processes, each process has
> >    multi threads to lock the mutex.
> > 2. One of the threads locks the mutex, and the others are waiting
> >    and sorted in order of priority.
> > 3. The process to which the mutex owner thread belongs is dying
> >    without unlocking the mutex，and handle_futex_death is invoked
> >    to wake the first waiter.
> > 4. If the first waiter belongs to the same process，it has no chance
> >    to return to the userspace to lock the mutex, and it won't wake
> >    the next waiter because it is not the owner of the mutex.
> > 5. The rest waiters of the other process may block forever.
> 
> Fair enough.
>  
> > This patch remove the owner check when waking task in handle_futex_death.
> > If above occured, The dying task can wake the next waiter by processing its list_op_pending.
> > The waked task could return to userspace and try to lock the mutex again.
> > 
> 
> The owner check needs to stay. The robust list is a user space managed
> list on which the kernel operates. We do not trust it at all and we
> really want as many sanity checks as possible and definitely not
> removing one.
> 
> The simplest solution is just to wake all waiters and let them sort it
> out. We could do a more complex one by checking whether this is a
> group exit and not wake any threads belonging to the same process, but
> that's not really worth the trouble.
> 

I think given that this is the error path, that waking everything is a
reasonable approach to addressing the problem. I haven't been able to
step through the failure case as carefully as I've wanted to, but it
appears sound just reading through it.

--
Darren

> Thanks,
> 
>         tglx

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


