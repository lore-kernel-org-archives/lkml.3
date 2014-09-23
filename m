Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbaIWP4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:56:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:33914 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaIWP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:56:00 -0400
Date: Tue, 23 Sep 2014 17:55:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] signal: simplify deadlock-avoidance in
 lock_task_sighand()
Message-ID: <20140923155556.GJ3312@worktop.programming.kicks-ass.net>
References: <20140922164404.GA28910@redhat.com>
 <20140922164437.GA28939@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922164437.GA28939@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 06:44:37PM +0200, Oleg Nesterov wrote:
> __lock_task_sighand() does local_irq_save() to prevent the potential
> deadlock, we can use preempt_disable() with the same effect. And in
> this case we can do preempt_disable/enable + rcu_read_lock/unlock only
> once outside of the main loop and simplify the code. This also shaves
> 112 bytes from signal.o.
> 
> With this patch the main loop runs with preemption disabled, but this
> should be fine because restart is very unlikely: it can only happen if
> we race with de_thread() and ->sighand is shared. And the latter is only
> possible if CLONE_SIGHAND was used without CLONE_THREAD, most probably
> nobody does this nowadays.

If its unlikely to repeat, it shouldn't matter either way and we can
keep the preempt_disable() inside the loop to guarantee better worst
case behaviour.

And I suppose we can fix -rt, like Steve already mentioned, there's the
preempt_disable_nort() thing for just such cases.
