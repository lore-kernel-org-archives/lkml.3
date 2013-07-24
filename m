Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab3GXVFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:05:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:15101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab3GXVC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:02:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,737,1367996400"; 
   d="scan'208";a="351015684"
Message-Id: <c37f0444671553807cdb253bad4a135d58f54123.1374699492.git.tony.luck@intel.com>
In-Reply-To: <cover.1374699492.git.tony.luck@intel.com>
References: <cover.1374699492.git.tony.luck@intel.com>
From: Tony Luck <tony.luck@intel.com>
Date: Wed, 24 Jul 2013 10:09:43 -0700
Subject: [PATCH 1/2] x86/mce: Fix mce regression from recent cleanup
To: linux-kernel@vger.kernel.org
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Borislav Petkov <bp@suse.de>, Chen Gong <gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    commit 33d7885b594e169256daef652e8d3527b2298e75
    x86/mce: Update MCE severity condition check

Simplified the rules to recognise each classification of recoverable
machine check combining the instruction and data fetch rules into a
single entry based on clarifications in the June 2013 SDM that all
recoverable events would be reported on the unaffected processor with
MCG_STATUS.EIPV=0 and MCG_STATUS.RIPV=1.  Unfortunately the simplified
rule has a couple of bugs.  Fix them here.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce-severity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
index e2703520..c370e1c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
@@ -111,8 +111,8 @@ static struct severity {
 #ifdef	CONFIG_MEMORY_FAILURE
 	MCESEV(
 		KEEP, "Action required but unaffected thread is continuable",
-		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR),
-		MCGMASK(MCG_STATUS_RIPV, MCG_STATUS_RIPV)
+		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR, MCI_UC_SAR|MCI_ADDR),
+		MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, MCG_STATUS_RIPV)
 		),
 	MCESEV(
 		AR, "Action required: data load error in a user process",
-- 
1.8.1.4

