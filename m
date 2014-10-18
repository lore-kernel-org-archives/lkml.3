Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaJRXGm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 19:06:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:22959 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751273AbaJRXGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 19:06:38 -0400
Message-ID: <1413673519.30326.11.camel@pippen.local.home>
Subject: Re: [PATCH 3/7] wait.[ch]: Introduce the simple waitqueue (swait)
 implementation
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Sat, 18 Oct 2014 19:05:19 -0400
In-Reply-To: <20141018213417.GE23531@worktop.programming.kicks-ass.net>
References: <1413591782-23453-1-git-send-email-paul.gortmaker@windriver.com>
	 <1413591782-23453-4-git-send-email-paul.gortmaker@windriver.com>
	 <20141018213417.GE23531@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-18 at 23:34 +0200, Peter Zijlstra wrote:

> Same comment as before, that is an unbounded loop in a non preemptible
> section and therefore violates RT design principles.
> 
> We actually did talk about ways of fixing that.

Right, and we should slap Paul for not showing up for it ;-)

The decision that we came up with was to splice the current list onto a
local list variable. And then we could go into a loop releasing the lock
and grabbing it again. Each time pop a waiter off the list and doing the
work of only one task at a time. This prevents doing large amounts of
wake ups under a spinlock. The splice is required to only wake up those
that are on the list when the wake up is called. This prevents waking up
a task twice because it woke up, removed itself, and then added itself
again. We must keep the semantics that a wake up only wakes up a task
once.

> 
> Also, I'm not entirely sure we want to do the cwait thing, it looks
> painful.

Yeah, I have to think about that some more too. I'm currently sitting in
the airport waiting for my final leg of my flight. After 18 hours of
travel, it is probably not too wise to review this work in my current
state ;-)

-- Steve


