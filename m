Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3HGKWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:22:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab3HGKVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:21:02 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8143907"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH 6/8] rcu: call rcu_read_unlock_special() in rcu_preempt_check_callbacks()
Date: Wed, 7 Aug 2013 18:25:02 +0800
Message-Id: <1375871104-10688-7-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:36,
	Serialize complete at 2013/08/07 18:19:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if rcu_read_unlock_special() is deferred, we can invoke it earlier
in the schedule-tick.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcutree_plugin.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 997b424..c9ff9f1 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -684,8 +684,11 @@ static void rcu_preempt_check_callbacks(int cpu)
 {
 	struct task_struct *t = current;
 
-	if (t->rcu_read_lock_nesting == 0) {
+	if (t->rcu_read_lock_nesting == 0 ||
+	    t->rcu_read_lock_nesting == INT_MIN) {
 		rcu_preempt_qs(cpu);
+		if (t->rcu_read_unlock_special)
+			rcu_read_unlock_special(t, false);
 		return;
 	}
 	if (t->rcu_read_lock_nesting > 0 &&
-- 
1.7.4.4

