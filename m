Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967273Ab3DRJcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:32:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40111 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3DRJRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vikram Mulukutla <markivx@codeaurora.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 24/72] panic: fix a possible deadlock in panic()
Date: Thu, 18 Apr 2013 10:16:09 +0100
Message-Id: <1366276617-3553-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikram Mulukutla <markivx@codeaurora.org>

commit 190320c3b6640d4104650f55ff69611e050ea06b upstream.

panic_lock is meant to ensure that panic processing takes place only on
one cpu; if any of the other cpus encounter a panic, they will spin
waiting to be shut down.

However, this causes a regression in this scenario:

1. Cpu 0 encounters a panic and acquires the panic_lock
   and proceeds with the panic processing.
2. There is an interrupt on cpu 0 that also encounters
   an error condition and invokes panic.
3. This second invocation fails to acquire the panic_lock
   and enters the infinite while loop in panic_smp_self_stop.

Thus all panic processing is stopped, and the cpu is stuck for eternity
in the while(1) inside panic_smp_self_stop.

To address this, disable local interrupts with local_irq_disable before
acquiring the panic_lock.  This will prevent interrupt handlers from
executing during the panic processing, thus avoiding this particular
problem.

Signed-off-by: Vikram Mulukutla <markivx@codeaurora.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/panic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index d2a5f4e..e1b2822 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -75,6 +75,14 @@ void panic(const char *fmt, ...)
 	int state = 0;
 
 	/*
+	 * Disable local interrupts. This will prevent panic_smp_self_stop
+	 * from deadlocking the first cpu that invokes the panic, since
+	 * there is nothing to prevent an interrupt handler (that runs
+	 * after the panic_lock is acquired) from invoking panic again.
+	 */
+	local_irq_disable();
+
+	/*
 	 * It's possible to come here directly from a panic-assertion and
 	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
-- 
1.8.1.2

