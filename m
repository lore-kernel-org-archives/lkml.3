Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbaCNPqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:46:08 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:31222
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754136AbaCNPqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:46:06 -0400
Date: Fri, 14 Mar 2014 21:11:38 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 07/11][SCSI]mpt2sas: For >2TB volumes, DirectDrive support
 sends I/Os with LBA bit 31 to IR FW instead of DirectDrive
Message-ID: <20140314154138.GA8023@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(51856001)(44976005)(33656001)(56816005)(81542001)(54356001)(76176001)(36756003)(74706001)(87936001)(53806001)(57986002)(81342001)(6806004)(81816001)(90146001)(85852003)(83072002)(77982001)(77096001)(95416001)(76786001)(93136001)(19580405001)(47776003)(94316002)(47976001)(56776001)(76482001)(54316002)(80976001)(4396001)(23726002)(16796002)(93516002)(94946001)(92726001)(31966008)(74662001)(46102001)(87266001)(74502001)(47446002)(50466002)(69226001)(80022001)(74366001)(20776003)(46406003)(76796001)(59766001)(49866001)(97186001)(83322001)(95666003)(19580395003)(63696002)(83506001)(86362001)(50986001)(79102001)(85306002)(65816001)(92566001)(97756001)(97336001)(47736001)(74876001)(81686001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR07MB648;H:COSEXCH10.lsi.com;CLIP:192.19.220.100;FPR:DE6EB47C.BF926EFE.71C3E99F.B9369201.201EE;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a down casting of the volume max LBA from a U64 to a U32,
which is taken out and now the max LBA is set appropriately to U64.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6ae109b..4a0728a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3865,7 +3865,8 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
 	u16 smid)
 {
-	u32 v_lba, p_lba, stripe_off, stripe_unit, column, io_size;
+	u32 p_lba, stripe_off, stripe_unit, column, io_size;
+	u64 v_lba;
 	u32 stripe_sz, stripe_exp;
 	u8 num_pds, *cdb_ptr, i;
 	u8 cdb0 = scmd->cmnd[0];
@@ -3882,12 +3883,17 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 			| cdb_ptr[5])) {
 			io_size = scsi_bufflen(scmd) >>
 			    raid_device->block_exponent;
-			i = (cdb0 < READ_16) ? 2 : 6;
+
 			/* get virtual lba */
-			v_lba = be32_to_cpu(*(__be32 *)(&cdb_ptr[i]));
+			if (cdb0 < READ_16)
+				v_lba = be32_to_cpu(*(__be32 *)(&cdb_ptr[2]));
+			else
+				v_lba = be64_to_cpu(*(__be64 *)(&cdb_ptr[2]));
+
+			i = (cdb0 < READ_16) ? 2 : 6;
 
 			if (((u64)v_lba + (u64)io_size - 1) <=
-			    (u32)raid_device->max_lba) {
+				raid_device->max_lba) {
 				stripe_sz = raid_device->stripe_sz;
 				stripe_exp = raid_device->stripe_exponent;
 				stripe_off = v_lba & (stripe_sz - 1);
-- 
1.7.1

