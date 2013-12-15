Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab3LOCBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:50 -0500
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:59257 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754433Ab3LOCBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:47 -0500
X-AuditID: 12074425-b7fd96d000000c39-db-52ad0d8aae08
Date: Sat, 14 Dec 2013 21:01:44 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] random: direct all routine input via input pool
Message-ID: <20131215020144.GJ27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsUixG6notvFuzbIYPdPIYvLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXxet0ixoITchU751xmaWDcKNnFyMkhIWAisW/CRGYIW0ziwr31
	bF2MXBxCArOZJP4+PAXlbGSUeDmtG8r5xSjx/MhCNpAWFgFViYXXlzKB2GwCChI/5q8DGyUi
	oCyxauYmsDgzUPzXvU2sILawgJvEn7P97CA2r4CVxM03a8DmCAkYSLTPbGCCiAtKnJz5hAWi
	V0vixr+XQHEOIFtaYvk/DpAwp4ChxLuFVxlBbFEBFYkpJ7exTWAUnIWkexaS7lkI3QsYmVcx
	yqbkVunmJmbmFKcm6xYnJ+blpRbpWujlZpbopaaUbmIEB6qL6g7GCYeUDjEKcDAq8fBKsK0N
	EmJNLCuuzD3EKMnBpCTKK8UJFOJLyk+pzEgszogvKs1JLT7EKMHBrCTCu+P8miAh3pTEyqrU
	onyYlDQHi5I47y0O+yAhgfTEktTs1NSC1CKYrAwHh5IEbyYP0FDBotT01Iq0zJwShDQTByfI
	cB6g4f0gNbzFBYm5xZnpEPlTjIpS4rz+IAkBkERGaR5cLyyRvGIUB3pFmDcQpIoHmITgul8B
	DWYCGuy9ZxXI4JJEhJRUA6M6q1IA75p5byIYEsqZuE3l5zDK9hdm67EWFL+sr358py+e4UPu
	FKdtvNZztl57lu9v2v25gLdKTCzyyVuhfTNXlF19oWDcbCnEf2SqksxHidqW5N+6EXPPtc2b
	esdiJfPy3cWHJ5zeIqq1cMkBJz9FtV+ryqflFM/NbDdvz5jF1J/4cV67qRJLcUaioRZzUXEi
	AO+9pHn/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets us control when the nonblocking pool is reseeded from
input, even early in boot.  Our normal reseed mechanisms then
ensure that the input is used in "catastrophic reseeds",
high-entropy blobs added all at once with no possibility of output
between one part of the input and another.  If we alternate
reseed, output, reseed, output, etc., and an attacker sees the
output, then they can brute-force one reseed at a time, so that
our randomness is only slightly better than the single best reseed.

The preceding commits should ensure that until we're initialized,
we get entropy into the nonblocking pool ASAP without rate-limiting,
or sending any to the blocking pool, or losing any extra entropy
beyond our estimates, limited only by the need to batch it up into
large reseeds.  This should accomplish the important job of
getting us quickly seeded that was previously accomplished by
sending the input straight to the nonblocking pool early on.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 58e3e81d4..ea389723f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -753,11 +753,6 @@ void add_device_randomness(const void *buf, unsigned int size)
 	_mix_pool_bytes(&input_pool, buf, size, NULL);
 	_mix_pool_bytes(&input_pool, &time, sizeof(time), NULL);
 	spin_unlock_irqrestore(&input_pool.lock, flags);
-
-	spin_lock_irqsave(&nonblocking_pool.lock, flags);
-	_mix_pool_bytes(&nonblocking_pool, buf, size, NULL);
-	_mix_pool_bytes(&nonblocking_pool, &time, sizeof(time), NULL);
-	spin_unlock_irqrestore(&nonblocking_pool.lock, flags);
 }
 EXPORT_SYMBOL(add_device_randomness);
 
@@ -775,7 +770,6 @@ static struct timer_rand_state input_timer_state = INIT_TIMER_RAND_STATE;
  */
 static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 {
-	struct entropy_store	*r;
 	struct {
 		long jiffies;
 		unsigned cycles;
@@ -788,8 +782,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 	sample.jiffies = jiffies;
 	sample.cycles = random_get_entropy();
 	sample.num = num;
-	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
-	mix_pool_bytes(r, &sample, sizeof(sample), NULL);
+	mix_pool_bytes(&input_pool, &sample, sizeof(sample), NULL);
 
 	/*
 	 * Calculate number of bits of randomness we probably added.
@@ -823,7 +816,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 		 * Round down by 1 bit on general principles,
 		 * and limit entropy entimate to 12 bits.
 		 */
-		credit_entropy_bits(r, min_t(int, fls(delta>>1), 11));
+		credit_entropy_bits(&input_pool, min_t(int, fls(delta>>1), 11));
 	}
 	preempt_enable();
 }
@@ -848,7 +841,6 @@ static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
 void add_interrupt_randomness(int irq, int irq_flags)
 {
-	struct entropy_store	*r;
 	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
@@ -871,8 +863,9 @@ void add_interrupt_randomness(int irq, int irq_flags)
 
 	fast_pool->last = now;
 
-	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
-	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
+	__mix_pool_bytes(&input_pool,
+			 &fast_pool->pool, sizeof(fast_pool->pool),
+			 NULL);
 	/*
 	 * If we don't have a valid cycle counter, and we see
 	 * back-to-back timer interrupts, then skip giving credit for
@@ -886,7 +879,7 @@ void add_interrupt_randomness(int irq, int irq_flags)
 		} else
 			fast_pool->last_timer_intr = 0;
 	}
-	credit_entropy_bits(r, 1);
+	credit_entropy_bits(&input_pool, 1);
 }
 
 #ifdef CONFIG_BLOCK
-- 
1.8.3.2

