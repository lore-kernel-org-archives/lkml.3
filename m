Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362Ab3GWVSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:18:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:5411 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932567Ab3GWVSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:18:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,730,1367996400"; 
   d="scan'208";a="350388445"
From: "Luck, Tony" <tony.luck@intel.com>
Date: Tue, 23 Jul 2013 13:34:42 -0700
Subject: [PATCH] x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC' errors.
To: linux-kernel@vger.kernel.org
Cc: Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Message-Id: <0104420@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 0x1000 bit of the MCACOD field of machine check MCi_STATUS
registers is only defined for corrected errors (where it means
that hardware may be filtering errors see SDM section 15.9.2.1).

For uncorrected errors it may, or may not be set - so we should mask
it out when checking for the architecturaly defined recoverable
error signatures (see SDM 15.9.3.1 and 15.9.3.2)

While fixing this - I also noticed a bug introduced by
  commit 33d7885b594e169256daef652e8d3527b2298e75
  x86/mce: Update MCE severity condition check
where we were including MCACOD bits in the check for the
unaffected thread(s) during a machine check.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/mce.h                | 3 ++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c | 8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index fa5f71e..a528f28 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -33,10 +33,11 @@
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
 #define MCACOD		  0xffff     /* MCA Error Code */
+#define MCACOD_UC	  0xefff     /* MCA Error Code - for UC errors */
 
 /* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
 #define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
-#define MCACOD_SCRUBMSK	0xfff0
+#define MCACOD_SCRUBMSK	0xeff0
 #define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
 #define MCACOD_DATA	0x0134	/* Data Load */
 #define MCACOD_INSTR	0x0150	/* Instruction Fetch */
diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index e2703520..7f6ab4e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -111,17 +111,17 @@ static struct severity {
 #ifdef	CONFIG_MEMORY_FAILURE
 	MCESEV(
 		KEEP, "Action required but unaffected thread is continuable",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR),
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR, MCI_UC_SAR|MCI_ADDR),
 		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
 		),
 	MCESEV(
 		AR, "Action required: data load error in a user process",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD_UC, MCI_UC_SAR|MCI_ADDR|MCACOD_DATA),
 		USER
 		),
 	MCESEV(
 		AR, "Action required: instruction fetch error in a user process",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD_UC, MCI_UC_SAR|MCI_ADDR|MCACOD_INSTR),
 		USER
 		),
 #endif
@@ -137,7 +137,7 @@ static struct severity {
 		),
 	MCESEV(
 		AO, "Action optional: last level cache writeback error",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD, MCI_UC_S|MCACOD_L3WB)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCACOD_UC, MCI_UC_S|MCACOD_L3WB)
 		),
 	MCESEV(
 		SOME, "Action optional: unknown MCACOD",
-- 
1.8.1.4

