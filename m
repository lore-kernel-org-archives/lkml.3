Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3J3Q1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:27:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab3J3Q1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:30 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 05/12] sb_edac: isolate TOHM retrieval
Date: Wed, 30 Oct 2013 12:26:59 -0400
Message-Id: <1383150426-24730-6-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation of Ivy Bridge support.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index eb6c9d4..fcd9c66 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -261,6 +261,7 @@ struct sbridge_info {
 	u32	mcmtr;
 	u32	rankcfgr;
 	u64	(*get_tolm)(struct sbridge_pvt *pvt);
+	u64	(*get_tohm)(struct sbridge_pvt *pvt);
 };
 
 struct sbridge_channel {
@@ -453,6 +454,14 @@ static u64 sbridge_get_tolm(struct sbridge_pvt *pvt)
 	return GET_TOLM(reg);
 }
 
+static u64 sbridge_get_tohm(struct sbridge_pvt *pvt)
+{
+	u32 reg;
+
+	pci_read_config_dword(pvt->pci_sad1, TOHM, &reg);
+	return GET_TOHM(reg);
+}
+
 /****************************************************************************
 			Memory check routines
  ****************************************************************************/
@@ -634,9 +643,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	edac_dbg(0, "TOLM: %u.%03u GB (0x%016Lx)\n", mb, kb, (u64)pvt->tolm);
 
 	/* Address range is already 45:25 */
-	pci_read_config_dword(pvt->pci_sad1, TOHM,
-			      &reg);
-	pvt->tohm = GET_TOHM(reg);
+	pvt->tohm = pvt->info.get_tohm(pvt);
 	tmp_mb = (1 + pvt->tohm) >> 20;
 
 	mb = div_u64_rem(tmp_mb, 1000, &kb);
@@ -1653,6 +1660,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	mci->dev_name = pci_name(sbridge_dev->pdev[0]);
 	mci->ctl_page_to_phys = NULL;
 	pvt->info.get_tolm = sbridge_get_tolm;
+	pvt->info.get_tohm = sbridge_get_tohm;
 
 	/* Set the function pointer to an actual operation function */
 	mci->edac_check = sbridge_check_error;
-- 
1.7.1

