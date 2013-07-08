Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3GHRDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:03:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55166 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805Ab3GHRDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:03:13 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ankita Garg <ankita@in.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 4/4] lkdtm: add "EXEC_*" triggers
Date: Mon,  8 Jul 2013 10:01:33 -0700
Message-Id: <1373302893-4990-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373302893-4990-1-git-send-email-keescook@chromium.org>
References: <1373302893-4990-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new crash locations that attempt to execute non-executable memory
regions (data segment, stack, kmalloc, vmalloc).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 8bc7f0b..2fc0586 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -43,6 +43,7 @@
 #include <linux/slab.h>
 #include <scsi/scsi_cmnd.h>
 #include <linux/debugfs.h>
+#include <linux/vmalloc.h>
 
 #ifdef CONFIG_IDE
 #include <linux/ide.h>
@@ -50,6 +51,7 @@
 
 #define DEFAULT_COUNT 10
 #define REC_NUM_DEFAULT 10
+#define EXEC_SIZE 64
 
 enum cname {
 	CN_INVALID,
@@ -80,6 +82,10 @@ enum ctype {
 	CT_HARDLOCKUP,
 	CT_SPINLOCKUP,
 	CT_HUNG_TASK,
+	CT_EXEC_DATA,
+	CT_EXEC_STACK,
+	CT_EXEC_KMALLOC,
+	CT_EXEC_VMALLOC,
 };
 
 static char* cp_name[] = {
@@ -109,6 +115,10 @@ static char* cp_type[] = {
 	"HARDLOCKUP",
 	"SPINLOCKUP",
 	"HUNG_TASK",
+	"EXEC_DATA",
+	"EXEC_STACK",
+	"EXEC_KMALLOC",
+	"EXEC_VMALLOC",
 };
 
 static struct jprobe lkdtm;
@@ -127,6 +137,8 @@ static int count = DEFAULT_COUNT;
 static DEFINE_SPINLOCK(count_lock);
 static DEFINE_SPINLOCK(lock_me_up);
 
+static u8 data_area[EXEC_SIZE];
+
 module_param(recur_count, int, 0644);
 MODULE_PARM_DESC(recur_count, " Recursion level for the stack overflow test, "\
 				 "default is 10");
@@ -280,6 +292,19 @@ static int recursive_loop(int a)
         	return recursive_loop(a);
 }
 
+static void do_nothing(void)
+{
+	return;
+}
+
+static void execute_location(void *dst)
+{
+	void (*func)(void) = dst;
+
+	memcpy(dst, do_nothing, EXEC_SIZE);
+	func();
+}
+
 static void lkdtm_do_action(enum ctype which)
 {
 	switch (which) {
@@ -356,6 +381,26 @@ static void lkdtm_do_action(enum ctype which)
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 		break;
+	case CT_EXEC_DATA:
+		execute_location(data_area);
+		break;
+	case CT_EXEC_STACK: {
+		u8 stack_area[EXEC_SIZE];
+		execute_location(stack_area);
+		break;
+	}
+	case CT_EXEC_KMALLOC: {
+		u32 *kmalloc_area = kmalloc(EXEC_SIZE, GFP_KERNEL);
+		execute_location(kmalloc_area);
+		kfree(kmalloc_area);
+		break;
+	}
+	case CT_EXEC_VMALLOC: {
+		u32 *vmalloc_area = vmalloc(EXEC_SIZE);
+		execute_location(vmalloc_area);
+		vfree(vmalloc_area);
+		break;
+	}
 	case CT_NONE:
 	default:
 		break;
-- 
1.7.9.5

