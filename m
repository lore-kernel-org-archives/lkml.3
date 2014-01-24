Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbaAXTLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 14:11:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34839 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbaAXTKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 14:10:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/3] x86: Revert wrong memblock current limit setting.
Date: Fri, 24 Jan 2014 11:11:08 -0800
Message-Id: <1390590670-25901-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
References: <1390590670-25901-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave reported big numa system booting is broken.

It turns out
| commit 5b6e529521d35e1bcaa0fe43456d1bbb335cae5d
| Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
| Date:   Tue Jan 21 15:50:03 2014 -0800
|
|    x86: memblock: set current limit to max low memory address

set limit to low wrongly.

max_low_pfn_mapped is different from max_pfn_mapped.
max_low_pfn_mapped is always under 4G.

That will memblock_alloc_nid all go under 4G.

Revert that offending patch.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/page_types.h |    4 ++--
 arch/x86/kernel/setup.c           |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/include/asm/page_types.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/page_types.h
+++ linux-2.6/arch/x86/include/asm/page_types.h
@@ -51,9 +51,9 @@ extern int devmem_is_allowed(unsigned lo
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
-static inline phys_addr_t get_max_low_mapped(void)
+static inline phys_addr_t get_max_mapped(void)
 {
-	return (phys_addr_t)max_low_pfn_mapped << PAGE_SHIFT;
+	return (phys_addr_t)max_pfn_mapped << PAGE_SHIFT;
 }
 
 bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn);
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -1173,7 +1173,7 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
-	memblock_set_current_limit(get_max_low_mapped());
+	memblock_set_current_limit(get_max_mapped());
 	dma_contiguous_reserve(0);
 
 	/*
