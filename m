Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaBBU4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 15:56:13 -0500
Received: from longford.logfs.org ([213.229.74.203]:42670 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbaBBU4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 15:56:12 -0500
X-Greylist: delayed 1251 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Feb 2014 15:56:12 EST
Date: Sun, 2 Feb 2014 15:36:17 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        geert@linux-m68k.org, tg@mirbsd.de
Subject: [PATCH,RFC] random: collect cpu randomness
Message-ID: <20140202203617.GA9499@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collects entropy from random behaviour all modern cpus exhibit.  The
scheduler and slab allocator are instrumented for this purpose.  How
much randomness can be gathered is clearly hardware-dependent and hard
to estimate.  Therefore the entropy estimate is zero, but random bits
still get mixed into the pools.

Performance overhead seems low.  I did 20 kernel compiles with
allnoconfig, everything precompiled and warm caches.  Difference was in
the noise and on average performance was actually better when collecting
randomness.

To judge the benefits I ran this in kvm with instrumentation to print
out the various input values.  Entropy was estimated by booting ten
times, collecting the output for each boot, doing a diff between any two
and counting the diff hunks.  Numbers like "46 .. 215" means the two
most similar runs had 46 hunks, the two most dissimilar ones had 215.

Running kvm with -smp 4 gave the following results:
                 slab+sched     slab            sched
input[0]         46 .. 215      202 .. 342        0 ..   0
input[1]         76 .. 180        0 ..   4        0 ..   0
input[2]        147 .. 388        4 ..  44      286 .. 464
input[3]         56 .. 185        0 ..   2        9 ..  40
jiffies           8 ..  67       10 ..  28       19 ..  50
caller          114 .. 306       25 .. 178      219 .. 422
val              54 .. 254       15 .. 106      175 .. 321
&input           50 .. 246        0 ..  59      178 .. 387

First column collected entropy from both the slab allocator and the
scheduler, second and third only collected from one source.  I only used
the first 512 values per cpu.  Therefore the combined numbers can be
lower than the individual ones - there was more entropy collected, it
was just swamped by non-entropy.

Lots of entropy gets collected and about half of it stems from the
uninitialized valued of input[] on the stack.

Rerunning only the first column with -smp 1 was more sobering:
                slab+sched
input[0]          0 ..  13
input[1]          0 ..  13
input[2]          0 ..  14
input[3]          0 ..  11
jiffies           2 ..  22
caller            0 ..  19
val               0 ..  16
&input            0 ..   4

Every single input value contains entropy in some runs, but the only one
that was an entropy guarantee was jiffies.  In other words, a
low-precision clock.  This clearly shows how important it is to have a
high-precision clock, which would gather significantly more entropy.

Measuring the randomness from random_get_entropy() with above approach
failed because there was so much randomness.  All numbers in all runs
were different.  Taking the delta between the numbers, again almost all
numbers were different with at most 1 identical delta per 1000.
Compared to a high-precision clock, no other input comes within two
orders of magnitude.

An interesting aside is that the cpu actually functions as a
high-precision clock.  This partially explains why the -smp 4 number are
so much better - any drift between the four cpu-clocks gets turned into
randomness.  The other explanation is that kvm is actually collecting
randomness from the host system.  I tried to minimize that effect by not
touching my notebook while running these tests, but a hardware test box
would clearly yield more meaningful results.

I invite others to also test whether the patch collects useful
randomness or causes a measureable performance loss on any hardware or
workload.  Preferrably not using my methods, in order to avoid
systematic errors.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/char/random.c  | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/random.h |  2 ++
 kernel/sched/core.c    |  1 +
 mm/slab.c              |  1 +
 4 files changed, 65 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75bb60e8..693dea730a3e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -587,6 +587,30 @@ static void fast_mix(struct fast_pool *f, __u32 input[4])
 }
 
 /*
+ * An even faster variant of fast_mix, albeit with worse mixing.
+ */
+static void weak_mix(struct fast_pool *f, __u32 input[4])
+{
+	__u32 acc, carry = f->pool[3] >> 25;
+
+	acc = (f->pool[0] << 7) ^ input[0] ^ carry;
+	carry = f->pool[0] >> 25;
+	f->pool[0] = acc;
+
+	acc = (f->pool[1] << 7) ^ input[1] ^ carry;
+	carry = f->pool[1] >> 25;
+	f->pool[1] = acc;
+
+	acc = (f->pool[2] << 7) ^ input[2] ^ carry;
+	carry = f->pool[2] >> 25;
+	f->pool[2] = acc;
+
+	acc = (f->pool[3] << 7) ^ input[3] ^ carry;
+	//carry = f->pool[3] >> 25;
+	f->pool[3] = acc;
+}
+
+/*
  * Credit (or debit) the entropy store with n bits of entropy.
  * Use credit_entropy_bits_safe() if the value comes from userspace
  * or otherwise should be checked for extreme values.
@@ -833,6 +857,43 @@ void add_input_randomness(unsigned int type, unsigned int code,
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
+static DEFINE_PER_CPU(struct fast_pool, cpu_randomness);
+
+void __add_cpu_randomness(void *caller, void *val)
+{
+	struct entropy_store	*r;
+	struct fast_pool	*fast_pool = &__get_cpu_var(cpu_randomness);
+	unsigned long		now = jiffies;
+	__u32			input[4], cycles = random_get_entropy();
+
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wuninitialized"
+	input[0] ^= cycles ^ jiffies;
+	input[1] ^= (unsigned long)caller;
+	input[2] ^= (unsigned long)val;
+	input[3] ^= (unsigned long)&input;
+#pragma GCC diagnostic pop
+
+	weak_mix(fast_pool, input);
+
+	if ((fast_pool->count++ & 1023) &&
+	    !time_after(now, fast_pool->last + HZ))
+		return;
+
+	fast_pool->last = now;
+	fast_pool->count = 1;
+
+	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
+	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
+}
+
+void add_cpu_randomness(void *caller, void *val)
+{
+	preempt_disable();
+	__add_cpu_randomness(caller, val);
+	preempt_enable();
+}
+
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
 void add_interrupt_randomness(int irq, int irq_flags)
diff --git a/include/linux/random.h b/include/linux/random.h
index 4002b3df4c85..ce0ccdcd1d63 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -12,6 +12,8 @@
 extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
+extern void __add_cpu_randomness(void *caller, void *val);
+extern void add_cpu_randomness(void *caller, void *val);
 extern void add_interrupt_randomness(int irq, int irq_flags);
 
 extern void get_random_bytes(void *buf, int nbytes);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index a88f4a485c5e..7af6389f9b9e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2511,6 +2511,7 @@ need_resched:
 	rq = cpu_rq(cpu);
 	rcu_note_context_switch(cpu);
 	prev = rq->curr;
+	__add_cpu_randomness(__builtin_return_address(1), prev);
 
 	schedule_debug(prev);
 
diff --git a/mm/slab.c b/mm/slab.c
index eb043bf05f4c..ea5a30d44ad1 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3587,6 +3587,7 @@ static __always_inline void *__do_kmalloc(size_t size, gfp_t flags,
 	trace_kmalloc(caller, ret,
 		      size, cachep->size, flags);
 
+	add_cpu_randomness(__builtin_return_address(2), ret);
 	return ret;
 }
 
-- 
1.8.5.2

