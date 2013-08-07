Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab3HGUlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:41:13 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60713 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312Ab3HGUlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:41:01 -0400
Message-ID: <201308072041.r77Kf1Vb016127@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 14:07:03 -0400
Subject: [PATCH] tile: support simulator notification for ET_DYN objects
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tile code notifies the simulator of new ET_EXEC objects starting
to execute so that tracing code can properly annotate the objects.
However, we didn't support ET_DYN executables like ld.so, so we
didn't properly load symbols, etc.  This change enables that support;
we use a variant of the SIM_CONTROL_DLOPEN simulator notification
that newer simulators will recognize and use to set the base address
for the next SIM_CONTROL_OS_EXEC notification.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/mm/elf.c | 62 ++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 48 insertions(+), 14 deletions(-)

diff --git a/arch/tile/mm/elf.c b/arch/tile/mm/elf.c
index 743c951..1691b81 100644
--- a/arch/tile/mm/elf.c
+++ b/arch/tile/mm/elf.c
@@ -21,7 +21,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
-#include <arch/sim_def.h>
+#include <arch/sim.h>
 
 /* Notify a running simulator, if any, that an exec just occurred. */
 static void sim_notify_exec(const char *binary_name)
@@ -38,21 +38,55 @@ static void sim_notify_exec(const char *binary_name)
 
 static int notify_exec(struct mm_struct *mm)
 {
-	int retval = 0;  /* failure */
-
-	if (mm->exe_file) {
-		char *buf = (char *) __get_free_page(GFP_KERNEL);
-		if (buf) {
-			char *path = d_path(&mm->exe_file->f_path,
-					    buf, PAGE_SIZE);
-			if (!IS_ERR(path)) {
-				sim_notify_exec(path);
-				retval = 1;
-			}
-			free_page((unsigned long)buf);
+	char *buf, *path;
+	struct vm_area_struct *vma;
+
+	if (!sim_is_simulator())
+		return 1;
+
+	if (mm->exe_file == NULL)
+		return 0;
+
+	for (vma = current->mm->mmap; ; vma = vma->vm_next) {
+		if (vma == NULL)
+			return 0;
+		if (vma->vm_file == mm->exe_file)
+			break;
+	}
+
+	buf = (char *) __get_free_page(GFP_KERNEL);
+	if (buf == NULL)
+		return 0;
+
+	path = d_path(&mm->exe_file->f_path, buf, PAGE_SIZE);
+	if (IS_ERR(path)) {
+		free_page((unsigned long)buf);
+		return 0;
+	}
+
+	/*
+	 * Notify simulator of an ET_DYN object so we know the load address.
+	 * The somewhat cryptic overuse of SIM_CONTROL_DLOPEN allows us
+	 * to be backward-compatible with older simulator releases.
+	 */
+	if (vma->vm_start == (ELF_ET_DYN_BASE & PAGE_MASK)) {
+		char buf[64];
+		int i;
+
+		snprintf(buf, sizeof(buf), "0x%lx:@", vma->vm_start);
+		for (i = 0; ; ++i) {
+			char c = buf[i];
+			__insn_mtspr(SPR_SIM_CONTROL,
+				     (SIM_CONTROL_DLOPEN
+				      | (c << _SIM_CONTROL_OPERATOR_BITS)));
+			if (c == '\0')
+				break;
 		}
 	}
-	return retval;
+
+	sim_notify_exec(path);
+	free_page((unsigned long)buf);
+	return 1;
 }
 
 /* Notify a running simulator, if any, that we loaded an interpreter. */
-- 
1.8.3.1

