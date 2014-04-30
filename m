Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422739AbaD3P23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:28:29 -0400
Received: from old-vorash.stgraber.org ([176.9.111.221]:54812 "EHLO
	smtpout1.stgraber.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422690AbaD3P22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:28:28 -0400
From: =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: Allow tc changes in user namespaces
Date: Wed, 30 Apr 2014 11:25:43 -0400
Message-Id: <1398871543-8435-1-git-send-email-stgraber@ubuntu.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches a few remaining capable(CAP_NET_ADMIN) to ns_capable so
that root in a user namespace may set tc rules inside that namespace.

Signed-off-by: Stéphane Graber <stgraber@ubuntu.com>
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>

---
 net/sched/cls_api.c | 3 ++-
 net/sched/sch_api.c | 8 +++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 8e118af..4c35f4a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -138,7 +138,8 @@ static int tc_ctl_tfilter(struct sk_buff *skb, struct nlmsghdr *n)
 	int err;
 	int tp_created = 0;
 
-	if ((n->nlmsg_type != RTM_GETTFILTER) && !capable(CAP_NET_ADMIN))
+	if ((n->nlmsg_type != RTM_GETTFILTER) &&
+	    !ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 replay:
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index cd81505..fc90bde 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1079,7 +1079,8 @@ static int tc_get_qdisc(struct sk_buff *skb, struct nlmsghdr *n)
 	struct Qdisc *p = NULL;
 	int err;
 
-	if ((n->nlmsg_type != RTM_GETQDISC) && !capable(CAP_NET_ADMIN))
+	if ((n->nlmsg_type != RTM_GETQDISC) &&
+	    !ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	err = nlmsg_parse(n, sizeof(*tcm), tca, TCA_MAX, NULL);
@@ -1146,7 +1147,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n)
 	struct Qdisc *q, *p;
 	int err;
 
-	if (!capable(CAP_NET_ADMIN))
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 replay:
@@ -1486,7 +1487,8 @@ static int tc_ctl_tclass(struct sk_buff *skb, struct nlmsghdr *n)
 	u32 qid;
 	int err;
 
-	if ((n->nlmsg_type != RTM_GETTCLASS) && !capable(CAP_NET_ADMIN))
+	if ((n->nlmsg_type != RTM_GETTCLASS) &&
+	    !ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
 	err = nlmsg_parse(n, sizeof(*tcm), tca, TCA_MAX, NULL);
-- 
1.9.1

