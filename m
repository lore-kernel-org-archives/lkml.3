Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751371AbaCWSyF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:54:05 -0400
Received: from longford.logfs.org ([213.229.74.203]:43045 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaCWSyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:54:02 -0400
X-Greylist: delayed 3227 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Mar 2014 14:54:02 EDT
Date: Sun, 23 Mar 2014 14:00:01 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        geert@linux-m68k.org, tg@mirbsd.de
Subject: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140323180000.GA7096@logfs.org>
References: <20140202203617.GA9499@logfs.org>
 <20140203155042.GD9499@logfs.org>
 <20140203163729.GA13634@thunk.org>
 <20140203184857.GA26740@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140203184857.GA26740@logfs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 February 2014 13:48:57 -0500, Jörn Engel wrote:
> On Mon, 3 February 2014 11:37:29 -0500, Theodore Ts'o wrote:
> > 
> > So we could take the struct pt_regs which we get from get_irq_regs(),
> > XOR them together and use them to feed into input[2] amd input[3] in
> > add_interrupt_randomness().  Or some other way of distributing the
> > values of all of the irq registers into the __u32 input[4] array.
> > 
> > That would probably be a good and useful thing to do.  Was that
> > basically what you were suggesting?
> 
> Yes.

And here is a patch to do just that.  I am extremely unhappy with it
because it plain Does Not Help(tm).  At least it does not when using
kvm without VGA output.  Booting kvm 1000 times gave me the exact same
values for every single boot.  Quite sobering.

This patch didn't collect a single bit of entropy!

Surprisingly I find this failure quite valuable.  I managed to prove
the futility of my method - at least on automated virtual machines
without network interactions.  Afaiu none of the other entropy sources
have proven to be of any value under these circumstances either.  It
is entirely possible that zero bits of entropy is the final verdict
for such virtual machines.  Not sure about everyone else, but that is
quite a surprise to me.

Next step will be to test this patch on some entropy-challenged
hardware.

Jörn

--
The object-oriented version of 'Spaghetti code' is, of course, 'Lasagna code'.
(Too many layers).
-- Roberto Waltman.


The single biggest entropy source is a high-resolution timer running
asynchronous to the triggering event.  That leaves systems without a
useful get_cycles() implementation with significantly less entropy.
Significant means orders of magnitude, not a few percent.

An alternate high-resolution timer is the register content at the time
of an interrupt.  While not monotonic, it is guaranteed to change every
few clock cycles and very unlikely to repeat the same pattern.  Not
useful for interpretation as time, but we only care about some bits
of the "clock" to flip in an unpredictable fashion.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/char/random.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 81 insertions(+), 4 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 693dea730a3e..4a0633973aa7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -257,6 +257,7 @@
 #include <linux/kmemcheck.h>
 #include <linux/workqueue.h>
 #include <linux/irq.h>
+#include <linux/crc32.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -553,6 +554,8 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 
 struct fast_pool {
 	__u32		pool[4];
+	u32		last_shift;
+	u32		regs_count;
 	unsigned long	last;
 	unsigned short	count;
 	unsigned char	rotate;
@@ -896,6 +899,79 @@ void add_cpu_randomness(void *caller, void *val)
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
+/*
+ * Ratelimit to a steady state of about once per jiffy.  A naïve approach
+ * would be to return 1 every time jiffies changes.  But we want to avoid
+ * being closely coupled to the timer interrupt.  So instead we increment
+ * a counter on every call and shift it right every time jiffies changes.
+ * If the counter is a power of two, return false;
+ *
+ * Effect is that some time after a jiffies change and cutting the counter
+ * in half we reach another power of two and return false.  But the
+ * likelihood of this happening is about the same at any time within a
+ * jiffies interval.
+ */
+static inline int ratelimited(struct fast_pool *p)
+{
+	int ret = !(p->regs_count == 0 || is_power_of_2(p->regs_count));
+
+	p->regs_count++;
+	if (p->last_shift != (u32)jiffies) {
+		p->regs_count >>= min(31u, (u32)jiffies - p->last_shift);
+		p->last_shift = (u32)jiffies;
+	}
+	return ret;
+}
+
+#define BOOT_IRQS 1024
+
+#if 1 /* XXX: create config option, as it is a bit spammy */
+/*
+ * We have a few conflicting requirements.  In order to judge the quality
+ * of randomness we want to print out inputs on the console.  Clearly we
+ * also want to keep the inputs secret.  Tradeoff is to print a hash of
+ * the inputs a couple of times during boot.
+ */
+static void trace_boot_regs(struct pt_regs *regs, int boot_count)
+{
+	static u32 log[BOOT_IRQS];
+	int i;
+	log[BOOT_IRQS - boot_count] = crc32(0, regs, sizeof(*regs));
+	if (boot_count == 1) {
+		for (i = 0; i < BOOT_IRQS; i++)
+			pr_info("irq regs(%d): %x\n", i, log[i]);
+	}
+}
+#endif
+
+/*
+ * The single biggest entropy source is a high-resolution timer running
+ * asynchronous to the triggering event.  That leaves systems without a
+ * useful get_cycles() implementation with significantly less entropy.
+ * Significant means orders of magnitude, not a few percent.
+ *
+ * An alternate high-resolution timer is the register content at the time
+ * of an interrupt.  While not monotonic, it is guaranteed to change every
+ * few clock cycles and very unlikely to repeat the same pattern.  Not
+ * useful for interpretation as time, but we only care about some bits
+ * of the "clock" to flip in an unpredictable fashion.
+ */
+static void mix_regs(struct pt_regs *regs, struct fast_pool *fast_pool)
+{
+	/* Two variables avoid decrementing by two without using atomics */
+	static int boot_count = BOOT_IRQS;
+	int in_boot = boot_count;
+
+	if (in_boot) {
+		trace_boot_regs(regs, boot_count);
+		boot_count = in_boot - 1;
+	} else if (ratelimited(fast_pool))
+		return;
+
+	mix_pool_bytes(&input_pool, regs, sizeof(*regs), NULL);
+	mix_pool_bytes(&nonblocking_pool, regs, sizeof(*regs), NULL);
+}
+
 void add_interrupt_randomness(int irq, int irq_flags)
 {
 	struct entropy_store	*r;
@@ -906,13 +982,14 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	__u32			input[4], c_high, j_high;
 	__u64			ip;
 
+	mix_regs(regs, fast_pool);
 	c_high = (sizeof(cycles) > 4) ? cycles >> 32 : 0;
 	j_high = (sizeof(now) > 4) ? now >> 32 : 0;
-	input[0] = cycles ^ j_high ^ irq;
-	input[1] = now ^ c_high;
+	input[0] ^= cycles ^ j_high ^ irq;
+	input[1] ^= now ^ c_high;
 	ip = regs ? instruction_pointer(regs) : _RET_IP_;
-	input[2] = ip;
-	input[3] = ip >> 32;
+	input[2] ^= ip;
+	input[3] ^= ip >> 32;
 
 	fast_mix(fast_pool, input);
 
-- 
1.8.5.3

