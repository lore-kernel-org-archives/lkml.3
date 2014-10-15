Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaJOFMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 01:12:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:61472 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbaJOFME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 01:12:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="400441081"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/8] x86: Naturally align the debug IST stack
Date: Tue, 14 Oct 2014 22:11:45 -0700
Message-Id: <1413349911-3620-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413349911-3620-1-git-send-email-andi@firstfloor.org>
References: <1413349911-3620-1-git-send-email-andi@firstfloor.org>
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
index 6782051..8b31477 100644
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
index e4ab2b4..a9f1331 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1162,8 +1162,12 @@ static const unsigned int exception_stack_sizes[N_EXCEPTION_STACKS] = {
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
@@ -1336,6 +1340,8 @@ void cpu_init(void)
 		char *estacks = per_cpu(exception_stacks, cpu);
 
 		for (v = 0; v < N_EXCEPTION_STACKS; v++) {
+			if (v == DEBUG_STACK - 1)
+				estacks = per_cpu(debug_stack, cpu);
 			estacks += exception_stack_sizes[v];
 			oist->ist[v] = t->x86_tss.ist[v] =
 					(unsigned long)estacks;
-- 
1.9.3

