Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104Ab3E1VbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:31:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59782 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357Ab3E1VZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 64/78] net_sched: act_ipt forward compat with xtables
Date: Tue, 28 May 2013 14:20:13 -0700
Message-Id: <1369776027-17859-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 0dcffd09641f3abb21ac5cabc61542ab289d1a3c ]

Deal with changes in newer xtables while maintaining backward
compatibility. Thanks to Jan Engelhardt for suggestions.

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/sched/act_ipt.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 58fb3c7..c1a8138 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -8,7 +8,7 @@
  *		as published by the Free Software Foundation; either version
  *		2 of the License, or (at your option) any later version.
  *
- * Copyright:	Jamal Hadi Salim (2002-4)
+ * Copyright:	Jamal Hadi Salim (2002-13)
  */
 
 #include <linux/types.h>
@@ -305,17 +305,44 @@ static struct tc_action_ops act_ipt_ops = {
 	.walk		=	tcf_generic_walker
 };
 
-MODULE_AUTHOR("Jamal Hadi Salim(2002-4)");
+static struct tc_action_ops act_xt_ops = {
+	.kind		=	"xt",
+	.hinfo		=	&ipt_hash_info,
+	.type		=	TCA_ACT_IPT,
+	.capab		=	TCA_CAP_NONE,
+	.owner		=	THIS_MODULE,
+	.act		=	tcf_ipt,
+	.dump		=	tcf_ipt_dump,
+	.cleanup	=	tcf_ipt_cleanup,
+	.lookup		=	tcf_hash_search,
+	.init		=	tcf_ipt_init,
+	.walk		=	tcf_generic_walker
+};
+
+MODULE_AUTHOR("Jamal Hadi Salim(2002-13)");
 MODULE_DESCRIPTION("Iptables target actions");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("act_xt");
 
 static int __init ipt_init_module(void)
 {
-	return tcf_register_action(&act_ipt_ops);
+	int ret1, ret2;
+	ret1 = tcf_register_action(&act_xt_ops);
+	if (ret1 < 0)
+		printk("Failed to load xt action\n");
+	ret2 = tcf_register_action(&act_ipt_ops);
+	if (ret2 < 0)
+		printk("Failed to load ipt action\n");
+
+	if (ret1 < 0 && ret2 < 0)
+		return ret1;
+	else
+		return 0;
 }
 
 static void __exit ipt_cleanup_module(void)
 {
+	tcf_unregister_action(&act_xt_ops);
 	tcf_unregister_action(&act_ipt_ops);
 }
 
-- 
1.8.1.2

