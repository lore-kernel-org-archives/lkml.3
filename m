Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031143Ab3HIU77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:59:59 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:26149 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031117Ab3HIU76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:59:58 -0400
Message-ID: <201308092059.r79Kxv0N011259@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 16:04:34 -0400
Subject: [PATCH] tile: allow "initrd" boot argument for kexec
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This enables support for "kexec --initrd" for tile.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/setup.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index b00e156..774e819 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -694,6 +694,25 @@ static void __init setup_bootmem_allocator(void)
 		reserve_bootmem(m->addr, m->size, 0);
 	}
 
+#ifdef CONFIG_BLK_DEV_INITRD
+	if (initrd_start) {
+		/* Make sure the initrd memory region is not modified. */
+		if (reserve_bootmem(initrd_start, initrd_end - initrd_start,
+				    BOOTMEM_EXCLUSIVE)) {
+			pr_crit("The initrd memory region has been polluted. Disabling it.\n");
+			initrd_start = 0;
+			initrd_end = 0;
+		} else {
+			/*
+			 * Translate initrd_start & initrd_end from PA to VA for
+			 * future access.
+			 */
+			initrd_start += PAGE_OFFSET;
+			initrd_end += PAGE_OFFSET;
+		}
+	}
+#endif
+
 #ifdef CONFIG_KEXEC
 	if (crashk_res.start != crashk_res.end)
 		reserve_bootmem(crashk_res.start, resource_size(&crashk_res), 0);
@@ -1095,6 +1114,10 @@ static void __init load_hv_initrd(void)
 	int fd, rc;
 	void *initrd;
 
+	/* If initrd has already been set, skip initramfs file in hvfs. */
+	if (initrd_start)
+		return;
+
 	fd = hv_fs_findfile((HV_VirtAddr) initramfs_file);
 	if (fd == HV_ENOENT) {
 		if (set_initramfs_file) {
@@ -1133,6 +1156,25 @@ void __init free_initrd_mem(unsigned long begin, unsigned long end)
 	free_bootmem(__pa(begin), end - begin);
 }
 
+static int __init setup_initrd(char *str)
+{
+	char *endp;
+	unsigned long initrd_size;
+
+	initrd_size = str ? simple_strtoul(str, &endp, 0) : 0;
+	if (initrd_size == 0 || *endp != '@')
+		return -EINVAL;
+
+	initrd_start = simple_strtoul(endp+1, &endp, 0);
+	if (initrd_start == 0)
+		return -EINVAL;
+
+	initrd_end = initrd_start + initrd_size;
+
+	return 0;
+}
+early_param("initrd", setup_initrd);
+
 #else
 static inline void load_hv_initrd(void) {}
 #endif /* CONFIG_BLK_DEV_INITRD */
-- 
1.8.3.1

