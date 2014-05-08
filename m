Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaEHVRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 17:17:37 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34724 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbaEHVRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 17:17:35 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Subject: [RESEND PATCH 4/6] mfd: stmpe: mask off unused blocks properly
Date: Thu,  8 May 2014 23:16:37 +0200
Message-Id: <1399583799-23517-4-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399583799-23517-1-git-send-email-linus.walleij@linaro.org>
References: <1399583799-23517-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STMPE driver would just read/modify/write the system control
register on the STMPE1601, meaning it would not properly mask off
the PWM block, which remained active if it was on at boot time.
This makes sure the blocks are always masked off if they were
active on boot, saving some power. Also rename the inconsistenty
named STMPE1601 define for the PWM block activation.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/stmpe.c | 9 +++++++++
 drivers/mfd/stmpe.h | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 692452442ead..065c923cb2a9 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -606,9 +606,18 @@ static int stmpe1601_enable(struct stmpe *stmpe, unsigned int blocks,
 
 	if (blocks & STMPE_BLOCK_GPIO)
 		mask |= STMPE1601_SYS_CTRL_ENABLE_GPIO;
+	else
+		mask &= ~STMPE1601_SYS_CTRL_ENABLE_GPIO;
 
 	if (blocks & STMPE_BLOCK_KEYPAD)
 		mask |= STMPE1601_SYS_CTRL_ENABLE_KPC;
+	else
+		mask &= ~STMPE1601_SYS_CTRL_ENABLE_KPC;
+
+	if (blocks & STMPE_BLOCK_PWM)
+		mask |= STMPE1601_SYS_CTRL_ENABLE_SPWM;
+	else
+		mask &= ~STMPE1601_SYS_CTRL_ENABLE_SPWM;
 
 	return __stmpe_set_bits(stmpe, STMPE1601_REG_SYS_CTRL, mask,
 				enable ? mask : 0);
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
index 6639f1b0fef5..9e4d21d37a11 100644
--- a/drivers/mfd/stmpe.h
+++ b/drivers/mfd/stmpe.h
@@ -192,7 +192,7 @@ int stmpe_remove(struct stmpe *stmpe);
 
 #define STMPE1601_SYS_CTRL_ENABLE_GPIO		(1 << 3)
 #define STMPE1601_SYS_CTRL_ENABLE_KPC		(1 << 1)
-#define STMPE1601_SYSCON_ENABLE_SPWM		(1 << 0)
+#define STMPE1601_SYS_CTRL_ENABLE_SPWM		(1 << 0)
 
 /* The 1601/2403 share the same masks */
 #define STMPE1601_AUTOSLEEP_TIMEOUT_MASK	(0x7)
-- 
1.9.0

