Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab3E1D4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:56:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52561 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758832Ab3E1DyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.272823052@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [82/94] net_sched: act_ipt forward compat with xtables
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 0dcffd09641f3abb21ac5cabc61542ab289d1a3c ]

Deal with changes in newer xtables while maintaining backward
compatibility. Thanks to Jan Engelhardt for suggestions.

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/act_ipt.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 60f8f61..57827bf 100644
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
@@ -299,17 +299,44 @@ static struct tc_action_ops act_ipt_ops = {
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
 

