Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaKFWna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:43:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58983 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKFWnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:23 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 084/162] freezer: Do not freeze tasks killed by OOM killer
Date: Thu,  6 Nov 2014 14:35:48 -0800
Message-Id: <1415313426-9622-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 51fae6da640edf9d266c94f36bc806c63c301991 upstream.

Since f660daac474c6f (oom: thaw threads if oom killed thread is frozen
before deferring) OOM killer relies on being able to thaw a frozen task
to handle OOM situation but a3201227f803 (freezer: make freezing() test
freeze conditions in effect instead of TIF_FREEZE) has reorganized the
code and stopped clearing freeze flag in __thaw_task. This means that
the target task only wakes up and goes into the fridge again because the
freezing condition hasn't changed for it. This reintroduces the bug
fixed by f660daac474c6f.

Fix the issue by checking for TIF_MEMDIE thread flag in
freezing_slow_path and exclude the task from freezing completely. If a
task was already frozen it would get woken by __thaw_task from OOM killer
and get out of freezer after rechecking freezing().

Changes since v1
- put TIF_MEMDIE check into freezing_slowpath rather than in __refrigerator
  as per Oleg
- return __thaw_task into oom_scan_process_thread because
  oom_kill_process will not wake task in the fridge because it is
  sleeping uninterruptible

[mhocko@suse.cz: rewrote the changelog]
Fixes: a3201227f803 (freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE)
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/freezer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index aa6a8aa..8f9279b 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -42,6 +42,9 @@ bool freezing_slow_path(struct task_struct *p)
 	if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
 		return false;
 
+	if (test_thread_flag(TIF_MEMDIE))
+		return false;
+
 	if (pm_nosig_freezing || cgroup_freezing(p))
 		return true;
 
-- 
1.9.1

