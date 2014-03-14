Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbaCNPks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:40:48 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:5408
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113AbaCNPko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:40:44 -0400
Date: Fri, 14 Mar 2014 21:06:22 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter
 disable_eedp to Disable EEDP Support
Message-ID: <20140314153622.GA7947@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(59766001)(80022001)(575784001)(93136001)(77982001)(65816001)(93516002)(86362001)(97186001)(83072002)(81816001)(95416001)(54316002)(95666003)(85852003)(83322001)(19580395003)(6806004)(94316002)(44976005)(46406003)(23726002)(76796001)(56776001)(63696002)(20776003)(36756003)(47776003)(81686001)(19580405001)(80976001)(97756001)(94946001)(76176001)(49866001)(50986001)(47736001)(4396001)(57986002)(90146001)(83506001)(74662001)(79102001)(47976001)(97336001)(47446002)(77096001)(56816005)(16796002)(74502001)(46102001)(76786001)(76482001)(92566001)(87936001)(81542001)(74706001)(87266001)(85306002)(74876001)(69226001)(81342001)(54356001)(53806001)(51856001)(74366001)(31966008)(92726001)(50466002)(33656001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR07MB068;H:COSEXCH10.lsi.com;FPR:AED1F569.2C07F40D.E6EDD1FF.1C168242.203B6;PTR:cosexch10.lsi.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A new mpt2sas driver module parameter 'disable_eedp' is added to Disable
EEDP support. By default DIF support is enabled in the driver and
this module parameter would allow users to turn it off.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c  |    9 ++++--
 drivers/scsi/mpt2sas/mpt2sas_base.h  |    1 +
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   47 +++++++++++++++++++++++-----------
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ed810fb..7355b28 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -440,13 +440,16 @@ _base_sas_ioc_info(struct MPT2SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
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
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 1f2ac3a..61b02ee 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -842,6 +842,7 @@ struct MPT2SAS_ADAPTER {
 	u32		ioc_reset_count;
 	MPT2SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
 	u32             non_operational_loop;
+	u8      disable_eedp_support;
 
 	/* internal commands, callback index */
 	u8		scsi_io_cb_idx;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 7f0af4f..d502728 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -127,6 +127,11 @@ static int disable_discovery = -1;
 module_param(disable_discovery, int, 0);
 MODULE_PARM_DESC(disable_discovery, " disable discovery ");
 
+/* Enable or disable EEDP support */
+static int disable_eedp;
+module_param(disable_eedp, uint, 0);
+MODULE_PARM_DESC(disable_eedp, " disable EEDP support: (default=0)");
+
 /* permit overriding the host protection capabilities mask (EEDP/T10 PI) */
 static int prot_mask = 0;
 module_param(prot_mask, int, 0);
@@ -4031,7 +4036,8 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	}
 	mpi_request = mpt2sas_base_get_msg_frame(ioc, smid);
 	memset(mpi_request, 0, sizeof(Mpi2SCSIIORequest_t));
-	_scsih_setup_eedp(scmd, mpi_request);
+	if (!ioc->disable_eedp_support)
+		_scsih_setup_eedp(scmd, mpi_request);
 	if (scmd->cmd_len == 32)
 		mpi_control |= 4 << MPI2_SCSIIO_CONTROL_ADDCDBLEN_SHIFT;
 	mpi_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
@@ -4196,14 +4202,20 @@ _scsih_scsi_ioc_info(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
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
 	default:
 		desc_ioc_state = "unknown";
 		break;
@@ -4625,8 +4637,10 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	case MPI2_IOCSTATUS_EEDP_GUARD_ERROR:
 	case MPI2_IOCSTATUS_EEDP_REF_TAG_ERROR:
 	case MPI2_IOCSTATUS_EEDP_APP_TAG_ERROR:
-		_scsih_eedp_error_handling(scmd, ioc_status);
-		break;
+		if (!ioc->disable_eedp_support) {
+			_scsih_eedp_error_handling(scmd, ioc_status);
+			break;
+		}
 	case MPI2_IOCSTATUS_SCSI_PROTOCOL_ERROR:
 	case MPI2_IOCSTATUS_INVALID_FUNCTION:
 	case MPI2_IOCSTATUS_INVALID_SGL:
@@ -8213,15 +8227,18 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_add_shost_fail;
 	}
 
-	/* register EEDP capabilities with SCSI layer */
-	if (prot_mask)
-		scsi_host_set_prot(shost, prot_mask);
-	else
-		scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
+	ioc->disable_eedp_support = disable_eedp;
+	if (!ioc->disable_eedp_support) {
+		/* register EEDP capabilities with SCSI layer */
+		if (prot_mask)
+			scsi_host_set_prot(shost, prot_mask);
+		else
+			scsi_host_set_prot(shost, SHOST_DIF_TYPE1_PROTECTION
 				   | SHOST_DIF_TYPE2_PROTECTION
 				   | SHOST_DIF_TYPE3_PROTECTION);
 
-	scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+		scsi_host_set_guard(shost, SHOST_DIX_GUARD_CRC);
+	}
 
 	/* event thread */
 	snprintf(ioc->firmware_event_name, sizeof(ioc->firmware_event_name),
-- 
1.7.1

