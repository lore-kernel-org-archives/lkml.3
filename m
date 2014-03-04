Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbaCDVDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:03:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaCDUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Cheng <chris.cheng@atrustcorp.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.13 113/172] PCI: Enable INTx if BIOS left them disabled
Date: Tue,  4 Mar 2014 12:03:17 -0800
Message-Id: <20140304200303.326501873@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1120,6 +1120,8 @@ EXPORT_SYMBOL_GPL(pci_load_and_free_save
 static int do_pci_enable_device(struct pci_dev *dev, int bars)
 {
 	int err;
+	u16 cmd;
+	u8 pin;
 
 	err = pci_set_power_state(dev, PCI_D0);
 	if (err < 0 && err != -EIO)
@@ -1129,6 +1131,14 @@ static int do_pci_enable_device(struct p
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
 


