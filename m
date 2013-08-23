Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab3HWPrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:47:09 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:35181 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112Ab3HWPrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:47:07 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH -next] staging: lustre: Use proper constant types for L*_POISON values
Date: Fri, 23 Aug 2013 17:46:48 +0200
Message-Id: <1377272808-21686-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit m68k, I get lots of warnings like:

    warning: integer constant is too large for ‘long’ type

Switch the L*_POISON definitions from too-large constants and casts
to the proper constant types to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
The values in drivers/staging/lustre/lustre/include/linux/lustre_lib.h
don't seem to be used, as LP_POISON is already defined at that point?

 .../lustre/include/linux/libcfs/linux/kp30.h       |   10 +++++++---
 .../lustre/lustre/include/linux/lustre_lib.h       |   10 ++++------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index 073f4d1..c204b67 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -187,9 +187,13 @@ extern int  lwt_snapshot (cfs_cycles_t *now, int *ncpu, int *total_size,
 # endif
 #endif
 
-# define LI_POISON ((int)0x5a5a5a5a5a5a5a5a)
-# define LL_POISON ((long)0x5a5a5a5a5a5a5a5a)
-# define LP_POISON ((void *)(long)0x5a5a5a5a5a5a5a5a)
+# define LI_POISON 0x5a5a5a5a
+#if BITS_PER_LONG > 32
+# define LL_POISON 0x5a5a5a5a5a5a5a5aL
+#else
+# define LL_POISON 0x5a5a5a5aL
+#endif
+# define LP_POISON ((void *)LL_POISON)
 
 /* this is a bit chunky */
 
diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_lib.h b/drivers/staging/lustre/lustre/include/linux/lustre_lib.h
index b2f755a..57f3b01 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_lib.h
@@ -53,15 +53,13 @@
 # include <linux/lustre_common.h>
 
 #ifndef LP_POISON
+# define LI_POISON 0x5a5a5a5a
 #if BITS_PER_LONG > 32
-# define LI_POISON ((int)0x5a5a5a5a5a5a5a5a)
-# define LL_POISON ((long)0x5a5a5a5a5a5a5a5a)
-# define LP_POISON ((void *)(long)0x5a5a5a5a5a5a5a5a)
+# define LL_POISON 0x5a5a5a5a5a5a5a5aL
 #else
-# define LI_POISON ((int)0x5a5a5a5a)
-# define LL_POISON ((long)0x5a5a5a5a)
-# define LP_POISON ((void *)(long)0x5a5a5a5a)
+# define LL_POISON 0x5a5a5a5aL
 #endif
+# define LP_POISON ((void *)LL_POISON)
 #endif
 
 /* This macro is only for compatibility reasons with older Linux Lustre user
-- 
1.7.9.5

