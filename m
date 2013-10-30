Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3J3Q32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:29:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab3J3Q1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:30 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 07/12] sb_edac: allow different interleave lists
Date: Wed, 30 Oct 2013 12:27:01 -0400
Message-Id: <1383150426-24730-8-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for Ivy Bridge support

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 0bafe0a..dbd99d3 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -90,11 +90,10 @@ static char *get_dram_attr(u32 reg)
 	}
 }
 
-static const u32 interleave_list[] = {
+static const u32 sbridge_interleave_list[] = {
 	0x84, 0x8c, 0x94, 0x9c, 0xa4,
 	0xac, 0xb4, 0xbc, 0xc4, 0xcc,
 };
-#define MAX_INTERLEAVE	ARRAY_SIZE(interleave_list)
 
 #define SAD_PKG0(reg)		GET_BITFIELD(reg, 0, 2)
 #define SAD_PKG1(reg)		GET_BITFIELD(reg, 3, 5)
@@ -262,7 +261,9 @@ struct sbridge_info {
 	u64		(*get_tolm)(struct sbridge_pvt *pvt);
 	u64		(*get_tohm)(struct sbridge_pvt *pvt);	
 	const u32	*dram_rule;
+	const u32	*interleave_list;
 	u8		max_sad;
+	u8		max_interleave;
 };
 
 struct sbridge_channel {
@@ -680,7 +681,7 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 			 reg);
 		prv = limit;
 
-		pci_read_config_dword(pvt->pci_sad0, interleave_list[n_sads],
+		pci_read_config_dword(pvt->pci_sad0, pvt->info.interleave_list[n_sads],
 				      &reg);
 		sad_interl = sad_pkg(reg, 0);
 		for (j = 0; j < 8; j++) {
@@ -803,7 +804,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	int 			n_rir, n_sads, n_tads, sad_way, sck_xch;
 	int			sad_interl, idx, base_ch;
 	int			interleave_mode;
-	unsigned		sad_interleave[MAX_INTERLEAVE];
+	unsigned		sad_interleave[pvt->info.max_interleave];
 	u32			reg;
 	u8			ch_way,sck_way;
 	u32			tad_offset;
@@ -854,7 +855,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	*area_type = get_dram_attr(reg);
 	interleave_mode = INTERLEAVE_MODE(reg);
 
-	pci_read_config_dword(pvt->pci_sad0, interleave_list[n_sads],
+	pci_read_config_dword(pvt->pci_sad0, pvt->info.interleave_list[n_sads],
 			      &reg);
 	sad_interl = sad_pkg(reg, 0);
 	for (sad_way = 0; sad_way < 8; sad_way++) {
@@ -1664,6 +1665,8 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	pvt->info.get_tohm = sbridge_get_tohm;
 	pvt->info.dram_rule = sbridge_dram_rule;
 	pvt->info.max_sad = ARRAY_SIZE(sbridge_dram_rule);
+	pvt->info.interleave_list = sbridge_interleave_list;
+	pvt->info.max_interleave = ARRAY_SIZE(sbridge_interleave_list);
 
 	/* Set the function pointer to an actual operation function */
 	mci->edac_check = sbridge_check_error;
-- 
1.7.1

