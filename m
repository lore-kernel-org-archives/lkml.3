Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036Ab3GSJF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:05:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759928Ab3GSJF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:05:56 -0400
From: Michal Hocko <mhocko@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC 1/2] watchdog: update watchdog attributes atomically
Date: Fri, 19 Jul 2013 11:04:58 +0200
Message-Id: <1374224699-13255-1-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_dowatchdog doesn't synchronize multiple callers which
might lead to confusion when two parallel callers might confuse
watchdog_enable_all_cpus resp. watchdog_disable_all_cpus (e.g. watchdog
gets enabled even if watchdog_thresh was set to 0 already).

This patch adds a local mutex which synchronizes callers to the sysctl
handler.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/watchdog.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 1241d8c..2d64c02 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -520,13 +520,15 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 		    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int err, old_thresh, old_enabled;
+	static DEFINE_MUTEX(watchdog_proc_mutex);
 
+	mutex_lock(&watchdog_proc_mutex);
 	old_thresh = ACCESS_ONCE(watchdog_thresh);
 	old_enabled = ACCESS_ONCE(watchdog_user_enabled);
 
 	err = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
 	if (err || !write)
-		return err;
+		goto out;
 
 	set_sample_period();
 	/*
@@ -544,7 +546,8 @@ int proc_dowatchdog(struct ctl_table *table, int write,
 		watchdog_thresh = old_thresh;
 		watchdog_user_enabled = old_enabled;
 	}
-
+out:
+	mutex_unlock(&watchdog_proc_mutex);
 	return err;
 }
 #endif /* CONFIG_SYSCTL */
-- 
1.8.3.2

