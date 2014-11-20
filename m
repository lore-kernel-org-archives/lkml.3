Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbaKTHNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:13:45 -0500
Received: from exprod7og119.obsmtp.com ([64.18.2.16]:50117 "EHLO
	exprod7og119.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893AbaKTHNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:13:42 -0500
From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
X-Google-Original-From: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        JBottomley@Parallels.com, Sathya.Prakash@avagotech.com,
        Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org,
        Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Subject: [PATCH 06/22] [SCSI] mpt2sas, mpt3sas: Removing uppper boundary restriction for the module parameter max_sgl_entries
Date: Thu, 20 Nov 2014 12:35:39 +0530
Message-Id: <1416467155-16869-7-git-send-email-Sreekanth.Reddy@avagotech.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Removed the upper boundary restriction for the module parameter max_sgl_entries. Earlier, the max_sgl_entries was capped at the SCSI_MAX_SG_SEGMENTS kernel definition. With this change, the user would be able to set the max_sgl_entries to any value.
2. Added a print for the message log whenever the user sets the max_sgl_entries to a value greater than SCSI_MAX_SG_SEGMENTS to warn about the kernel definition overriding.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 9 ++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 5 ++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 13d1d5b..adb99e5 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -2492,9 +2492,12 @@ _base_allocate_memory_pools(struct MPT2SAS_ADAPTER *ioc,  int sleep_flag)
 
 	/* command line tunables  for max sgl entries */
 	if (max_sgl_entries != -1) {
-		ioc->shost->sg_tablesize = (max_sgl_entries <
-		    MPT2SAS_SG_DEPTH) ? max_sgl_entries :
-		    MPT2SAS_SG_DEPTH;
+		if (max_sgl_entries > MPT2SAS_SG_DEPTH)
+			printk(MPT2SAS_WARN_FMT
+			 "setting max_sgl_entries(%d), overriding kernel"
+			 " defined SCSI_MAX_SG_SEGMENTS(%d)\n", ioc->name,
+			  max_sgl_entries, MPT2SAS_SG_DEPTH);
+		ioc->shost->sg_tablesize = max_sgl_entries;
 	} else {
 		ioc->shost->sg_tablesize = MPT2SAS_SG_DEPTH;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f1918cf..35d4780 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2667,7 +2667,10 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 	if (sg_tablesize < MPT3SAS_MIN_PHYS_SEGMENTS)
 		sg_tablesize = MPT3SAS_MIN_PHYS_SEGMENTS;
 	else if (sg_tablesize > MPT3SAS_MAX_PHYS_SEGMENTS)
-		sg_tablesize = MPT3SAS_MAX_PHYS_SEGMENTS;
+		pr_warn(MPT3SAS_FMT
+		 "setting max_sgl_entries(%d), overriding kernel"
+		 " defined SCSI_MAX_SG_SEGMENTS(%d)\n", ioc->name,
+		 max_sgl_entries, MPT3SAS_MAX_PHYS_SEGMENTS);
 	ioc->shost->sg_tablesize = sg_tablesize;
 
 	ioc->hi_priority_depth = facts->HighPriorityCredit;
-- 
2.0.2

