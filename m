Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3JCEJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:09:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3JCEI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:08:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [ 14/16] mm, memcg: give exiting processes access to memory reserves
Date: Wed,  2 Oct 2013 21:05:38 -0700
Message-Id: <20131003040446.510032417@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040445.523176877@linuxfoundation.org>
References: <20131003040445.523176877@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: David Rientjes <rientjes@google.com>

commit 465adcf1ea7b2e49b2e0899366624f5532b64012

A memcg may livelock when oom if the process that grabs the hierarchy's
oom lock is never the first process with PF_EXITING set in the memcg's
task iteration.

The oom killer, both global and memcg, will defer if it finds an
eligible process that is in the process of exiting and it is not being
ptraced.  The idea is to allow it to exit without using memory reserves
before needlessly killing another process.

This normally works fine except in the memcg case with a large number of
threads attached to the oom memcg.  In this case, the memcg oom killer
only gets called for the process that grabs the hierarchy's oom lock;
all others end up blocked on the memcg's oom waitqueue.  Thus, if the
process that grabs the hierarchy's oom lock is never the first
PF_EXITING process in the memcg's task iteration, the oom killer is
constantly deferred without anything making progress.

The fix is to give PF_EXITING processes access to memory reserves so
that we've marked them as oom killed without any iteration.  This allows
__mem_cgroup_try_charge() to succeed so that the process may exit.  This
makes the memcg oom killer exemption for TIF_MEMDIE tasks, now
immediately granted for processes with pending SIGKILLs and those in the
exit path, to be equivalent to what is done for the global oom killer.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[Qiang: backported to 3.4:
 - move the changes from memcontrol.c to oom_kill.c]
Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/oom_kill.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -562,11 +562,11 @@ void mem_cgroup_out_of_memory(struct mem
 	struct task_struct *p;
 
 	/*
-	 * If current has a pending SIGKILL, then automatically select it.  The
-	 * goal is to allow it to allocate so that it may quickly exit and free
-	 * its memory.
+	 * If current has a pending SIGKILL or is exiting, then automatically
+	 * select it.  The goal is to allow it to allocate so that it may
+	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current)) {
+	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}


