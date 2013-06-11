Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3FKUEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:04:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710Ab3FKUER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [ 63/79] powerpc: Set default VGA device
Date: Tue, 11 Jun 2013 13:03:29 -0700
Message-Id: <20130611195324.355968703@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit c2e1d84523ad2a19e5be08c1f01999cc9e82652e upstream.

Add a PCI quirk for VGA devices on Power to set the default VGA device.
Ensures a default VGA is always set if a graphics adapter is present,
even if firmware did not initialize it. If more than one graphics
adapter is present, ensure the one initialized by firmware is set
as the default VGA device. This ensures that X autoconfiguration
will work.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/pci-common.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -30,6 +30,7 @@
 #include <linux/irq.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
+#include <linux/vgaarb.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -1725,3 +1726,15 @@ static void fixup_hide_host_resource_fsl
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MOTOROLA, PCI_ANY_ID, fixup_hide_host_resource_fsl);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID, fixup_hide_host_resource_fsl);
+
+static void fixup_vga(struct pci_dev *pdev)
+{
+	u16 cmd;
+
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	if ((cmd & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) || !vga_default_device())
+		vga_set_default_device(pdev);
+
+}
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
+			      PCI_CLASS_DISPLAY_VGA, 8, fixup_vga);


