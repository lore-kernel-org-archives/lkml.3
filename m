Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab3CNAsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 20:48:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15628 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab3CNAsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 20:48:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Mar 2013 17:48:49 -0700
From: Danny Huang <dahuang@nvidia.com>
To: <linux@arm.linux.org.uk>, <swarren@wwwdotorg.org>, <ldewangan@nvidia.com>,
        <olof@lixom.net>, <hdoyu@nvidia.com>,
        <thierry.reding@avionic-design.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
CC: Danny Huang <dahuang@nvidia.com>
Subject: [PATCH v4] ARM: tegra: expose chip ID and revision
Date: Thu, 14 Mar 2013 08:48:40 +0800
Message-ID: <1363222120-22210-1-git-send-email-dahuang@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expose Tegra chip ID and revision in /sys/devices/soc for user mode
usage

Signed-off-by: Danny Huang <dahuang@nvidia.com>
---
 arch/arm/Kconfig            |  1 +
 arch/arm/mach-tegra/tegra.c | 29 ++++++++++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2363926..12fa4e5 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -675,6 +675,7 @@ config ARCH_TEGRA
 	select HAVE_CLK
 	select HAVE_SMP
 	select MIGHT_HAVE_CACHE_L2X0
+	select SOC_BUS
 	select SPARSE_IRQ
 	select USE_OF
 	help
diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 27232c9..84deeab 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -33,6 +33,8 @@
 #include <linux/io.h>
 #include <linux/i2c.h>
 #include <linux/i2c-tegra.h>
+#include <linux/slab.h>
+#include <linux/sys_soc.h>
 #include <linux/usb/tegra_usb_phy.h>
 
 #include <asm/mach-types.h>
@@ -42,6 +44,7 @@
 
 #include "board.h"
 #include "common.h"
+#include "fuse.h"
 #include "iomap.h"
 
 static struct tegra_ehci_platform_data tegra_ehci1_pdata = {
@@ -80,12 +83,36 @@ static struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
 
 static void __init tegra_dt_init(void)
 {
+	struct soc_device_attribute *soc_dev_attr;
+	struct soc_device *soc_dev;
+	struct device *parent = NULL;
+
+	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	if (!soc_dev_attr)
+		goto out;
+
+	soc_dev_attr->family = kasprintf(GFP_KERNEL, "Tegra");
+	soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d", tegra_revision);
+	soc_dev_attr->soc_id = kasprintf(GFP_KERNEL, "%d", tegra_chip_id);
+
+	soc_dev = soc_device_register(soc_dev_attr);
+	if (IS_ERR(soc_dev)) {
+		kfree(soc_dev_attr->family);
+		kfree(soc_dev_attr->revision);
+		kfree(soc_dev_attr->soc_id);
+		kfree(soc_dev_attr);
+		goto out;
+	}
+
+	parent = soc_device_to_device(soc_dev);
+
 	/*
 	 * Finished with the static registrations now; fill in the missing
 	 * devices
 	 */
+out:
 	of_platform_populate(NULL, of_default_bus_match_table,
-				tegra20_auxdata_lookup, NULL);
+				tegra20_auxdata_lookup, parent);
 }
 
 static void __init trimslice_init(void)
-- 
1.8.1.5

