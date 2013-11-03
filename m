Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3KCNdn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 08:33:43 -0500
Received: from imap.thunk.org ([74.207.234.97]:53762 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab3KCNdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 08:33:18 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 4/4] random: don't zap entropy count in rand_initialize()
Date: Sun,  3 Nov 2013 08:33:15 -0500
Message-Id: <1383485595-2020-5-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1383485595-2020-1-git-send-email-tytso@mit.edu>
References: <1383485595-2020-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rand_initialize() function was being run fairly late in the kernel
boot sequence.  This was unfortunate, since it zero'ed the entropy
counters, thus throwing away credit that was accumulated earlier in
the boot sequence, and it also meant that initcall functions run
before rand_initialize were using a minimally initialized pool.

To fix this, fix init_std_data() to no longer zap the entropy counter;
it wasn't necessary, and move rand_initialize() to be an early
initcall.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index f553600..4a0e458 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1235,14 +1235,11 @@ static void init_std_data(struct entropy_store *r)
 	ktime_t now = ktime_get_real();
 	unsigned long rv;
 
-	r->entropy_count = 0;
-	r->entropy_total = 0;
-	r->last_data_init = 0;
 	r->last_pulled = jiffies;
 	mix_pool_bytes(r, &now, sizeof(now), NULL);
 	for (i = r->poolinfo->poolbytes; i > 0; i -= sizeof(rv)) {
 		if (!arch_get_random_long(&rv))
-			break;
+			rv = random_get_entropy();
 		mix_pool_bytes(r, &rv, sizeof(rv), NULL);
 	}
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())), NULL);
@@ -1265,7 +1262,7 @@ static int rand_initialize(void)
 	init_std_data(&nonblocking_pool);
 	return 0;
 }
-module_init(rand_initialize);
+early_initcall(rand_initialize);
 
 #ifdef CONFIG_BLOCK
 void rand_initialize_disk(struct gendisk *disk)
@@ -1440,10 +1437,15 @@ static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		return 0;
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
-		/* Clear the entropy pool counters. */
+		/*
+		 * Clear the entropy pool counters. We no longer clear
+		 * the entropy pool, as that's silly.
+		 */
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
-		rand_initialize();
+		input_pool.entropy_count = 0;
+		nonblocking_pool.entropy_count = 0;
+		blocking_pool.entropy_count = 0;
 		return 0;
 	default:
 		return -EINVAL;
-- 
1.7.12.rc0.22.gcdd159b

