Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab3J1GEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:04:46 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37191 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab3J1GEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:04:44 -0400
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, stephen@networkplumber.org,
        davem@davemloft.net, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v2 1/3] vxlan: silence one build warning
Date: Mon, 28 Oct 2013 14:01:48 +0800
Message-Id: <1382940110-10737-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102806-9332-0000-0000-000001F23AAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

drivers/net/vxlan.c: In function ‘vxlan_sock_add’:
drivers/net/vxlan.c:2298:11: warning: ‘sock’ may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/net/vxlan.c:2275:17: note: ‘sock’ was declared here
  LD      drivers/net/built-in.o

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 drivers/net/vxlan.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 2ef5b62..019e1f4 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2180,7 +2180,7 @@ static void vxlan_del_work(struct work_struct *work)
  * could be used for both IPv4 and IPv6 communications, but
  * users may set bindv6only=1.
  */
-static int create_v6_sock(struct net *net, __be16 port, struct socket **psock)
+static struct socket *create_v6_sock(struct net *net, __be16 port)
 {
 	struct sock *sk;
 	struct socket *sock;
@@ -2193,7 +2193,7 @@ static int create_v6_sock(struct net *net, __be16 port, struct socket **psock)
 	rc = sock_create_kern(AF_INET6, SOCK_DGRAM, IPPROTO_UDP, &sock);
 	if (rc < 0) {
 		pr_debug("UDPv6 socket create failed\n");
-		return rc;
+		return ERR_PTR(rc);
 	}
 
 	/* Put in proper namespace */
@@ -2208,28 +2208,27 @@ static int create_v6_sock(struct net *net, __be16 port, struct socket **psock)
 		pr_debug("bind for UDPv6 socket %pI6:%u (%d)\n",
 			 &vxlan_addr.sin6_addr, ntohs(vxlan_addr.sin6_port), rc);
 		sk_release_kernel(sk);
-		return rc;
+		return ERR_PTR(rc);
 	}
 	/* At this point, IPv6 module should have been loaded in
 	 * sock_create_kern().
 	 */
 	BUG_ON(!ipv6_stub);
 
-	*psock = sock;
 	/* Disable multicast loopback */
 	inet_sk(sk)->mc_loop = 0;
-	return 0;
+	return sock;
 }
 
 #else
 
-static int create_v6_sock(struct net *net, __be16 port, struct socket **psock)
+static struct socket *create_v6_sock(struct net *net, __be16 port)
 {
-		return -EPFNOSUPPORT;
+		return ERR_PTR(-EPFNOSUPPORT);
 }
 #endif
 
-static int create_v4_sock(struct net *net, __be16 port, struct socket **psock)
+static struct socket *create_v4_sock(struct net *net, __be16 port)
 {
 	struct sock *sk;
 	struct socket *sock;
@@ -2244,7 +2243,7 @@ static int create_v4_sock(struct net *net, __be16 port, struct socket **psock)
 	rc = sock_create_kern(AF_INET, SOCK_DGRAM, IPPROTO_UDP, &sock);
 	if (rc < 0) {
 		pr_debug("UDP socket create failed\n");
-		return rc;
+		return ERR_PTR(rc);
 	}
 
 	/* Put in proper namespace */
@@ -2257,13 +2256,12 @@ static int create_v4_sock(struct net *net, __be16 port, struct socket **psock)
 		pr_debug("bind for UDP socket %pI4:%u (%d)\n",
 			 &vxlan_addr.sin_addr, ntohs(vxlan_addr.sin_port), rc);
 		sk_release_kernel(sk);
-		return rc;
+		return ERR_PTR(rc);
 	}
 
-	*psock = sock;
 	/* Disable multicast loopback */
 	inet_sk(sk)->mc_loop = 0;
-	return 0;
+	return sock;
 }
 
 /* Create new listen socket if needed */
@@ -2274,7 +2272,6 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, __be16 port,
 	struct vxlan_sock *vs;
 	struct socket *sock;
 	struct sock *sk;
-	int rc = 0;
 	unsigned int h;
 
 	vs = kmalloc(sizeof(*vs), GFP_KERNEL);
@@ -2287,12 +2284,12 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, __be16 port,
 	INIT_WORK(&vs->del_work, vxlan_del_work);
 
 	if (ipv6)
-		rc = create_v6_sock(net, port, &sock);
+		sock = create_v6_sock(net, port);
 	else
-		rc = create_v4_sock(net, port, &sock);
-	if (rc < 0) {
+		sock = create_v4_sock(net, port);
+	if (IS_ERR(sock)) {
 		kfree(vs);
-		return ERR_PTR(rc);
+		return ERR_PTR(PTR_ERR(sock));
 	}
 
 	vs->sock = sock;
-- 
1.7.11.7

