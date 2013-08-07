Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab3HGKWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:22:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55306 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932404Ab3HGKVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:21:01 -0400
X-IronPort-AV: E=Sophos;i="4.89,832,1367942400"; 
   d="scan'208";a="8143905"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: [PATCH 2/8] rcu: remove irq/softirq context check in rcu_read_unlock_special()
Date: Wed, 7 Aug 2013 18:24:58 +0800
Message-Id: <1375871104-10688-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/07 18:19:36,
	Serialize complete at 2013/08/07 18:19:36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After patch 10f39bb1, "special & RCU_READ_UNLOCK_BLOCKED" can't be true
in irq nor softirq.(due to RCU_READ_UNLOCK_BLOCKED can only be set
when preemption)

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/rcutree_plugin.h |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 8fd947e..54f7e45 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -361,12 +361,6 @@ void rcu_read_unlock_special(struct task_struct *t)
 		rcu_preempt_qs(smp_processor_id());
 	}
 
-	/* Hardware IRQ handlers cannot block. */
-	if (in_irq() || in_serving_softirq()) {
-		local_irq_restore(flags);
-		return;
-	}
-
 	/* Clean up if blocked during RCU read-side critical section. */
 	if (special & RCU_READ_UNLOCK_BLOCKED) {
 		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
-- 
1.7.4.4

