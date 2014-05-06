Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaEFVjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:39:48 -0400
Received: from ns.horizon.com ([71.41.210.147]:39261 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751349AbaEFVjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:39:47 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 May 2014 17:39:46 EDT
Date: 6 May 2014 17:33:06 -0400
Message-ID: <20140506213306.17674.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: john.stultz@linaro.org
Subject: Re: [PATCH 4/4] timekeeping: Use printk_deferred when holding timekeeping seqlock
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One misfeature in the timekeeping seqlock code I noticed is that
read_seqcount_begin returns "unsigned int", not "unsigned long".

Casting to a larger type is harmless, but inefficient.

> This is due to printk() triggering console sem wakeup, which can
> cause scheduling code to trigger hrtimers which may try to read
> the time.

An alternative solution, which avoids the need for this entire patch
series, is to make ktime_get completely nonblocking.

To do that, use a seqlock variant wherein you mintain an array of "struct
timekeeper" structures so that reading is always non-blocking if there
is no writer progress.  (I.e. livelock is remotely possible, but deadlock
is not.)

In the basic version, there are two.  (You can add more to further
reduce the chance of livelock.)  The currently stable one is indicated
by (timekeeper_seq->sequence & 2).  Writers update the appropriate
one ping-pong.  The low two bits indicate four phases:

0: Both timekeepers stable, [0] preferred for reading
1: Timekeeper[1] is being written; read timekeeper[0] only
2: Both timekeepers stable, [1] preferred for reading
3: Timekeeper[0] is being written; read timekeeper[1] only

The actual writer locking code is exactly the current write_seqcount_begin
and write_seqcount_end code.

A reader needs to retry only if end_seq > (start_seq & ~1u) + 2.
Accounting for wraparound, the read sequence is:

unsigned raw_read_FOO_begin(seqcount_t const *s)
{
	unsigned ret = ACCESS_ONCE(s->sequence);
	smp_rmb();
	return ret;
}

unsigned raw_read_FOO_retry(seqcount_t const *s, unsigned start)
{
	smp_rmb();
	start &= ~1u;
	return unlikely(s->seqence - start > 2);
}


A reader does:

        unsigned seq;

        do {
		struct timekeeper const *tk;
                seq = read_FOO_begin(&timekeeper_seq);
 		tk = timekeeper + (seq >> 1 & 1);
		frobnicate(tk);
        } while (read_FOO_retry(&timekeeper_seq, seq));

I haven't yet thought of a good name (to replace FOO) for this.
"seqnonblock"?


If you have more frequent updates, there's another variant that does
away with lsbit of the sequence number, so the writer only increments it
once, after update.  This reduces coherency traffic.  It does, however,
cause more readers to retry unless you go to an array of 4 structures.
