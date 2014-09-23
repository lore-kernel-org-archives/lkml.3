Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaIWCQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:16:25 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:36709 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbaIWCQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:16:23 -0400
From: Chen Yucong <slaoub@gmail.com>
To: tony.luck@intel.com
Cc: bp@alien8.de, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86, MCE, AMD: use macros to compute bank MSRs
Date: Tue, 23 Sep 2014 10:16:01 +0800
Message-Id: <1411438561-24319-1-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid open coded calculations for bank MSRs by hiding the index
of higher bank MSRs in well-defined macros.

No semantic changes.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 5d4999f..f8c56bd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -217,7 +217,7 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 	for (bank = 0; bank < mca_cfg.banks; ++bank) {
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0)
-				address = MSR_IA32_MC0_MISC + bank * 4;
+				address = MSR_IA32_MCx_MISC(bank);
 			else if (block == 1) {
 				address = (low & MASK_BLKPTR_LO) >> 21;
 				if (!address)
@@ -281,7 +281,7 @@ static void amd_threshold_interrupt(void)
 			continue;
 		for (block = 0; block < NR_BLOCKS; ++block) {
 			if (block == 0) {
-				address = MSR_IA32_MC0_MISC + bank * 4;
+				address = MSR_IA32_MCx_MISC(bank);
 			} else if (block == 1) {
 				address = (low & MASK_BLKPTR_LO) >> 21;
 				if (!address)
@@ -314,8 +314,7 @@ static void amd_threshold_interrupt(void)
 
 			if (high & MASK_OVERFLOW_HI) {
 				rdmsrl(address, m.misc);
-				rdmsrl(MSR_IA32_MC0_STATUS + bank * 4,
-				       m.status);
+				rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
 				m.bank = K8_MCE_THRESHOLD_BASE
 				       + bank * NR_BLOCKS
 				       + block;
@@ -617,8 +616,7 @@ static int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		}
 	}
 
-	err = allocate_threshold_blocks(cpu, bank, 0,
-					MSR_IA32_MC0_MISC + bank * 4);
+	err = allocate_threshold_blocks(cpu, bank, 0, MSR_IA32_MCx_MISC(bank));
 	if (!err)
 		goto out;
 
-- 
1.7.10.4

