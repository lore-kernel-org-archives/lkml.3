Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaD1PVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:21:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376AbaD1PT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:19:57 -0400
Date: Mon, 28 Apr 2014 17:19:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <bsingharora@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Peter Chiang <pchiang@nvidia.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 2/3] memcg: optimize the "Search everything else"
	loop in mm_update_next_owner()
Message-ID: <20140428151944.GA20750@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428151926.GA20729@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for_each_process_thread() is sub-optimal. All threads share the same
->mm, we can swicth to the next process once we found a thread with
->mm != NULL and ->mm != mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/exit.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index e270d2a..429659c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -358,9 +358,15 @@ retry:
 	/*
 	 * Search through everything else, we should not get here often.
 	 */
-	for_each_process_thread(g, c) {
-		if (!(c->flags & PF_KTHREAD) && c->mm == mm)
-			goto assign_new_owner;
+	for_each_process(g) {
+		if (g->flags & PF_KTHREAD)
+			continue;
+		for_each_thread(g, c) {
+			if (c->mm == mm)
+				goto assign_new_owner;
+			if (c->mm)
+				break;
+		}
 	}
 	read_unlock(&tasklist_lock);
 	/*
-- 
1.5.5.1

