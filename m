Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbbAMH3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:29:52 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:21441 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751390AbbAMH3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:29:50 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="55970501"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] rcu_tree: avoid touch rnp->completed when starts a new GP
Date: Tue, 13 Jan 2015 15:30:34 +0800
Message-ID: <1421134234-3418-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rcu_gp_init(), rnp->completed equals to rsp->completed in THEORY,
we don't need to touch it normally.  If something goes wrong,
it will complain and fixup rnp->completed and avoid oops.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcu/tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 7680fc2..ea6dc28 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1639,8 +1639,8 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		ACCESS_ONCE(rnp->gpnum) = rsp->gpnum;
-		WARN_ON_ONCE(rnp->completed != rsp->completed);
-		ACCESS_ONCE(rnp->completed) = rsp->completed;
+		if (WARN_ON_ONCE(rnp->completed != rsp->completed))
+			ACCESS_ONCE(rnp->completed) = rsp->completed;
 		if (rnp == rdp->mynode)
 			(void)__note_gp_changes(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
-- 
2.1.0

