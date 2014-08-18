Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaHRSEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:04:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57506 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaHRSED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:04:03 -0400
Date: Mon, 18 Aug 2014 11:03:52 -0700
From: tip-bot for Ulrich Obergfell <tipbot@zytor.com>
Message-ID: <tip-df577149594cefacd62740e86de080c6336d699e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        drjones@redhat.com, uobergfe@redhat.com, tglx@linutronix.de,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        drjones@redhat.com, tglx@linutronix.de, uobergfe@redhat.com,
        dzickus@redhat.com
In-Reply-To: <1407768567-171794-4-git-send-email-dzickus@redhat.com>
References: <1407768567-171794-4-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/watchdog] watchdog: Fix print-once on enable
Git-Commit-ID: df577149594cefacd62740e86de080c6336d699e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df577149594cefacd62740e86de080c6336d699e
Gitweb:     http://git.kernel.org/tip/df577149594cefacd62740e86de080c6336d699e
Author:     Ulrich Obergfell <uobergfe@redhat.com>
AuthorDate: Mon, 11 Aug 2014 10:49:25 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Aug 2014 11:17:46 +0200

watchdog: Fix print-once on enable

This patch avoids printing the message 'enabled on all CPUs,
...' multiple times. For example, the issue can occur in the
following scenario:

1) watchdog_nmi_enable() fails to enable PMU counters and sets
   cpu0_err.

2) 'echo [0|1] > /proc/sys/kernel/nmi_watchdog' is executed to
   disable and re-enable the watchdog mechanism 'on the fly'.

3) If watchdog_nmi_enable() succeeds to enable PMU counters,
   each CPU will print the message because step1 left behind a
   non-zero cpu0_err.

   if (!IS_ERR(event)) {
       if (cpu == 0 || cpu0_err)
           pr_info("enabled on all CPUs, ...")

The patch avoids this by clearing cpu0_err in watchdog_nmi_disable().

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: pbonzini@redhat.com
Link: http://lkml.kernel.org/r/1407768567-171794-4-git-send-email-dzickus@redhat.com
[ Applied small cleanups. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/watchdog.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4c2e11c..df5494e 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -506,7 +506,10 @@ static void watchdog_nmi_disable(unsigned int cpu)
 		/* should be in cleanup, but blocks oprofile */
 		perf_event_release_kernel(event);
 	}
-	return;
+	if (cpu == 0) {
+		/* watchdog_nmi_enable() expects this to be zero initially. */
+		cpu0_err = 0;
+	}
 }
 #else
 static int watchdog_nmi_enable(unsigned int cpu) { return 0; }
