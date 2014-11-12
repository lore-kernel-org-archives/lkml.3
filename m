Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaKLS73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:59:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbaKLS7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:59:01 -0500
From: Michal Hocko <mhocko@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: <linux-mm@kvack.org>, linux-pm@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [RFC 4/4] OOM: thaw the OOM victim if it is frozen
Date: Wed, 12 Nov 2014 19:58:52 +0100
Message-Id: <1415818732-27712-5-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415818732-27712-1-git-send-email-mhocko@suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1415818732-27712-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oom_kill_process only sets TIF_MEMDIE flag and sends a signal to the
victim. This is basically noop when the task is frozen though because
the task sleeps in uninterruptible sleep. The victim is eventually
thawed later when oom_scan_process_thread meets the task again in a
later OOM invocation so the OOM killer doesn't live lock. But this is
less than optimal. Let's add the frozen check and thaw the task right
before we send SIGKILL to the victim.

The check and thawing in oom_scan_process_thread has to stay because the
task might got access to memory reserves even without an explicit
SIGKILL from oom_kill_process (e.g. it already has fatal signal pending
or it is exiting already).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/oom_kill.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 39a591092ca0..67ea7fb70fa4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -511,6 +511,8 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	rcu_read_unlock();
 
 	set_tsk_thread_flag(victim, TIF_MEMDIE);
+	if (frozen(victim))
+		__thaw_task(victim);
 	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, victim, true);
 	put_task_struct(victim);
 }
-- 
2.1.1

