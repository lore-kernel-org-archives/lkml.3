Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750968Ab3HSPgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:36:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4965 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3HSPgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:36:20 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=rUDy6mxvJUUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WBYz-hhrmcAA:10 a=VnNF1IyMAAAA:8 a=OABYoLltPhgSIxiDJQYA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130819153618.854174262@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 11:35:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RT 1/3] rcu/swait: Fix RCU conversion of wake_up_all() to swait_wake()
References: <20130819153530.409041534@goodmis.org>
Content-Disposition: inline; filename=0001-rcu-swait-Fix-RCU-conversion-of-wake_up_all-to-swait.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Reverting the rcu swait patches fixed the boot problem. Then when I was
looking at the revert itself, this stood out like a sore thumb.

 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp) {
-       swait_wake(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
+       wake_up_all(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
 }

See the problem there?

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutree_plugin.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 684b762..dc0c4b2 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2036,7 +2036,7 @@ static int rcu_nocb_needs_gp(struct rcu_state *rsp)
  */
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 {
-	swait_wake(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
+	swait_wake_all(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
 }
 
 /*
-- 
1.7.10.4


