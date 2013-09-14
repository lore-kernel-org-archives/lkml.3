Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3INTtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 15:49:32 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47134 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932447Ab3INTsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 15:48:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH 6/7] x86 tsc clock: implement clock latch
Date: Sat, 14 Sep 2013 12:48:00 -0700
Message-Id: <1379188081-15613-7-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
References: <1379188081-15613-1-git-send-email-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/tsc.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6ff4924..c75e9f9 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -766,10 +766,28 @@ static cycle_t read_tsc(struct clocksource *cs)
 		ret : clocksource_tsc.cycle_last;
 }
 
+static cycle_t read_tsc_latch(struct clocksource *cs, int index)
+{
+	cycle_t ret = (cycle_t)get_cycles();
+
+	return ret >= clocksource_tsc.cycle_last_latch[index] ?
+		ret : clocksource_tsc.cycle_last_latch[index];
+}
+
+static void update_tsc_latch(struct clocksource *cs, int oldindex,
+		int newindex)
+{
+	clocksource_tsc.cycle_last_latch[newindex] =
+		clocksource_tsc.cycle_last_latch[oldindex];
+}
+
 static void resume_tsc(struct clocksource *cs)
 {
-	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3))
+	if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC_S3)) {
 		clocksource_tsc.cycle_last = 0;
+		clocksource_tsc.cycle_last_latch[0] = 0;
+		clocksource_tsc.cycle_last_latch[1] = 0;
+	}
 }
 
 static struct clocksource clocksource_tsc = {
@@ -783,6 +801,8 @@ static struct clocksource clocksource_tsc = {
 #ifdef CONFIG_X86_64
 	.archdata               = { .vclock_mode = VCLOCK_TSC },
 #endif
+	.read_latch		= read_tsc_latch,
+	.update_latch		= update_tsc_latch,
 };
 
 void mark_tsc_unstable(char *reason)
-- 
1.7.10.4

