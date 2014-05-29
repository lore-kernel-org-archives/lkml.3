Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbaE2QQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:16:31 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:33591 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757425AbaE2QQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:16:26 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 05/10] mm: memcontrol: catch root bypass in move precharge
Date: Thu, 29 May 2014 12:15:57 -0400
Message-Id: <1401380162-24121-6-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
References: <1401380162-24121-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mem_cgroup_try_charge() returns -EINTR, it bypassed the charge to
the root memcg.  But move precharging does not catch this and treats
this case as if no charge had happened, thus leaking a charge against
root.  Because of an old optimization, the root memcg's res_counter is
not actually charged right now, but it's still an imbalance and
subsequent patches will charge the root memcg again.

Catch those bypasses to the root memcg and properly cancel them before
giving up the move.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8957d6c945b8..184e67cce4e4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6485,8 +6485,15 @@ one_by_one:
 			cond_resched();
 		}
 		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
+		/*
+		 * In case of failure, any residual charges against
+		 * mc.to will be dropped by mem_cgroup_clear_mc()
+		 * later on.  However, cancel any charges that are
+		 * bypassed to root right away or they'll be lost.
+		 */
+		if (ret == -EINTR)
+			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
 		if (ret)
-			/* mem_cgroup_clear_mc() will do uncharge later */
 			return ret;
 		mc.precharge++;
 	}
-- 
1.9.3

