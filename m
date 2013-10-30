Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3J3Q1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab3J3Q1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:33 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 03/12] sb_edac: isolate TOLM retrieval
Date: Wed, 30 Oct 2013 12:26:57 -0400
Message-Id: <1383150426-24730-4-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for the Ivy Bridge support.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 466c313..3e4837f 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -256,9 +256,11 @@ static const u32 correrrthrsld[] = {
 #define NUM_CHANNELS	4
 #define MAX_DIMMS	3		/* Max DIMMS per channel */
 
+struct sbridge_pvt;
 struct sbridge_info {
 	u32	mcmtr;
 	u32	rankcfgr;
+	u64	(*get_tolm)(struct sbridge_pvt *pvt);
 };
 
 struct sbridge_channel {
@@ -442,6 +444,15 @@ static void free_sbridge_dev(struct sbridge_dev *sbridge_dev)
 	kfree(sbridge_dev);
 }
 
+static u64 sbridge_get_tolm(struct sbridge_pvt *pvt)
+{
+	u32 reg;
+
+	/* Address range is 32:28 */
+	pci_read_config_dword(pvt->pci_sad1, TOLM, &reg);
+	return GET_TOLM(reg);
+}
+
 /****************************************************************************
 			Memory check routines
  ****************************************************************************/
@@ -616,10 +627,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	 * Step 1) Get TOLM/TOHM ranges
 	 */
 
-	/* Address range is 32:28 */
-	pci_read_config_dword(pvt->pci_sad1, TOLM,
-			      &reg);
-	pvt->tolm = GET_TOLM(reg);
+	pvt->tolm = pvt->info.get_tolm(pvt);
 	tmp_mb = (1 + pvt->tolm) >> 20;
 
 	mb = div_u64_rem(tmp_mb, 1000, &kb);
@@ -1644,6 +1652,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	mci->ctl_name = kasprintf(GFP_KERNEL, "Sandy Bridge Socket#%d", mci->mc_idx);
 	mci->dev_name = pci_name(sbridge_dev->pdev[0]);
 	mci->ctl_page_to_phys = NULL;
+	pvt->info.get_tolm = sbridge_get_tolm;
 
 	/* Set the function pointer to an actual operation function */
 	mci->edac_check = sbridge_check_error;
-- 
1.7.1

