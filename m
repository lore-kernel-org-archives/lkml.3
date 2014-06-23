Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbaFWNEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:04:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36897 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbaFWNEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:04:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rabin Vincent <rabin@rab.in>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 35/93] ARM: 8064/1: fix v7-M signal return
Date: Mon, 23 Jun 2014 14:02:14 +0100
Message-Id: <1403528592-2163-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin@rab.in>

commit 483a6c9d447f625b991fa04a1530493d893984db upstream.

According to the ARM ARM, the behaviour is UNPREDICTABLE if the PC read
from the exception return stack is not half word aligned.  See the
pseudo code for ExceptionReturn() and PopStack().

The signal handler's address has the bit 0 set, and setup_return()
directly writes this to regs->ARM_pc.  Current hardware happens to
discard this bit, but QEMU's emulation doesn't and this makes processes
crash.  Mask out bit 0 before the exception return in order to get
predictable behaviour.

Fixes: 19c4d593f0b4 ("ARM: ARMv7-M: Add support for exception handling")

Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/entry-header.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index de23a9beed13..b527a79f73f1 100644
--- a/arch/arm/kernel/entry-header.S
+++ b/arch/arm/kernel/entry-header.S
@@ -132,6 +132,10 @@
 	orrne	r5, V7M_xPSR_FRAMEPTRALIGN
 	biceq	r5, V7M_xPSR_FRAMEPTRALIGN
 
+	@ ensure bit 0 is cleared in the PC, otherwise behaviour is
+	@ unpredictable
+	bic	r4, #1
+
 	@ write basic exception frame
 	stmdb	r2!, {r1, r3-r5}
 	ldmia	sp, {r1, r3-r5}
-- 
1.9.1

