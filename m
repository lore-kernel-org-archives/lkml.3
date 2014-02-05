Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbaBEVGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:06:12 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48025 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754279AbaBEUEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:04:54 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 048/213] net_sched: gact: Fix potential panic in tcf_gact().
Date: Wed, 5 Feb 2014 15:00:03 -0500
Message-ID: <1391630568-49251-49-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 696ecdc10622d86541f2e35cc16e15b6b3b1b67e upstream.

gact_rand array is accessed by gact->tcfg_ptype whose value
is assumed to less than MAX_RAND, but any range checks are
not performed.

So add a check in tcf_gact_init(). And in tcf_gact(), we can
reduce a branch.

Signed-off-by: Hiroaki SHIMODA <shimoda.hiroaki@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/sched/act_gact.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index f9fc6ec1fef6..faebd8a6da57 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -67,6 +67,9 @@ static int tcf_gact_init(struct nlattr *nla, struct nlattr *est,
 	struct tcf_common *pc;
 	int ret = 0;
 	int err;
+#ifdef CONFIG_GACT_PROB
+	struct tc_gact_p *p_parm = NULL;
+#endif
 
 	if (nla == NULL)
 		return -EINVAL;
@@ -82,6 +85,12 @@ static int tcf_gact_init(struct nlattr *nla, struct nlattr *est,
 #ifndef CONFIG_GACT_PROB
 	if (tb[TCA_GACT_PROB] != NULL)
 		return -EOPNOTSUPP;
+#else
+	if (tb[TCA_GACT_PROB]) {
+		p_parm = nla_data(tb[TCA_GACT_PROB]);
+		if (p_parm->ptype >= MAX_RAND)
+			return -EINVAL;
+	}
 #endif
 
 	pc = tcf_hash_check(parm->index, a, bind, &gact_hash_info);
@@ -103,8 +112,7 @@ static int tcf_gact_init(struct nlattr *nla, struct nlattr *est,
 	spin_lock_bh(&gact->tcf_lock);
 	gact->tcf_action = parm->action;
 #ifdef CONFIG_GACT_PROB
-	if (tb[TCA_GACT_PROB] != NULL) {
-		struct tc_gact_p *p_parm = nla_data(tb[TCA_GACT_PROB]);
+	if (p_parm) {
 		gact->tcfg_paction = p_parm->paction;
 		gact->tcfg_pval    = p_parm->pval;
 		gact->tcfg_ptype   = p_parm->ptype;
@@ -132,7 +140,7 @@ static int tcf_gact(struct sk_buff *skb, struct tc_action *a, struct tcf_result
 
 	spin_lock(&gact->tcf_lock);
 #ifdef CONFIG_GACT_PROB
-	if (gact->tcfg_ptype && gact_rand[gact->tcfg_ptype] != NULL)
+	if (gact->tcfg_ptype)
 		action = gact_rand[gact->tcfg_ptype](gact);
 	else
 		action = gact->tcf_action;
-- 
1.8.5.2

