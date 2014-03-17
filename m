Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaCQXhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 19:37:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:48988 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaCQXgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 19:36:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,673,1389772800"; 
   d="scan'208";a="500757083"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: "Ted Ts'o" <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH v2 3/4] random: If we have arch_get_random_seed*(), try it before blocking
Date: Mon, 17 Mar 2014 16:36:29 -0700
Message-Id: <1395099390-807-4-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395099390-807-1-git-send-email-hpa@linux.intel.com>
References: <1395099390-807-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have arch_get_random_seed*(), try to use it for emergency refill
of the entropy pool before giving up and blocking on /dev/random.  It
may or may not work in the moment, but if it does work, it will give
the user better service than blocking will.

Reviewed-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/char/random.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index a4bea77..c35cee2 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1294,6 +1294,34 @@ void rand_initialize_disk(struct gendisk *disk)
 }
 #endif
 
+/*
+ * Attempt an emergency refill using arch_get_random_seed_long().
+ *
+ * As with add_interrupt_randomness() be paranoid and only
+ * credit the output as 50% entropic.
+ */
+static int arch_random_refill(void)
+{
+	const unsigned int nlongs = 64;	/* Arbitrary number */
+	unsigned int n = 0;
+	unsigned int i;
+	unsigned long buf[nlongs];
+
+	for (i = 0; i < nlongs; i++) {
+		if (arch_get_random_seed_long(&buf[n]))
+			n++;
+	}
+
+	if (n) {
+		unsigned int rand_bytes = n * sizeof(unsigned long);
+
+		mix_pool_bytes(&input_pool, buf, rand_bytes, NULL);
+		credit_entropy_bits(&input_pool, rand_bytes*4);
+	}
+
+	return n;
+}
+
 static ssize_t
 random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
@@ -1312,8 +1340,13 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 				  ENTROPY_BITS(&input_pool));
 		if (n > 0)
 			return n;
+
 		/* Pool is (near) empty.  Maybe wait and retry. */
 
+		/* First try an emergency refill */
+		if (arch_random_refill())
+			continue;
+
 		if (file->f_flags & O_NONBLOCK)
 			return -EAGAIN;
 
-- 
1.8.5.3

