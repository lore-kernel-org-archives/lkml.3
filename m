Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934695Ab3DGX3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:29:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46675 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934586Ab3DGX3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:29:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bjorn Helgaas" <bhelgaas@google.com>,
        "Yinghai Lu" <yinghai@kernel.org>,
        "Matthew Whitehead" <mwhitehe@redhat.com>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.879424092@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [44/74] EISA/PCI: Init EISA early, before PNP
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit c5fb301ae83bec6892e54984e6ec765c47df8e10 upstream.

Matthew reported kernels fail the pci_eisa probe and are later successful
with the virtual_eisa_root_init force probe without slot0.

The reason for that is: PNP probing is before pci_eisa_init gets called
as pci_eisa_init is called via pci_driver.

pnp 00:0f has 0xc80 - 0xc84 reserved.
[    9.700409] pnp 00:0f: [io  0x0c80-0x0c84]

so eisa_probe will fail from pci_eisa_init
				==>eisa_root_register
					==>eisa_probe path.
as force_probe is not set in pci_eisa_root, it will bail early when
slot0 is not probed and initialized.

Try to use subsys_initcall_sync instead, and will keep following sequence:
	pci_subsys_init
	pci_eisa_init_early
	pnpacpi_init/isapnp_init

After this patch EISA can be initialized properly, and PNP overlapping
resource will not be reserved.
[   10.104434] system 00:0f: [io  0x0c80-0x0c84] could not be reserved

Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
Tested-by: Matthew Whitehead <mwhitehe@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/eisa/pci_eisa.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

--- a/drivers/eisa/pci_eisa.c
+++ b/drivers/eisa/pci_eisa.c
@@ -19,8 +19,7 @@
 /* There is only *one* pci_eisa device per machine, right ? */
 static struct eisa_root_device pci_eisa_root;
 
-static int __init pci_eisa_init(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
+static int __init pci_eisa_init(struct pci_dev *pdev)
 {
 	int rc;
 
@@ -45,22 +44,26 @@ static int __init pci_eisa_init(struct p
 	return 0;
 }
 
-static struct pci_device_id pci_eisa_pci_tbl[] = {
-	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_BRIDGE_EISA << 8, 0xffff00, 0 },
-	{ 0, }
-};
-
-static struct pci_driver __refdata pci_eisa_driver = {
-	.name		= "pci_eisa",
-	.id_table	= pci_eisa_pci_tbl,
-	.probe		= pci_eisa_init,
-};
-
-static int __init pci_eisa_init_module (void)
+/*
+ * We have to call pci_eisa_init_early() before pnpacpi_init()/isapnp_init().
+ *   Otherwise pnp resource will get enabled early and could prevent eisa
+ *   to be initialized.
+ * Also need to make sure pci_eisa_init_early() is called after
+ * x86/pci_subsys_init().
+ * So need to use subsys_initcall_sync with it.
+ */
+static int __init pci_eisa_init_early(void)
 {
-	return pci_register_driver (&pci_eisa_driver);
-}
+	struct pci_dev *dev = NULL;
+	int ret;
+
+	for_each_pci_dev(dev)
+		if ((dev->class >> 8) == PCI_CLASS_BRIDGE_EISA) {
+			ret = pci_eisa_init(dev);
+			if (ret)
+				return ret;
+		}
 
-device_initcall(pci_eisa_init_module);
-MODULE_DEVICE_TABLE(pci, pci_eisa_pci_tbl);
+	return 0;
+}
+subsys_initcall_sync(pci_eisa_init_early);

