Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3LCOit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:38:49 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:60519 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3LCOii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:38:38 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/6] context_tracking: Rename context_tracking_active() to context_tracking_cpu_is_enabled()
Date: Tue,  3 Dec 2013 15:38:24 +0100
Message-Id: <1386081506-24358-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
References: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently have a confusing couple of API naming with the existing
context_tracking_active() and context_tracking_is_enabled().

Lets keep the latter one, context_tracking_is_enabled(), for global
context tracking state check and use context_tracking_cpu_is_enabled()
for local state check.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/context_tracking_state.h | 9 +++++----
 include/linux/vtime.h                  | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/context_tracking_state.h b/include/linux/context_tracking_state.h
index 0db535b..97a8122 100644
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -26,14 +26,15 @@ static inline bool context_tracking_is_enabled(void)
 {
 	return static_key_false(&context_tracking_enabled);
 }
-static inline bool context_tracking_in_user(void)
+
+static inline bool context_tracking_cpu_is_enabled(void)
 {
-	return __this_cpu_read(context_tracking.state) == IN_USER;
+	return __this_cpu_read(context_tracking.active);
 }
 
-static inline bool context_tracking_active(void)
+static inline bool context_tracking_in_user(void)
 {
-	return __this_cpu_read(context_tracking.active);
+	return __this_cpu_read(context_tracking.state) == IN_USER;
 }
 #else
 static inline bool context_tracking_in_user(void) { return false; }
diff --git a/include/linux/vtime.h b/include/linux/vtime.h
index 807c732..c5165fd 100644
--- a/include/linux/vtime.h
+++ b/include/linux/vtime.h
@@ -20,7 +20,7 @@ static inline bool vtime_accounting_enabled(void) { return true; }
 static inline bool vtime_accounting_enabled(void)
 {
 	if (context_tracking_is_enabled()) {
-		if (context_tracking_active())
+		if (context_tracking_cpu_is_enabled())
 			return true;
 	}
 
-- 
1.8.3.1

