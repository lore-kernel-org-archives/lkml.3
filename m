Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbaCNQOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:14:30 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:31405
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755798AbaCNQO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:14:27 -0400
Date: Fri, 14 Mar 2014 21:39:58 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 1/9][SCSI]mpt3sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
Message-ID: <20140314160958.GA8350@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(87266001)(74876001)(85306002)(87936001)(74706001)(81542001)(33656001)(50466002)(81342001)(69226001)(31966008)(74366001)(92726001)(54356001)(53806001)(51856001)(23726002)(46406003)(56776001)(76796001)(83322001)(19580395003)(94316002)(6806004)(44976005)(80976001)(19580405001)(81686001)(63696002)(47776003)(20776003)(36756003)(65816001)(93516002)(86362001)(80022001)(59766001)(93136001)(77982001)(54316002)(95416001)(85852003)(95666003)(97186001)(81816001)(83072002)(47446002)(97336001)(77096001)(56816005)(47976001)(79102001)(83506001)(74662001)(76786001)(46102001)(92566001)(76482001)(74502001)(16796002)(97756001)(47736001)(90146001)(4396001)(57986002)(94946001)(50986001)(76176001)(49866001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB068;H:COSEXCH10.lsi.com;FPR:FAC0F748.3C2BE62C.C6E1D6EF.101692F1.2041E;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new mpt3sas driver module parameter 'disable_eedp' is added to Disable
EEDP support. By default DIF support is enabled in the driver and
this module parameter would allow users to turn it off.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |   38 ++++++++++++++++-------------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   45 ++++++++++++++++++++++-----------
 3 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 0cf4f70..d46956e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -429,13 +429,16 @@ _base_sas_ioc_info(struct MPT3SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
 ****************************************************************************/
 
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
-		desc = "eedp guard error";
+		if (!ioc->disable_eedp_support)
+			desc = "eedp guard error";
 		break;
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
-		desc = "eedp ref tag error";
+		if (!ioc->disable_eedp_support)
+			desc = "eedp ref tag error";
 		break;
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
-		desc = "eedp app tag error";
+		if (!ioc->disable_eedp_support)
+			desc = "eedp app tag error";
 		break;
 
 /****************************************************************************
@@ -2429,21 +2432,22 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->ir_firmware)
 		mpt3sas_config_get_manufacturing_pg10(ioc, &mpi_reply,
 		    &ioc->manu_pg10);
-
-	/*
-	 * Ensure correct T10 PI operation if vendor left EEDPTagMode
-	 * flag unset in NVDATA.
-	 */
-	mpt3sas_config_get_manufacturing_pg11(ioc, &mpi_reply, &ioc->manu_pg11);
-	if (ioc->manu_pg11.EEDPTagMode == 0) {
-		pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
-		    ioc->name);
-		ioc->manu_pg11.EEDPTagMode &= ~0x3;
-		ioc->manu_pg11.EEDPTagMode |= 0x1;
-		mpt3sas_config_set_manufacturing_pg11(ioc, &mpi_reply,
-		    &ioc->manu_pg11);
+	if (!ioc->disable_eedp_support) {
+		/*
+		 * Ensure correct T10 PI operation if vendor left EEDPTagMode
+		 * flag unset in NVDATA.
+		 */
+		mpt3sas_config_get_manufacturing_pg11(ioc, &mpi_reply,
+							&ioc->manu_pg11);
+		if (ioc->manu_pg11.EEDPTagMode == 0) {
+			pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
+			ioc->name);
+			ioc->manu_pg11.EEDPTagMode &= ~0x3;
+			ioc->manu_pg11.EEDPTagMode |= 0x1;
+			mpt3sas_config_set_manufacturing_pg11(ioc, &mpi_reply,
+			    &ioc->manu_pg11);
+		}
 	}
-
 	mpt3sas_config_get_bios_pg2(ioc, &mpi_reply, &ioc->bios_pg2);
 	mpt3sas_config_get_bios_pg3(ioc, &mpi_reply, &ioc->bios_pg3);
 	mpt3sas_config_get_ioc_pg8(ioc, &mpi_reply, &ioc->ioc_pg8);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 0ebf5d9..b1494ce 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -791,6 +791,7 @@ struct MPT3SAS_ADAPTER {
 	u32		event_context;
 	void		*event_log;
 	u32		event_masks[MPI2_EVENT_NOTIFY_EVENTMASK_WORDS];
+	u8              disable_eedp_support;
 
 	/* static config pages */
 	struct mpt3sas_facts facts;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a961fe1..1056cbf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -116,7 +116,10 @@ static int max_lun = MPT3SAS_MAX_LUN;
 module_param(max_lun, int, 0);
 MODULE_PARM_DESC(max_lun, " max lun, default=16895 ");
 
-
+/* Enable or disable EEDP support */
+static int disable_eedp;
+module_param(disable_eedp, uint, 0);
+MODULE_PARM_DESC(disable_eedp, " disable EEDP support: (default=0)");
 
 
 /* diag_buffer_enable is bitwise
@@ -3614,7 +3617,8 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	}
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	memset(mpi_request, 0, sizeof(Mpi2SCSIIORequest_t));
-	_scsih_setup_eedp(ioc, scmd, mpi_request);
+	if (!ioc->disable_eedp_support)
+		_scsih_setup_eedp(ioc, scmd, mpi_request);
 
 	if (scmd->cmd_len == 32)
 		mpi_control |= 4 << MPI2_SCSIIO_CONTROL_ADDCDBLEN_SHIFT;
@@ -3769,14 +3773,21 @@ _scsih_scsi_ioc_info(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 		desc_ioc_state = "scsi ext terminated";
 		break;
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
-		desc_ioc_state = "eedp guard error";
-		break;
+		if (!ioc->disable_eedp_support) {
+			desc_ioc_state = "eedp guard error";
+			break;
+		}
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
-		desc_ioc_state = "eedp ref tag error";
-		break;
+		if (!ioc->disable_eedp_support) {
+			desc_ioc_state = "eedp ref tag error";
+			break;
+		}
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
-		desc_ioc_state = "eedp app tag error";
-		break;
+		if (!ioc->disable_eedp_support) {
+			desc_ioc_state = "eedp app tag error";
+			break;
+		}
+
 	default:
 		desc_ioc_state = "unknown";
 		break;
@@ -4191,8 +4202,10 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
+	if (!ioc->disable_eedp_support) {
 		_scsih_eedp_error_handling(scmd, ioc_status);
 		break;
+	}
 
 	case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
 	case MPI2_IOCSTATUS_INVALID_FUNCTION:
@@ -7814,16 +7827,18 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_add_shost_fail;
 	}
 
-	/* register EEDP capabilities with SCSI layer */
-	if (prot_mask > 0)
-		scsi_host_set_prot(shost, prot_mask);
-	else
-		scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
+	ioc->disable_eedp_support = disable_eedp;
+	if (!ioc->disable_eedp_support) {
+		/* register EEDP capabilities with SCSI layer */
+		if (prot_mask > 0)
+			scsi_host_set_prot(shost, prot_mask);
+		else
+			scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
 				   | SHOST_DIF_TYPE2_PROTECTION
 				   | SHOST_DIF_TYPE3_PROTECTION);
 
-	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
-
+		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+	}
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
 	    "fw_event%d", ioc->id);
-- 
1.7.1

