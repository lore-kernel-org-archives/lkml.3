Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbaFNGZJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 02:25:09 -0400
Received: from imap.thunk.org ([74.207.234.97]:38655 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaFNGZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 02:25:04 -0400
Date: Sat, 14 Jun 2014 02:24:58 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
Subject: Re: random: Benchamrking fast_mix2
Message-ID: <20140614062458.GC6447@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	George Spelvin <linux@horizon.com>, hpa@linux.intel.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org, price@mit.edu
References: <20140614030621.GB6447@thunk.org>
 <20140614052527.14849.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614052527.14849.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, so I normally do my testing using 32-bit kernels under KVM.  On a
i386 kernel, running under kvm (again using a Lenovo T540 with a
i7-4900MQ CPU), with the original fast_mix, I get a timestamp count of
166 cycles using a weighted smoothed average.  Using your fast_mix2 I
get around 450 cycles.

I'll try a 64-bit kernel build later this weekend.

Want to give this patch a try on your collection of machines?

						- Ted

P.S.  ADD_INTERRUPT_BENCH works only on x86 architectures because
random_get_entropy() mapes to get_cycles() which is RDTSC.  It won't
work on many other architectures, which don't have a timestamp
counter.

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4bb6e37..90a1c9f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -267,6 +267,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/random.h>
 
+#define ADD_INTERRUPT_BENCH
+
 /*
  * Configuration information
  */
@@ -553,6 +555,7 @@ struct fast_pool {
 	unsigned char	last_timer_intr;
 };
 
+#ifdef ORIG_FAST_MIX
 /*
  * This is a fast mixing routine used by the interrupt randomness
  * collector.  It's hardcoded for an 128 bit pool and assumes that any
@@ -579,6 +582,34 @@ static void fast_mix(struct fast_pool *f, __u32 input[4])
 	f->rotate = input_rotate;
 	f->count++;
 }
+#else
+extern void fast_mix(struct fast_pool *f, __u32 const input[4])
+{
+	__u32 a = f->pool[0] ^ input[0],  b = f->pool[1] ^ input[1];
+	__u32 c = f->pool[2] ^ input[2],  d = f->pool[3] ^ input[3];
+	int i;
+
+
+	for (i = 0; i < 3; i++) {
+		/*
+		 * Inspired by ChaCha's QuarterRound, but
+		 * modified for much greater parallelism.
+		 * Surprisingly, rotating a and c seems to work
+		 * better than b and d.  And it runs faster.
+		 */
+		a += b;                 c += d;
+		d ^= a;                 b ^= c;
+		a = rol32(a, 15);       c = rol32(c, 21);
+
+		a += b;                 c += d;
+		d ^= a;                 b ^= c;
+		a = rol32(a, 3);	c = rol32(c, 7);
+	}
+	f->pool[0] = a;  f->pool[1] = b;
+	f->pool[2] = c;  f->pool[3] = d;
+	f->count++;
+}
+#endif
 
 /*
  * Credit (or debit) the entropy store with n bits of entropy.
@@ -829,6 +860,27 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
+#ifdef ADD_INTERRUPT_BENCH
+static unsigned long avg_cycles;
+
+#define FSHIFT		11		/* nr of bits of precision */
+#define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
+#define EXP		2040
+
+static void add_interrupt_bench(cycles_t start)
+{
+	cycles_t duration = random_get_entropy() - start;
+
+	/* use a weighted moving average */
+	avg_cycles *= EXP;
+	avg_cycles += duration * (FIXED_1 - EXP);
+	avg_cycles += 1UL << (FSHIFT - 1);
+	avg_cycles >>= FSHIFT;
+}
+#else
+#define add_interrupt_bench(x)
+#endif
+
 void add_interrupt_randomness(int irq, int irq_flags)
 {
 	struct entropy_store	*r;
@@ -850,6 +902,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	input[3] = ip >> 32;
 
 	fast_mix(fast_pool, input);
+	add_interrupt_bench(cycles);
 
 	if ((fast_pool->count & 63) && !time_after(now, fast_pool->last + HZ))
 		return;
@@ -1644,6 +1697,15 @@ struct ctl_table random_table[] = {
 		.mode		= 0444,
 		.proc_handler	= proc_do_uuid,
 	},
+#ifdef ADD_INTERRUPT_BENCH
+	{
+		.procname	= "add_interrupt_avg_cycles",
+		.data		= &avg_cycles,
+		.maxlen		= sizeof(avg_cycles),
+		.mode		= 0444,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+#endif
 	{ }
 };
 #endif 	/* CONFIG_SYSCTL */
