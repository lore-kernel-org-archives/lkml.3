Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbaDRR1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:27:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556AbaDRR1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:27:13 -0400
Date: Fri, 18 Apr 2014 19:26:53 +0200
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
Subject: [PATCH 1/2] memcg: mm_update_next_owner() should skip kthreads
Message-ID: <20140418172653.GB13323@redhat.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com> <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com> <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com> <20140416135741.GA9407@redhat.com> <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com> <20140418162359.GA4398@redhat.com> <20140418172631.GA13323@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418172631.GA13323@redhat.com>
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


