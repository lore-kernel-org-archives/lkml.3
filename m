Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbaJJXZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 19:25:27 -0400
Received: from mga03.intel.com ([134.134.136.65]:27076 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaJJXZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 19:25:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,695,1406617200"; 
   d="scan'208";a="616755989"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/4] x86: Optimize enhanced copy user fault handling
Date: Fri, 10 Oct 2014 16:25:16 -0700
Message-Id: <1412983517-12419-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
References: <1412983517-12419-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For the enhanced copy string case we can trivially optimize the fault
handling. It is just a single subtraction, as there is only one
possible fault point. So get rid of handle tail for this and
just do the subtraction directly.

This patch is strictly not needed for the goal of making perf
backtrace faster, but it will possibly help other workloads.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/lib/copy_user_64.S | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index dee945d..608caf45 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -285,8 +285,10 @@ ENTRY(copy_user_enhanced_fast_string)
 	ret
 
 	.section .fixup,"ax"
-12:	movl %ecx,%edx		/* ecx is zerorest also */
-	jmp copy_user_handle_tail
+	/* edx: len: ecx: actually copied bytes */
+12:	sub  %ecx,%edx
+	mov %edx,%eax
+	ret
 	.previous
 
 	_ASM_EXTABLE(1b,12b)
-- 
1.9.3

