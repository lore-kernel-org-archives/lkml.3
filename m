Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447Ab3GaI54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:57:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759394Ab3GaI5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:57:51 -0400
Date: Wed, 31 Jul 2013 01:57:07 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-93786a5f6aeb9c032c1c240246c5aabcf457b38f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, anish198519851985@gmail.com,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, anish198519851985@gmail.com,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de, dzickus@redhat.com
In-Reply-To: <1374539466-4799-9-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-9-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] watchdog: Make it work under full dynticks
Git-Commit-ID: 93786a5f6aeb9c032c1c240246c5aabcf457b38f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:57:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  93786a5f6aeb9c032c1c240246c5aabcf457b38f
Gitweb:     http://git.kernel.org/tip/93786a5f6aeb9c032c1c240246c5aabcf457b38f
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 23 Jul 2013 02:31:06 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:29:15 +0200

watchdog: Make it work under full dynticks

A perf event can be used without forcing the tick to
stay alive if it doesn't use a frequency but a sample
period and if it doesn't throttle (raise storm of events).

Since the lockup detector neither use a perf event frequency
nor should ever throttle due to its high period, it can now
run concurrently with the full dynticks feature.

So remove the hack that disabled the watchdog.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Anish Singh <anish198519851985@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374539466-4799-9-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/watchdog.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1241d8c..51c4f34 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -553,14 +553,6 @@ void __init lockup_detector_init(void)
 {
 	set_sample_period();
 
-#ifdef CONFIG_NO_HZ_FULL
-	if (watchdog_user_enabled) {
-		watchdog_user_enabled = 0;
-		pr_warning("Disabled lockup detectors by default for full dynticks\n");
-		pr_warning("You can reactivate it with 'sysctl -w kernel.watchdog=1'\n");
-	}
-#endif
-
 	if (watchdog_user_enabled)
 		watchdog_enable_all_cpus();
 }
