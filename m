Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab3KFOul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:50:41 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60218 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092Ab3KFOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:50:40 -0500
From: "ethan.zhao" <ethan.kernel@gmail.com>
To: yu.zhao@intel.com, bhelgaas@google.com
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
        "ethan.zhao" <ethan.kernel@gmail.com>
Subject: [PATCH] PCI: Init NumVFs register to zero in sriov_init()
Date: Wed,  6 Nov 2013 22:49:13 +0800
Message-Id: <1383749353-3510-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though no specification about NumVFs register initial value after POST, to void the confusion
lspci output as following before VF was enabled, we should clear the NumVFs value left by BIOS
to zero:

$lspci -vvv -s 03:00.0
Ethernet controller: Intel Corporation 82599EB 10-Gigabit SFI/SFP+ Network Connection (rev 01)
~
Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
		IOVCap:	Migration-, Interrupt Message Number: 000
		IOVCtl:	Enable+ Migration- Interrupt- MSE+ ARIHierarchy+
		IOVSta:	Migration-
		Initial VFs: 64, Total VFs: 64, Number of VFs: 64, Function Dependency Link: 00
                                                              ^dazed !
~
Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 drivers/pci/iov.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index de8ffac..a4941ad 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -439,6 +439,8 @@ static int sriov_init(struct pci_dev *dev, int pos)
 
 found:
 	pci_write_config_word(dev, pos + PCI_SRIOV_CTRL, ctrl);
+	/* VF Enable is cleared, so we could init the NumVFs register to 0 */
+	pci_write_config_word(dev, pos + PCI_SRIOV_NUM_VF, 0);
 	pci_read_config_word(dev, pos + PCI_SRIOV_VF_OFFSET, &offset);
 	pci_read_config_word(dev, pos + PCI_SRIOV_VF_STRIDE, &stride);
 	if (!offset || (total > 1 && !stride))
-- 
1.8.3.4 (Apple Git-47)

