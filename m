Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaHAJbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:31:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbaHAJbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:31:00 -0400
From: Daniel Borkmann <dborkman@redhat.com>
To: hch@lst.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Bottomley <JBottomley@Parallels.com>,
        James Smart <james.smart@emulex.com>
Subject: [PATCH] random32: do not feed jiffies as seed from lpfc driver
Date: Fri,  1 Aug 2014 11:30:52 +0200
Message-Id: <1406885452-15659-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In prandom we have already reseeding mechanisms that trigger
periodically from a much better entropy source than just
feeding in jiffies through lpfc_mbx_cmpl_fcf_scan_read_fcf_rec()
[what a function name 8-)]. Therefore, just remove this.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2a17e31..5072bb2 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2146,7 +2146,6 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 	uint16_t fcf_index, next_fcf_index;
 	struct lpfc_fcf_rec *fcf_rec = NULL;
 	uint16_t vlan_id;
-	uint32_t seed;
 	bool select_new_fcf;
 	int rc;
 
@@ -2383,9 +2382,6 @@ lpfc_mbx_cmpl_fcf_scan_read_fcf_rec(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		phba->fcf.fcf_flag |= FCF_AVAILABLE;
 		/* Setup initial running random FCF selection count */
 		phba->fcf.eligible_fcf_cnt = 1;
-		/* Seeding the random number generator for random selection */
-		seed = (uint32_t)(0xFFFFFFFF & jiffies);
-		prandom_seed(seed);
 	}
 	spin_unlock_irq(&phba->hbalock);
 	goto read_next_fcf;
-- 
1.7.11.7

