Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaHDJeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:34:25 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:64730 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaHDJeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:34:23 -0400
Subject: [PATCH v1.3 10/18] arcmsr: clear outbound doorbell buffer
 completely
From: Ching Huang <ching2048@areca.com.tw>
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Aug 2014 17:34:14 +0800
Message-ID: <1407144854.4756.74.camel@Centos6.3-64>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Clear outbound doorbell buffer completely for adapter type C.
This is to prevent getting bad data input from IOP before ioctl command beginning.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-04 16:44:50.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-04 16:45:00.000000000 +0800
@@ -2888,11 +2888,23 @@ static void arcmsr_clear_doorbell_queue_
 		break;
 	case ACB_ADAPTER_TYPE_C: {
 		struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
-		uint32_t outbound_doorbell;
+		uint32_t outbound_doorbell, i;
 		/* empty doorbell Qbuffer if door bell ringed */
 		outbound_doorbell = readl(&reg->outbound_doorbell);
 		writel(outbound_doorbell, &reg->outbound_doorbell_clear);
 		writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);
+		for (i = 0; i < 200; i++) {
+			msleep(20);
+			outbound_doorbell = readl(&reg->outbound_doorbell);
+			if (outbound_doorbell &
+				ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {
+				writel(outbound_doorbell,
+					&reg->outbound_doorbell_clear);
+				writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK,
+					&reg->inbound_doorbell);
+			} else
+				break;
+		}
 		}
 	}
 }
@@ -3120,9 +3132,7 @@ sleep:
 				arcmsr_get_firmware_spec(acb);
 				arcmsr_start_adapter_bgrb(acb);
 				/* clear Qbuffer if door bell ringed */
-				outbound_doorbell = readl(&reg->outbound_doorbell);
-				writel(outbound_doorbell, &reg->outbound_doorbell_clear); /*clear interrupt */
-				writel(ARCMSR_HBCMU_DRV2IOP_DATA_READ_OK, &reg->inbound_doorbell);
+				arcmsr_clear_doorbell_queue_buffer(acb);
 				/* enable outbound Post Queue,outbound doorbell Interrupt */
 				arcmsr_enable_outbound_ints(acb, intmask_org);
 				atomic_set(&acb->rq_map_token, 16);


