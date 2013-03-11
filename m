Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab3CKMho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:37:44 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19910 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab3CKMhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:37:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 11 Mar 2013 05:37:37 -0700
From: Danny Huang <dahuang@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>, <dahuang@nvidia.com>,
        <ldewangan@nvidia.com>, <pgaikwad@nvidia.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: tegra: fuse: export chip id and revision
Date: Mon, 11 Mar 2013 20:37:21 +0800
Message-ID: <1363005441-26329-1-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose tegra chip id and revision in /proc/cpu/chipinfo for user mode
usage.

Signed-off-by: Danny Huang <dahuang@nvidia.com>
---
 arch/arm/mach-tegra/fuse.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index f7db078..7895542 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/export.h>
+#include <linux/proc_fs.h>
 #include <linux/tegra-soc.h>
 
 #include "fuse.h"
@@ -43,6 +44,7 @@ enum tegra_revision tegra_revision;
 
 static int tegra_fuse_spare_bit;
 static void (*tegra_init_speedo_data)(void);
+static struct proc_dir_entry *proc_entry;
 
 /* The BCT to use at boot is specified by board straps that can be read
  * through a APB misc register and decoded. 2 bits, i.e. 4 possible BCTs.
@@ -161,3 +163,20 @@ unsigned long long tegra_chip_uid(void)
 	return (hi << 32ull) | lo;
 }
 EXPORT_SYMBOL(tegra_chip_uid);
+
+static int show_chip_info(char *page, char **start, off_t offset,
+			    int count, int *eof, void *data)
+{
+	return snprintf(page, count, "tegra_chip_id: %d\ntegra_chip_rev: %d\n",
+			tegra_chip_id, tegra_revision);
+}
+
+static int __init tegra_chip_info(void)
+{
+	proc_entry = create_proc_entry("cpu/chipinfo", S_IRUGO, NULL);
+	if (proc_entry)
+		proc_entry->read_proc = show_chip_info;
+	return 0;
+}
+
+late_initcall(tegra_chip_info);
-- 
1.8.1.5

