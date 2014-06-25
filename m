Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669AbaFYKoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:44:03 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:51120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756376AbaFYKn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:43:58 -0400
Date: Wed, 25 Jun 2014 16:09:30 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [RESEND][PATCH 2/8][SCSI]mpt3sas: Clear PFA Status on SGPIO when PFA
 Drive is Removed or Replaced
Message-ID: <20140625103930.GA13003@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481666350530242;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(50466002)(64706001)(86362001)(81342001)(21056001)(83322001)(4396001)(23726002)(31966008)(81542001)(16796002)(74662001)(50986999)(92726001)(107046001)(47776003)(20776003)(19580405001)(77096002)(99396002)(26826002)(85306003)(33656002)(95666004)(92566001)(102836001)(46406003)(83072002)(87936001)(85852003)(79102001)(46102001)(44976005)(19580395003)(105596002)(57986006)(36756003)(76506005)(6806004)(74502001)(54356999)(97756001)(83506001)(80022001)(77982001)(106466001)(76482001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR07MB485;H:COSEXCH10.lsi.com;FPR:;MLV:ovrnspm;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added code to send an SEP message that turns off the Predictive
Failure LED when a drive is removed (if Predictive Failure LED was turned on).

Added a new flag 'pfa_led_on' per device that tracks the status of Predictive
Failure LED. When the drive is removed, this flag is checked and
sends an SEP message to turn off the respective Predictive Failure LED.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    5 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   67 +++++++++++++++++++++++++++++-----
 2 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index b1494ce..3007521 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -272,8 +272,10 @@ struct _internal_cmd {
  * @channel: target channel
  * @slot: number number
  * @phy: phy identifier provided in sas device page 0
- * @fast_path: fast path feature enable bit
  * @responding: used in _scsih_sas_device_mark_responding
+ * @fast_path: fast path feature enable bit
+ * @pfa_led_on: flag for PFA LED status
+ *
  */
 struct _sas_device {
 	struct list_head list;
@@ -293,6 +295,7 @@ struct _sas_device {
 	u8	phy;
 	u8	responding;
 	u8	fast_path;
+	u8	pfa_led_on;
 };
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 1056cbf..905c82c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -162,7 +162,7 @@ struct sense_info {
 };
 
 #define MPT3SAS_PROCESS_TRIGGER_DIAG (0xFFFB)
-#define MPT3SAS_TURN_ON_FAULT_LED (0xFFFC)
+#define MPT3SAS_TURN_ON_PFA_LED (0xFFFC)
 #define MPT3SAS_PORT_ENABLE_COMPLETE (0xFFFD)
 #define MPT3SAS_ABRT_TASK_SET (0xFFFE)
 #define MPT3SAS_REMOVE_UNRESPONDING_DEVICES (0xFFFF)
@@ -3903,7 +3903,7 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 #endif
 
 /**
- * _scsih_turn_on_fault_led - illuminate Fault LED
+ * _scsih_turn_on_pfa_led - illuminate PFA LED
  * @ioc: per adapter object
  * @handle: device handle
  * Context: process
@@ -3911,10 +3911,15 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
  * Return nothing.
  */
 static void
-_scsih_turn_on_fault_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+_scsih_turn_on_pfa_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 {
 	Mpi2SepReply_t mpi_reply;
 	Mpi2SepRequest_t mpi_request;
+	struct _sas_device *sas_device;
+
+	sas_device = _scsih_sas_device_find_by_handle(ioc, handle);
+	if (!sas_device)
+		return;
 
 	memset(&mpi_request, 0, sizeof(Mpi2SepRequest_t));
 	mpi_request.Function = MPI2_FUNCTION_SCSI_ENCLOSURE_PROCESSOR;
@@ -3929,6 +3934,7 @@ _scsih_turn_on_fault_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		__FILE__, __LINE__, __func__);
 		return;
 	}
+	sas_device->pfa_led_on = 1;
 
 	if (mpi_reply.IOCStatus || mpi_reply.IOCLogInfo) {
 		dewtprintk(ioc, pr_info(MPT3SAS_FMT
@@ -3938,9 +3944,46 @@ _scsih_turn_on_fault_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 		return;
 	}
 }
+/**
+ * _scsih_turn_off_pfa_led - turn off Fault LED
+ * @ioc: per adapter object
+ * @sas_device: sas device whose PFA LED has to turned off
+ * Context: process
+ *
+ * Return nothing.
+ */
+static void
+_scsih_turn_off_pfa_led(struct MPT3SAS_ADAPTER *ioc,
+	struct _sas_device *sas_device)
+{
+	Mpi2SepReply_t mpi_reply;
+	Mpi2SepRequest_t mpi_request;
 
+	memset(&mpi_request, 0, sizeof(Mpi2SepRequest_t));
+	mpi_request.Function = MPI2_FUNCTION_SCSI_ENCLOSURE_PROCESSOR;
+	mpi_request.Action = MPI2_SEP_REQ_ACTION_WRITE_STATUS;
+	mpi_request.SlotStatus = 0;
+	mpi_request.Slot = cpu_to_le16(sas_device->slot);
+	mpi_request.DevHandle = 0;
+	mpi_request.EnclosureHandle = cpu_to_le16(sas_device->enclosure_handle);
+	mpi_request.Flags = MPI2_SEP_REQ_FLAGS_ENCLOSURE_SLOT_ADDRESS;
+	if ((mpt3sas_base_scsi_enclosure_processor(ioc, &mpi_reply,
+		&mpi_request)) != 0) {
+		printk(MPT3SAS_FMT "failure at %s:%d/%s()!\n", ioc->name,
+		__FILE__, __LINE__, __func__);
+		return;
+	}
+
+	if (mpi_reply.IOCStatus || mpi_reply.IOCLogInfo) {
+		dewtprintk(ioc, printk(MPT3SAS_FMT
+		 "enclosure_processor: ioc_status (0x%04x), loginfo(0x%08x)\n",
+		 ioc->name, le16_to_cpu(mpi_reply.IOCStatus),
+		 le32_to_cpu(mpi_reply.IOCLogInfo)));
+		return;
+	}
+}
 /**
- * _scsih_send_event_to_turn_on_fault_led - fire delayed event
+ * _scsih_send_event_to_turn_on_pfa_led - fire delayed event
  * @ioc: per adapter object
  * @handle: device handle
  * Context: interrupt.
@@ -3948,14 +3991,14 @@ _scsih_turn_on_fault_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
  * Return nothing.
  */
 static void
-_scsih_send_event_to_turn_on_fault_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
+_scsih_send_event_to_turn_on_pfa_led(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 {
 	struct fw_event_work *fw_event;
 
 	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
 	if (!fw_event)
 		return;
-	fw_event->event = MPT3SAS_TURN_ON_FAULT_LED;
+	fw_event->event = MPT3SAS_TURN_ON_PFA_LED;
 	fw_event->device_handle = handle;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
@@ -3999,7 +4042,7 @@ _scsih_smart_predicted_fault(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
 
 	if (ioc->pdev->subsystem_vendor == PCI_VENDOR_ID_IBM)
-		_scsih_send_event_to_turn_on_fault_led(ioc, handle);
+		_scsih_send_event_to_turn_on_pfa_led(ioc, handle);
 
 	/* insert into event log */
 	sz = offsetof(Mpi2EventNotificationReply_t, EventData) +
@@ -4931,7 +4974,11 @@ _scsih_remove_device(struct MPT3SAS_ADAPTER *ioc,
 {
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 
-
+	if ((ioc->pdev->subsystem_vendor == PCI_VENDOR_ID_IBM) &&
+	     (sas_device->pfa_led_on)) {
+		_scsih_turn_off_pfa_led(ioc, sas_device);
+		sas_device->pfa_led_on = 0;
+	}
 	dewtprintk(ioc, pr_info(MPT3SAS_FMT
 		"%s: enter: handle(0x%04x), sas_addr(0x%016llx)\n",
 		ioc->name, __func__,
@@ -7070,8 +7117,8 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 			"port enable: complete from worker thread\n",
 			ioc->name));
 		break;
-	case MPT3SAS_TURN_ON_FAULT_LED:
-		_scsih_turn_on_fault_led(ioc, fw_event->device_handle);
+	case MPT3SAS_TURN_ON_PFA_LED:
+		_scsih_turn_on_pfa_led(ioc, fw_event->device_handle);
 		break;
 	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
 		_scsih_sas_topology_change_event(ioc, fw_event);
-- 
1.7.1

