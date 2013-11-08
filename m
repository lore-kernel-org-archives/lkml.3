Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab3KHCQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:16:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34497 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab3KHCQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 15/91] l2tp: Fix build warning with ipv6 disabled.
Date: Thu,  7 Nov 2013 18:14:30 -0800
Message-Id: <1383876946-2396-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 8d8a51e26a6d415e1470759f2cf5f3ee3ee86196 ]

net/l2tp/l2tp_core.c: In function ‘l2tp_verify_udp_checksum’:
net/l2tp/l2tp_core.c:499:22: warning: unused variable ‘tunnel’ [-Wunused-variable]

Create a helper "l2tp_tunnel()" to facilitate this, and as a side
effect get rid of a bunch of unnecessary void pointer casts.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/l2tp/l2tp_core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 8861e9f..02a922c 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -115,6 +115,11 @@ static void l2tp_session_set_header_len(struct l2tp_session *session, int versio
 static void l2tp_tunnel_free(struct l2tp_tunnel *tunnel);
 static void l2tp_tunnel_closeall(struct l2tp_tunnel *tunnel);
 
+static inline struct l2tp_tunnel *l2tp_tunnel(struct sock *sk)
+{
+	return sk->sk_user_data;
+}
+
 static inline struct l2tp_net *l2tp_pernet(struct net *net)
 {
 	BUG_ON(!net);
@@ -517,7 +522,6 @@ out:
 static inline int l2tp_verify_udp_checksum(struct sock *sk,
 					   struct sk_buff *skb)
 {
-	struct l2tp_tunnel *tunnel = (struct l2tp_tunnel *)sk->sk_user_data;
 	struct udphdr *uh = udp_hdr(skb);
 	u16 ulen = ntohs(uh->len);
 	__wsum psum;
@@ -526,7 +530,7 @@ static inline int l2tp_verify_udp_checksum(struct sock *sk,
 		return 0;
 
 #if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family == PF_INET6 && !tunnel->v4mapped) {
+	if (sk->sk_family == PF_INET6 && !l2tp_tunnel(sk)->v4mapped) {
 		if (!uh->check) {
 			LIMIT_NETDEBUG(KERN_INFO "L2TP: IPv6: checksum is 0\n");
 			return 1;
@@ -1271,9 +1275,8 @@ EXPORT_SYMBOL_GPL(l2tp_xmit_skb);
  */
 static void l2tp_tunnel_destruct(struct sock *sk)
 {
-	struct l2tp_tunnel *tunnel;
+	struct l2tp_tunnel *tunnel = l2tp_tunnel(sk);
 
-	tunnel = sk->sk_user_data;
 	if (tunnel == NULL)
 		goto end;
 
@@ -1596,7 +1599,7 @@ int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32
 	}
 
 	/* Check if this socket has already been prepped */
-	tunnel = (struct l2tp_tunnel *)sk->sk_user_data;
+	tunnel = l2tp_tunnel(sk);
 	if (tunnel != NULL) {
 		/* This socket has already been prepped */
 		err = -EBUSY;
-- 
1.8.1.2

