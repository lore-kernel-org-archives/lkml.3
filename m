Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab3APQG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36400 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab3APQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:06:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 147/222] inet_diag: fix oops for IPv4 AF_INET6 TCP SYN-RECV state
Date: Wed, 16 Jan 2013 13:55:47 -0200
Message-Id: <1358351822-7675-148-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neal Cardwell <ncardwell@google.com>

commit 1c95df85ca49640576de2f0a850925957b547b84 upstream.

Fix inet_diag to be aware of the fact that AF_INET6 TCP connections
instantiated for IPv4 traffic and in the SYN-RECV state were actually
created with inet_reqsk_alloc(), instead of inet6_reqsk_alloc(). This
means that for such connections inet6_rsk(req) returns a pointer to a
random spot in memory up to roughly 64KB beyond the end of the
request_sock.

With this bug, for a server using AF_INET6 TCP sockets and serving
IPv4 traffic, an inet_diag user like `ss state SYN-RECV` would lead to
inet_diag_fill_req() causing an oops or the export to user space of 16
bytes of kernel memory as a garbage IPv6 address, depending on where
the garbage inet6_rsk(req) pointed.

Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ipv4/inet_diag.c |   53 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 1bfc104..d780fca 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -44,6 +44,10 @@ struct inet_diag_entry {
 	u16 dport;
 	u16 family;
 	u16 userlocks;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct in6_addr saddr_storage;	/* for IPv4-mapped-IPv6 addresses */
+	struct in6_addr daddr_storage;	/* for IPv4-mapped-IPv6 addresses */
+#endif
 };
 
 #define INET_DIAG_PUT(skb, attrtype, attrlen) \
@@ -586,6 +590,36 @@ static int inet_twsk_diag_dump(struct inet_timewait_sock *tw,
 				   cb->nlh->nlmsg_seq, NLM_F_MULTI, cb->nlh);
 }
 
+/* Get the IPv4, IPv6, or IPv4-mapped-IPv6 local and remote addresses
+ * from a request_sock. For IPv4-mapped-IPv6 we must map IPv4 to IPv6.
+ */
+static inline void inet_diag_req_addrs(const struct sock *sk,
+				       const struct request_sock *req,
+				       struct inet_diag_entry *entry)
+{
+	struct inet_request_sock *ireq = inet_rsk(req);
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (sk->sk_family == AF_INET6) {
+		if (req->rsk_ops->family == AF_INET6) {
+			entry->saddr = inet6_rsk(req)->loc_addr.s6_addr32;
+			entry->daddr = inet6_rsk(req)->rmt_addr.s6_addr32;
+		} else if (req->rsk_ops->family == AF_INET) {
+			ipv6_addr_set_v4mapped(ireq->loc_addr,
+					       &entry->saddr_storage);
+			ipv6_addr_set_v4mapped(ireq->rmt_addr,
+					       &entry->daddr_storage);
+			entry->saddr = entry->saddr_storage.s6_addr32;
+			entry->daddr = entry->daddr_storage.s6_addr32;
+		}
+	} else
+#endif
+	{
+		entry->saddr = &ireq->loc_addr;
+		entry->daddr = &ireq->rmt_addr;
+	}
+}
+
 static int inet_diag_fill_req(struct sk_buff *skb, struct sock *sk,
 			      struct request_sock *req, u32 pid, u32 seq,
 			      const struct nlmsghdr *unlh)
@@ -624,8 +658,10 @@ static int inet_diag_fill_req(struct sk_buff *skb, struct sock *sk,
 	r->idiag_inode = 0;
 #if IS_ENABLED(CONFIG_IPV6)
 	if (r->idiag_family == AF_INET6) {
-		*(struct in6_addr *)r->id.idiag_src = inet6_rsk(req)->loc_addr;
-		*(struct in6_addr *)r->id.idiag_dst = inet6_rsk(req)->rmt_addr;
+		struct inet_diag_entry entry;
+		inet_diag_req_addrs(sk, req, &entry);
+		memcpy(r->id.idiag_src, entry.saddr, sizeof(struct in6_addr));
+		memcpy(r->id.idiag_dst, entry.daddr, sizeof(struct in6_addr));
 	}
 #endif
 	nlh->nlmsg_len = skb_tail_pointer(skb) - b;
@@ -683,18 +719,7 @@ static int inet_diag_dump_reqs(struct sk_buff *skb, struct sock *sk,
 				continue;
 
 			if (bc) {
-				entry.saddr =
-#if IS_ENABLED(CONFIG_IPV6)
-					(entry.family == AF_INET6) ?
-					inet6_rsk(req)->loc_addr.s6_addr32 :
-#endif
-					&ireq->loc_addr;
-				entry.daddr =
-#if IS_ENABLED(CONFIG_IPV6)
-					(entry.family == AF_INET6) ?
-					inet6_rsk(req)->rmt_addr.s6_addr32 :
-#endif
-					&ireq->rmt_addr;
+				inet_diag_req_addrs(sk, req, &entry);
 				entry.dport = ntohs(ireq->rmt_port);
 
 				if (!inet_diag_bc_run(bc, &entry))
-- 
1.7.9.5

