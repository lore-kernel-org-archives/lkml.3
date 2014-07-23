Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbaGWROZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:14:25 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57584 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201AbaGWROX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:14:23 -0400
Date: Wed, 23 Jul 2014 20:14:21 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: tytso@mit.edu, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, acab@digitalfuture.it, stable@kernel.org
Subject: [PATCH] random: fix 32MB+ reads from /dev/urandom
Message-ID: <20140723171421.GA2997@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=80981

Steps to reproduce:

	strace dd if=/dev/urandom of=/dev/null bs=64M count=1

Before, dd did 1 read() syscall and returned full length.
Now, dd stops at 32 MB.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

	STABLE needs 79a8468747c5f95ed3d5ce8376a3e82e0c5857fc
	and this patch.

 drivers/char/random.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1377,20 +1377,32 @@ random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 }
 
 static ssize_t
-urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+urandom_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
-	int ret;
+	ssize_t ret;
 
 	if (unlikely(nonblocking_pool.initialized == 0))
 		printk_once(KERN_NOTICE "random: %s urandom read "
 			    "with %d bits of entropy available\n",
 			    current->comm, nonblocking_pool.entropy_total);
 
-	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
-	ret = extract_entropy_user(&nonblocking_pool, buf, nbytes);
+	ret = 0;
+	while (count > 0) {
+		size_t count1;
+		ssize_t ret1;
+
+		count1 = min_t(size_t, count, INT_MAX >> (ENTROPY_SHIFT + 3));
+		ret1 = extract_entropy_user(&nonblocking_pool, buf, count1);
+		if (ret1 < 0)
+			return ret1;
 
-	trace_urandom_read(8 * nbytes, ENTROPY_BITS(&nonblocking_pool),
-			   ENTROPY_BITS(&input_pool));
+		trace_urandom_read(8 * count1, ENTROPY_BITS(&nonblocking_pool),
+				   ENTROPY_BITS(&input_pool));
+
+		buf += ret1;
+		count -= ret1;
+		ret += ret1;
+	}
 	return ret;
 }
 
