Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3LOCBn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 21:01:43 -0500
Received: from dmz-mailsec-scanner-5.mit.edu ([18.7.68.34]:43553 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392Ab3LOCBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 21:01:41 -0500
X-AuditID: 12074422-b7f9d6d000000bc0-59-52ad0d84eae4
Date: Sat, 14 Dec 2013 21:01:38 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] random: reserve entropy for nonblocking pool early on
Message-ID: <20131215020138.GI27191@athena.dialup.mit.edu>
References: <cover.1387067223.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387067223.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsUixG6notvCuzbI4P5CS4vLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJWx7v1xxoLrEhWbzk5kbmCcIdLFyMEhIWAisedSfBcjJ5ApJnHh
	3nq2LkYuDiGB2UwSO65cZoFwNjJKvLx0hBHC+cUo8WLVfUaQFhYBVYlp1y+D2WwCChI/5q9j
	BrFFBJQlVs3cxARiMwPFf93bxApiCwv4SDze0MYGYvMKWEmcOv8SzBYSMJBon9nABBEXlDg5
	8wkLRK+WxI1/L5lALmUWkJZY/o8DJMwpYCjxbuFVsLWiAioSU05uY5vAKDgLSfcsJN2zELoX
	MDKvYpRNya3SzU3MzClOTdYtTk7My0st0jXVy80s0UtNKd3ECA5TF6UdjD8PKh1iFOBgVOLh
	lWBbGyTEmlhWXJl7iFGSg0lJlFeKEyjEl5SfUpmRWJwRX1Sak1p8iFGCg1lJhHfH+TVBQrwp
	iZVVqUX5MClpDhYlcd5bHPZBQgLpiSWp2ampBalFMFkZDg4lCd5FPEBDBYtS01Mr0jJzShDS
	TBycIMN5gIafA6nhLS5IzC3OTIfIn2LU5ehZ9+EboxBLXn5eqpQ4rz9IkQBIUUZpHtwcWHp5
	xSgO9JYw7ymQKh5gaoKb9ApoCRPQEu89q0CWlCQipKQaGP0nhV/fJlah+Tnbtahtn7f9d7m/
	i5+lLNBhkPfNmHYs4fqso+tSUgLvzbVY9mTmhrPp7zeKWhm8jvFdu2GFK2sc51IOiWvMn18t
	mR94uSHok21G1TJbC8UbW1j+6vPba5zaPu3Kb2WbB2fePjl7zpr1oseM0rvx5zxShQSOG28x
	CHl74JXCz11KLMUZiYZazEXFiQCuNZcdCgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While booting, our priority is to get the nonblocking pool (which
supplies /dev/urandom and the kernel's internal randomness
consumption) initialized soon.  If someone reads from /dev/random,
let them wait until we've either done that, or have enough entropy
to serve them and also do that.

This adds a wrinkle to determining when we're ready for someone to
read from /dev/random, so factor that out.

At present most input goes directly to the nonblocking pool early
on anyway, but this puts us in a position to change that.

Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index f55365696..58e3e81d4 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -586,6 +586,17 @@ static void fast_mix(struct fast_pool *f, __u32 input[4])
 	f->count++;
 }
 
+static int
+random_readable(int input_entropy_bits)
+{
+	/* We need enough bits to wake up for ... */
+	int thresh = random_read_wakeup_bits;
+	if (!nonblocking_pool.initialized)
+		/* ... that aren't reserved for the nonblocking pool. */
+		thresh += random_read_wakeup_bits;
+	return input_entropy_bits >= thresh;
+}
+
 /*
  * Credit (or debit) the entropy store with n bits of entropy.
  * Use credit_entropy_bits_safe() if the value comes from userspace
@@ -669,7 +680,7 @@ retry:
 		int entropy_bits = entropy_count >> ENTROPY_SHIFT;
 
 		/* should we wake readers? */
-		if (entropy_bits >= random_read_wakeup_bits) {
+		if (random_readable(entropy_bits)) {
 			wake_up_interruptible(&random_read_wait);
 			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
@@ -936,9 +947,12 @@ static void account_xfer(struct entropy_store *dest, int nbytes,
 				 (dest->entropy_total+7) / 8);
 	}
 
-	/* Reserve some for /dev/random's pool, unless we really need it. */
+	/* Reserve a reseed's worth for the nonblocking pool early on
+	 * when we really need it; later, reserve some for /dev/random */
 	*reserved_bytes = 0;
-	if (!dest->limit && dest->initialized)
+	if (dest == &blocking_pool && !nonblocking_pool.initialized)
+		*reserved_bytes = random_read_wakeup_bits / 8;
+	else if (dest == &nonblocking_pool && dest->initialized)
 		*reserved_bytes = 2 * (random_read_wakeup_bits / 8);
 }
 
@@ -1329,8 +1343,7 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 			return -EAGAIN;
 
 		wait_event_interruptible(random_read_wait,
-			ENTROPY_BITS(&input_pool) >=
-			random_read_wakeup_bits);
+			random_readable(ENTROPY_BITS(&input_pool)));
 		if (signal_pending(current))
 			return -ERESTARTSYS;
 	}
@@ -1361,7 +1374,7 @@ random_poll(struct file *file, poll_table * wait)
 	poll_wait(file, &random_read_wait, wait);
 	poll_wait(file, &random_write_wait, wait);
 	mask = 0;
-	if (ENTROPY_BITS(&input_pool) >= random_read_wakeup_bits)
+	if (random_readable(ENTROPY_BITS(&input_pool)))
 		mask |= POLLIN | POLLRDNORM;
 	if (ENTROPY_BITS(&input_pool) < random_write_wakeup_bits)
 		mask |= POLLOUT | POLLWRNORM;
-- 
1.8.3.2

