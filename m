Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbbA1FB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:01:26 -0500
Received: from mail.kernel.org ([198.145.29.136]:39159 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933978AbbA1EUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:20:18 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 070/177] freezer: Do not freeze tasks killed by OOM killer
Date: Wed, 28 Jan 2015 12:08:27 +0800
Message-Id: <1422418236-12852-140-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/freezer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 11f82a4..2f8ecd9 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -36,6 +36,9 @@ bool freezing_slow_path(struct task_struct *p)
 	if (p->flags & PF_NOFREEZE)
 		return false;
 
+	if (test_thread_flag(TIF_MEMDIE))
+		return false;
+
 	if (pm_nosig_freezing || cgroup_freezing(p))
 		return true;
 
-- 
1.9.1

