Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaD1PUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:20:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375AbaD1PTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:19:55 -0400
Date: Mon, 28 Apr 2014 17:19:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Peter Chiang <pchiang@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/3] memcg: mm_update_next_owner() should skip
	kthreads
Message-ID: <20140428151941.GA20747@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428151926.GA20729@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Search through everything else" in mm_update_next_owner() can
hit a kthread which adopted this "mm" via use_mm(), it should
not be used as mm->owner. Add the PF_KTHREAD check.

While at it, change this code to use for_each_process_thread()
instead of deprecated do_each_thread/while_each_thread.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/exit.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index ad7183a..e270d2a 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -356,14 +356,12 @@ retry:
 	}
 
 	/*
-	 * Search through everything else. We should not get
-	 * here often
+	 * Search through everything else, we should not get here often.
 	 */
-	do_each_thread(g, c) {
-		if (c->mm == mm)
+	for_each_process_thread(g, c) {
+		if (!(c->flags & PF_KTHREAD) && c->mm == mm)
 			goto assign_new_owner;
-	} while_each_thread(g, c);
-
+	}
 	read_unlock(&tasklist_lock);
 	/*
 	 * We found no owner yet mm_users > 1: this implies that we are
-- 
1.5.5.1

