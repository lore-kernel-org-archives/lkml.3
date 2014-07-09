Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaGIRK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:10:57 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:47985 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613AbaGIRJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:09:43 -0400
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, Ewout van Bekkum <ewout@google.com>,
        Havard Skinnemoen <hskinnemoen@google.com>
Subject: [PATCH 6/6] x86-mce: ensure the MCP timer is not already set in the mce_timer_fn.
Date: Wed,  9 Jul 2014 10:09:26 -0700
Message-Id: <1404925766-32253-7-git-send-email-hskinnemoen@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ewout van Bekkum <ewout@google.com>

The machine check poll timer function, mce_timer_fn(), did not check
whether the MCP timer had already been set in case the function was
preempted by an interrupt. A CMCI interrupt could preempt this function
and enable the MCP timer through mce_timer_kick(). The race condition
was resolved by disabling interrupts during the mce_timer_fn() function
and by verifying the timer isn't already set before starting the timer.

Signed-off-by: Ewout van Bekkum <ewout@google.com>
Signed-off-by: Havard Skinnemoen <hskinnemoen@google.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 1587b18..c5e40cb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1310,10 +1310,13 @@ static void mce_timer_fn(unsigned long data)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 	unsigned long iv;
+	unsigned long flags;
 	int notify;
 
 	WARN_ON(smp_processor_id() != data);
 
+	/* Ensure a CMCI interrupt can't preempt this. */
+	local_irq_save(flags);
 	if (mce_available(__this_cpu_ptr(&cpu_info))) {
 		machine_check_poll(MCP_TIMESTAMP,
 				&__get_cpu_var(mce_poll_banks));
@@ -1334,11 +1337,15 @@ static void mce_timer_fn(unsigned long data)
 		iv = mce_adjust_timer(iv);
 	}
 	__this_cpu_write(mce_next_interval, iv);
-	/* Might have become 0 after CMCI storm subsided */
-	if (iv) {
+
+	/* Ensure the timer isn't already set and the interval has not become
+	 * 0 after a CMCMI storm has subsided.
+	 */
+	if (!timer_pending(t) && iv) {
 		t->expires = jiffies + iv;
 		add_timer_on(t, smp_processor_id());
 	}
+	local_irq_restore(flags);
 }
 
 /*
-- 
2.0.0.526.g5318336

