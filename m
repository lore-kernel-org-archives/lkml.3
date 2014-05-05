Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaEEM4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:56:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40988 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932259AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 31/50] staging: comedi: 8255_pci: initialize MITE data window
Date: Mon,  5 May 2014 14:43:13 +0200
Message-Id: <c78609380c224adcbdf21f138505c63d93d4ce7c.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 268d1e799663b795cba15c64f5d29407786a9dd4 upstream.

According to National Instruments' PCI-DIO-96/PXI-6508/PCI-6503 User
Manual, the physical address in PCI BAR1 needs to be OR'ed with 0x80 and
written to register offset 0xC0 in the "MITE" registers (BAR0).  Do so
during initialization of the National Instruments boards handled by the
"8255_pci" driver.  The boards were previously handled by the
"ni_pcidio" driver, where the initialization was done by `mite_setup()`
in the "mite" module.  The "mite" module comes with too much extra
baggage for the "8255_pci" driver to deal with so use a local, simpler
initialization function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/comedi/drivers/8255_pci.c | 34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/staging/comedi/drivers/8255_pci.c b/drivers/staging/comedi/drivers/8255_pci.c
index c55f234b29e6..26321f9f5caf 100644
--- a/drivers/staging/comedi/drivers/8255_pci.c
+++ b/drivers/staging/comedi/drivers/8255_pci.c
@@ -56,6 +56,7 @@ Configuration Options: not applicable, uses PCI auto config
 #include "../comedidev.h"
 
 #include "8255.h"
+#include "mite.h"
 
 enum pci_8255_boardid {
 	BOARD_ADLINK_PCI7224,
@@ -79,6 +80,7 @@ struct pci_8255_boardinfo {
 	const char *name;
 	int dio_badr;
 	int n_8255;
+	unsigned int has_mite:1;
 };
 
 static const struct pci_8255_boardinfo pci_8255_boards[] = {
@@ -126,36 +128,43 @@ static const struct pci_8255_boardinfo pci_8255_boards[] = {
 		.name		= "ni_pci-dio-96",
 		.dio_badr	= 1,
 		.n_8255		= 4,
+		.has_mite	= 1,
 	},
 	[BOARD_NI_PCIDIO96B] = {
 		.name		= "ni_pci-dio-96b",
 		.dio_badr	= 1,
 		.n_8255		= 4,
+		.has_mite	= 1,
 	},
 	[BOARD_NI_PXI6508] = {
 		.name		= "ni_pxi-6508",
 		.dio_badr	= 1,
 		.n_8255		= 4,
+		.has_mite	= 1,
 	},
 	[BOARD_NI_PCI6503] = {
 		.name		= "ni_pci-6503",
 		.dio_badr	= 1,
 		.n_8255		= 1,
+		.has_mite	= 1,
 	},
 	[BOARD_NI_PCI6503B] = {
 		.name		= "ni_pci-6503b",
 		.dio_badr	= 1,
 		.n_8255		= 1,
+		.has_mite	= 1,
 	},
 	[BOARD_NI_PCI6503X] = {
 		.name		= "ni_pci-6503x",
 		.dio_badr	= 1,
 		.n_8255		= 1,
+		.has_mite	= 1,
 	},
 	[BOARD_NI_PXI_6503] = {
 		.name		= "ni_pxi-6503",
 		.dio_badr	= 1,
 		.n_8255		= 1,
+		.has_mite	= 1,
 	},
 };
 
@@ -163,6 +172,25 @@ struct pci_8255_private {
 	void __iomem *mmio_base;
 };
 
+static int pci_8255_mite_init(struct pci_dev *pcidev)
+{
+	void __iomem *mite_base;
+	u32 main_phys_addr;
+
+	/* ioremap the MITE registers (BAR 0) temporarily */
+	mite_base = pci_ioremap_bar(pcidev, 0);
+	if (!mite_base)
+		return -ENOMEM;
+
+	/* set data window to main registers (BAR 1) */
+	main_phys_addr = pci_resource_start(pcidev, 1);
+	writel(main_phys_addr | WENAB, mite_base + MITE_IODWBSR);
+
+	/* finished with MITE registers */
+	iounmap(mite_base);
+	return 0;
+}
+
 static int pci_8255_mmio(int dir, int port, int data, unsigned long iobase)
 {
 	void __iomem *mmio_base = (void __iomem *)iobase;
@@ -201,6 +229,12 @@ static int pci_8255_auto_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
+	if (board->has_mite) {
+		ret = pci_8255_mite_init(pcidev);
+		if (ret)
+			return ret;
+	}
+
 	is_mmio = (pci_resource_flags(pcidev, board->dio_badr) &
 		   IORESOURCE_MEM) != 0;
 	if (is_mmio) {
-- 
1.9.2

