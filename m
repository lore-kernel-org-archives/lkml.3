Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3J3Q31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:29:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3J3Q1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:30 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 08/12] sb_edac: rework sad_pkg
Date: Wed, 30 Oct 2013 12:27:02 -0400
Message-Id: <1383150426-24730-9-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for Ivy Bridge support

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |   66 +++++++++++++++++++++--------------------------
 1 files changed, 30 insertions(+), 36 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index dbd99d3..bf305a2 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -95,37 +95,27 @@ static const u32 sbridge_interleave_list[] = {
 	0xac, 0xb4, 0xbc, 0xc4, 0xcc,
 };
 
-#define SAD_PKG0(reg)		GET_BITFIELD(reg, 0, 2)
-#define SAD_PKG1(reg)		GET_BITFIELD(reg, 3, 5)
-#define SAD_PKG2(reg)		GET_BITFIELD(reg, 8, 10)
-#define SAD_PKG3(reg)		GET_BITFIELD(reg, 11, 13)
-#define SAD_PKG4(reg)		GET_BITFIELD(reg, 16, 18)
-#define SAD_PKG5(reg)		GET_BITFIELD(reg, 19, 21)
-#define SAD_PKG6(reg)		GET_BITFIELD(reg, 24, 26)
-#define SAD_PKG7(reg)		GET_BITFIELD(reg, 27, 29)
-
-static inline int sad_pkg(u32 reg, int interleave)
+struct interleave_pkg {
+	unsigned char start;
+	unsigned char end;
+};
+
+static const struct interleave_pkg sbridge_interleave_pkg[] = {
+	{ 0, 2 },
+	{ 3, 5 },
+	{ 8, 10 },
+	{ 11, 13 },
+	{ 16, 18 },
+	{ 19, 21 },
+	{ 24, 26 },
+	{ 27, 29 },
+};
+
+static inline int sad_pkg(const struct interleave_pkg *table, u32 reg,
+			  int interleave)
 {
-	switch (interleave) {
-	case 0:
-		return SAD_PKG0(reg);
-	case 1:
-		return SAD_PKG1(reg);
-	case 2:
-		return SAD_PKG2(reg);
-	case 3:
-		return SAD_PKG3(reg);
-	case 4:
-		return SAD_PKG4(reg);
-	case 5:
-		return SAD_PKG5(reg);
-	case 6:
-		return SAD_PKG6(reg);
-	case 7:
-		return SAD_PKG7(reg);
-	default:
-		return -EINVAL;
-	}
+	return GET_BITFIELD(reg, table[interleave].start,
+			    table[interleave].end);
 }
 
 /* Devices 12 Function 7 */
@@ -262,6 +252,7 @@ struct sbridge_info {
 	u64		(*get_tohm)(struct sbridge_pvt *pvt);	
 	const u32	*dram_rule;
 	const u32	*interleave_list;
+	const struct interleave_pkg *interleave_pkg;
 	u8		max_sad;
 	u8		max_interleave;
 };
@@ -683,13 +674,14 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 
 		pci_read_config_dword(pvt->pci_sad0, pvt->info.interleave_list[n_sads],
 				      &reg);
-		sad_interl = sad_pkg(reg, 0);
+		sad_interl = sad_pkg(pvt->info.interleave_pkg, reg, 0);
 		for (j = 0; j < 8; j++) {
-			if (j > 0 && sad_interl == sad_pkg(reg, j))
+			u32 pkg = sad_pkg(pvt->info.interleave_pkg, reg, j);
+			if (j > 0 && sad_interl == pkg)
 				break;
 
 			edac_dbg(0, "SAD#%d, interleave #%d: %d\n",
-				 n_sads, j, sad_pkg(reg, j));
+				 n_sads, j, pkg);
 		}
 	}
 
@@ -857,11 +849,12 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 
 	pci_read_config_dword(pvt->pci_sad0, pvt->info.interleave_list[n_sads],
 			      &reg);
-	sad_interl = sad_pkg(reg, 0);
+	sad_interl = sad_pkg(pvt->info.interleave_pkg, reg, 0);
 	for (sad_way = 0; sad_way < 8; sad_way++) {
-		if (sad_way > 0 && sad_interl == sad_pkg(reg, sad_way))
+		u32 pkg = sad_pkg(pvt->info.interleave_pkg, reg, sad_way);
+		if (sad_way > 0 && sad_interl == pkg)
 			break;
-		sad_interleave[sad_way] = sad_pkg(reg, sad_way);
+		sad_interleave[sad_way] = pkg;
 		edac_dbg(0, "SAD interleave #%d: %d\n",
 			 sad_way, sad_interleave[sad_way]);
 	}
@@ -1667,6 +1660,7 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	pvt->info.max_sad = ARRAY_SIZE(sbridge_dram_rule);
 	pvt->info.interleave_list = sbridge_interleave_list;
 	pvt->info.max_interleave = ARRAY_SIZE(sbridge_interleave_list);
+	pvt->info.interleave_pkg = sbridge_interleave_pkg;
 
 	/* Set the function pointer to an actual operation function */
 	mci->edac_check = sbridge_check_error;
-- 
1.7.1

