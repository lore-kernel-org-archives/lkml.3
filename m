Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaI3Vms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:42:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32941 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbaI3VjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 085/103] arm64: ptrace: fix compat hardware watchpoint reporting
Date: Tue, 30 Sep 2014 14:31:30 -0700
Message-Id: <1412112708-27356-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 27d7ff273c2aad37b28f6ff0cab2cfa35b51e648 upstream.

I'm not sure what I was on when I wrote this, but when iterating over
the hardware watchpoint array (hbp_watch_array), our index is off by
ARM_MAX_BRP, so we walk off the end of our thread_struct...

... except, a dodgy condition in the loop means that it never executes
at all (bp cannot be NULL).

This patch fixes the code so that we remove the bp check and use the
correct index for accessing the watchpoint structures.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/include/asm/hw_breakpoint.h | 1 -
 arch/arm64/kernel/ptrace.c             | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
index d064047..52b484b 100644
--- a/arch/arm64/include/asm/hw_breakpoint.h
+++ b/arch/arm64/include/asm/hw_breakpoint.h
@@ -79,7 +79,6 @@ static inline void decode_ctrl_reg(u32 reg,
  */
 #define ARM_MAX_BRP		16
 #define ARM_MAX_WRP		16
-#define ARM_MAX_HBP_SLOTS	(ARM_MAX_BRP + ARM_MAX_WRP)
 
 /* Virtual debug register bases. */
 #define AARCH64_DBG_REG_BVR	0
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 7a50b86..b1269da 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -81,7 +81,8 @@ static void ptrace_hbptriggered(struct perf_event *bp,
 			break;
 		}
 	}
-	for (i = ARM_MAX_BRP; i < ARM_MAX_HBP_SLOTS && !bp; ++i) {
+
+	for (i = 0; i < ARM_MAX_WRP; ++i) {
 		if (current->thread.debug.hbp_watch[i] == bp) {
 			info.si_errno = -((i << 1) + 1);
 			break;
-- 
1.9.1

