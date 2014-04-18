Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaDRR1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:27:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbaDRR11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:27:27 -0400
Date: Fri, 18 Apr 2014 19:27:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc: "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] memcg: optimize the "Search everything else" loop in
	mm_update_next_owner()
Message-ID: <20140418172714.GC13323@redhat.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com> <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com> <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com> <20140416135741.GA9407@redhat.com> <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com> <20140418162359.GA4398@redhat.com> <20140418172631.GA13323@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418172631.GA13323@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for_each_process_thread() is sub-optimal. All threads share the same
->mm, we can swicth to the next process once we found a thread with
->mm != NULL and ->mm != mm.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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


