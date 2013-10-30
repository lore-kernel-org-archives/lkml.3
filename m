Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3J3Qaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3J3Q1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:27:30 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-edac@vger.kernel.org
Cc: tony.luck@intel.com, Aristeu Rozanski <arozansk@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com> (maintainer:EDAC-SBRIDGE),
        Doug Thompson <dougthompson@xmission.com> (supporter:EDAC-CORE),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 06/12] sb_edac: allow different dram_rule arrays
Date: Wed, 30 Oct 2013 12:27:00 -0400
Message-Id: <1383150426-24730-7-git-send-email-arozansk@redhat.com>
In-Reply-To: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
References: <1383150426-24730-1-git-send-email-arozansk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is in preparation for Ivy Bridge support

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
---
 drivers/edac/sb_edac.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index fcd9c66..0bafe0a 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -66,11 +66,10 @@ static int probed;
 #define PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_ERR3	0x3c77	/* 16.7 */
 
 /* Devices 12 Function 6, Offsets 0x80 to 0xcc */
-static const u32 dram_rule[] = {
+static const u32 sbridge_dram_rule[] = {
 	0x80, 0x88, 0x90, 0x98, 0xa0,
 	0xa8, 0xb0, 0xb8, 0xc0, 0xc8,
 };
-#define MAX_SAD		ARRAY_SIZE(dram_rule)
 
 #define SAD_LIMIT(reg)		((GET_BITFIELD(reg, 6, 25) << 26) | 0x3ffffff)
 #define DRAM_ATTR(reg)		GET_BITFIELD(reg, 2,  3)
@@ -258,10 +257,12 @@ static const u32 correrrthrsld[] = {
 
 struct sbridge_pvt;
 struct sbridge_info {
-	u32	mcmtr;
-	u32	rankcfgr;
-	u64	(*get_tolm)(struct sbridge_pvt *pvt);
-	u64	(*get_tohm)(struct sbridge_pvt *pvt);
+	u32		mcmtr;
+	u32		rankcfgr;	
+	u64		(*get_tolm)(struct sbridge_pvt *pvt);
+	u64		(*get_tohm)(struct sbridge_pvt *pvt);	
+	const u32	*dram_rule;
+	u8		max_sad;
 };
 
 struct sbridge_channel {
@@ -656,9 +657,9 @@ static void get_memory_layout(const struct mem_ctl_info *mci)
 	 * algorithm bellow.
 	 */
 	prv = 0;
-	for (n_sads = 0; n_sads < MAX_SAD; n_sads++) {
+	for (n_sads = 0; n_sads < pvt->info.max_sad; n_sads++) {
 		/* SAD_LIMIT Address range is 45:26 */
-		pci_read_config_dword(pvt->pci_sad0, dram_rule[n_sads],
+		pci_read_config_dword(pvt->pci_sad0, pvt->info.dram_rule[n_sads],
 				      &reg);
 		limit = SAD_LIMIT(reg);
 
@@ -830,8 +831,8 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 	/*
 	 * Step 1) Get socket
 	 */
-	for (n_sads = 0; n_sads < MAX_SAD; n_sads++) {
-		pci_read_config_dword(pvt->pci_sad0, dram_rule[n_sads],
+	for (n_sads = 0; n_sads < pvt->info.max_sad; n_sads++) {
+		pci_read_config_dword(pvt->pci_sad0, pvt->info.dram_rule[n_sads],
 				      &reg);
 
 		if (!DRAM_RULE_ENABLE(reg))
@@ -846,7 +847,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 			break;
 		prv = limit;
 	}
-	if (n_sads == MAX_SAD) {
+	if (n_sads == pvt->info.max_sad) {
 		sprintf(msg, "Can't discover the memory socket");
 		return -EINVAL;
 	}
@@ -1661,6 +1662,8 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev)
 	mci->ctl_page_to_phys = NULL;
 	pvt->info.get_tolm = sbridge_get_tolm;
 	pvt->info.get_tohm = sbridge_get_tohm;
+	pvt->info.dram_rule = sbridge_dram_rule;
+	pvt->info.max_sad = ARRAY_SIZE(sbridge_dram_rule);
 
 	/* Set the function pointer to an actual operation function */
 	mci->edac_check = sbridge_check_error;
-- 
1.7.1

