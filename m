Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab3JXQZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:25:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40005 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab3JXQZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:25:47 -0400
Date: Thu, 24 Oct 2013 09:25:39 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] lkdtm: adjust recursion size to avoid warnings
Message-ID: <20131024162539.GA24331@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_FRAME_WARN is set low (e.g. some ARM builds), the hard-coded
stack buffer size used for kernel stack over run testing triggers build
warnings. Instead, avoid the warning by recalcuating the buffer size and
recursion count needed to trigger the test. Also uses the recursion counter
indirectly to avoid changing the parameter during the test.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 2fc0586ce3bb..9cc89b1f5caa 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -49,8 +49,19 @@
 #include <linux/ide.h>
 #endif
 
+/*
+ * Make sure our attempts to over run the kernel stack doesn't trigger
+ * a compiler warning when CONFIG_FRAME_WARN is set. Then make sure we
+ * recurse past the end of THREAD_SIZE by default.
+ */
+#if defined(CONFIG_FRAME_WARN) && (CONFIG_FRAME_WARN > 0)
+#define REC_STACK_SIZE (CONFIG_FRAME_WARN / 2)
+#else
+#define REC_STACK_SIZE (THREAD_SIZE / 8)
+#endif
+#define REC_NUM_DEFAULT ((THREAD_SIZE / REC_STACK_SIZE) * 2)
+
 #define DEFAULT_COUNT 10
-#define REC_NUM_DEFAULT 10
 #define EXEC_SIZE 64
 
 enum cname {
@@ -140,8 +151,7 @@ static DEFINE_SPINLOCK(lock_me_up);
 static u8 data_area[EXEC_SIZE];
 
 module_param(recur_count, int, 0644);
-MODULE_PARM_DESC(recur_count, " Recursion level for the stack overflow test, "\
-				 "default is 10");
+MODULE_PARM_DESC(recur_count, " Recursion level for the stack overflow test");
 module_param(cpoint_name, charp, 0444);
 MODULE_PARM_DESC(cpoint_name, " Crash Point, where kernel is to be crashed");
 module_param(cpoint_type, charp, 0444);
@@ -280,16 +290,16 @@ static int lkdtm_parse_commandline(void)
 	return -EINVAL;
 }
 
-static int recursive_loop(int a)
+static int recursive_loop(int remaining)
 {
-	char buf[1024];
+	char buf[REC_STACK_SIZE];
 
-	memset(buf,0xFF,1024);
-	recur_count--;
-	if (!recur_count)
+	/* Make sure compiler does not optimize this away. */
+	memset(buf, (remaining & 0xff) | 0x1, REC_STACK_SIZE);
+	if (!remaining)
 		return 0;
 	else
-        	return recursive_loop(a);
+		return recursive_loop(remaining - 1);
 }
 
 static void do_nothing(void)
@@ -325,7 +335,7 @@ static void lkdtm_do_action(enum ctype which)
 			;
 		break;
 	case CT_OVERFLOW:
-		(void) recursive_loop(0);
+		(void) recursive_loop(recur_count);
 		break;
 	case CT_CORRUPT_STACK: {
 		/* Make sure the compiler creates and uses an 8 char array. */
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
