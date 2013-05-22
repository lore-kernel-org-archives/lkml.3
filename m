Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab3EVWKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:10:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab3EVWKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 01/21] arm64: debug: clear mdscr_el1 instead of taking the OS lock
Date: Wed, 22 May 2013 15:10:19 -0700
Message-Id: <20130522205232.804536363@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/debug-monitors.c |    2 --
 arch/arm64/mm/proc.S               |    3 +--
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -136,8 +136,6 @@ void disable_debug_monitors(enum debug_e
  */
 static void clear_os_lock(void *unused)
 {
-	asm volatile("msr mdscr_el1, %0" : : "r" (0));
-	isb();
 	asm volatile("msr oslar_el1, %0" : : "r" (0));
 	isb();
 }
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


