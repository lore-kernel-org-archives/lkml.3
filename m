Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbaFWIc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:32:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55636 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbaFWIcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 032/111] ARM: 8064/1: fix v7-M signal return
Date: Mon, 23 Jun 2014 10:31:07 +0200
Message-Id: <ae87686e2c356aba851817e804bd4fc4023b6468.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin@rab.in>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/kernel/entry-header.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
index 39f89fbd5111..88c6babeb0b5 100644
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
2.0.0

