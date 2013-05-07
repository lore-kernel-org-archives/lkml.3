Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238Ab3EGC3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:29:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15985 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab3EGCTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:19:30 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363104000"; 
   d="scan'208";a="7201769"
From: Gao feng <gaofeng@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com, akpm@linux-foundation.org, serge.hallyn@ubuntu.com,
        davem@davemloft.net
Cc: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH RFC 24/48] Audit: xt_AUDIT: Log audit message in proper user namespace
Date: Tue, 7 May 2013 10:20:45 +0800
Message-Id: <1367893269-9308-25-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/07 10:18:29,
	Serialize complete at 2013/05/07 10:18:29
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we can log audit message in the user namespace which
netfilter xt_AUDIT rules belongs to.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 net/netfilter/xt_AUDIT.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 3228d7f..b1ffba2 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -122,12 +122,14 @@ static unsigned int
 audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_audit_info *info = par->targinfo;
+	struct net *net = dev_net(par->in ? par->in : par->out);
+	struct user_namespace *ns = net->user_ns;
 	struct audit_buffer *ab;
 
-	if (audit_enabled == 0)
+	if (audit_enabled_ns(ns) == 0)
 		goto errout;
 
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+	ab = audit_log_start_ns(ns, NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
 		goto errout;
 
@@ -172,7 +174,7 @@ audit_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		audit_log_secctx(ab, skb->secmark);
 #endif
 
-	audit_log_end(ab);
+	audit_log_end_ns(ns, ab);
 
 errout:
 	return XT_CONTINUE;
-- 
1.8.1.4

