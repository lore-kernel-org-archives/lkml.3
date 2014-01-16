Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaAPTAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 14:00:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32095 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750933AbaAPTAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 14:00:04 -0500
Date: Thu, 16 Jan 2014 14:00:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH 0/2] preempt: Track unmatched preempt_enable() to
 preempt_disable()
Message-ID: <20140116140001.58758cfd@gandalf.local.home>
In-Reply-To: <20140116184251.GA11314@laptop.programming.kicks-ass.net>
References: <20140116171824.748919700@goodmis.org>
	<20140116174536.GB9655@laptop.programming.kicks-ass.net>
	<20140116133906.50bcbc93@gandalf.local.home>
	<20140116184251.GA11314@laptop.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014 19:42:51 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> Suppose a reschedule interrupt happens in the middle; we set
> NEED_RESCHED but won't act because preempt is disabled.
> 
> When we hit preempt_enable() we'll call into preempt_schedule() but fail
> because preemptible() finds irqs_disabled().
> 
> And in the end we do not schedule, but have NEED_RESCHED set.
> 
> FAIL.

Ah! Interesting. Actually, you don't even need the first part. That
happens simply with:

	preempt_disable();

	<interrupt - set need_resched>

	local_irq_save();
	preempt_enable();
	local_irq_restore();

I think we can get lockdep to trigger on that. I have ideas to make
preempt tracer do that, which shouldn't be too hard to convert to
lockdep.

It looks that all we need to do is check for anytime we have interrupts
becoming disabled with preemption disabled, and then enable preemption
without first enabling interrupts. This should be able to be driven by
state of the task or CPU even.

I can see if I can whip up a patch to do that.

-- Steve
