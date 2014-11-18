Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbaKROm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:42:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755003AbaKROKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 135/206] freezer: Do not freeze tasks killed by OOM killer
Date: Tue, 18 Nov 2014 15:08:10 +0100
Message-Id: <a8b7bdeab0c35d96b7acdf94f90c0594d2a50245.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/freezer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index aa6a8aadb911..8f9279b9c6d7 100644
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
2.1.3

