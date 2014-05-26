Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaEZQ7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:59:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:20367 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbaEZQ56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,914,1392192000"; 
   d="scan'208";a="545122349"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 13/15] x86/xsaves: Call booting time xsaves and xrstors in setup_init_fpu_buf
Date: Mon, 26 May 2014 10:01:20 -0700
Message-Id: <1401123682-5384-14-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
References: <1401123682-5384-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

setup_init_fpu_buf() calls booting time xsaves and xrstors to save/restore
xstate in xsave area.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/kernel/xsave.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index a4b451c..8fa7c7d 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -496,15 +496,21 @@ static void __init setup_init_fpu_buf(void)
 
 	setup_xstate_features();
 
+	if (cpu_has_xsaves) {
+		init_xstate_buf->xsave_hdr.xcomp_bv =
+						(u64)1 << 63 | pcntxt_mask;
+		init_xstate_buf->xsave_hdr.xstate_bv = pcntxt_mask;
+	}
+
 	/*
 	 * Init all the features state with header_bv being 0x0
 	 */
-	xrstor_state(init_xstate_buf, -1);
+	xrstor_state_booting(init_xstate_buf, -1);
 	/*
 	 * Dump the init state again. This is to identify the init state
 	 * of any feature which is not represented by all zero's.
 	 */
-	xsave_state(init_xstate_buf, -1);
+	xsave_state_booting(init_xstate_buf, -1);
 }
 
 static enum { AUTO, ENABLE, DISABLE } eagerfpu = AUTO;
-- 
1.8.1.2

