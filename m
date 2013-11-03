Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3KCNdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 08:33:20 -0500
Received: from imap.thunk.org ([74.207.234.97]:53764 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab3KCNdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 08:33:18 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 3/4] random: printk notifications for urandom pool initialization
Date: Sun,  3 Nov 2013 08:33:14 -0500
Message-Id: <1383485595-2020-4-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.12.rc0.22.gcdd159b
In-Reply-To: <1383485595-2020-1-git-send-email-tytso@mit.edu>
References: <1383485595-2020-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print a notification to the console when the nonblocking pool is
initialized.  Also printk a warning when a process tries reading from
/dev/urandom before it is fully initialized.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index b578c03..f553600 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -655,6 +655,9 @@ retry:
 	r->entropy_total += nbits;
 	if (!r->initialized && nbits > 0) {
 		if (r->entropy_total > 128) {
+			if (r == &nonblocking_pool)
+				pr_notice("random: %s pool is initialized\n",
+					  r->name);
 			r->initialized = 1;
 			r->entropy_total = 0;
 		}
@@ -1334,7 +1337,14 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 static ssize_t
 urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	int ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
+	int ret;
+
+	if (unlikely(nonblocking_pool.initialized == 0))
+		printk_once(KERN_NOTICE "random: %s urandom read "
+			    "with %d bits of entropy available\n",
+			    current->comm, nonblocking_pool.entropy_total);
+
+	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
 
 	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),
 			   ENTROPY_BITS(&input_pool));
-- 
1.7.12.rc0.22.gcdd159b

