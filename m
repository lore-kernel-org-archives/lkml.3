Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885AbaD3Kzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:55:38 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:40691 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180AbaD3Kzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:55:36 -0400
Subject: [PATCH v1.0 6/16] arcmsr: redefine adapter type
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 18:55:28 +0800
Message-ID: <1398855328.6930.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Rewrite the define adapter type function.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:09:06.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:10:02.000000000 +0800
@@ -295,24 +295,43 @@ static int arcmsr_bios_param(struct scsi
 	return 0;
 }
 
-static void arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
+static bool arcmsr_define_adapter_type(struct AdapterControlBlock *acb)
 {
 	struct pci_dev *pdev = acb->pdev;
 	u16 dev_id;
+
 	pci_read_config_word(pdev, PCI_DEVICE_ID, &dev_id);
 	acb->dev_id = dev_id;
 	switch (dev_id) {
-	case 0x1880: {
+	case 0x1880:
 		acb->adapter_type = ACB_ADAPTER_TYPE_C;
-		}
 		break;
-	case 0x1201: {
+	case 0x1200:
+	case 0x1201:
+	case 0x1202:
 		acb->adapter_type = ACB_ADAPTER_TYPE_B;
-		}
 		break;
-
-	default: acb->adapter_type = ACB_ADAPTER_TYPE_A;
+	case 0x1110:
+	case 0x1120:
+	case 0x1130:
+	case 0x1160:
+	case 0x1170:
+	case 0x1210:
+	case 0x1220:
+	case 0x1230:
+	case 0x1260:
+	case 0x1270:
+	case 0x1280:
+	case 0x1380:
+	case 0x1381:
+	case 0x1680:
+		acb->adapter_type = ACB_ADAPTER_TYPE_A;
+		break;
+	default:
+		pr_notice("Unknown device ID = 0x%x\n", dev_id);
+		return false;
 	}
+	return true;
 }
 
 static uint8_t arcmsr_hba_wait_msgint_ready(struct AdapterControlBlock *acb)
@@ -746,7 +765,9 @@ static int arcmsr_probe(struct pci_dev *
 			ACB_F_MESSAGE_WQBUFFER_READED);
 	acb->acb_flags &= ~ACB_F_SCSISTOPADAPTER;
 	INIT_LIST_HEAD(&acb->ccb_free_list);
-	arcmsr_define_adapter_type(acb);
+	error = arcmsr_define_adapter_type(acb);
+	if (!error)
+		goto pci_release_regs;
 	error = arcmsr_remap_pciregion(acb);
 	if(!error){
 		goto pci_release_regs;


