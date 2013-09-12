Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab3IMBKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:10:21 -0400
Received: from longford.logfs.org ([213.229.74.203]:60268 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3IMBKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:10:19 -0400
Date: Thu, 12 Sep 2013 19:35:36 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130912233535.GI3809@logfs.org>
References: <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
 <20130910203853.GG29237@thunk.org>
 <522F851D.1040101@linaro.org>
 <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
 <20130910223326.GD11063@thunk.org>
 <522FB9F1.3070905@linaro.org>
 <20130911005047.GA13315@thunk.org>
 <20130912210717.GC3809@logfs.org>
 <20130912233155.GB5279@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130912233155.GB5279@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 September 2013 19:31:55 -0400, Theodore Ts'o wrote:
> On Thu, Sep 12, 2013 at 05:07:17PM -0400, Jörn Engel wrote:
> > 
> > I happen to have a real-world system with >100k interrupts per second
> > and - surprise - add_interrupt_randomness() showed up prominently in
> > the profiles.  I was also told twice to just remove that call.  I
> > resisted both times and have done far more work to reduce overhead
> > while still collecting entropy.  Some others would have caved in.
> 
> Would it be possible for you to send me the perf numbers that you saw?

Eventually.  The idiot that was me half a year ago failed to attach
perf numbers to the patch description.

> What platform is this?  x86?   Some embedded processor?

x86.  I suspect NAPI significantly cuts down the number of interrupts
for ethernet cards.  My case is with FC interrupts.  Quite likely
doing something like NAPI would help far more for performance than
disabling add_interrupt_randomness().

> > One option is to add the "input_pool.entropy_count > trickle_thresh"
> > condition that all other entropy sources currently have.  But instead
> > I would rather rename fast_mix() to not_too_fast_mix() and implement a
> > real fast_mix().  Essentially just xor the collected numbers into a
> > pool and schedule something to shuffle the bits at a later point.
> 
> We can try some different things to make fast_mix() faster, but it
> would be good to get some hard numbers before we start deciding we
> need to do something more complicated.
> 
> One thing that comes to mind is that fast_mix() is only called in
> exactly one place, and we always pass in a long.  So there are
> certainly ways that we could optimize fast_mix even keeping the
> current mixing algorithm.

I think the existing code is doing just fine for low interrupt loads.
It makes sense to spend a bit more work to squeeze the last bit of
randomness out.  But when you get lots of interrupts, you can be
sloppy and just xor things into the pool.

My patch below is going too far by not even doing the xor.  I was
stupid and under time pressure.  But to my defence,
add_timer_randomness() makes the same mistake.

Jörn

--
Eighty percent of success is showing up.
-- Woody Allen

>From ee197e39b9a6c905db870606f5bacab2a52a8da2 Mon Sep 17 00:00:00 2001
From: Joern Engel <joern@logfs.org>
Date: Wed, 13 Feb 2013 10:34:26 -0800
Subject: [PATCH] random: limit overhead of add_interrupt_randomness

fast_mix is noticeably less fast than the name might imply.  Add
rate-limiting to it, so we only run it once per jiffie and cpu for the
painful case of a single interrupt hammering a cpu.  Instead we do the
dumbest possible mixing - we xor the input with the pool without any
shifting whatsoever.  Gathers some randomness at near-zero cost.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/char/random.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b86eae9..7b7f64e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -557,6 +557,7 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 struct fast_pool {
 	__u32		pool[4];
 	unsigned long	last;
+	unsigned long	last_jiffies;
 	unsigned short	count;
 	unsigned char	rotate;
 	unsigned char	last_timer_intr;
@@ -760,6 +761,17 @@ void add_interrupt_randomness(int irq, int irq_flags)
 		input[3] = ip >> 32;
 	}
 
+	/*
+	 * Even fast_mix is slow when dealing with 6-digit interrupt
+	 * rates.  Rate-limit this to once per jiffie.  If we get lots
+	 * of interrupts, this still generates 1.6 bits of entropy per
+	 * second and cpu.  If we get few interrupts, it shouldn't
+	 * substantially change the entropy collection.
+	 */
+	if (fast_pool->last_jiffies == jiffies)
+		return;
+	fast_pool->last_jiffies = jiffies;
+
 	fast_mix(fast_pool, input, sizeof(input));
 
 	if ((fast_pool->count & 1023) &&
-- 
1.7.10.4

