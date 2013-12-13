Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3LMPvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:51:12 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16487 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3LMPvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:51:10 -0500
From: Betty Dall <betty.dall@hp.com>
To: rjw@rjwysocki.net, bhelgaas@google.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH] PCI AER: handle pci_cleanup_aer_uncorrect_error_status() in firmware first mode
Date: Fri, 13 Dec 2013 08:41:46 -0700
Message-Id: <1386949306-30601-1-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three functions exported from aerdrv_core.c that could be
called when the system is in firmware first mode:
pci_enable_pcie_error_reporting(), pci_disable_pcie_error_reporting, and
pci_cleanup_aer_uncorrect_error_status(). The first two functions check if
we are in firmware first mode and return immediately.
pci_cleanup_aer_uncorrect_error_status() does not check firmware first
mode. The problem is that all of these functions should not access the AER
registers in firmware first mode because the firmware has not granted OS
control of the AER registers through the _OSC. Many drivers call this
function in their pci_error_handlers in firmware first mode.

The fix is to change pci_cleanup_aer_uncorrect_error_status() to check
firmware first mode before accessing the AER registers. If it is in firmware
first mode, return 0. I considered returning -EIO, but decided the status
has been cleaned up appropriately for firmware first. Returning 0 also avoids
an error message. Not many places check the return of this function, and the
ones that do, print an error message and continue such as:
   err = pci_cleanup_aer_uncorrect_error_status(pdev);
   if (err) {
       dev_err(&pdev->dev,
           "pci_cleanup_aer_uncorrect_error_status failed 0x%0x\n",
            err); /* non-fatal, continue */
   }
That error message is how I found this problem, and it is not applicable
for the firmware first recovery path.

Signed-off-by: Betty Dall <betty.dall@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index b2c8881..1f60408 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -62,6 +62,9 @@ int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
 	int pos;
 	u32 status;
 
+	if (pcie_aer_get_firmware_first(dev))
+		return 0;
+
 	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ERR);
 	if (!pos)
 		return -EIO;
