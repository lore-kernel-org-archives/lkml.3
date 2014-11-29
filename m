Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaK2JNa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 04:13:30 -0500
Received: from mout.gmx.net ([212.227.17.21]:51538 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbaK2JN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 04:13:27 -0500
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, Michael Kerrisk <mtk.manpages@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] urandom: handle signals immediately
Date: Sat, 29 Nov 2014 10:12:29 +0100
Message-Id: <1417252349-808-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <54707352.8050208@gmx.de>
References: <54707352.8050208@gmx.de>
X-Provags-ID: V03:K0:1ijsGTarkAfaQgboOtaOx5Q7RLelzWm2+MlY/ayiq55BFRAMjD3
 4zmOeJqYdxUP5rybDPg+wzfM8J+TmJmVPjZo+1WFAK5OenwgIv1hUz0/GlD70hVljAUJv3j
 R2BgdEL1Jv6+odPQ2q9GXxr4ZuKP1+Z0NRPMxABUdv3lABcI6hFc0mL6qn5uJ1+CKqZIhHV
 d0jznd1Q57aDki+/8APLQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the patch device /dev/urandom only considers signals when a
rescheduling of the thread is requested. This may imply that
signals will not be handled for time intervals in excess of 30s.

With the patch signals are handled in every round copying 10 bytes if more
than 256 bytes have been collected. This 256 byte limit ensures the
guarantee given by system call getrandom().

With the patch rescheduling may occur even when reading less than 257 bytes.
This restores the logic before the introduction of the getrandom() system
call. getrandom() provides no guarantee concerning rescheduling.

An example code for testing is provided in
https://lkml.org/lkml/2014/11/22/41

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/char/random.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 04645c0..75e96c1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1189,21 +1189,20 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 {
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
-	int large_request = (nbytes > 256);
 
 	trace_extract_entropy_user(r->name, nbytes, ENTROPY_BITS(r), _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, 0, 0);
 
 	while (nbytes) {
-		if (large_request && need_resched()) {
-			if (signal_pending(current)) {
-				if (ret == 0)
-					ret = -ERESTARTSYS;
-				break;
-			}
+		/*
+		 * getrandom must not be interrupted by a signal while
+		 * reading up to 256 bytes.
+		 */
+		if (signal_pending(current) && ret > 256)
+			break;
+		if (need_resched())
 			schedule();
-		}
 
 		extract_buf(r, tmp);
 		i = min_t(int, nbytes, EXTRACT_SIZE);
-- 
2.1.3

