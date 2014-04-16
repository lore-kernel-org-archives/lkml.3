Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaDPDUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:20:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:56945 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbaDPDUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:20:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,868,1389772800"; 
   d="scan'208";a="493905201"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: hpa@zytor.com, tony.luck@intel.com
Cc: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH 1/2 v2] x86, MCE: Fix a bug in CMCI handler
Date: Tue, 15 Apr 2014 22:55:32 -0400
Message-Id: <1397616933-11239-1-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397546035-6384-1-git-send-email-gong.chen@linux.intel.com>
References: <1397546035-6384-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug is introduced by me in commit 27f6c573e0. I forget
to execute put_cpu_var operation after get_cpu_var. Fix it
via this_cpu_write instead of get_cpu_var.

v2 -> v1: Separate cleanup from bug fix.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Suggested-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index eeee23f..68317c8 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -598,7 +598,6 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 {
 	struct mce m;
 	int i;
-	unsigned long *v;
 
 	this_cpu_inc(mce_poll_count);
 
@@ -618,8 +617,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (!(m.status & MCI_STATUS_VAL))
 			continue;
 
-		v = &get_cpu_var(mce_polled_error);
-		set_bit(0, v);
+		this_cpu_write(mce_polled_error, 1);
 		/*
 		 * Uncorrected or signalled events are handled by the exception
 		 * handler when it is enabled, so don't process those here.
-- 
1.9.0

