Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbaKDQVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:21:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbaKDQUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:20:51 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        uobergfe@redhat.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/9] watchdog: introduce the proc_watchdog_update() function
Date: Tue,  4 Nov 2014 11:20:17 -0500
Message-Id: <1415118024-194247-3-git-send-email-dzickus@redhat.com>
In-Reply-To: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
References: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

This series introduces a separate handler for each watchdog parameter
in /proc/sys/kernel. The separate handlers need a common function that
they can call to update the run state of the lockup detectors, or to
have the lockup detectors use a new sample period.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 91e7bff..dcf28b2 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -679,6 +679,29 @@ static void watchdog_disable_all_cpus(void)
 }
 
 /*
+ * Update the run state of the lockup detectors.
+ */
+static int proc_watchdog_update(void)
+{
+	int err = 0;
+
+	/*
+	 * Watchdog threads won't be started if they are already active.
+	 * The 'watchdog_running' variable in watchdog_*_all_cpus() takes
+	 * care of this. If those threads are already active, the sample
+	 * period will be updated and the lockup detectors will be enabled
+	 * or disabled 'on the fly'.
+	 */
+	if (watchdog_enabled && watchdog_thresh)
+		err = watchdog_enable_all_cpus(true);
+	else
+		watchdog_disable_all_cpus();
+
+	return err;
+
+}
+
+/*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
 
-- 
1.7.1

