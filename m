Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab3ILDW4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:22:56 -0400
Received: from mail.openrapids.net ([64.15.138.104]:44042 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757666Ab3ILDWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:22:55 -0400
Date: Wed, 11 Sep 2013 23:22:52 -0400
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
Message-ID: <20130912032252.GA8347@Krystal>
References: <20130911150853.GA19800@Krystal> <52309D13.3020305@linaro.org> <20130911185441.GC23532@Krystal> <20130911203618.GH3966@linux.vnet.ibm.com> <20130912004811.GA6096@Krystal> <20130912012531.GS31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912012531.GS31370@twins.programming.kicks-ass.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, Sep 11, 2013 at 08:48:11PM -0400, Mathieu Desnoyers wrote:
> > Thoughts ?
> 
> 
> struct foo {
> 	...
> };
> 
> spinlock_t foo_lock;
> unsigned int foo_head = 0;
> unsigned int foo_tail = 0;
> struct foo foo_array[2];
> 
> void foo_assign(struct foo f)
> {
> 	spin_lock(&foo_lock);
> 	foo_head++;
> 	smp_wmb();
> 	foo_array[foo_head & 1] = f;
> 	smp_wmb();
> 	foo_tail++;
> 	spin_unlock(&foo_lock);
> }
> 
> struct foo foo_get(void)
> {
> 	unsigned int tail, head;
> 	struct foo ret;
> 
> again:
> 	tail = ACCESS_ONCE(foo_tail);
> 	smp_rmb();
> 	ret = foo_array[tail & 1];
> 	smp_rmb();
> 	head = ACCESS_ONCE(foo_head);
> 	if (head - tail >= 2)
> 		goto again;
> 
> 	return ret;
> }
> 
> Should work and get you the most recent 'complete' foo even when
> foo_get() is called nested inside foo_assign().

Cool!

Your design looks good to me. It reminds me of a latch. My only fear is
that struct timekeeper is probably too large to be copied every time on
the read path. Here is a slightly reworked version that would allow
in-place read of "foo" without copy.

struct foo {
	...
};

struct latchfoo {
	unsigned int head, tail;
	spinlock_t write_lock;
	struct foo data[2];
};

static
void foo_update(struct latchfoo *lf, void cb(struct foo *foo), void *ctx)
{
	spin_lock(&lf->write_lock);
	lf->head++;
	smp_wmb();
	lf->data[lf->head & 1] = lf->data[lf->tail & 1];
	cb(&lf->data[lf->head & 1], ctx);
	smp_wmb();
	lf->tail++;
	spin_unlock(&lock->write_lock);
}

static
unsigned int foo_read_begin(struct latchfoo *lf)
{
	unsigned int ret;

	ret = ACCESS_ONCE(lf->tail);
	smp_rmb();
	return ret;
}

static
struct foo *foo_read_get(struct latchfoo *lf, unsigned int tail)
{
	return &lf->data[tail & 1];
}

static
int foo_read_retry(struct latchfoo *lf, unsigned int tail)
{
	smp_rmb();
	return (ACCESS_ONCE(lf->head) - tail >= 2);
}

Comments are welcome,

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
