Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaB0LJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:09:17 -0500
Received: from snt0-omc1-s25.snt0.hotmail.com ([65.55.90.36]:15008 "EHLO
	snt0-omc1-s25.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbaB0LJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:09:12 -0500
X-TMN: [NFnudiwCjFcM69JfVI5qtF7s24bgRPB0]
X-Originating-Email: [ching2048@outlook.com]
Message-ID: <SNT151-W226A5819DC34210E45F42CB9830@phx.gbl>
From: Huang ching-lung <ching2048@outlook.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: "ching2048@areca.com.tw" <ching2048@areca.com.tw>
Subject: [PATCH v1.4 1/11] arcmsr: Rewrite interrupt service routine to fix
 command timeout
Date: Thu, 27 Feb 2014 11:09:11 +0000
Importance: Normal
Content-Type: text/plain; charset="big5"
MIME-Version: 1.0
X-OriginalArrivalTime: 27 Feb 2014 11:09:11.0652 (UTC) FILETIME=[57BE6240:01CF33AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1RB9Uuo005976

From: Ching <ching2048@areca.com.tw>

Rewrite interrupt service routine to fix command timeout on controller too heavy loading.

Singed-off-by: Ching <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
--- a/drivers/scsi/arcmsr/arcmsr.h      2014-02-07 01:47:44.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr.h      2014-02-24 18:43:54.000000000 +0800
@@ -45,13 +45,13 @@
 #include <linux/interrupt.h>
 struct device_attribute;
 /*The limit of outstanding scsi command that firmware can handle*/
-#define ARCMSR_MAX_OUTSTANDING_CMD                                             256
+#define ARCMSR_MAX_OUTSTANDING_CMD     255
 #ifdef CONFIG_XEN
        #define ARCMSR_MAX_FREECCB_NUM  160
 #else
        #define ARCMSR_MAX_FREECCB_NUM  320
 #endif
-#define ARCMSR_DRIVER_VERSION               "Driver Version 1.20.00.15 2010/08/05"
+#define ARCMSR_DRIVER_VERSION          "v1.30.00.04-20131204"
 #define ARCMSR_SCSI_INITIATOR_ID                                               255
 #define ARCMSR_MAX_XFER_SECTORS                                                        512
 #define ARCMSR_MAX_XFER_SECTORS_B                                              4096
@@ -690,3 +690,4 @@ extern struct QBUFFER __iomem *arcmsr_ge
 extern struct device_attribute *arcmsr_host_attrs[];
 extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
 void arcmsr_free_sysfs_attr(struct AdapterControlBlock *acb);
+
diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-07 01:47:00.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-24 18:44:05.000000000 +0800
@@ -104,7 +104,7 @@ static void arcmsr_request_hbc_device_ma
 static void arcmsr_message_isr_bh_fn(struct work_struct *work);
 static bool arcmsr_get_firmware_spec(struct AdapterControlBlock *acb);
 static void arcmsr_start_adapter_bgrb(struct AdapterControlBlock *acb);
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *pACB);
+static void arcmsr_hbaC_message_isr(struct AdapterControlBlock *pACB);
 static void arcmsr_hardware_reset(struct AdapterControlBlock *acb);
 static const char *arcmsr_info(struct Scsi_Host *);
 static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb);
@@ -1436,45 +1436,46 @@ static void arcmsr_iop2drv_data_read_han
        }
 }
 
-static void arcmsr_hba_doorbell_isr(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)
 {
        uint32_t outbound_doorbell;
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        outbound_doorbell = readl(&reg->outbound_doorbell);
-       writel(outbound_doorbell, &reg->outbound_doorbell);
-       if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK) {
-               arcmsr_iop2drv_data_wrote_handle(acb);
-       }
-
-       if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK) {
-               arcmsr_iop2drv_data_read_handle(acb);
-       }
+       do {
+               writel(outbound_doorbell, &reg->outbound_doorbell);
+               if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK)
+                       arcmsr_iop2drv_data_wrote_handle(acb);
+               if (outbound_doorbell & ARCMSR_OUTBOUND_IOP331_DATA_READ_OK)
+                       arcmsr_iop2drv_data_read_handle(acb);
+               outbound_doorbell = readl(&reg->outbound_doorbell);
+       } while (outbound_doorbell & (ARCMSR_OUTBOUND_IOP331_DATA_WRITE_OK
+               | ARCMSR_OUTBOUND_IOP331_DATA_READ_OK));
 }
-static void arcmsr_hbc_doorbell_isr(struct AdapterControlBlock *pACB)
+
+static void
+arcmsr_hbaC_doorbell_isr(struct AdapterControlBlock *pACB)
 {
        uint32_t outbound_doorbell;
-       struct MessageUnit_C *reg = (struct MessageUnit_C *)pACB->pmuC;
-       /*
-       *******************************************************************
-       **  Maybe here we need to check wrqbuffer_lock is lock or not
-       **  DOORBELL: din! don!
-       **  check if there are any mail need to pack from firmware
-       *******************************************************************
-       */
+       struct MessageUnit_C __iomem *reg = pACB->pmuC;
        outbound_doorbell = readl(&reg->outbound_doorbell);
-       writel(outbound_doorbell, &reg->outbound_doorbell_clear);/*clear interrupt*/
-       if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK) {
-               arcmsr_iop2drv_data_wrote_handle(pACB);
-       }
-       if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK) {
-               arcmsr_iop2drv_data_read_handle(pACB);
-       }
-       if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE) {
-               arcmsr_hbc_message_isr(pACB);    /* messenger of "driver to iop commands" */
-       }
-       return;
+       do {
+               writel(outbound_doorbell, &reg->outbound_doorbell_clear);
+               readl(&reg->outbound_doorbell_clear);
+               if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK)
+                       arcmsr_iop2drv_data_wrote_handle(pACB);
+               if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK)
+                       arcmsr_iop2drv_data_read_handle(pACB);
+               if (outbound_doorbell & ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE)
+                       arcmsr_hbaC_message_isr(pACB);
+               outbound_doorbell = readl(&reg->outbound_doorbell);
+       } while (outbound_doorbell & (ARCMSR_HBCMU_IOP2DRV_DATA_WRITE_OK
+               | ARCMSR_HBCMU_IOP2DRV_DATA_READ_OK
+               | ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE));
 }
-static void arcmsr_hba_postqueue_isr(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaA_postqueue_isr(struct AdapterControlBlock *acb)
 {
        uint32_t flag_ccb;
        struct MessageUnit_A __iomem *reg = acb->pmuA;
@@ -1482,13 +1483,18 @@ static void arcmsr_hba_postqueue_isr(str
        struct CommandControlBlock *pCCB;
        bool error;
        while ((flag_ccb = readl(&reg->outbound_queueport)) != 0xFFFFFFFF) {
-               pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset + (flag_ccb << 5));/*frame must be 32 bytes aligned*/
-               pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
-               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+               pARCMSR_CDB = (struct ARCMSR_CDB *)
+                       (acb->vir2phy_offset + (flag_ccb << 5));
+               pCCB = container_of(pARCMSR_CDB,
+                       struct CommandControlBlock, arcmsr_cdb);
+               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)
+                       ? true : false;
                arcmsr_drain_donequeue(acb, pCCB, error);
        }
 }
-static void arcmsr_hbb_postqueue_isr(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
 {
        uint32_t index;
        uint32_t flag_ccb;
@@ -1499,9 +1505,12 @@ static void arcmsr_hbb_postqueue_isr(str
        index = reg->doneq_index;
        while ((flag_ccb = readl(&reg->done_qbuffer[index])) != 0) {
                writel(0, &reg->done_qbuffer[index]);
-               pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb << 5));/*frame must be 32 bytes aligned*/
-               pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
-               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
+               pARCMSR_CDB = (struct ARCMSR_CDB *)
+                       (acb->vir2phy_offset + (flag_ccb << 5));
+               pCCB = container_of(pARCMSR_CDB,
+                       struct CommandControlBlock, arcmsr_cdb);
+               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0)
+                       ? true : false;
                arcmsr_drain_donequeue(acb, pCCB, error);
                index++;
                index %= ARCMSR_MAX_HBB_POSTQUEUE;
@@ -1509,175 +1518,160 @@ static void arcmsr_hbb_postqueue_isr(str
        }
 }
 
-static void arcmsr_hbc_postqueue_isr(struct AdapterControlBlock *acb)
+static void
+arcmsr_hbaC_postqueue_isr(struct AdapterControlBlock *acb)
 {
-       struct MessageUnit_C *phbcmu;
-       struct ARCMSR_CDB *arcmsr_cdb;
-       struct CommandControlBlock *ccb;
        uint32_t flag_ccb, ccb_cdb_phy, throttling = 0;
        int error;
+       struct MessageUnit_C __iomem *phbcmu;
+       struct ARCMSR_CDB *arcmsr_cdb;
+       struct CommandControlBlock *ccb;
 
-       phbcmu = (struct MessageUnit_C *)acb->pmuC;
+       phbcmu = acb->pmuC;
        /* areca cdb command done */
        /* Use correct offset and size for syncing */
-
-       while (readl(&phbcmu->host_int_status) &
-       ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR){
-       /* check if command done with no error*/
-       flag_ccb = readl(&phbcmu->outbound_queueport_low);
-       ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);/*frame must be 32 bytes aligned*/
-       arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset + ccb_cdb_phy);
-       ccb = container_of(arcmsr_cdb, struct CommandControlBlock, arcmsr_cdb);
-       error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
-       /* check if command done with no error */
-       arcmsr_drain_donequeue(acb, ccb, error);
-       if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
-               writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING, &phbcmu->inbound_doorbell);
-               break;
-       }
-       throttling++;
-       }
+       do {
+               /* check if command done with no error*/
+               flag_ccb = readl(&phbcmu->outbound_queueport_low);
+               ccb_cdb_phy = (flag_ccb & 0xFFFFFFF0);
+               arcmsr_cdb = (struct ARCMSR_CDB *)(acb->vir2phy_offset
+                       + ccb_cdb_phy);
+               ccb = container_of(arcmsr_cdb, struct CommandControlBlock,
+                       arcmsr_cdb);
+               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE1)
+                       ? true : false;
+               /* check if command done with no error */
+               arcmsr_drain_donequeue(acb, ccb, error);
+               throttling++;
+               if (throttling == ARCMSR_HBC_ISR_THROTTLING_LEVEL) {
+                       writel(ARCMSR_HBCMU_DRV2IOP_POSTQUEUE_THROTTLING,
+                               &phbcmu->inbound_doorbell);
+                       throttling = 0;
+               }
+       } while (readl(&phbcmu->host_int_status) &
+               ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR);
 }
-/*
-**********************************************************************************
-** Handle a message interrupt
-**
-** The only message interrupt we expect is in response to a query for the current adapter config.  
-** We want this in order to compare the drivemap so that we can detect newly-attached drives.
-**********************************************************************************
-*/
-static void arcmsr_hba_message_isr(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaA_message_isr(struct AdapterControlBlock *acb)
 {
-       struct MessageUnit_A *reg  = acb->pmuA;
+       struct MessageUnit_A __iomem *reg  = acb->pmuA;
        /*clear interrupt and message state*/
        writel(ARCMSR_MU_OUTBOUND_MESSAGE0_INT, &reg->outbound_intstatus);
        schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
-static void arcmsr_hbb_message_isr(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaB_message_isr(struct AdapterControlBlock *acb)
 {
        struct MessageUnit_B *reg  = acb->pmuB;
-
        /*clear interrupt and message state*/
        writel(ARCMSR_MESSAGE_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
        schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
-/*
-**********************************************************************************
-** Handle a message interrupt
-**
-** The only message interrupt we expect is in response to a query for the
-** current adapter config.
-** We want this in order to compare the drivemap so that we can detect newly-attached drives.
-**********************************************************************************
-*/
-static void arcmsr_hbc_message_isr(struct AdapterControlBlock *acb)
+
+static void
+arcmsr_hbaC_message_isr(struct AdapterControlBlock *acb)
 {
-       struct MessageUnit_C *reg  = acb->pmuC;
+       struct MessageUnit_C __iomem *reg  = acb->pmuC;
        /*clear interrupt and message state*/
-       writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR, &reg->outbound_doorbell_clear);
+       writel(ARCMSR_HBCMU_IOP2DRV_MESSAGE_CMD_DONE_DOORBELL_CLEAR,
+               &reg->outbound_doorbell_clear);
        schedule_work(&acb->arcmsr_do_message_isr_bh);
 }
 
-static int arcmsr_handle_hba_isr(struct AdapterControlBlock *acb)
+static irqreturn_t
+arcmsr_hbaA_handle_isr(struct AdapterControlBlock *acb)
 {
        uint32_t outbound_intstatus;
        struct MessageUnit_A __iomem *reg = acb->pmuA;
        outbound_intstatus = readl(&reg->outbound_intstatus) &
                acb->outbound_int_enable;
-       if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))      {
-               return 1;
-       }
-       writel(outbound_intstatus, &reg->outbound_intstatus);
-       if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)       {
-               arcmsr_hba_doorbell_isr(acb);
-       }
-       if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT) {
-               arcmsr_hba_postqueue_isr(acb);
-       }
-       if(outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)        {
-               /* messenger of "driver to iop commands" */
-               arcmsr_hba_message_isr(acb);
-       }
-       return 0;
+       if (!(outbound_intstatus & ARCMSR_MU_OUTBOUND_HANDLE_INT))
+               return IRQ_NONE;
+       do {
+               writel(outbound_intstatus, &reg->outbound_intstatus);
+               if (outbound_intstatus & ARCMSR_MU_OUTBOUND_DOORBELL_INT)
+                       arcmsr_hbaA_doorbell_isr(acb);
+               if (outbound_intstatus & ARCMSR_MU_OUTBOUND_POSTQUEUE_INT)
+                       arcmsr_hbaA_postqueue_isr(acb);
+               if (outbound_intstatus & ARCMSR_MU_OUTBOUND_MESSAGE0_INT)
+                       arcmsr_hbaA_message_isr(acb);
+               outbound_intstatus = readl(&reg->outbound_intstatus) &
+                       acb->outbound_int_enable;
+       } while (outbound_intstatus & (ARCMSR_MU_OUTBOUND_DOORBELL_INT
+               | ARCMSR_MU_OUTBOUND_POSTQUEUE_INT
+               | ARCMSR_MU_OUTBOUND_MESSAGE0_INT));
+       return IRQ_HANDLED;
 }
 
-static int arcmsr_handle_hbb_isr(struct AdapterControlBlock *acb)
+static irqreturn_t
+arcmsr_hbaB_handle_isr(struct AdapterControlBlock *acb)
 {
        uint32_t outbound_doorbell;
        struct MessageUnit_B *reg = acb->pmuB;
        outbound_doorbell = readl(reg->iop2drv_doorbell) &
-                               acb->outbound_int_enable;
+               acb->outbound_int_enable;
        if (!outbound_doorbell)
-               return 1;
-
-       writel(~outbound_doorbell, reg->iop2drv_doorbell);
-       /*in case the last action of doorbell interrupt clearance is cached,
-       this action can push HW to write down the clear bit*/
-       readl(reg->iop2drv_doorbell);
-       writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
-       if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK) {
-               arcmsr_iop2drv_data_wrote_handle(acb);
-       }
-       if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK) {
-               arcmsr_iop2drv_data_read_handle(acb);
-       }
-       if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE) {
-               arcmsr_hbb_postqueue_isr(acb);
-       }
-       if(outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE) {
-               /* messenger of "driver to iop commands" */
-               arcmsr_hbb_message_isr(acb);
-       }
-       return 0;
+               return IRQ_NONE;
+       do {
+               writel(~outbound_doorbell, reg->iop2drv_doorbell);
+               writel(ARCMSR_DRV2IOP_END_OF_INTERRUPT, reg->drv2iop_doorbell);
+               if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_WRITE_OK)
+                       arcmsr_iop2drv_data_wrote_handle(acb);
+               if (outbound_doorbell & ARCMSR_IOP2DRV_DATA_READ_OK)
+                       arcmsr_iop2drv_data_read_handle(acb);
+               if (outbound_doorbell & ARCMSR_IOP2DRV_CDB_DONE)
+                       arcmsr_hbaB_postqueue_isr(acb);
+               if (outbound_doorbell & ARCMSR_IOP2DRV_MESSAGE_CMD_DONE)
+                       arcmsr_hbaB_message_isr(acb);
+               outbound_doorbell = readl(reg->iop2drv_doorbell) &
+                       acb->outbound_int_enable;
+       } while (outbound_doorbell & (ARCMSR_IOP2DRV_DATA_WRITE_OK
+               | ARCMSR_IOP2DRV_DATA_READ_OK
+               | ARCMSR_IOP2DRV_CDB_DONE
+               | ARCMSR_IOP2DRV_MESSAGE_CMD_DONE));
+       return IRQ_HANDLED;
 }
 
-static int arcmsr_handle_hbc_isr(struct AdapterControlBlock *pACB)
+static irqreturn_t
+arcmsr_hbaC_handle_isr(struct AdapterControlBlock *pACB)
 {
        uint32_t host_interrupt_status;
-       struct MessageUnit_C *phbcmu = (struct MessageUnit_C *)pACB->pmuC;
-       /*
-       *********************************************
-       **   check outbound intstatus
-       *********************************************
-       */
-       host_interrupt_status = readl(&phbcmu->host_int_status);
-       if (!host_interrupt_status) {
-               /*it must be share irq*/
-               return 1;
-       }
-       /* MU ioctl transfer doorbell interrupts*/
-       if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR) {
-               arcmsr_hbc_doorbell_isr(pACB);   /* messenger of "ioctl message read write" */
-       }
-       /* MU post queue interrupts*/
-       if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR) {
-               arcmsr_hbc_postqueue_isr(pACB);  /* messenger of "scsi commands" */
-       }
-       return 0;
+       struct MessageUnit_C __iomem *phbcmu = pACB->pmuC;
+       host_interrupt_status = readl(&phbcmu->host_int_status) &
+               (ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR |
+               ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR);
+       if (!host_interrupt_status)
+               return IRQ_NONE;
+       do {
+               if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR)
+                       arcmsr_hbaC_doorbell_isr(pACB);
+               /* MU post queue interrupts*/
+               if (host_interrupt_status & ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR)
+                       arcmsr_hbaC_postqueue_isr(pACB);
+               host_interrupt_status = readl(&phbcmu->host_int_status);
+       } while (host_interrupt_status & (ARCMSR_HBCMU_OUTBOUND_POSTQUEUE_ISR |
+               ARCMSR_HBCMU_OUTBOUND_DOORBELL_ISR));
+       return IRQ_HANDLED;
 }
-static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
+
+static irqreturn_t
+arcmsr_interrupt(struct AdapterControlBlock *acb)
 {
        switch (acb->adapter_type) {
-       case ACB_ADAPTER_TYPE_A: {
-               if (arcmsr_handle_hba_isr(acb)) {
-                       return IRQ_NONE;
-               }
-               }
+       case ACB_ADAPTER_TYPE_A:
+               return arcmsr_hbaA_handle_isr(acb);
                break;
-
-       case ACB_ADAPTER_TYPE_B: {
-               if (arcmsr_handle_hbb_isr(acb)) {
-                       return IRQ_NONE;
-               }
-               }
+       case ACB_ADAPTER_TYPE_B:
+               return arcmsr_hbaB_handle_isr(acb);
                break;
-        case ACB_ADAPTER_TYPE_C: {
-               if (arcmsr_handle_hbc_isr(acb)) {
-                       return IRQ_NONE;
-               }
-               }
+       case ACB_ADAPTER_TYPE_C:
+               return arcmsr_hbaC_handle_isr(acb);
+               break;
+       default:
+               return IRQ_NONE;
        }
-       return IRQ_HANDLED;
 }
 
 static void arcmsr_iop_parking(struct AdapterControlBlock *acb) 		 	   		  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
