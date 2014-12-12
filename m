Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966058AbaLLTNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:13:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:23464 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965690AbaLLTMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:12:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="636810331"
Subject: [RFC][PATCH 2/8] x86: make __VIRTUAL_MASK safe to use on 32 bit
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>,
        dave.hansen@linux.intel.com
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 11:12:16 -0800
References: <20141212191213.579887D2@viggo.jf.intel.com>
In-Reply-To: <20141212191213.579887D2@viggo.jf.intel.com>
Message-Id: <20141212191216.6676010C@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

We are going to do some calculations in a moment that are based on the
size of the virtual address space.  __VIRTUAL_MASK is currently unsafe
to use on 32-bit since it overflows an unsigned long with its shift.

The current version will emit a warning if used at all on 32-bit
kernels.

Add a version which is safe on 32-bit and consequently does not spit
out a warning.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/page_types.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/include/asm/page_types.h~x86-make-__VIRTUAL_MASK-safe-to-use-on-32-bit arch/x86/include/asm/page_types.h
--- a/arch/x86/include/asm/page_types.h~x86-make-__VIRTUAL_MASK-safe-to-use-on-32-bit	2014-12-12 11:11:39.484965499 -0800
+++ b/arch/x86/include/asm/page_types.h	2014-12-12 11:11:39.487965634 -0800
@@ -10,7 +10,15 @@
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #define __PHYSICAL_MASK		((phys_addr_t)((1ULL << __PHYSICAL_MASK_SHIFT) - 1))
+#ifdef CONFIG_X86_64
+/*
+ * This version doesn't work on 32-bit because __VIRTUAL_MASK_SHIFT=32
+ * overflows the unsigned long we're trying to shift.
+ */
 #define __VIRTUAL_MASK		((1UL << __VIRTUAL_MASK_SHIFT) - 1)
+#else
+#define __VIRTUAL_MASK		(~0UL)
+#endif
 
 /* Cast PAGE_MASK to a signed type so that it is sign-extended if
    virtual addresses are 32-bits but physical addresses are larger
_
