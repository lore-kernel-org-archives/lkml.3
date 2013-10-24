Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3JXQ0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:26:08 -0400
Received: from smtp.outflux.net ([198.145.64.163]:44215 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755772Ab3JXQ0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:26:06 -0400
Date: Thu, 24 Oct 2013 09:25:57 -0700
From: Kees Cook <keescook@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] lkdtm: add tests for additional page permissions
Message-ID: <20131024162557.GA24350@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing execution and access of userspace from the kernel is needed for
validating things like Intel's SMEP and SMAP protections. Additionally,
add an explicit test for validating that RO page permissions have been
set for the RO data area.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 9cc89b1f5caa..3727bfcf95b4 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -44,6 +44,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <linux/debugfs.h>
 #include <linux/vmalloc.h>
+#include <linux/mman.h>
 
 #ifdef CONFIG_IDE
 #include <linux/ide.h>
@@ -97,6 +98,9 @@ enum ctype {
 	CT_EXEC_STACK,
 	CT_EXEC_KMALLOC,
 	CT_EXEC_VMALLOC,
+	CT_EXEC_USERSPACE,
+	CT_ACCESS_USERSPACE,
+	CT_WRITE_RO,
 };
 
 static char* cp_name[] = {
@@ -130,6 +134,9 @@ static char* cp_type[] = {
 	"EXEC_STACK",
 	"EXEC_KMALLOC",
 	"EXEC_VMALLOC",
+	"EXEC_USERSPACE",
+	"ACCESS_USERSPACE",
+	"WRITE_RO",
 };
 
 static struct jprobe lkdtm;
@@ -150,6 +157,8 @@ static DEFINE_SPINLOCK(lock_me_up);
 
 static u8 data_area[EXEC_SIZE];
 
+static const unsigned long rodata = 0xAA55AA55;
+
 module_param(recur_count, int, 0644);
 MODULE_PARM_DESC(recur_count, " Recursion level for the stack overflow test");
 module_param(cpoint_name, charp, 0444);
@@ -315,6 +324,15 @@ static void execute_location(void *dst)
 	func();
 }
 
+static void execute_user_location(void *dst)
+{
+	void (*func)(void) = dst;
+
+	if (copy_to_user(dst, do_nothing, EXEC_SIZE))
+		return;
+	func();
+}
+
 static void lkdtm_do_action(enum ctype which)
 {
 	switch (which) {
@@ -411,6 +429,49 @@ static void lkdtm_do_action(enum ctype which)
 		vfree(vmalloc_area);
 		break;
 	}
+	case CT_EXEC_USERSPACE: {
+		unsigned long user_addr;
+
+		user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
+				    PROT_READ | PROT_WRITE | PROT_EXEC,
+				    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+		if (user_addr >= TASK_SIZE) {
+			pr_warn("Failed to allocate user memory\n");
+			return;
+		}
+		execute_user_location((void *)user_addr);
+		vm_munmap(user_addr, PAGE_SIZE);
+		break;
+	}
+	case CT_ACCESS_USERSPACE: {
+		unsigned long user_addr, tmp;
+		unsigned long *ptr;
+
+		user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
+				    PROT_READ | PROT_WRITE | PROT_EXEC,
+				    MAP_ANONYMOUS | MAP_PRIVATE, 0);
+		if (user_addr >= TASK_SIZE) {
+			pr_warn("Failed to allocate user memory\n");
+			return;
+		}
+
+		ptr = (unsigned long *)user_addr;
+		tmp = *ptr;
+		tmp += 0xc0dec0de;
+		*ptr = tmp;
+
+		vm_munmap(user_addr, PAGE_SIZE);
+
+		break;
+	}
+	case CT_WRITE_RO: {
+		unsigned long *ptr;
+
+		ptr = (unsigned long *)&rodata;
+		*ptr ^= 0xabcd1234;
+
+		break;
+	}
 	case CT_NONE:
 	default:
 		break;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
