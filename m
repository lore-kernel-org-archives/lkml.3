Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019AbaENLdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:33:55 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:35996 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020AbaENLdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:33:53 -0400
Subject: [PATCH v1.2 10/16] arcmsr: clear outbound doorbell buffer
 completely
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        agordeev@redhat.com, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 May 2014 19:33:39 +0800
Message-ID: <1400067219.6957.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Clearing outbound doorbell buffer completely for adapter type C.
This is to prevent getting garbage data input from IOP before ioctl command beginning.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:47:20.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:48:04.000000000 +0800
@@ -2892,11 +2892,23 @@ static void arcmsr_clear_doorbell_queue_
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
@@ -3124,9 +3136,7 @@ sleep:
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


