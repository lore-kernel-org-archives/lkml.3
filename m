Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab3KUJfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:35:44 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35586 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3KUJfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:35:40 -0500
From: "ethan.zhao" <ethan.kernel@gmail.com>
To: yu.zhao@intel.com, bhelgaas@google.com
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org,
        "ethan.zhao" <ethan.kernel@gmail.com>
Subject: [PATCH V2] PCI: Init NumVFs register to zero in sriov_init()
Date: Thu, 21 Nov 2013 17:34:10 +0800
Message-Id: <1385026450-289-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Though no specification about NumVFs register initial value after POST, to void the confusion
lspci output as following before VF was enabled, we should clear the NumVFs value left by BIOS
to zero:

#lspci -vvvxxx -s 13:00.0
13:00.0 Ethernet controller: Intel Corporation 82599EB 10-Gigabit SFI/SFP+
Network Connection (rev 01)  Subsystem: Oracle/SUN Ethernet Server Adapter X520-2
~
Capabilities: [160 v1] Single Root I/O Virtualization (SR-IOV)
        IOVCap: Migration-, Interrupt Message Number: 000
        IOVCtl: Enable- Migration- Interrupt- MSE- ARIHierarchy+
        IOVSta: Migration-
        Initial VFs: 64, Total VFs: 64, Number of VFs: 64, Function
        Dependency Link: 00
                                             ^dazed !
140: 03 00 01 15 c4 24 c8 ff ff 21 1b 00 00 00 00 00
150: 0e 00 01 16 00 01 00 00 00 00 00 00 00 00 00 00
160: 10 00 01 00 00 00 00 00 10 00 00 00 40 00 40 00
                                         ^     ^Total VFs
                                          Initial VFs
170: 40 00 00 00 80 00 02 00 00 00 ed 10 53 05 00 00
      ^Number of VFs

~
V2: Rivised description.

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

