Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbaISGsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 02:48:12 -0400
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:53134 "EHLO
	exprod7og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaISGsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 02:48:11 -0400
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
X-Google-Original-From: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        JBottomley@Parallels.com, Sathya.Prakash@avagotech.com,
        Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Subject: [PATCH][SCSI] mpt2sas: fix undefined reference to `__udivdi3' compilation errors
Date: Fri, 19 Sep 2014 12:17:27 +0530
Message-Id: <1411109247-18184-1-git-send-email-Sreekanth.Reddy@avagotech.com>
X-Mailer: git-send-email 2.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will fix the below compilation errors on i386 ARCH

drivers/built-in.o: In function `_scsih_qcmd':
mpt2sas_scsih.c:(.text+0x1e7b56): undefined reference to `__udivdi3'
mpt2sas_scsih.c:(.text+0x1e7b8a): undefined reference to `__umoddi3'

Used sector_div() API to fix above compilation errors.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 992a224..c80ed04 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3860,7 +3860,7 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 	struct _raid_device *raid_device, Mpi2SCSIIORequest_t *mpi_request,
 	u16 smid)
 {
-	sector_t v_lba, p_lba, stripe_off, stripe_unit, column, io_size;
+	sector_t v_lba, p_lba, stripe_off, column, io_size;
 	u32 stripe_sz, stripe_exp;
 	u8 num_pds, cmd = scmd->cmnd[0];
 
@@ -3888,9 +3888,9 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 
 	num_pds = raid_device->num_pds;
 	p_lba = v_lba >> stripe_exp;
-	stripe_unit = p_lba / num_pds;
-	column = p_lba % num_pds;
-	p_lba = (stripe_unit << stripe_exp) + stripe_off;
+	column = sector_div(p_lba, num_pds);
+	p_lba = (p_lba << stripe_exp) + stripe_off;
+
 	mpi_request->DevHandle = cpu_to_le16(raid_device->pd_handle[column]);
 
 	if (cmd == READ_10 || cmd == WRITE_10)
-- 
2.0.2

