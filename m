Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaFWIoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:44:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55568 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 088/111] net: Move the permission check in sock_diag_put_filterinfo to packet_diag_dump
Date: Mon, 23 Jun 2014 10:32:03 +0200
Message-Id: <4dcecf4ce16a20c210e91a62ae28275418e3ed2c.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit a53b72c83a4216f2eb883ed45a0cbce014b8e62d ]

The permission check in sock_diag_put_filterinfo is wrong, and it is so removed
from it's sources it is not clear why it is wrong.  Move the computation
into packet_diag_dump and pass a bool of the result into sock_diag_filterinfo.

This does not yet correct the capability check but instead simply moves it to make
it clear what is going on.

Reported-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/sock_diag.h | 2 +-
 net/core/sock_diag.c      | 4 ++--
 net/packet/diag.c         | 7 ++++++-
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/sock_diag.h b/include/linux/sock_diag.h
index 302ab805b0bb..46cca4c06848 100644
--- a/include/linux/sock_diag.h
+++ b/include/linux/sock_diag.h
@@ -23,7 +23,7 @@ int sock_diag_check_cookie(void *sk, __u32 *cookie);
 void sock_diag_save_cookie(void *sk, __u32 *cookie);
 
 int sock_diag_put_meminfo(struct sock *sk, struct sk_buff *skb, int attr);
-int sock_diag_put_filterinfo(struct sock *sk,
+int sock_diag_put_filterinfo(bool may_report_filterinfo, struct sock *sk,
 			     struct sk_buff *skb, int attrtype);
 
 #endif
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index 6a7fae228634..c38e7a2b5a8e 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -49,7 +49,7 @@ int sock_diag_put_meminfo(struct sock *sk, struct sk_buff *skb, int attrtype)
 }
 EXPORT_SYMBOL_GPL(sock_diag_put_meminfo);
 
-int sock_diag_put_filterinfo(struct sock *sk,
+int sock_diag_put_filterinfo(bool may_report_filterinfo, struct sock *sk,
 			     struct sk_buff *skb, int attrtype)
 {
 	struct nlattr *attr;
@@ -57,7 +57,7 @@ int sock_diag_put_filterinfo(struct sock *sk,
 	unsigned int len;
 	int err = 0;
 
-	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)) {
+	if (!may_report_filterinfo) {
 		nla_reserve(skb, attrtype, 0);
 		return 0;
 	}
diff --git a/net/packet/diag.c b/net/packet/diag.c
index ec8b6e8a80b1..01cd1ac44ff5 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -127,6 +127,7 @@ static int pdiag_put_fanout(struct packet_sock *po, struct sk_buff *nlskb)
 
 static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 			struct packet_diag_req *req,
+			bool may_report_filterinfo,
 			struct user_namespace *user_ns,
 			u32 portid, u32 seq, u32 flags, int sk_ino)
 {
@@ -171,7 +172,8 @@ static int sk_diag_fill(struct sock *sk, struct sk_buff *skb,
 		goto out_nlmsg_trim;
 
 	if ((req->pdiag_show & PACKET_SHOW_FILTER) &&
-	    sock_diag_put_filterinfo(sk, skb, PACKET_DIAG_FILTER))
+	    sock_diag_put_filterinfo(may_report_filterinfo, sk, skb,
+				     PACKET_DIAG_FILTER))
 		goto out_nlmsg_trim;
 
 	return nlmsg_end(skb, nlh);
@@ -187,9 +189,11 @@ static int packet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	struct packet_diag_req *req;
 	struct net *net;
 	struct sock *sk;
+	bool may_report_filterinfo;
 
 	net = sock_net(skb->sk);
 	req = nlmsg_data(cb->nlh);
+	may_report_filterinfo = ns_capable(net->user_ns, CAP_NET_ADMIN);
 
 	mutex_lock(&net->packet.sklist_lock);
 	sk_for_each(sk, &net->packet.sklist) {
@@ -199,6 +203,7 @@ static int packet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
 			goto next;
 
 		if (sk_diag_fill(sk, skb, req,
+				 may_report_filterinfo,
 				 sk_user_ns(NETLINK_CB(cb->skb).sk),
 				 NETLINK_CB(cb->skb).portid,
 				 cb->nlh->nlmsg_seq, NLM_F_MULTI,
-- 
2.0.0

