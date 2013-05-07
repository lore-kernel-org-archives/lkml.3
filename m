Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab3EGENr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:13:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889Ab3EGD6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:45 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=627E-fS9MMsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7Jupn-8awV8A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=P3f3k1vR-OQB382XG1EA:9 a=LI9Vle30uBYA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035842.766865390@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matthew Whitehead <mwhitehe@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [011/126] EISA/PCI: Init EISA early, before PNP
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0011-EISA-PCI-Init-EISA-early-before-PNP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

[ Upstream commit c5fb301ae83bec6892e54984e6ec765c47df8e10 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/eisa/pci_eisa.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
index cdae207..d4cd56a 100644
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
 
@@ -45,22 +44,26 @@ static int __init pci_eisa_init(struct pci_dev *pdev,
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
1.7.10.4


