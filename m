Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbaENLN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:13:28 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:33566 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaENLN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:13:26 -0400
Subject: [PATCH v1.2 4/16] arcmsr: limit max number of SCSI command request
From: ching <ching2048@areca.com.tw>
To: jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com,
        agordeev@redhat.com, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 May 2014 19:13:19 +0800
Message-ID: <1400065999.6957.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ching<ching2048@areca.com.tw>

Have a limitation of max number of SCSI command request to prevent command overflow.

Signed-off-by: Ching<ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h	2014-05-06 15:24:06.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h	2014-05-06 15:22:36.000000000 +0800
@@ -45,11 +45,12 @@
 #include <linux/interrupt.h>
 struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
-#define ARCMSR_MAX_OUTSTANDING_CMD						256
 #ifdef CONFIG_XEN
 	#define ARCMSR_MAX_FREECCB_NUM	160
+#define ARCMSR_MAX_OUTSTANDING_CMD	155
 #else
 	#define ARCMSR_MAX_FREECCB_NUM	320
+#define ARCMSR_MAX_OUTSTANDING_CMD	255
 #endif
 #define ARCMSR_DRIVER_VERSION		"v1.30.00.04-20140428"
 #define ARCMSR_SCSI_INITIATOR_ID						255
@@ -598,6 +599,7 @@ struct AdapterControlBlock
 				#define	FW_DEADLOCK	0x0010
 	atomic_t 			rq_map_token;
 	atomic_t			ante_token_value;
+	uint32_t	maxOutstanding;
 	int		msix_vector_count;
 };/* HW_DEVICE_EXTENSION */
 /*
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:26:42.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-05-07 18:43:40.000000000 +0800
@@ -134,7 +134,7 @@ static struct scsi_host_template arcmsr_
 	.eh_bus_reset_handler	= arcmsr_bus_reset,
 	.bios_param		= arcmsr_bios_param,
 	.change_queue_depth	= arcmsr_adjust_disk_queue_depth,
-	.can_queue		= ARCMSR_MAX_FREECCB_NUM,
+	.can_queue		= ARCMSR_MAX_OUTSTANDING_CMD,
 	.this_id			= ARCMSR_SCSI_INITIATOR_ID,
 	.sg_tablesize	        	= ARCMSR_DEFAULT_SG_ENTRIES, 
 	.max_sectors    	    	= ARCMSR_MAX_XFER_SECTORS_C, 
@@ -697,7 +697,7 @@ static int arcmsr_probe(struct pci_dev *
 	host->max_lun = ARCMSR_MAX_TARGETLUN;
 	host->max_id = ARCMSR_MAX_TARGETID;		/*16:8*/
 	host->max_cmd_len = 16;	 			/*this is issue of 64bit LBA ,over 2T byte*/
-	host->can_queue = ARCMSR_MAX_FREECCB_NUM;	/* max simultaneous cmds */		
+	host->can_queue = ARCMSR_MAX_OUTSTANDING_CMD;	/* max simultaneous cmds */		
 	host->cmd_per_lun = ARCMSR_MAX_CMD_PERLUN;	    
 	host->this_id = ARCMSR_SCSI_INITIATOR_ID;
 	host->unique_id = (bus << 8) | dev_fun;
@@ -2220,8 +2220,7 @@ static int arcmsr_queue_command_lck(stru
 		arcmsr_handle_virtual_command(acb, cmd);
 		return 0;
 	}
-	if (atomic_read(&acb->ccboutstandingcount) >=
-			ARCMSR_MAX_OUTSTANDING_CMD)
+	if (atomic_read(&acb->ccboutstandingcount) >= acb->maxOutstanding)
 		return SCSI_MLQUEUE_HOST_BUSY;
 	ccb = arcmsr_get_freeccb(acb);
 	if (!ccb)
@@ -2432,12 +2431,26 @@ static bool arcmsr_get_hbc_config(struct
 }
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb)
 {
-	if (acb->adapter_type == ACB_ADAPTER_TYPE_A)
-		return arcmsr_get_hba_config(acb);
-	else if (acb->adapter_type == ACB_ADAPTER_TYPE_B)
-		return arcmsr_get_hbb_config(acb);
+	bool rtn = false;
+
+	switch (acb->adapter_type) {
+	case ACB_ADAPTER_TYPE_A:
+		rtn = arcmsr_get_hba_config(acb);
+		break;
+	case ACB_ADAPTER_TYPE_B:
+		rtn = arcmsr_get_hbb_config(acb);
+		break;
+	case ACB_ADAPTER_TYPE_C:
+		rtn = arcmsr_get_hbc_config(acb);
+		break;
+	default:
+		break;
+	}
+	if(acb->firm_numbers_queue > ARCMSR_MAX_OUTSTANDING_CMD)
+		acb->maxOutstanding = ARCMSR_MAX_OUTSTANDING_CMD;
 	else
-		return arcmsr_get_hbc_config(acb);
+		acb->maxOutstanding = acb->firm_numbers_queue - 1;
+	return rtn;
 }
 
 static int arcmsr_polling_hba_ccbdone(struct AdapterControlBlock *acb,



