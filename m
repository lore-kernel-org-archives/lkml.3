Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3ILMJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:09:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44258 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab3ILMJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:09:38 -0400
Date: Thu, 12 Sep 2013 14:09:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] timekeeping: introduce timekeeping_is_busy()
Message-ID: <20130912120916.GW31370@twins.programming.kicks-ass.net>
References: <20130911150853.GA19800@Krystal>
 <52309D13.3020305@linaro.org>
 <20130911185441.GC23532@Krystal>
 <20130911203618.GH3966@linux.vnet.ibm.com>
 <20130912004811.GA6096@Krystal>
 <20130912012531.GS31370@twins.programming.kicks-ass.net>
 <20130912032252.GA8347@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912032252.GA8347@Krystal>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 11:22:52PM -0400, Mathieu Desnoyers wrote:
> Cool!
> 
> Your design looks good to me. It reminds me of a latch. My only fear is
> that struct timekeeper is probably too large to be copied every time on
> the read path. Here is a slightly reworked version that would allow
> in-place read of "foo" without copy.
> 
> struct foo {
> 	...
> };
> 
> struct latchfoo {
> 	unsigned int head, tail;
> 	spinlock_t write_lock;
> 	struct foo data[2];
> };
> 
> static
> void foo_update(struct latchfoo *lf, void cb(struct foo *foo), void *ctx)
> {
> 	spin_lock(&lf->write_lock);
> 	lf->head++;
> 	smp_wmb();
> 	lf->data[lf->head & 1] = lf->data[lf->tail & 1];
> 	cb(&lf->data[lf->head & 1], ctx);

You do that initial copy such that the cb gets the previous state to
work from and doesn't have to do a fetch/complete rewrite?

The alternative is to give the cb function both pointers, old and new
and have it do its thing.

Yet another option is to split the update side into helper functions
just like you did below for the read side.

> 	smp_wmb();
> 	lf->tail++;
> 	spin_unlock(&lock->write_lock);
> }
> 
> static
> unsigned int foo_read_begin(struct latchfoo *lf)
> {
> 	unsigned int ret;
> 
> 	ret = ACCESS_ONCE(lf->tail);
> 	smp_rmb();
> 	return ret;
> }
> 
> static
> struct foo *foo_read_get(struct latchfoo *lf, unsigned int tail)
> {
> 	return &lf->data[tail & 1];
> }
> 
> static
> int foo_read_retry(struct latchfoo *lf, unsigned int tail)
> {
> 	smp_rmb();
> 	return (ACCESS_ONCE(lf->head) - tail >= 2);
> }
> 
> Comments are welcome,

Yeah this would work. The foo_read_begin() and foo_read_get() split is a
bit awkward but C doesn't really encourage us to do any better.



