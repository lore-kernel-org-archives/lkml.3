Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaJUH3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 03:29:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43412 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbaJUH1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 03:27:35 -0400
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 1/4] freezer: Do not freeze tasks killed by OOM killer
Date: Tue, 21 Oct 2014 09:27:12 +0200
Message-Id: <1413876435-11720-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

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
Cc: stable@vger.kernel.org # 3.3+
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Oleg Nesterov <oleg@redhat.com>
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
2.1.1

