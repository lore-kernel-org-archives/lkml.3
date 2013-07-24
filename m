Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3GXVEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:04:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:36594 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab3GXVC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,737,1367996400"; 
   d="scan'208";a="336275196"
Message-Id: <6c1ccb7a070710da09b657c90badf7103c9f7d61.1374699492.git.tony.luck@intel.com>
In-Reply-To: <cover.1374699492.git.tony.luck@intel.com>
References: <cover.1374699492.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Wed, 24 Jul 2013 13:54:20 -0700
Subject: [PATCH 2/2] x86/mce: Pay no attention to 'F' bit in MCACOD when parsing 'UC' errors
To: linux-kernel@vger.kernel.org
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 0x1000 bit of the MCACOD field of machine check MCi_STATUS
registers is only defined for corrected errors (where it means
that hardware may be filtering errors see SDM section 15.9.2.1).

For uncorrected errors it may, or may not be set - so we should mask
it out when checking for the architecturaly defined recoverable
error signatures (see SDM 15.9.3.1 and 15.9.3.2)

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/mce.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 29e3093..aa97342 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -32,11 +32,20 @@
 #define MCI_STATUS_PCC   (1ULL<<57)  /* processor context corrupt */
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
-#define MCACOD		  0xffff     /* MCA Error Code */
+
+/*
+ * Note that the full MCACOD field of IA32_MCi_STATUS MSR is
+ * bits 15:0.  But bit 12 is the 'F' bit, defined for corrected
+ * errors to indicate that errors are being filtered by hardware.
+ * We should mask out bit 12 when looking for specific signatures
+ * of uncorrected errors - so the F bit is deliberately skipped
+ * in this #define.
+ */
+#define MCACOD		  0xefff     /* MCA Error Code */
 
 /* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
 #define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
-#define MCACOD_SCRUBMSK	0xfff0
+#define MCACOD_SCRUBMSK	0xeff0	/* Skip bit 12 ('F' bit) */
 #define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
 #define MCACOD_DATA	0x0134	/* Data Load */
 #define MCACOD_INSTR	0x0150	/* Instruction Fetch */
-- 
1.8.1.4

