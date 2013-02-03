Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3BCPMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:12:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34347 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389Ab3BCO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:28 -0500
Message-Id: <20130203144649.101814520@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Stephen Boyd <sboyd@codeaurora.org>,
        Patrik Kluba <pkluba@dension.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 057/128] ARM: 7627/1: Predicate preempt logic on PREEMP_COUNT not PREEMPT
 alone
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 568dca15aa2a0f4ddee255894ec393a159f13147 upstream.

Patrik Kluba reports that the preempt count becomes invalid due
to the preempt_enable() call being unbalanced with a
preempt_disable() call in the vfp assembly routines. This happens
because preempt_enable() and preempt_disable() update preempt
counts under PREEMPT_COUNT=y but the vfp assembly routines do so
under PREEMPT=y. In a configuration where PREEMPT=n and
DEBUG_ATOMIC_SLEEP=y, PREEMPT_COUNT=y and so the preempt_enable()
call in VFP_bounce() keeps subtracting from the preempt count
until it goes negative.

Fix this by always using PREEMPT_COUNT to decided when to update
preempt counts in the ARM assembly code.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-by: Patrik Kluba <pkluba@dension.com>
Tested-by: Patrik Kluba <pkluba@dension.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/vfp/entry.S |    6 +++---
 arch/arm/vfp/vfphw.S |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/vfp/entry.S b/arch/arm/vfp/entry.S
index cc926c9..323ce1a 100644
--- a/arch/arm/vfp/entry.S
+++ b/arch/arm/vfp/entry.S
@@ -22,7 +22,7 @@
 @  IRQs disabled.
 @
 ENTRY(do_vfp)
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 	ldr	r4, [r10, #TI_PREEMPT]	@ get preempt count
 	add	r11, r4, #1		@ increment it
 	str	r11, [r10, #TI_PREEMPT]
@@ -35,7 +35,7 @@ ENTRY(do_vfp)
 ENDPROC(do_vfp)
 
 ENTRY(vfp_null_entry)
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 	get_thread_info	r10
 	ldr	r4, [r10, #TI_PREEMPT]	@ get preempt count
 	sub	r11, r4, #1		@ decrement it
@@ -53,7 +53,7 @@ ENDPROC(vfp_null_entry)
 
 	__INIT
 ENTRY(vfp_testing_entry)
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 	get_thread_info	r10
 	ldr	r4, [r10, #TI_PREEMPT]	@ get preempt count
 	sub	r11, r4, #1		@ decrement it
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index ea0349f..dd5e56f 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -168,7 +168,7 @@ vfp_hw_state_valid:
 					@ else it's one 32-bit instruction, so
 					@ always subtract 4 from the following
 					@ instruction address.
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 	get_thread_info	r10
 	ldr	r4, [r10, #TI_PREEMPT]	@ get preempt count
 	sub	r11, r4, #1		@ decrement it
@@ -192,7 +192,7 @@ look_for_VFP_exceptions:
 	@ not recognised by VFP
 
 	DBGSTR	"not VFP"
-#ifdef CONFIG_PREEMPT
+#ifdef CONFIG_PREEMPT_COUNT
 	get_thread_info	r10
 	ldr	r4, [r10, #TI_PREEMPT]	@ get preempt count
 	sub	r11, r4, #1		@ decrement it


