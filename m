Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab3IWECN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 00:02:13 -0400
Received: from imap.thunk.org ([74.207.234.97]:36236 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3IWECL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 00:02:11 -0400
Date: Mon, 23 Sep 2013 00:01:48 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: hpa@zytor.com, joern@logfs.org, macro@linux-mips.org, ralf@linux-mips.org,
        dave.taht@gmail.com, blogic@openwrt.org, andrewmcgr@gmail.com,
        smueller@chronox.de, geert@linux-m68k.org, tg@mirbsd.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH, RFC 03/12] random: Allow fractional bits to be tracked
Message-ID: <20130923040148.GG7321@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	hpa@zytor.com, joern@logfs.org, macro@linux-mips.org,
	ralf@linux-mips.org, dave.taht@gmail.com, blogic@openwrt.org,
	andrewmcgr@gmail.com, smueller@chronox.de, geert@linux-m68k.org,
	tg@mirbsd.de, "H. Peter Anvin" <hpa@linux.intel.com>,
	stable@vger.kernel.org
References: <1379882338-7209-1-git-send-email-tytso@mit.edu>
 <1379882338-7209-4-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379882338-7209-4-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added the following changes to this patch since upon testing,
there were some uses of r->entropy_count that were not properly
converted from using fractional bits to bits.

					- Ted

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 1547338..8654b7e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -286,6 +286,7 @@
  * entropy_count, trickle_thresh
  */
 #define ENTROPY_SHIFT 3
+#define ENTROPY_BITS(r) ((r)->entropy_count >> ENTROPY_SHIFT)
 
 /*
  * The minimum number of bits of entropy before we wake up a read on
@@ -618,7 +619,8 @@ retry:
 			r->initialized = 1;
 	}
 
-	trace_credit_entropy_bits(r->name, nbits, entropy_count,
+	trace_credit_entropy_bits(r->name, nbits,
+				  entropy_count >> ENTROPY_SHIFT,
 				  r->entropy_total, _RET_IP_);
 
 	/* should we wake readers? */
@@ -695,7 +697,7 @@ static void add_timer_randomness(struct timer_rand_state *state, unsigned num)
 
 	preempt_disable();
 	/* if over the trickle threshold, use only 1 in 4096 samples */
-	if (input_pool.entropy_count > trickle_thresh &&
+	if (ENTROPY_BITS(&input_pool) > trickle_thresh &&
 	    ((__this_cpu_inc_return(trickle_count) - 1) & 0xfff))
 		goto out;
 
@@ -999,7 +1001,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 			r->last_data_init = true;
 			spin_unlock_irqrestore(&r->lock, flags);
 			trace_extract_entropy(r->name, EXTRACT_SIZE,
-					      r->entropy_count, _RET_IP_);
+					      ENTROPY_BITS(r), _RET_IP_);
 			xfer_secondary_pool(r, EXTRACT_SIZE);
 			extract_buf(r, tmp);
 			spin_lock_irqsave(&r->lock, flags);
@@ -1008,7 +1010,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 		spin_unlock_irqrestore(&r->lock, flags);
 	}
 
-	trace_extract_entropy(r->name, nbytes, r->entropy_count, _RET_IP_);
+	trace_extract_entropy(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
@@ -1041,7 +1043,7 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
 
-	trace_extract_entropy_user(r->name, nbytes, r->entropy_count, _RET_IP_);
+	trace_extract_entropy_user(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, 0, 0);
 
@@ -1213,8 +1215,8 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 			DEBUG_ENT("sleeping?\n");
 
 			wait_event_interruptible(random_read_wait,
-				input_pool.entropy_count >=
-						 random_read_wakeup_thresh);
+				ENTROPY_BITS(&input_pool) >=
+				random_read_wakeup_thresh);
 
 			DEBUG_ENT("awake\n");
 
@@ -1250,9 +1252,9 @@ random_poll(struct file *file, poll_table * wait)
 	poll_wait(file, &random_read_wait, wait);
 	poll_wait(file, &random_write_wait, wait);
 	mask = 0;
-	if (input_pool.entropy_count >= random_read_wakeup_thresh)
+	if (ENTROPY_BITS(&input_pool) >= random_read_wakeup_thresh)
 		mask |= POLLIN | POLLRDNORM;
-	if (input_pool.entropy_count < random_write_wakeup_thresh)
+	if (ENTROPY_BITS(&input_pool) < random_write_wakeup_thresh)
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;
 }
@@ -1303,7 +1305,7 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case RNDGETENTCNT:
 		/* inherently racy, no point locking */
-		ent_count = input_pool.entropy_count >> ENTROPY_SHIFT;
+		ent_count = ENTROPY_BITS(&input_pool);
 		if (put_user(ent_count, p))
 			return -EFAULT;
 		return 0;
