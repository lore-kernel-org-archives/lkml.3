Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbaLWMaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:30:07 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:36354 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbaLWMaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:30:05 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 2/3] MIPS: OCTEON: Protect accesses to bootbus flash with octeon_bootbus_sem.
Date: Tue, 23 Dec 2014 15:27:00 +0300
Message-ID: <1419337623-16101-3-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419337623-16101-1-git-send-email-aleksey.makarov@auriga.com>
References: <1419337623-16101-1-git-send-email-aleksey.makarov@auriga.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Without this, we get bus errors.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 arch/mips/Kconfig                     |  1 +
 arch/mips/cavium-octeon/flash_setup.c | 42 ++++++++++++++++++++++++++++++++++-
 2 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 3289969..94f6012 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -790,6 +790,7 @@ config CAVIUM_OCTEON_SOC
 	select SYS_SUPPORTS_SMP
 	select NR_CPUS_DEFAULT_16
 	select BUILTIN_DTB
+	select MTD_COMPLEX_MAPPINGS
 	help
 	  This option supports all of the Octeon reference boards from Cavium
 	  Networks. It builds a kernel that dynamically determines the Octeon
diff --git a/arch/mips/cavium-octeon/flash_setup.c b/arch/mips/cavium-octeon/flash_setup.c
index 237e5b1..39e26df 100644
--- a/arch/mips/cavium-octeon/flash_setup.c
+++ b/arch/mips/cavium-octeon/flash_setup.c
@@ -9,6 +9,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/export.h>
+#include <linux/semaphore.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/map.h>
 #include <linux/mtd/partitions.h>
@@ -25,6 +26,41 @@ static const char *part_probe_types[] = {
 	NULL
 };
 
+static map_word octeon_flash_map_read(struct map_info *map, unsigned long ofs)
+{
+	map_word r;
+
+	down(&octeon_bootbus_sem);
+	r = inline_map_read(map, ofs);
+	up(&octeon_bootbus_sem);
+
+	return r;
+}
+
+static void octeon_flash_map_write(struct map_info *map, const map_word datum,
+				   unsigned long ofs)
+{
+	down(&octeon_bootbus_sem);
+	inline_map_write(map, datum, ofs);
+	up(&octeon_bootbus_sem);
+}
+
+static void octeon_flash_map_copy_from(struct map_info *map, void *to,
+				       unsigned long from, ssize_t len)
+{
+	down(&octeon_bootbus_sem);
+	inline_map_copy_from(map, to, from, len);
+	up(&octeon_bootbus_sem);
+}
+
+static void octeon_flash_map_copy_to(struct map_info *map, unsigned long to,
+				     const void *from, ssize_t len)
+{
+	down(&octeon_bootbus_sem);
+	inline_map_copy_to(map, to, from, len);
+	up(&octeon_bootbus_sem);
+}
+
 /**
  * Module/ driver initialization.
  *
@@ -56,7 +92,11 @@ static int __init flash_init(void)
 		flash_map.virt = ioremap(flash_map.phys, flash_map.size);
 		pr_notice("Bootbus flash: Setting flash for %luMB flash at "
 			  "0x%08llx\n", flash_map.size >> 20, flash_map.phys);
-		simple_map_init(&flash_map);
+		WARN_ON(!map_bankwidth_supported(flash_map.bankwidth));
+		flash_map.read = octeon_flash_map_read;
+		flash_map.write = octeon_flash_map_write;
+		flash_map.copy_from = octeon_flash_map_copy_from;
+		flash_map.copy_to = octeon_flash_map_copy_to;
 		mymtd = do_map_probe("cfi_probe", &flash_map);
 		if (mymtd) {
 			mymtd->owner = THIS_MODULE;
-- 
2.1.3

