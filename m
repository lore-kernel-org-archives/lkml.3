Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3KHADv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:03:51 -0500
Received: from dmz-mailsec-scanner-7.mit.edu ([18.7.68.36]:57909 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584Ab3KHADn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:03:43 -0500
X-AuditID: 12074424-b7f0b8e000004bf2-24-527c2931e2bd
Date: Thu, 7 Nov 2013 18:58:40 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] random: simplify loop in random_read
Message-ID: <20131107235839.GG16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixG6nrmukWRNk8O8+k8XlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4MpYPn8qe8F6kYpp6y8zNTA+4u9i5OSQEDCROPX/MROELSZx4d56
	ti5GLg4hgdlMEtcOv2SGcDYwSkxctpAFwvnJKLHk9GSwFhYBFYnZGy+zg9hsAgoSP+avYwax
	RQSUJVbN3ARWwwwU/3VvEyuILSxgLXH9+HGgQRwcvAJmElfeK4OEhQQMJH5Of8sCYvMKCEqc
	nPmEBaJVS+LGv5dMIOXMAtISy/9xgIQ5BQwl2puvgE0UBbpgysltbBMYBWch6Z6FpHsWQvcC
	RuZVjLIpuVW6uYmZOcWpybrFyYl5ealFuuZ6uZkleqkppZsYwWHqorKDsfmQ0iFGAQ5GJR7e
	ggvVQUKsiWXFlbmHGCU5mJREeSeq1wQJ8SXlp1RmJBZnxBeV5qQWH2KU4GBWEuF9pgiU401J
	rKxKLcqHSUlzsCiJ897isA8SEkhPLEnNTk0tSC2CycpwcChJ8H4AGSpYlJqeWpGWmVOCkGbi
	4AQZzgM0/AlIDW9xQWJucWY6RP4Uo6KUOO93kIQASCKjNA+uF5ZGXjGKA70izPsCpIoHmILg
	ul8BDWYCGhzyqxJkcEkiQkqqgbH/2yRPKx7+BpZrN35YCi58NvW83JHPlxjYw09tNvv9TWfZ
	0rU3Chxmbvrx8du+hZWmUZe+GBorpOiF35ymcPtG5MVQ5foi1irpuF7FJSHGuc8zl3BYPzg2
	gaH/mGZg+5d+QS7J+dtjw5TmFH6Z82mOwdq1Cm+2XTBYziLUs7hz2mW1npDdOY+UWIozEg21
	mIuKEwFaq1Gg/gIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop condition never changes until just before a break, so we
might as well write it as a constant.  Also since v2.6.33-rc7~40^2~2
("random: drop weird m_time/a_time manipulation") we don't do
anything after the loop finishes, so the 'break's might as well
return directly.  Some other simplifications.

The behavior should be identical except that I've changed a debug
message.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 68 +++++++++++++++++----------------------------------
 1 file changed, 22 insertions(+), 46 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d1466c9..85f5fce 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1155,58 +1155,34 @@ void rand_initialize_disk(struct gendisk *disk)
 static ssize_t
 random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
-	ssize_t n, retval = 0, count = 0;
+	ssize_t n;
 
 	if (nbytes == 0)
 		return 0;
 
-	while (nbytes > 0) {
-		n = nbytes;
-		if (n > SEC_XFER_SIZE)
-			n = SEC_XFER_SIZE;
-
-		DEBUG_ENT("reading %zu bits\n", n*8);
-
-		n = extract_entropy_user(&blocking_pool, buf, n);
-
-		if (n < 0) {
-			retval = n;
-			break;
-		}
-
-		DEBUG_ENT("read got %zd bits (%zd still needed)\n",
+	nbytes = min_t(size_t, nbytes, SEC_XFER_SIZE);
+	while (1) {
+		DEBUG_ENT("reading %zu bits\n", nbytes*8);
+		n = extract_entropy_user(&blocking_pool, buf, nbytes);
+		if (n < 0)
+			return n;
+		DEBUG_ENT("read got %zd bits (%zd short)\n",
 			  n*8, (nbytes-n)*8);
-
-		if (n == 0) {
-			if (file->f_flags & O_NONBLOCK) {
-				retval = -EAGAIN;
-				break;
-			}
-
-			DEBUG_ENT("sleeping?\n");
-
-			wait_event_interruptible(random_read_wait,
-				input_pool.entropy_count >=
-						 random_read_wakeup_thresh);
-
-			DEBUG_ENT("awake\n");
-
-			if (signal_pending(current)) {
-				retval = -ERESTARTSYS;
-				break;
-			}
-
-			continue;
-		}
-
-		count += n;
-		buf += n;
-		nbytes -= n;
-		break;		/* This break makes the device work */
-				/* like a named pipe */
+		if (n > 0)
+			return n;
+		/* Pool is (near) empty.  Maybe wait and retry. */
+
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		DEBUG_ENT("sleeping?\n");
+		wait_event_interruptible(random_read_wait,
+			input_pool.entropy_count >=
+					 random_read_wakeup_thresh);
+		DEBUG_ENT("awake\n");
+		if (signal_pending(current))
+			return -ERESTARTSYS;
 	}
-
-	return (count ? count : retval);
 }
 
 static ssize_t
-- 
1.8.3.2

