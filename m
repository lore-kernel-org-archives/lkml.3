Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaKSQIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:08:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32859 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160AbaKSQFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:05:32 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, bhelgaas@google.com,
        lorenzo.pieralisi@arm.com, wangyijing@huawei.com, arnd@arndb.de,
        hanjun.guo@linaro.org, Liviu.Dudau@arm.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rjw@rjwysocki.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 1/6] x86, acpi, pci: Reorder logic of pci_mmconfig_insert() function
Date: Wed, 19 Nov 2014 17:04:46 +0100
Message-Id: <1416413091-13452-2-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is the first step of MMCONFIG refactoring process.

Code that uses pci_mmcfg_lock will be moved to common file and become
accessible for all architectures. pci_mmconfig_insert() cannot be moved
so easily since it is mixing generic mmcfg code with x86 specific logic
inside of mutual exclusive block guarded by pci_mmcfg_lock.

To get rid of that constraint we reorder actions as fallow:
1. mmconfig entry allocation can be done at first, does not need lock
2. insertion to iomem_resource has its own lock, no need to wrap it into mutex
3. insertion to mmconfig list can be done as the final stage in separate
function (candidate for further factoring)

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Tested-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/x86/pci/mmconfig-shared.c | 100 ++++++++++++++++++++++-------------------
 1 file changed, 54 insertions(+), 46 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 326198a..ac24e1c 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -692,6 +692,39 @@ static int __init pci_mmcfg_late_insert_resources(void)
  */
 late_initcall(pci_mmcfg_late_insert_resources);
 
+static int __init pci_mmconfig_inject(struct pci_mmcfg_region *cfg)
+{
+	struct pci_mmcfg_region *cfg_conflict;
+	int err = 0;
+
+	mutex_lock(&pci_mmcfg_lock);
+	cfg_conflict = pci_mmconfig_lookup(cfg->segment, cfg->start_bus);
+	if (cfg_conflict) {
+		if (cfg_conflict->end_bus < cfg->end_bus)
+			pr_info(FW_INFO "MMCONFIG for "
+				"domain %04x [bus %02x-%02x] "
+				"only partially covers this bridge\n",
+				cfg_conflict->segment, cfg_conflict->start_bus,
+				cfg_conflict->end_bus);
+		err = -EEXIST;
+		goto out;
+	}
+
+	if (pci_mmcfg_arch_map(cfg)) {
+		pr_warn("fail to map MMCONFIG %pR.\n", &cfg->res);
+		err = -ENOMEM;
+		goto out;
+	} else {
+		list_add_sorted(cfg);
+		pr_info("MMCONFIG at %pR (base %#lx)\n",
+			&cfg->res, (unsigned long)cfg->address);
+
+	}
+out:
+	mutex_unlock(&pci_mmcfg_lock);
+	return err;
+}
+
 /* Add MMCFG information for host bridges */
 int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 			phys_addr_t addr)
@@ -703,66 +736,41 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 	if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
 		return -ENODEV;
 
-	if (start > end)
+	if (start > end || !addr)
 		return -EINVAL;
 
-	mutex_lock(&pci_mmcfg_lock);
-	cfg = pci_mmconfig_lookup(seg, start);
-	if (cfg) {
-		if (cfg->end_bus < end)
-			dev_info(dev, FW_INFO
-				 "MMCONFIG for "
-				 "domain %04x [bus %02x-%02x] "
-				 "only partially covers this bridge\n",
-				  cfg->segment, cfg->start_bus, cfg->end_bus);
-		mutex_unlock(&pci_mmcfg_lock);
-		return -EEXIST;
-	}
-
-	if (!addr) {
-		mutex_unlock(&pci_mmcfg_lock);
-		return -EINVAL;
-	}
-
 	rc = -EBUSY;
 	cfg = pci_mmconfig_alloc(seg, start, end, addr);
 	if (cfg == NULL) {
 		dev_warn(dev, "fail to add MMCONFIG (out of memory)\n");
-		rc = -ENOMEM;
+		return -ENOMEM;
 	} else if (!pci_mmcfg_check_reserved(dev, cfg, 0)) {
 		dev_warn(dev, FW_BUG "MMCONFIG %pR isn't reserved\n",
 			 &cfg->res);
-	} else {
-		/* Insert resource if it's not in boot stage */
-		if (pci_mmcfg_running_state)
-			tmp = insert_resource_conflict(&iomem_resource,
-						       &cfg->res);
-
-		if (tmp) {
-			dev_warn(dev,
-				 "MMCONFIG %pR conflicts with "
-				 "%s %pR\n",
-				 &cfg->res, tmp->name, tmp);
-		} else if (pci_mmcfg_arch_map(cfg)) {
-			dev_warn(dev, "fail to map MMCONFIG %pR.\n",
-				 &cfg->res);
-		} else {
-			list_add_sorted(cfg);
-			dev_info(dev, "MMCONFIG at %pR (base %#lx)\n",
-				 &cfg->res, (unsigned long)addr);
-			cfg = NULL;
-			rc = 0;
-		}
+		goto error;
 	}
 
-	if (cfg) {
-		if (cfg->res.parent)
-			release_resource(&cfg->res);
-		kfree(cfg);
+	/* Insert resource if it's not in boot stage */
+	if (pci_mmcfg_running_state)
+		tmp = insert_resource_conflict(&iomem_resource, &cfg->res);
+
+	if (tmp) {
+		dev_warn(dev,
+			 "MMCONFIG %pR conflicts with %s %pR\n",
+			 &cfg->res, tmp->name, tmp);
+		goto error;
 	}
 
-	mutex_unlock(&pci_mmcfg_lock);
+	rc = pci_mmconfig_inject(cfg);
+	if (rc)
+		goto error;
+
+	return 0;
 
+error:
+	if (cfg->res.parent)
+		release_resource(&cfg->res);
+	kfree(cfg);
 	return rc;
 }
 
-- 
1.9.1

