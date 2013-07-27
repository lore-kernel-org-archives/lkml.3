Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3G1Be0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 21:34:26 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48579 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab3G1BeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 21:34:25 -0400
From: ethan.kernel@gmail.com
To: bhelgaas@google.com, yinghai@kernel.org, jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, jiang.liu@huawei.com,
        linux-pci@vger.kernel.org, joe.jin@oracle.com,
        "ethan.zhao" <ethan.zhao@oracle.com>
Subject: [PATCH V2] x86/PCI: MMCONFIG: cleanup and add address warning to pci_mmconfig_insert
Date: Sat, 27 Jul 2013 15:32:38 -0400
Message-Id: <1374953558-4704-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup the -EINVAL return value handling and add warning message for invalid
start,end,addr parameters.

V2: Corrected code style and tested for Linux v 3.11-rc2

Signed-off-by: ethan.zhao <ethan.zhao@oracle.com>
---
 arch/x86/pci/mmconfig-shared.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 082e881..37f6c7f 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -700,8 +700,13 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 	if (!(pci_probe & PCI_PROBE_MMCONF) || pci_mmcfg_arch_init_failed)
 		return -ENODEV;
 
-	if (start > end)
+	if (start > end || !addr) {
+		dev_warn(dev, FW_INFO
+			"Invalid address to add MMCONFIG"
+			"start %02x end %02x addr %pR\n",
+			start, end, addr);
 		return -EINVAL;
+	}
 
 	mutex_lock(&pci_mmcfg_lock);
 	cfg = pci_mmconfig_lookup(seg, start);
@@ -716,11 +721,6 @@ int pci_mmconfig_insert(struct device *dev, u16 seg, u8 start, u8 end,
 		return -EEXIST;
 	}
 
-	if (!addr) {
-		mutex_unlock(&pci_mmcfg_lock);
-		return -EINVAL;
-	}
-
 	rc = -EBUSY;
 	cfg = pci_mmconfig_alloc(seg, start, end, addr);
 	if (cfg == NULL) {
-- 
1.7.1
