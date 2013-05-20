Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3ETQC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 12:02:28 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:42368 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903Ab3ETQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 12:02:17 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC PATCH 8/8] watchdog: Fix internal state with boot user disabled watchdog
Date: Mon, 20 May 2013 18:01:56 +0200
Message-Id: <1369065716-22801-9-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the watchdog is disabled through the 'nmi_watchdog=0'
boot parameter, the watchdog_running internal state isn't
cleared. Hence further enablements through sysctl/procfs
are ignored because the subsystem spuriously thinks it's
already running.

Initialize it properly on boot.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/watchdog.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 10776fe..3fa5df20 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -31,7 +31,7 @@
 
 int watchdog_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
-static int __read_mostly watchdog_running = 1;
+static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
 
 static DEFINE_PER_CPU(unsigned long, watchdog_touch_ts);
@@ -545,10 +545,10 @@ void __init lockup_detector_init(void)
 {
 #ifdef CONFIG_NO_HZ_FULL
 	watchdog_user_enabled = 0;
-	watchdog_running = 0;
 	pr_warning("Disabled lockup detectors by default because of full dynticks\n");
 	pr_warning("You can overwrite that with 'sysctl -w kernel.watchdog=1'\n");
 #endif
+	watchdog_running = watchdog_user_enabled;
 	set_sample_period();
 	if (smpboot_register_percpu_thread(&watchdog_threads)) {
 		pr_err("Failed to create watchdog threads, disabled\n");
-- 
1.7.5.4

