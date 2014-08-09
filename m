Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaHIAq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:46:56 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39980 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbaHIAqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:46:54 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] freezer: check OOM kill signal while being frozen
Date: Fri,  8 Aug 2014 17:46:38 -0700
Message-Id: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a race condition between OOM killer and freezer when
they try to operate on the same process, something like below:

	Process A	Process B		Process C
trigger oom
B=oom_scan_process_thread()
					cgroup_freezer_freeze(B)
			...
			try_to_freeze()
			stay in D state
oom_kill_process(B)

In this case, process A triggers OOM and kernel selects process B
as the victim, right before being killed process B was frozen by
process C therefore went to D state, then kernel sent SIGKILL but
it is already too late as process B will never care about pending
signals any more. Fix this straightly by checking fatal pending signal
from OOM killer, so that the frozen process will recover itself
and then be killed finally.

Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
diff --git a/kernel/freezer.c b/kernel/freezer.c
index aa6a8aa..c6d189d 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -68,7 +68,9 @@ bool __refrigerator(bool check_kthr_stop)
 		spin_lock_irq(&freezer_lock);
 		current->flags |= PF_FROZEN;
 		if (!freezing(current) ||
-		    (check_kthr_stop && kthread_should_stop()))
+		    (check_kthr_stop && kthread_should_stop()) ||
+		    (test_tsk_thread_flag(current, TIF_MEMDIE) &&
+			 fatal_signal_pending(current)))
 			current->flags &= ~PF_FROZEN;
 		spin_unlock_irq(&freezer_lock);
 
