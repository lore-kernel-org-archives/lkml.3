Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaFPT5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:57:01 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:36730 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbaFPTzL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:55:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 07/12] mm: memcontrol: catch root bypass in move precharge
Date: Mon, 16 Jun 2014 15:54:27 -0400
Message-Id: <1402948472-8175-8-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
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
Acked-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3d9df94896a7..a3b69d4a6f17 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6389,6 +6389,10 @@ static int mem_cgroup_do_precharge(unsigned long count)
 		mc.precharge += count;
 		return ret;
 	}
+	if (ret == -EINTR) {
+		__mem_cgroup_cancel_charge(root_mem_cgroup, count);
+		return ret;
+	}
 
 	/* Try charges one by one with reclaim */
 	while (count--) {
@@ -6396,8 +6400,11 @@ static int mem_cgroup_do_precharge(unsigned long count)
 		/*
 		 * In case of failure, any residual charges against
 		 * mc.to will be dropped by mem_cgroup_clear_mc()
-		 * later on.
+		 * later on.  However, cancel any charges that are
+		 * bypassed to root right away or they'll be lost.
 		 */
+		if (ret == -EINTR)
+			__mem_cgroup_cancel_charge(root_mem_cgroup, 1);
 		if (ret)
 			return ret;
 		mc.precharge++;
-- 
2.0.0

