Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaKDQU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:20:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbaKDQUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:20:49 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        uobergfe@redhat.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 4/9] watchdog: introduce the proc_watchdog_common() function
Date: Tue,  4 Nov 2014 11:20:19 -0500
Message-Id: <1415118024-194247-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
References: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

Three of four handlers for the watchdog parameters in /proc/sys/kernel
essentially have to do the same thing.

  if the parameter is being read {
    return the state of the corresponding bit(s) in 'watchdog_enabled'
  } else {
    set/clear the state of the corresponding bit(s) in 'watchdog_enabled'
    update the run state of the lockup detector(s)
  }

Hence, introduce a common function that can be called by those handlers.
The callers pass a 'bit mask' to this function to indicate which bit(s)
should be set/cleared in 'watchdog_enabled'.

This function handles an uncommon race with watchdog_nmi_enable() where
a concurrent update of 'watchdog_enabled' is possible. We use 'cmpxchg'
to detect the concurrency. [This avoids introducing a new spinlock or a
mutex to synchronize updates of 'watchdog_enabled'. Using the same lock
or mutex in watchdog thread context and in system call context needs to
be considered carefully because it can make the code prone to deadlock
situations in connection with parking/unparking the watchdog threads.]

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index df4ef38..7626208 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -704,6 +704,71 @@ static int proc_watchdog_update(void)
 static DEFINE_MUTEX(watchdog_proc_mutex);
 
 /*
+ * common function for watchdog, nmi_watchdog and soft_watchdog parameter
+ *
+ * caller             | table->data points to | 'which' contains the flag(s)
+ * -------------------|-----------------------|-----------------------------
+ * proc_watchdog      | watchdog_user_enabled | NMI_WATCHDOG_ENABLED or'ed
+ *                    |                       | with SOFT_WATCHDOG_ENABLED
+ * -------------------|-----------------------|-----------------------------
+ * proc_nmi_watchdog  | nmi_watchdog_enabled  | NMI_WATCHDOG_ENABLED
+ * -------------------|-----------------------|-----------------------------
+ * proc_soft_watchdog | soft_watchdog_enabled | SOFT_WATCHDOG_ENABLED
+ */
+static int proc_watchdog_common(int which, struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int err, old, new;
+	int *watchdog_param = (int *)table->data;
+
+	mutex_lock(&watchdog_proc_mutex);
+
+	/*
+	 * If the parameter is being read return the state of the corresponding
+	 * bit(s) in 'watchdog_enabled', else update 'watchdog_enabled' and the
+	 * run state of the lockup detectors.
+	 */
+	if (!write) {
+		*watchdog_param = (watchdog_enabled & which) != 0;
+		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+	} else {
+		err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+		if (err)
+			goto out;
+
+		/*
+		 * There is a race window between fetching the current value
+		 * from 'watchdog_enabled' and storing the new value. During
+		 * this race window, watchdog_nmi_enable() can sneak in and
+		 * clear the NMI_WATCHDOG_ENABLED bit in 'watchdog_enabled'.
+		 * The 'cmpxchg' detects this race and the loop retries.
+		 */
+		do {
+			old = watchdog_enabled;
+			/*
+			 * If the parameter value is not zero set the
+			 * corresponding bit(s), else clear it(them).
+			 */
+			if (*watchdog_param)
+				new = old | which;
+			else
+				new = old & ~which;
+		} while (cmpxchg(&watchdog_enabled, old, new) != old);
+
+		/*
+		 * Update the run state of the lockup detectors.
+		 * Restore 'watchdog_enabled' on failure.
+		 */
+		err = proc_watchdog_update();
+		if (err)
+			watchdog_enabled = old;
+	}
+out:
+	mutex_unlock(&watchdog_proc_mutex);
+	return err;
+}
+
+/*
  * proc handler for /proc/sys/kernel/nmi_watchdog,watchdog_thresh
  */
 
-- 
1.7.1

