Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaKLS7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:59:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbaKLS7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:59:01 -0500
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [RFC 3/4] OOM, PM: handle pm freezer as an OOM victim correctly
Date: Wed, 12 Nov 2014 19:58:51 +0100
Message-Id: <1415818732-27712-4-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415818732-27712-1-git-send-email-mhocko@suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1415818732-27712-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM freezer doesn't check whether it has been killed by OOM killer
after it disables OOM killer which means that it continues with the
suspend even though it should die as soon as possible. This has been
the case ever since PM suspend disables OOM killer and I suppose
it has ignored OOM even before.

This is not harmful though. The allocation which triggers OOM will
retry the allocation after a process is killed and the next attempt
will fail because the OOM killer will be disabled at the time so
there is no risk of an endless loop because the OOM victim doesn't
die.

But this is a correctness issue because no task should ignore OOM.
As suggested by Tejun, oom_killer_lock will return a success status
now. If the current task is pending fatal signals or TIF_MEMDIE is set
after oom_sem is taken then the caller should bail out and this is what
freeze_processes does with this patch.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/oom.h    |  5 ++++-
 kernel/power/process.c |  5 ++++-
 mm/oom_kill.c          | 12 +++++++++++-
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 8ca73c0b07df..8f4f634cc5b3 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -92,10 +92,13 @@ extern void oom_killer_enable(void);
 
 /** oom_killer_lock - locks global OOM killer.
  *
+ * Returns true on success and fails if the OOM killer couldn't be
+ * locked (e.g. because the current task has been killed before).
+ *
  * This function should be used with an extreme care. No allocations
  * are allowed with the lock held.
  */
-extern void oom_killer_lock(void);
+extern bool oom_killer_lock(void);
 
 /** oom_killer_unlock - unlocks global OOM killer.
  */
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 5c5da0fe54dd..49d8d84ccd6e 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -127,7 +127,10 @@ int freeze_processes(void)
 	 * getting frozen to make sure none of them gets killed after
 	 * try_to_freeze_tasks is done.
 	 */
-	oom_killer_lock()
+	if (!oom_killer_lock()) {
+		usermodehelper_enable();
+		return -EBUSY;
+	}
 
 	/* Make sure this task doesn't get frozen */
 	current->flags |= PF_SUSPEND_TASK;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0a061803be09..39a591092ca0 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -601,9 +601,19 @@ void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
 bool oom_killer_disabled __read_mostly;
 static DECLARE_RWSEM(oom_sem);
 
-void oom_killer_lock(void)
+bool oom_killer_lock(void)
 {
+	bool ret = true;
+
 	down_write(&oom_sem);
+
+	/* We might have been killed while waiting for the oom_sem. */
+	if (fatal_signal_pending(current) || test_thread_flag(TIF_MEMDIE)) {
+		up_write(&oom_sem);
+		ret = false;
+	}
+
+	return ret;
 }
 
 void oom_killer_unlock(void)
-- 
2.1.1

