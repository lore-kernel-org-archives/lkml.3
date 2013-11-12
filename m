Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3KLARO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:17:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:47195 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab3KLAQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:16:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407152569"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Olof Johansson <olof@lixom.net>, "H. Peter Anvin" <hpa@linux.intel.com>,
        <stable@vger.kernel.org>
Subject: [RFC PATCH 1/3] x86, boot: Move setup_bios_corruption_check() later
Date: Mon, 11 Nov 2013 16:16:45 -0800
Message-Id: <1384215407-22288-2-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384215407-22288-1-git-send-email-hpa@linux.intel.com>
References: <1384215407-22288-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

setup_bios_corruption_check() tries to claim any low memory regions
that we haven't already reserved.  Make sure we reserve any low memory
regions that we intend to either use or know/assume a priori is bad
*before* we initialize the checker.

Stable team note: adding this to the list to consider for stable
because it generates user-visible nuisance dmesg warnings in some
configurations.  However, it is not urgent and should be allowed to
percolate in Linus' tree for a bit first.

Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/528168CB.7070602@linux.intel.com
Cc: <stable@vger.kernel.org> v3.9+ [not urgent]
---
 arch/x86/kernel/setup.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..8c01d6e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1080,10 +1080,6 @@ void __init setup_arch(char **cmdline_p)
 	/* preallocate 4k for mptable mpc */
 	early_reserve_e820_mpc_new();
 
-#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
-	setup_bios_corruption_check();
-#endif
-
 #ifdef CONFIG_X86_32
 	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
 			(max_pfn_mapped<<PAGE_SHIFT) - 1);
@@ -1100,6 +1096,14 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
+	/*
+	 * At this point we should have reserved any low memory regions
+	 * we need to reserve.
+	 */
+#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
+	setup_bios_corruption_check();
+#endif
+
 	memblock_set_current_limit(get_max_mapped());
 	dma_contiguous_reserve(0);
 
-- 
1.8.3.1

