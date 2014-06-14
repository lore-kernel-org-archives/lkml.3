Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaFNCKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 22:10:18 -0400
Received: from ns.horizon.com ([71.41.210.147]:26460 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754078AbaFNCKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 22:10:16 -0400
Date: 13 Jun 2014 22:10:14 -0400
Message-ID: <20140614021014.1863.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140613155241.GA4265@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Unrolling doesn't make much difference; which isn't surprising given
> that almost all of the differences go away when I commented out the
> udelay().  Basically, at this point what we're primarily measuring is
> how good various CPU's caches work, especially across context switches
> where other code gets to run in between.

Huh.  As I was referring to when I talked about the branch
predictor, I was hoping the removing *conditional* branches would
help.

> If that's the case, all else being equal, removing the extra memory
> reference for twist_table[] does make sense, and something else I've
> considered doing is to remove the input[] array entirely, and have
> add_interrupt_randomness[] xor values directly into the pool, and then
> let that fast_mix function stir the pool.

Are you trying for an XOR to memory, or is the idea to remain in registers
for the entire operation?

I'm not sure an XOR to memory is that much better; it's 2 pool loads
and 1 pool store either way.  Currently, the store is first (to
input[]) and then both it and the fast_pool are fetched in fast_mix.

With an XOR to memory, it's load-store-load, but is that really better?

In case it's useful, below is a small patch I made to
add_interrupt_randomness to take advantage of 64-bit processors and make
it a bit clearer what it's doing.  Not submitted officially because:
1) I haven't examined the consequences on 32-bit processors carefully yet.
2) It's more of a "code cleanup", meaning personal style preference,
   and you've expressed some pretty strong unhappiness with such churn.

It's also useful preparation for changing to a native 64-bit fast_mix.

In general, I dislike "pre-compressing" the input; if the input hash isn't
fast enough, fix that for all users rather than adding something ad-hoc.

If you want a last_mix function with different input and state widths,
I can try to come up with one. (Given the iterated nature of the current
fast_mix2, you can also just add additional seed material betwene the
rounds.)

> I also think that it's going to be worthwhile to do the RDTSC
> measurement in vitro, and calculate average and max latencies, since
> it's clear that there are real limitations to userspace benchmarking.

I'm not sure you're not making a clever joke about the use of silicon
dioxide in real chips, but don't you mean "in vivo"?

(Also, if we're reading the TSC twice, and we know the delta is noisy
as heck, seed with it!)



commit d3c0a185991a45e420925d040f19e764808b354e
Author: George Spelvin <linux@horizon.com>
Date:   Sat Jun 7 21:16:45 2014 -0400

    random: Simplify add_interrupt_randomness using 64-bit math
    
    The same values (except word-swapped on big-endian machines) are passed
    to fast_mix, but the code is simpler, smaller, and uses 64-bit operations
    if available.
    
    Signed-off-by: George Spelvin <linux@horizon.com>

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 868760e1..acc9bb1a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -563,7 +563,7 @@ struct fast_pool {
  * collector.  It's hardcoded for an 128 bit pool and assumes that any
  * locks that might be needed are taken by the caller.
  */
-static void fast_mix(struct fast_pool *f, __u32 input[4])
+static void fast_mix(struct fast_pool *f, __u32 const input[4])
 {
 	__u32		w;
 	unsigned	input_rotate = f->rotate;
@@ -839,22 +839,16 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	struct entropy_store	*r;
 	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
-	unsigned long		now = jiffies;
-	cycles_t		cycles = random_get_entropy();
-	__u32			input[4], c_high, j_high;
-	__u64			ip;
 	unsigned long		seed;
 	int			credit;
+	unsigned long		now = jiffies;
+	cycles_t		cycles = random_get_entropy();
+	__u64 const 	input[2] = {
+				cycles ^ irq ^ rol64(now, 32),
+				regs ? instruction_pointer(regs) : _RET_IP_
+			};
 
-	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
-	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
-	input[0] = cycles ^ j_high ^ irq;
-	input[1] = now ^ c_high;
-	ip = regs ? instruction_pointer(regs) : _RET_IP_;
-	input[2] = ip;
-	input[3] = ip >> 32;
-
-	fast_mix(fast_pool, input);
+	fast_mix(fast_pool, (__u32 const *)input);
 
 	if ((fast_pool->count & 63) && !time_after(now, fast_pool->last + HZ))
 		return;
