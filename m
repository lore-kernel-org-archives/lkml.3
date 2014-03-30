Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaC3Xlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:41:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36426 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbaC3XZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "Chris Cheng" <chris.cheng@atrustcorp.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.13737205@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 118/200] PCI: Enable INTx if BIOS left them disabled
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1078,6 +1078,8 @@ EXPORT_SYMBOL_GPL(pci_load_and_free_save
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;
+	u16 cmd;
+	u8 pin;
 
 	err = pci_set_power_state(dev, PCI_D0);
 	if (err < 0 && err != -EIO)
@@ -1087,6 +1089,14 @@ static int do_pci_enable_device(struct p
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
 

