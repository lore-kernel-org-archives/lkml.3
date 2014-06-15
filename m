Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaFODEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 23:04:46 -0400
Received: from imap.thunk.org ([74.207.234.97]:39320 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbaFODEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 23:04:44 -0400
Date: Sat, 14 Jun 2014 23:04:41 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: George Spelvin <linux@horizon.com>
Subject: Surprising 64-bit performance anomaly (was Re: [PATCH] random: use
 an improved fast_mix() function)
Message-ID: <20140615030441.GA8111@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	George Spelvin <linux@horizon.com>
References: <1402798797-26251-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402798797-26251-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On top of the above patch, I applied the following to add 64-bit pool
support.  I had to use a union to avoid type punning warnings.

When building a 64-bit kernel and running under under KVM, I'm finding
that the 64-bit mix function which you suggested is twice as slow.

Using the (new) 32-bit function:

31821 23970
31629 24366
30856 24182

Using the 64-bit mixing function:

60438 44369
60820 45402
58778 45419

				- Ted


diff --git a/drivers/char/random.c b/drivers/char/random.c
index b19edad..0685413 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -257,6 +257,7 @@
 #include <linux/kmemcheck.h>
 #include <linux/workqueue.h>
 #include <linux/irq.h>
+#include <linux/bitops.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -267,7 +268,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/random.h>
 
-/* #define ADD_INTERRUPT_BENCH */
+#define ADD_INTERRUPT_BENCH
+/* #define FORCE_32_VERSION */
 
 /*
  * Configuration information
@@ -548,7 +550,10 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 }
 
 struct fast_pool {
-	__u32		pool[4];
+	union {
+		__u32	pool32[4];
+		__u64	pool64[2];
+	} pool;
 	unsigned long	last;
 	unsigned char	count;
 	unsigned char	notimer_count;
@@ -560,10 +565,32 @@ struct fast_pool {
  * collector.  It's hardcoded for an 128 bit pool and assumes that any
  * locks that might be needed are taken by the caller.
  */
+#if (BITS_PER_LONG == 64) && !defined(FORCE_32_VERSION)
+#warning Building 64 bit fast_mix
 static void fast_mix(struct fast_pool *f)
 {
-	__u32 a = f->pool[0],	b = f->pool[1];
-	__u32 c = f->pool[2],	d = f->pool[3];
+	__u64 a = f->pool.pool64[0], b = f->pool.pool64[1];
+
+	a += b; b = rol64(b, 52);
+	b ^= a; a = rol64(a, 10);
+	a += b; b = rol64(b, 47);
+	b ^= a; a = rol64(a, 17);
+
+	a += b; b = rol64(b, 52);
+	b ^= a; a = rol64(a, 10);
+	a += b; b = rol64(b, 47);
+	b ^= a; a = rol64(a, 17);
+
+	f->pool.pool64[0] = a;  f->pool.pool64[1] = b;
+	f->count++;
+}
+
+#else
+#warning Building 32 bit fast_mix
+static void fast_mix(struct fast_pool *f)
+{
+	__u32 a = f->pool.pool32[0], b = f->pool.pool32[1];
+	__u32 c = f->pool.pool32[2], d = f->pool.pool32[3];
 
 	a += b;			c += d;
 	b = rol32(a, 6);	d = rol32(c, 27);
@@ -581,10 +608,11 @@ static void fast_mix(struct fast_pool *f)
 	b = rol32(a, 16);	d = rol32(c, 14);
 	d ^= a;			b ^= c;
 
-	f->pool[0] = a;  f->pool[1] = b;
-	f->pool[2] = c;  f->pool[3] = d;
+	f->pool.pool32[0] = a;  f->pool.pool32[1] = b;
+	f->pool.pool32[2] = c;  f->pool.pool32[3] = d;
 	f->count++;
 }
+#endif
 
 /*
  * Credit (or debit) the entropy store with n bits of entropy.
@@ -870,11 +898,11 @@ void add_interrupt_randomness(int irq, int irq_flags)
 
 	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
 	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
-	fast_pool->pool[0] ^= cycles ^ j_high ^ irq;
-	fast_pool->pool[1] ^= now ^ c_high;
+	fast_pool->pool.pool32[0] ^= cycles ^ j_high ^ irq;
+	fast_pool->pool.pool32[1] ^= now ^ c_high;
 	ip = regs ? instruction_pointer(regs) : _RET_IP_;
-	fast_pool->pool[2] ^= ip;
-	fast_pool->pool[3] ^= ip >> 32;
+	fast_pool->pool.pool32[2] ^= ip;
+	fast_pool->pool.pool32[3] ^= ip >> 32;
 
 	fast_mix(fast_pool);
 	if ((irq_flags & __IRQF_TIMER) == 0)
