Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaBDMrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 07:47:31 -0500
Received: from mail.eperm.de ([89.247.134.16]:34130 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478AbaBDMr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 07:47:28 -0500
From: Stephan Mueller <smueller@chronox.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org,
        tg@mirbsd.de, sandyinchina@gmail.com
Subject: [PATCH 3/5] CPU Jitter RNG: integration with /dev/random
Date: Tue, 04 Feb 2014 13:40:54 +0100
Message-ID: <2427012.m8QUSqNNKF@myon.chronox.de>
User-Agent: KMail/4.11.5 (Linux/3.12.8-300.fc20.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2039634.jSmQAS6tdi@myon.chronox.de>
References: <2039634.jSmQAS6tdi@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The CPU Jitter RNG is included into random.c as a new noise source.
The noise source, however, works differently than all other noise
sources. The CPU Jitter RNG provides entropy on demand and thus, the
callback to obtain new data is implemented as a pull operation.

The pull operation is only executed for the input_pool when its entropy
estimator falls below the threshold that causes /dev/random to block. In
this case, the CPU Jitter RNG is queried to provide as much random
numbers as requested by the caller, but not more than 64 bytes at one
time.

The restrictions shall ensure that the CPU Jitter RNG does not
monopolize all other Linux RNG noise sources, as it provides entropy far
faster than any other noise sources.

When pulling data from /dev/random, no user-noticable blocking occurs
any more. Also, the speed of /dev/urandom is not lowered by the
patch.

When the first random number is pulled from the Linux RNG, the code
invokes the CPU Jitter RNG self test which verifies that the underlying
hardware is capable enough to support the RNG. If the hardware is
insufficient (i.e. it does not provide a high-resolution timer), the CPU
Jitter RNG noise source is completely disabled. Otherwise it will
provide entropy right for the first invocations of the Linux RNG.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/random.c | 86 
++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75b..eb4fe99 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -267,6 +267,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/random.h>
 
+#include <linux/jitterentropy.h>
+
 /*
  * Configuration information
  */
@@ -430,19 +432,23 @@ struct entropy_store {
 	unsigned int limit:1;
 	unsigned int last_data_init:1;
 	__u8 last_data[EXTRACT_SIZE];
+	struct rand_data jent_ec;
 };
 
 static void push_to_pool(struct work_struct *work);
 static __u32 input_pool_data[INPUT_POOL_WORDS];
 static __u32 blocking_pool_data[OUTPUT_POOL_WORDS];
 static __u32 nonblocking_pool_data[OUTPUT_POOL_WORDS];
+static unsigned char input_jentmem[JENT_MEMORY_SIZE];
 
 static struct entropy_store input_pool = {
 	.poolinfo = &poolinfo_table[0],
 	.name = "input",
 	.limit = 1,
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
-	.pool = input_pool_data
+	.pool = input_pool_data,
+	.jent_ec.mem = input_jentmem,
+	.jent_ec.memblocks = 0,
 };
 
 static struct entropy_store blocking_pool = {
@@ -454,6 +460,7 @@ static struct entropy_store blocking_pool = {
 	.pool = blocking_pool_data,
 	.push_work = __WORK_INITIALIZER(blocking_pool.push_work,
 					push_to_pool),
+	.jent_ec.mem = NULL,
 };
 
 static struct entropy_store nonblocking_pool = {
@@ -464,6 +471,7 @@ static struct entropy_store nonblocking_pool = {
 	.pool = nonblocking_pool_data,
 	.push_work = __WORK_INITIALIZER(nonblocking_pool.push_work,
 					push_to_pool),
+	.jent_ec.mem = NULL,
 };
 
 static __u32 const twist_table[8] = {
@@ -715,6 +723,81 @@ static void credit_entropy_bits_safe(struct entropy_store 
*r, int nbits)
  *
  *********************************************************************/
 
+/* On some architectures without random_get_entropy, the clocksource
+ * drivers may provide a high resolution timer. This, however, prevents
+ * this function from being called from init_std_data to fill the
+ * entropy pools with entropy at the time of creation. The clocksource 
drivers
+ * are loaded during module_init() time, just as init_std_data. Thus, there
+ * is no guarantee that the clocksource drivers are available here.
+ */
+static void add_jent_randomness(struct entropy_store *r, int bytes)
+{
+#define JENT_BUFFER 64 /* ensure that JENT_BUFFER is a multiple of
+			* the CPU Jitter RNG block size */
+	char rand[JENT_BUFFER];
+	int ret = 0;
+	int entropy_count = 0;
+	unsigned long flags;
+
+	/* the initialization process determined that we cannot use the
+	 * CPU Jitter RNG or the caller provided wrong input */
+	if(NULL == r->jent_ec.mem || 0 >= bytes)
+		return;
+
+	/* only use the Jitter RNG if we fall to the low threshold as
+	 * otherwise the Jitter RNG monopolizes the noise sources */
+	entropy_count = ACCESS_ONCE(r->entropy_count);
+	entropy_count = entropy_count >> (ENTROPY_SHIFT);
+	if (entropy_count > random_read_wakeup_thresh)
+		return;
+
+	memset(rand, 0, JENT_BUFFER);
+	spin_lock_irqsave(&r->lock, flags);
+	if(0 == r->jent_ec.memblocks)
+	{
+		/* we are uninitialized, try to initialize */
+		if(jent_entropy_init())
+		{
+			/* there is no CPU Jitter, disable the collector */
+			r->jent_ec.mem = NULL;
+			spin_unlock_irqrestore(&r->lock, flags);
+			return;
+		}
+		r->jent_ec.data = 0;
+		r->jent_ec.prev_time = 0;
+		r->jent_ec.old_data = 0;
+		r->jent_ec.fips_fail = 0;
+		r->jent_ec.stir = 0;
+		r->jent_ec.disable_unbias = 0;
+		r->jent_ec.osr = 1;
+		/* r->jent_ec.mem does not need to be zeroized */
+		r->jent_ec.memblocksize = JENT_MEMORY_BLOCKSIZE;
+		r->jent_ec.memblocks = JENT_MEMORY_BLOCKS;
+		r->jent_ec.memaccessloops = JENT_MEMORY_ACCESSLOOPS;
+		/* fill the entropy collector and init the FIPS test
+		 * by pulling one round from the RNG */
+		jent_read_entropy(&r->jent_ec, rand, 8);
+	}
+
+	/* never pull more bytes than available in temp variable */
+	ret = min_t(int, bytes, JENT_BUFFER);
+#define JENT_WRAP (DATA_SIZE_BITS / 8 - 1)
+	/* round up number of bytes to be pulled to next multiple of
+	 * CPU Jitter RNG block size */
+	ret = (ret + JENT_WRAP) &~ JENT_WRAP;
+
+	ret = jent_read_entropy(&r->jent_ec, rand, ret);
+	spin_unlock_irqrestore(&r->lock, flags);
+	if(0 < ret)
+	{
+		/* we do not need to worry about trickle threshold as we are
+		 * called when we are low on entropy */
+		mix_pool_bytes(r, rand, ret, NULL);
+		credit_entropy_bits(r, ret * 8);
+	}
+	memset(rand, 0, JENT_BUFFER);
+}
+
 /* There is one of these per entropy source */
 struct timer_rand_state {
 	cycles_t last_time;
@@ -935,6 +1018,7 @@ static void _xfer_secondary_pool(struct entropy_store *r, 
size_t nbytes)
 
 	trace_xfer_secondary_pool(r->name, bytes * 8, nbytes * 8,
 				  ENTROPY_BITS(r), ENTROPY_BITS(r->pull));
+	add_jent_randomness(r->pull, bytes);
 	bytes = extract_entropy(r->pull, tmp, bytes,
 				random_read_wakeup_thresh / 8, rsvd);
 	mix_pool_bytes(r, tmp, bytes, NULL);
-- 
1.8.5.3


