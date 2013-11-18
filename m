Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3KRJo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 04:44:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:28591 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab3KRJoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 04:44:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,722,1378882800"; 
   d="scan'208";a="429500970"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH] sparc64: fix build regession
Date: Mon, 18 Nov 2013 11:44:09 +0200
Message-Id: <1384767850-2574-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ea1e7ed33708 triggers build regression on sparc64.

include/linux/mm.h:1391:2: error: implicit declaration of function 'pgtable_cache_init' [-Werror=implicit-function-declaration]
arch/sparc/include/asm/pgtable_64.h:978:13: error: conflicting types for 'pgtable_cache_init' [-Werror]

It happens due headers include loop:

<linux/mm.h> -> <asm/pgtable.h> -> <asm/pgtable_64.h> ->
	<asm/tlbflush.h> -> <asm/tlbflush_64.h> -> <linux/mm.h>

Let's drop <linux/mm.h> include from asm/tlbflush_64.h.
Build tested with allmodconfig.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/sparc/include/asm/tlbflush_64.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sparc/include/asm/tlbflush_64.h b/arch/sparc/include/asm/tlbflush_64.h
index f0d6a9700f4c..3c3c89f52643 100644
--- a/arch/sparc/include/asm/tlbflush_64.h
+++ b/arch/sparc/include/asm/tlbflush_64.h
@@ -1,7 +1,6 @@
 #ifndef _SPARC64_TLBFLUSH_H
 #define _SPARC64_TLBFLUSH_H
 
-#include <linux/mm.h>
 #include <asm/mmu_context.h>
 
 /* TSB flush operations. */
-- 
1.8.4.3

