Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbaFYKiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:38:46 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:7380
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755910AbaFYKio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:38:44 -0400
Date: Wed, 25 Jun 2014 16:04:18 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [RESEND][PATCH 06/10][SCSI]mpt2sas: For >2TB volumes, DirectDrive
 support sends IO's with LBA bit 31 to IR FW instead of DirectDrive
Message-ID: <20140625103418.GA12939@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481663221366226;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(19580395003)(76506005)(102836001)(44976005)(57986006)(80022001)(64706001)(20776003)(54356999)(76482001)(46406003)(85306003)(26826002)(4396001)(47776003)(106466001)(95666004)(33656002)(74502001)(77096002)(23726002)(105596002)(81342001)(50986999)(79102001)(21056001)(86362001)(77982001)(16796002)(99396002)(97756001)(31966008)(85852003)(92566001)(92726001)(36756003)(19580405001)(83072002)(83322001)(81542001)(46102001)(74662001)(6806004)(83506001)(50466002)(87936001)(107046001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB484;H:COSEXCH10.lsi.com;FPR:;MLV:ovrnspm;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a down casting of the volume max LBA from a U64 to a U32,
which is taken out and now the max LBA is set appropriately to U64.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
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

