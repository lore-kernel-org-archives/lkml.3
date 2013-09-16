Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab3IPRPY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 13:15:24 -0400
Received: from longford.logfs.org ([213.229.74.203]:60343 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3IPRPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 13:15:23 -0400
Date: Mon, 16 Sep 2013 11:40:27 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130916154026.GA23345@logfs.org>
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

Here is a patch to make add_interrupt_randomness() significantly
cheaper without significantly impacting the quality.  The second part
is my personal opinion and others might disagree.

So far this has only seen userspace performance testing, so don't
merge it in a hurry.

Jörn

--
You can't tell where a program is going to spend its time. Bottlenecks
occur in surprising places, so don't try to second guess and put in a
speed hack until you've proven that's where the bottleneck is.
-- Rob Pike


Doing a quick benchmark on my notebook, fast_mix() turned out to be
barely faster than the full mixing operation.  Doing 10M in a loop took
2.1s for the old fast_mix(), 2.5s for _mix_pool_bytes() and .12s for
my new fast_mix().  Making fast_mix() 16x less expensive gives people
less incentive to disable entropy collection.

The new fast_mix has a lower quality.  It simply rotates the entire pool
left by 39 bits and xor's the new entropy into the pool.  I think this
is good enough - if every interrupt collects just one bit of truly
unpredictable data and that bit is always in the same position, we will
accumulate 64 bits of entropy over the 64 rounds.  Given two bits in the
likely position - the lowest two bits of any one word - all 128 bits of
the pool are unpredictable.  If we wanted to collect more randomness, we
would have to either enlarge the pool or empty it more than once every
64 interrupts.

So I think the mixing quality is good enough.  If someone is concerned,
we can add a multiplication, which will fairly quickly mix every input
bit into every pool bit, at a 20% performance cost.  But really I would
rather collect from more entropy sources than improve mixing quality.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/char/random.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 32a6c57..36ef6e1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -555,7 +555,6 @@ struct fast_pool {
 	__u32		pool[4];
 	unsigned long	last;
 	unsigned short	count;
-	unsigned char	rotate;
 	unsigned char	last_timer_intr;
 };
 
@@ -564,21 +563,17 @@ struct fast_pool {
  * collector.  It's hardcoded for an 128 bit pool and assumes that any
  * locks that might be needed are taken by the caller.
  */
-static void fast_mix(struct fast_pool *f, const void *in, int nbytes)
+static void fast_mix(struct fast_pool *f, __u32 input[4])
 {
-	const char	*bytes = in;
-	__u32		w;
-	unsigned	i = f->count;
-	unsigned	input_rotate = f->rotate;
+	int i;
+	__u32 acc, carry = f->pool[3] >> 25;
 
-	while (nbytes--) {
-		w = rol32(*bytes++, input_rotate & 31) ^ f->pool[i & 3] ^
-			f->pool[(i + 1) & 3];
-		f->pool[i & 3] = (w >> 3) ^ twist_table[w & 7];
-		input_rotate += (i++ & 3) ? 7 : 14;
+	for (i = 0; i < 3; i++) {
+		acc = (f->pool[i] << 7) ^ input[i] ^ carry;
+		carry = f->pool[i] >> 25;
+		f->pool[i] = acc;
 	}
-	f->count = i;
-	f->rotate = input_rotate;
+	f->count++;
 }
 
 /*
@@ -757,9 +752,9 @@ void add_interrupt_randomness(int irq, int irq_flags)
 		input[3] = ip >> 32;
 	}
 
-	fast_mix(fast_pool, input, sizeof(input));
+	fast_mix(fast_pool, input);
 
-	if ((fast_pool->count & 1023) &&
+	if ((fast_pool->count & 63) &&
 	    !time_after(now, fast_pool->last + HZ))
 		return;
 
-- 
1.7.10.4

