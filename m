Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaKGN2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:28:22 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36176 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaKGN2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:28:17 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, bhelgaas@google.com,
        Liviu.Dudau@arm.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rjw@rjwysocki.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [RFC PATCH 2/4] x86, acpi, pci: Isolate new PCI mmconfig entry insertion.
Date: Fri,  7 Nov 2014 14:27:54 +0100
Message-Id: <1415366876-30811-3-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add special pci_mmcfg_insert_lock mutex since pci_mmcfg_lock was moved
to common file. No functional changes.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
---
 arch/x86/pci/mmconfig-shared.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 94c3d38..d1e45e7 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -28,6 +28,7 @@
 /* Indicate if the mmcfg resources have been placed into the resource table. */
 static bool pci_mmcfg_running_state;
 static bool pci_mmcfg_arch_init_failed;
+static DEFINE_MUTEX(pci_mmcfg_insert_lock);
 
 static const char *__init pci_mmcfg_e7520(void)
 {
@@ -566,7 +567,7 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 	if (start > end)
 		return -EINVAL;
 
-	mutex_lock(&pci_mmcfg_lock);
+	mutex_lock(&pci_mmcfg_insert_lock);
 	cfg = pci_mmconfig_lookup(seg, start);
 	if (cfg) {
 		if (cfg->end_bus < end)
@@ -575,12 +576,12 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 				 "domain %04x [bus %02x-%02x] "
 				 "only partially covers this bridge\n",
 				  cfg->segment, cfg->start_bus, cfg->end_bus);
-		mutex_unlock(&pci_mmcfg_lock);
+		mutex_unlock(&pci_mmcfg_insert_lock);
 		return -EEXIST;
 	}
 
 	if (!addr) {
-		mutex_unlock(&pci_mmcfg_lock);
+		mutex_unlock(&pci_mmcfg_insert_lock);
 		return -EINVAL;
 	}
 
@@ -621,7 +622,7 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 		kfree(cfg);
 	}
 
-	mutex_unlock(&pci_mmcfg_lock);
+	mutex_unlock(&pci_mmcfg_insert_lock);
 
 	return rc;
 }
-- 
1.9.1

