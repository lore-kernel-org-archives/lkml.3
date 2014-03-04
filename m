Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaCDWkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:40:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:62910 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476AbaCDWkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:40:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,588,1389772800"; 
   d="scan'208";a="494106887"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3/3] random: If we have arch_get_random_seed*(), try it before blocking
Date: Tue,  4 Mar 2014 14:40:15 -0800
Message-Id: <1393972815-16689-4-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
References: <1393972815-16689-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

If we have arch_get_random_seed*(), try to use it for emergency refill
of the entropy pool before giving up and blocking on /dev/random.  It
may or may not work in the moment, but if it does work, it will give
the user better service than blocking will.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/char/random.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b1d5ae2..f13f04b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1297,6 +1297,34 @@ void rand_initialize_disk(struct gendisk *disk)
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
@@ -1322,6 +1350,10 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 				  ENTROPY_BITS(&input_pool));
 
 		if (n == 0) {
+			/* Try an emergency refill */
+			if (arch_random_refill())
+				continue;
+
 			if (file->f_flags & O_NONBLOCK) {
 				retval = -EAGAIN;
 				break;
-- 
1.8.3.1

