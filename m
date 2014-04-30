Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbaD3LTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 07:19:33 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:42811 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbaD3LTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 07:19:32 -0400
Subject: [PATCH v1.0 10/16] arcmsr: clear outbound doorbell buffer
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 19:19:25 +0800
Message-ID: <1398856765.6930.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Clearing outbound doorbell buffer completely for adapter type C.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:12:36.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-04-30 15:13:30.000000000 +0800
@@ -2934,11 +2934,23 @@ static void arcmsr_clear_doorbell_queue_
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
@@ -3166,9 +3178,7 @@ sleep:
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


