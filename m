Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaK0XEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:04:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaK0XEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:04:22 -0500
Date: Fri, 28 Nov 2014 00:04:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] oom: kill the insufficient and no longer needed
	PT_TRACE_EXIT check
Message-ID: <20141127230408.GA25100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127230349.GA25075@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous patch we can remove the PT_TRACE_EXIT check in
oom_scan_process_thread(), it was added to handle the case when the
coredumping was "frozen" by ptrace, but it doesn't really work. If
nothing else, we would need to check all threads which could share
the same ->mm to make it more or less correct.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/oom_kill.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7af33b5..a2a4036 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -287,14 +287,9 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task_will_free_mem(task) && !force_kill) {
-		/*
-		 * If this task is not being ptraced on exit, then wait for it
-		 * to finish before killing some other task unnecessarily.
-		 */
-		if (!(task->group_leader->ptrace & PT_TRACE_EXIT))
-			return OOM_SCAN_ABORT;
-	}
+	if (task_will_free_mem(task) && !force_kill)
+		return OOM_SCAN_ABORT;
+
 	return OOM_SCAN_OK;
 }
 
-- 
1.5.5.1

