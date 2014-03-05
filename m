Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbaCEOZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:25:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40845 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756745AbaCEOZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:25:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 032/131] PCI: Enable INTx if BIOS left them disabled
Date: Wed,  5 Mar 2014 14:22:36 +0000
Message-Id: <1394029455-23128-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 1f42db786b14a31bf807fc41ee5583a00c08fcb1 upstream.

Some firmware leaves the Interrupt Disable bit set even if the device uses
INTx interrupts.  Clear Interrupt Disable so we get those interrupts.

Based on the report mentioned below, if the user selects the "EHCI only"
option in the Intel Baytrail BIOS, the EHCI device is handed off to the OS
with the PCI_COMMAND_INTX_DISABLE bit set.

Link: http://lkml.kernel.org/r/20140114181721.GC12126@xanatos
Link: https://bugzilla.kernel.org/show_bug.cgi?id=70601
Reported-by: Chris Cheng <chris.cheng@atrustcorp.com>
Reported-and-tested-by: Jamie Chen <jamie.chen@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e37fea6..1088e0d 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1119,6 +1119,8 @@ EXPORT_SYMBOL_GPL(pci_load_and_free_saved_state);
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;
+	u16 cmd;
+	u8 pin;
 
 	err = pci_set_power_state(dev, PCI_D0);
 	if (err < 0 && err != -EIO)
@@ -1128,6 +1130,14 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 		return err;
 	pci_fixup_device(pci_fixup_enable, dev);
 
+	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+	if (pin) {
+		pci_read_config_word(dev, PCI_COMMAND, &cmd);
+		if (cmd & PCI_COMMAND_INTX_DISABLE)
+			pci_write_config_word(dev, PCI_COMMAND,
+					      cmd & ~PCI_COMMAND_INTX_DISABLE);
+	}
+
 	return 0;
 }
 
-- 
1.9.0

