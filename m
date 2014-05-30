Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934575AbaE3UKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:10:20 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:61424 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaE3UKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:10:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 32/32] fs: use new inode_time definition unconditionally
Date: Fri, 30 May 2014 22:01:56 +0200
Message-Id: <1401480116-1973111-33-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:91SpbqRvMwm9UF1GbTzCanH8GHUDg5C3A9gphg51N46
 39aqXUULhsO4JulRaMnFzkODR3yCpd2A3iHU8Simqg8UB9FE+Y
 6R16UwXDwORoAS4+/iFr50QDZuCgYx6ifHHnmQkM1DjcVmBke9
 XNBepiRDdbJMW7S/tJ8UQWUeS7vUV2WCo4de7OTmmCLfz+Ez48
 IyiKSeftpBiLD0212y8EJ3jjmK8+NCOzyJJypvq3WLKjWxMwls
 Iz0vA0fPc66BFb6L3AlzHJI2u9Bvgw3GF3d7xCF9cyy4uXJI7+
 g01EUAijMp0C/5OaInnIzcJFSzA0YbLbEX84c97arjNEKQ0NVv
 OkJ4CKZARj4saSXtJtDpzq6U0YsQsA7H48H3PzipN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After all file systems have been converted to use 'struct inode_time'
for timestamps, we can remove the compatibility definition for this
structure.

This patch picks the first of the three variants I defined, but we
could pick one of the others as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/time.h | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index f431263..00d2f14 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -6,44 +6,17 @@
 # include <linux/math64.h>
 #include <uapi/linux/time.h>
 
-#ifdef CONFIG_NEW_INODE_TIME
 /*
  * This is the type we use internally in the kernel to represent
- * absolute times in file system metadata.
+ * absolute times in file system metadata using unsigned seconds
+ * lets us extend the life span for another 69 years beyond 2038.
  * This structure must not leak out to user space, and new interfaces
  * should be using 64-bit types right away.
  */
-
-/*
- * Variant a) using unsigned seconds lets us extend the life span
- * for another 69 years beyond 2038.
- */
 struct inode_time {
 	unsigned long	tv_sec;
 	long		tv_nsec;
 };
-#elif 0
-/*
- * This variant can represent the widest range of times, but also
- * bloats 'struct inode' a little more.
- */
-struct inode_time {
-	long long	tv_sec __attribute__((packed));
-	int		tv_nsec;
-};
-#elif 0
-/*
- * The variant using bit fields is less efficient to access, but
- * small and has a wider range as the 32-bit one, plus it keeps
- * the signedness of the original timespec.
- */
-struct inode_time {
-	long long	tv_sec	: 34;
-	int		tv_nsec : 30;
-};
-#else
-#define inode_time timespec
-#endif
 
 extern struct timezone sys_tz;
 
-- 
1.8.3.2

