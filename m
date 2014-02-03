Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbaBCUzm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 15:55:42 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:3313 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCUzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 15:55:40 -0500
Message-ID: <1391460934.7498.49.camel@j-VirtualBox>
Subject: Re: [RFC][PATCH v2 5/5] mutex: Give spinners a chance to
 spin_on_owner if need_resched() triggered while queued
From: Jason Low <jason.low2@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, chegu_vinod@hp.com
Date: Mon, 03 Feb 2014 12:55:34 -0800
In-Reply-To: <20140203192525.GN8874@twins.programming.kicks-ass.net>
References: <20140128210753.GJ11314@laptop.programming.kicks-ass.net>
	 <1390949495.2807.52.camel@j-VirtualBox>
	 <20140129115142.GE9636@twins.programming.kicks-ass.net>
	 <1391138977.6284.82.camel@j-VirtualBox>
	 <20140131140941.GF4941@twins.programming.kicks-ass.net>
	 <CAGQ1y=72+N4=yjVpjsTKjr-8xSQRS2xw4gcOGOipLgwPwgnA7A@mail.gmail.com>
	 <20140131200825.GS5002@laptop.programming.kicks-ass.net>
	 <1391374883.3164.8.camel@j-VirtualBox>
	 <20140202211230.GX5002@laptop.programming.kicks-ass.net>
	 <1391452760.7498.26.camel@j-VirtualBox>
	 <20140203192525.GN8874@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 20:25 +0100, Peter Zijlstra wrote:
> On Mon, Feb 03, 2014 at 10:39:20AM -0800, Jason Low wrote:
> > > To avoid the xchg on every loop.
> > 
> > Ah yes, we want to use xchg() on &node->next.
> > 
> > Since the cmpxchg() is now in a loop in the unlock function, an
> > additional (*lock == node) check before the cmpxchg() would also be nice
> > to avoid spinning on cmpxchg() there too.
> 
> Right, I have the below; you can find the patches this depends upon
> here:
> 
>   http://programming.kicks-ass.net/sekrit/patches.tar.bz2
> 
> ---
> Subject: locking, mutex: Cancelable MCS lock for adaptive spinning
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, 29 Jan 2014 12:51:42 +0100
> 
> Since we want a task waiting for a mutex_lock() to go to sleep and
> reschedule on need_resched() we must be able to abort the
> mcs_spin_lock() around the adaptive spin.
> 
> Therefore implement a cancelable mcs lock.
> 
> XXX: anybody got a better name than m_spinlock?

So I was thinking something along the lines of
mcs_spin_lock_cancelable() as that's essentially what this function
does.

