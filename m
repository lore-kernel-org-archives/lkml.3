Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab3E1VhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:37:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59663 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486Ab3E1VYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 42/78] arm64: debug: clear mdscr_el1 instead of taking the OS lock
Date: Tue, 28 May 2013 14:19:51 -0700
Message-Id: <1369776027-17859-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 9c413e25d95fd3c0abe23eadad66191b22baa549 upstream.

During boot, we take the debug OS lock before interrupts are enabled.
This is required to prevent clearing of PSTATE.D on the interrupt entry
path, which could result in spurious debug exceptions before we've got
round to resetting things like the hardware breakpoints registers to a
sane state.

A problem with this approach is that taking the OS lock prevents an
external JTAG debugger from debugging the system, which is especially
irritating during boot, where JTAG debugging can be most useful.

This patch clears mdscr_el1 rather than taking the lock, clearing the
MDE and KDE bits and preventing self-hosted hardware debug exceptions
from occurring.

Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/debug-monitors.c | 2 --
 arch/arm64/mm/proc.S               | 3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index 0c3ba9f..f4726dc 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -136,8 +136,6 @@ void disable_debug_monitors(enum debug_el el)
  */
 static void clear_os_lock(void *unused)
 {
-	asm volatile("msr mdscr_el1, %0" : : "r" (0));
-	isb();
 	asm volatile("msr oslar_el1, %0" : : "r" (0));
 	isb();
 }
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index f1d8b9b..a82ae88 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -119,8 +119,7 @@ ENTRY(__cpu_setup)
 
 	mov	x0, #3 << 20
 	msr	cpacr_el1, x0			// Enable FP/ASIMD
-	mov	x0, #1
-	msr	oslar_el1, x0			// Set the debug OS lock
+	msr	mdscr_el1, xzr			// Reset mdscr_el1
 	tlbi	vmalle1is			// invalidate I + D TLBs
 	/*
 	 * Memory region attributes for LPAE:
-- 
1.8.1.2

