Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3HRKhy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 06:37:54 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42237 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3HRKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 06:37:53 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] genirq: Correct fuzzy and fragile IRQ_RETVAL() definition
Date: Sun, 18 Aug 2013 12:37:12 +0200
Message-Id: <1376822232-19905-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bedd30d986a05e32dc3eab874e4b9ed8a38058bb ("genirq: make irqreturn_t
an enum") blindly replaced "0" by "IRQ_NONE" in the "IRQ_RETVAL(x)" macro
definition.

However, as "x" is a condition, "0" meant "boolean false", not an
irqreturn_t value.

All of this worked, and kept working after the addition of IRQ_WAKE_THREAD,
as
  - both "boolean false" and "IRQ_NONE" are "0" (for the comparison),
  - "boolean true" and "boolean false" nicely map to the correct values of
    "IRQ_HANDLED" and "IRQ_NONE" (for the return value).

Correct the macro definition for clarity and future-proofness.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 include/linux/irqreturn.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/irqreturn.h b/include/linux/irqreturn.h
index 714ba08..e374e36 100644
--- a/include/linux/irqreturn.h
+++ b/include/linux/irqreturn.h
@@ -14,6 +14,6 @@ enum irqreturn {
 };
 
 typedef enum irqreturn irqreturn_t;
-#define IRQ_RETVAL(x)	((x) != IRQ_NONE)
+#define IRQ_RETVAL(x)	((x) ? IRQ_HANDLED : IRQ_NONE)
 
 #endif
-- 
1.7.9.5

