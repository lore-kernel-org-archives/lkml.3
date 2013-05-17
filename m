Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3EQWNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:13:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab3EQVhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 060/102] net_sched: act_ipt forward compat with xtables
Date: Fri, 17 May 2013 14:36:15 -0700
Message-Id: <20130517213250.699107251@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 0dcffd09641f3abb21ac5cabc61542ab289d1a3c ]

Deal with changes in newer xtables while maintaining backward
compatibility. Thanks to Jan Engelhardt for suggestions.

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ipt.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

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
@@ -303,17 +303,44 @@ static struct tc_action_ops act_ipt_ops
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
 


