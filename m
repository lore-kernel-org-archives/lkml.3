Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab3ILNsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:48:22 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44675 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751906Ab3ILNsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:48:20 -0400
Date: Thu, 12 Sep 2013 09:48:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] timekeeping: introduce timekeeping_is_busy()
Message-ID: <20130912134816.GA26417@Krystal>
References: <20130911150853.GA19800@Krystal> <52309D13.3020305@linaro.org> <20130911185441.GC23532@Krystal> <20130911203618.GH3966@linux.vnet.ibm.com> <20130912004811.GA6096@Krystal> <20130912012531.GS31370@twins.programming.kicks-ass.net> <20130912032252.GA8347@Krystal> <20130912120916.GW31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912120916.GW31370@twins.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, Sep 11, 2013 at 11:22:52PM -0400, Mathieu Desnoyers wrote:
> > Cool!
> > 
> > Your design looks good to me. It reminds me of a latch. My only fear is
> > that struct timekeeper is probably too large to be copied every time on
> > the read path. Here is a slightly reworked version that would allow
> > in-place read of "foo" without copy.
> > 
> > struct foo {
> > 	...
> > };
> > 
> > struct latchfoo {
> > 	unsigned int head, tail;
> > 	spinlock_t write_lock;
> > 	struct foo data[2];
> > };
> > 
> > static
> > void foo_update(struct latchfoo *lf, void cb(struct foo *foo), void *ctx)
> > {
> > 	spin_lock(&lf->write_lock);
> > 	lf->head++;
> > 	smp_wmb();
> > 	lf->data[lf->head & 1] = lf->data[lf->tail & 1];
> > 	cb(&lf->data[lf->head & 1], ctx);
> 
> You do that initial copy such that the cb gets the previous state to
> work from and doesn't have to do a fetch/complete rewrite?

Yep, my original intent was to simplify life for callers.

> 
> The alternative is to give the cb function both pointers, old and new
> and have it do its thing.

Good point. The caller don't necessarily need to copy the old entry into
the new one: it may very well want to overwrite all the fields.

> 
> Yet another option is to split the update side into helper functions
> just like you did below for the read side.

OK. Updated code below.

> 
> > 	smp_wmb();
> > 	lf->tail++;
> > 	spin_unlock(&lock->write_lock);
> > }
> > 
> > static
> > unsigned int foo_read_begin(struct latchfoo *lf)
> > {
> > 	unsigned int ret;
> > 
> > 	ret = ACCESS_ONCE(lf->tail);
> > 	smp_rmb();
> > 	return ret;
> > }
> > 
> > static
> > struct foo *foo_read_get(struct latchfoo *lf, unsigned int tail)
> > {
> > 	return &lf->data[tail & 1];
> > }
> > 
> > static
> > int foo_read_retry(struct latchfoo *lf, unsigned int tail)
> > {
> > 	smp_rmb();
> > 	return (ACCESS_ONCE(lf->head) - tail >= 2);
> > }
> > 
> > Comments are welcome,
> 
> Yeah this would work. The foo_read_begin() and foo_read_get() split is a
> bit awkward but C doesn't really encourage us to do any better.

We might be able to do better:


struct foo {
	...
};

spinlock_t foo_lock;

struct latchfoo {
	unsigned int head, tail;
	struct foo data[2];
};

/**
 * foo_write_begin - begin foo update.
 *
 " @lf: struct latchfoo to update.
 * @prev: pointer to previous element (output parameter).
 * @next: pointer to next element (output parameter).
 *
 * The area pointed to by "next" should be considered uninitialized.
 * The caller needs to have exclusive update access to struct latchfoo.
 */
static
void foo_write_begin(struct latchfoo *lf, const struct foo **prev,
		struct foo **next)
{
	lf->head++;
	smp_wmb();
	*prev = &lf->data[lf->tail & 1];
	*next = &lf->data[lf->head & 1];
}

/**
 * foo_write_end - end foo update.
 *
 " @lf: struct latchfoo.
 *
 * The caller needs to have exclusive update access to struct latchfoo.
 */
static void
void foo_write_end(struct latchfoo *lf)
{
	smp_wmb();
	lf->tail++;
}

/**
 * foo_read_begin - begin foo read.
 *
 " @lf: struct latchfoo to read.
 * @tail: pointer to unsigned int containing tail position (output).
 */
static
struct foo *foo_read_begin(struct latchfoo *lf, unsigned int *tail)
{
	unsigned int ret;

	ret = ACCESS_ONCE(lf->tail);
	smp_rmb();
	*tail = ret;
	return &lf->data[ret & 1];
}

/**
 * foo_read_retry - end foo read, trigger retry if needed.
 *
 " @lf: struct latchfoo read.
 * @tail: tail position returned as output by foo_read_begin().
 *
 * If foo_read_retry() returns nonzero, the content of the read should
 * be considered invalid, and the read should be performed again to
 * reattempt reading coherent data, starting with foo_read_begin().
 */
static
int foo_read_retry(struct latchfoo *lf, unsigned int tail)
{
	smp_rmb();
	return (ACCESS_ONCE(lf->head) - tail >= 2);
}


Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
