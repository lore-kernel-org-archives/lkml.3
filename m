Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab3DRJR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:17:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40003 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab3DRJRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 06/72] EISA/PCI: Init EISA early, before PNP
Date: Thu, 18 Apr 2013 10:15:51 +0100
Message-Id: <1366276617-3553-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/eisa/pci_eisa.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
index ef5c3ec..6c3fca9 100644
--- a/drivers/eisa/pci_eisa.c
+++ b/drivers/eisa/pci_eisa.c
@@ -19,8 +19,7 @@
 /* There is only *one* pci_eisa device per machine, right ? */
 static struct eisa_root_device pci_eisa_root;
 
-static int __init pci_eisa_init(struct pci_dev *pdev,
-				const struct pci_device_id *ent)
+static int __init pci_eisa_init(struct pci_dev *pdev)
 {
 	int rc, i;
 	struct resource *res, *bus_res = NULL;
@@ -67,22 +66,26 @@ static int __init pci_eisa_init(struct pci_dev *pdev,
 	return 0;
 }
 
-static struct pci_device_id pci_eisa_pci_tbl[] = {
-	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_BRIDGE_EISA << 8, 0xffff00, 0 },
-	{ 0, }
-};
+/*
+ * We have to call pci_eisa_init_early() before pnpacpi_init()/isapnp_init().
+ *   Otherwise pnp resource will get enabled early and could prevent eisa
+ *   to be initialized.
+ * Also need to make sure pci_eisa_init_early() is called after
+ * x86/pci_subsys_init().
+ * So need to use subsys_initcall_sync with it.
+ */
+static int __init pci_eisa_init_early(void)
+{
+	struct pci_dev *dev = NULL;
+	int ret;
 
-static struct pci_driver __refdata pci_eisa_driver = {
-	.name		= "pci_eisa",
-	.id_table	= pci_eisa_pci_tbl,
-	.probe		= pci_eisa_init,
-};
+	for_each_pci_dev(dev)
+		if ((dev->class >> 8) == PCI_CLASS_BRIDGE_EISA) {
+			ret = pci_eisa_init(dev);
+			if (ret)
+				return ret;
+		}
 
-static int __init pci_eisa_init_module (void)
-{
-	return pci_register_driver (&pci_eisa_driver);
+	return 0;
 }
-
-device_initcall(pci_eisa_init_module);
-MODULE_DEVICE_TABLE(pci, pci_eisa_pci_tbl);
+subsys_initcall_sync(pci_eisa_init_early);
-- 
1.8.1.2

