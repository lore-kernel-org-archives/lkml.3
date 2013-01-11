Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3AKHq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:46:57 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17328 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab3AKHqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:46:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 10 Jan 2013 23:46:45 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v4 1/9] ARM: tegra: Add function to read chipid
Date: Fri, 11 Jan 2013 13:16:19 +0530
Message-ID: <1357890387-23245-2-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com>
References: <1357890387-23245-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function to read chip id from APB MISC registers. This function
will also get called from clock driver to flush write operations on
apb bus.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 arch/arm/mach-tegra/fuse.c |    8 +++++++-
 include/linux/tegra-soc.h  |   22 ++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/tegra-soc.h

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index 8121742..f7db078 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/export.h>
+#include <linux/tegra-soc.h>
 
 #include "fuse.h"
 #include "iomap.h"
@@ -105,6 +106,11 @@ static void tegra_get_process_id(void)
 	tegra_core_process_id = (reg >> 12) & 3;
 }
 
+u32 tegra_read_chipid(void)
+{
+	return readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804);
+}
+
 void tegra_init_fuse(void)
 {
 	u32 id;
@@ -119,7 +125,7 @@ void tegra_init_fuse(void)
 	reg = tegra_apb_readl(TEGRA_APB_MISC_BASE + STRAP_OPT);
 	tegra_bct_strapping = (reg & RAM_ID_MASK) >> RAM_CODE_SHIFT;
 
-	id = readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804);
+	id = tegra_read_chipid();
 	tegra_chip_id = (id >> 8) & 0xff;
 
 	switch (tegra_chip_id) {
diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
new file mode 100644
index 0000000..95f611d
--- /dev/null
+++ b/include/linux/tegra-soc.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __LINUX_TEGRA_SOC_H_
+#define __LINUX_TEGRA_SOC_H_
+
+u32 tegra_read_chipid(void);
+
+#endif /* __LINUX_TEGRA_SOC_H_ */
-- 
1.7.4.1

