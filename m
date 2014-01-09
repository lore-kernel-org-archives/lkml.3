Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643AbaAIXQa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:16:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbaAIXQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:16:28 -0500
From: Rafael Aquini <aquini@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Stephan Mueller <stephan.mueller@atsec.com>
Subject: [RFC PATCH] char: random: stir the output pools differently when the random_write lenght allows splitting the seed
Date: Thu,  9 Jan 2014 21:15:53 -0200
Message-Id: <42f6dc88535d5ecdab13b1376db7ccbbbc550600.1389297772.git.aquini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit "7f397dc random: fix seeding with zero entropy" we are adding
data from zero-entropy random_writes directly to output pools. We can leverage
the fact the seed used for such case is usually long enough to completely stir
all bits from the input pool which is, by default, 4 times longer than the
output pools and break it in two to stir differently the output pools. This
can help on making a stronger security claim on output pool internal state.

This patch introduces changes to the random_write method so it can split the
given seed and completely stir the output pools with different halves of it, 
when seed lenght allows us doing so. 

Signed-off-by: Rafael Aquini <aquini@redhat.com>
---
Suggested by Stephan Mueller <stephan.mueller@atsec.com>

 drivers/char/random.c | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 429b75b..d623234 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -274,6 +274,7 @@
 #define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
 #define OUTPUT_POOL_SHIFT	10
 #define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
+#define OUTPUT_POOL_SIZE	((1 << OUTPUT_POOL_SHIFT) >> 3)
 #define SEC_XFER_SIZE		512
 #define EXTRACT_SIZE		10
 
@@ -1387,19 +1388,44 @@ write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
 	return 0;
 }
 
-static ssize_t random_write(struct file *file, const char __user *buffer,
-			    size_t count, loff_t *ppos)
+static size_t __do_random_write(const char __user *buffer,
+				size_t count, bool split_buffer)
 {
-	size_t ret;
+	size_t ret, offset, count1, count2;
+	struct entropy_store *pool1, *pool2;
+
+	offset = 0;
+	count1 = count2 = count;
+	pool1 = &blocking_pool;
+	pool2 = &nonblocking_pool;
+
+	if (split_buffer) {
+		size_t rnd;
+		count1 = count / 2;
+		count2 = count - count1;
+		offset = count1;
+
+		get_random_bytes(&rnd, 2);
+		if (rnd % 2) {
+			pool1 = &nonblocking_pool;
+			pool2 = &blocking_pool;
+		}
+	}
 
-	ret = write_pool(&blocking_pool, buffer, count);
+	ret = write_pool(pool1, buffer, count1);
 	if (ret)
 		return ret;
-	ret = write_pool(&nonblocking_pool, buffer, count);
+	ret = write_pool(pool2, buffer + offset, count2);
 	if (ret)
 		return ret;
 
-	return (ssize_t)count;
+	return count;
+}
+
+static ssize_t random_write(struct file *file, const char __user *buffer,
+			    size_t count, loff_t *ppos)
+{
+	return __do_random_write(buffer, count, (count >= 2*OUTPUT_POOL_SIZE));
 }
 
 static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
-- 
1.8.3.1

