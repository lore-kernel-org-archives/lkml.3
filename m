Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964779AbaD1WNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:13:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:42236 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755410AbaD1WMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:12:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="530089475"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/7] x86: Naturally align the debug IST stack
Date: Mon, 28 Apr 2014 15:12:36 -0700
Message-Id: <1398723161-21968-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The followon patch for RD*BASE requires the IST stacks to be naturally
aligned because it uses and to access the bottom of the stack.
This was true for everyone except for the debug ist stack.
Make the debug ist stack naturally aligned too.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/page_64_types.h | 4 ++--
 arch/x86/kernel/cpu/common.c         | 8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index 43dcd80..76564b6 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -17,8 +17,8 @@
 #define STACKFAULT_STACK 1
 #define DOUBLEFAULT_STACK 2
 #define NMI_STACK 3
-#define DEBUG_STACK 4
-#define MCE_STACK 5
+#define MCE_STACK 4
+#define DEBUG_STACK 5 /* Must be always last */
 #define N_EXCEPTION_STACKS 5  /* hw limit: 7 */
 
 #define PUD_PAGE_SIZE		(_AC(1, UL) << PUD_SHIFT)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 24b6fd1..79ba4b9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1114,8 +1114,12 @@ static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
 	  [DEBUG_STACK - 1]			= DEBUG_STKSZ
 };
 
+/* The IST stacks must be naturally aligned */
+
 static DEFINE_PER_CPU_PAGE_ALIGNED(char, exception_stacks
-	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ + DEBUG_STKSZ]);
+	[(N_EXCEPTION_STACKS - 1) * EXCEPTION_STKSZ]);
+static DEFINE_PER_CPU_2PAGE_ALIGNED(char, debug_stack
+	[DEBUG_STKSZ]);
 
 /* May not be marked __init: used by software suspend */
 void syscall_init(void)
@@ -1285,6 +1289,8 @@ void cpu_init(void)
 		char *estacks = per_cpu(exception_stacks, cpu);
 
 		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+			if (v == DEBUG_STACK - 1)
+				estacks = per_cpu(debug_stack, cpu);
 			estacks += exception_stack_sizes[v];
 			oist->ist[v] = t->x86_tss.ist[v] =
 					(unsigned long)estacks;
-- 
1.9.0

