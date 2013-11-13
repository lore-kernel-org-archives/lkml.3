Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab3KMIIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:08:00 -0500
Received: from dmz-mailsec-scanner-6.mit.edu ([18.7.68.35]:60133 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758743Ab3KMIHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:07:43 -0500
X-AuditID: 12074423-b7f2b6d000000ce1-f1-5283334ed3f3
Date: Wed, 13 Nov 2013 03:07:40 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] random: simplify loop in random_read
Message-ID: <20131113080740.GR16018@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384329436.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsUixG6noutn3BxksPypjcXlXXPYHBg9Pm+S
	C2CM4rJJSc3JLEst0rdL4Mq4c2EOS8ExoYrf036yNTCu5Oti5OSQEDCROLn9ADuELSZx4d56
	ti5GLg4hgdlMEvP/nWaEcDYySszcf48VpEpI4BejRNNjbxCbRUBV4tzehWwgNpuAgsSP+euY
	QWwRAWWJVTM3MYHYzEDxX/c2gfUKC1hKzJmyhQXE5hUwk3i2fSo7xEwDiY37JzBDxAUlTs58
	wgLRqyVx499LoDkcQLa0xPJ/HCBhTgFDiUkbjoKNFBVQkZhychvbBEbBWUi6ZyHpnoXQvYCR
	eRWjbEpulW5uYmZOcWqybnFyYl5eapGumV5uZoleakrpJkZwmLoo72D8c1DpEKMAB6MSD69F
	TFOQEGtiWXFl7iFGSQ4mJVFeJ53mICG+pPyUyozE4oz4otKc1OJDjBIczEoivAeEgXK8KYmV
	ValF+TApaQ4WJXHeWxz2QUIC6YklqdmpqQWpRTBZGQ4OJQnev4ZAjYJFqempFWmZOSUIaSYO
	TpDhPEDDRYxAhhcXJOYWZ6ZD5E8xKkqJ8+aCNAuAJDJK8+B6YWnkFaM40CvCvKIg7TzAFATX
	/QpoMBPQYIviJpDBJYkIKakGRuPazTKFp8sSTi+LZj4+dZqGVk/Yh7K/L0JNZI1F13PNWV6c
	fFaGnXPlA+/mhbFff356vePaRDvDGWVbm5Oyzj9xqd5SOE0472Ry05RZWZmxl+43vtCe7crw
	Vkv5Z37CZ2ftOQ8+nJxkoPJHcrO4f2RG9GMG4xWCr0rmfe2SZZLICj2t48x7TomlOCPRUIu5
	qDgRADkLwA7+AgAA
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
 drivers/char/random.c | 57 ++++++++++++++++-----------------------------------
 1 file changed, 18 insertions(+), 39 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6d3627d..cf1357b 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1289,53 +1289,32 @@ void rand_initialize_disk(struct gendisk *disk)
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
-		n = extract_entropy_user(&blocking_pool, buf, n);
-
-		if (n < 0) {
-			retval = n;
-			break;
-		}
-
+	nbytes = min_t(size_t, nbytes, SEC_XFER_SIZE);
+	while (1) {
+		n = extract_entropy_user(&blocking_pool, buf, nbytes);
+		if (n < 0)
+			return n;
 		trace_random_read(n*8, (nbytes-n)*8,
 				  ENTROPY_BITS(&blocking_pool),
 				  ENTROPY_BITS(&input_pool));
-
-		if (n == 0) {
-			if (file->f_flags & O_NONBLOCK) {
-				retval = -EAGAIN;
-				break;
-			}
-
-			wait_event_interruptible(random_read_wait,
-				ENTROPY_BITS(&input_pool) >=
-				random_read_wakeup_thresh);
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
+		wait_event_interruptible(random_read_wait,
+			ENTROPY_BITS(&input_pool) >=
+			random_read_wakeup_thresh);
+		if (signal_pending(current))
+			return -ERESTARTSYS;
 	}
-
-	return (count ? count : retval);
 }
 
 static ssize_t
-- 
1.8.3.2

