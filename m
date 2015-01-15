Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbbAORuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:50:12 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34159 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbbAORuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:50:10 -0500
From: =?UTF-8?q?Rafa=C5=82=20Krypa?= <rafal@krypa.net>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafal Krypa <r.krypa@samsung.com>
Subject: [PATCH] Smack: Don't build IPv6 stuff when CONFIG_IPV6=n
Date: Thu, 15 Jan 2015 18:49:57 +0100
Message-Id: <1421344197-25256-1-git-send-email-rafal@krypa.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafal Krypa <r.krypa@samsung.com>

For case when IPv6 is disabled, this fixes build break in one place and removes
unused code in several other places.

Signed-off-by: Rafal Krypa <r.krypa@samsung.com>
---
 security/smack/smack_lsm.c | 46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index a688f7b..6fe7c6e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -52,9 +52,9 @@
 #define SMK_RECEIVING	1
 #define SMK_SENDING	2
 
-#ifndef CONFIG_SECURITY_SMACK_NETFILTER
+#if IS_ENABLED(CONFIG_IPV6) && !defined(CONFIG_SECURITY_SMACK_NETFILTER)
 LIST_HEAD(smk_ipv6_port_list);
-#endif
+#endif /* CONFIG_IPV6 && !CONFIG_SECURITY_SMACK_NETFILTER */
 static struct kmem_cache *smack_inode_cache;
 int smack_enabled;
 
@@ -2218,7 +2218,7 @@ static int smack_netlabel_send(struct sock *sk, struct sockaddr_in *sap)
 	return smack_netlabel(sk, sk_lbl);
 }
 
-#ifndef CONFIG_SECURITY_SMACK_NETFILTER
+#if IS_ENABLED(CONFIG_IPV6) && !defined(CONFIG_SECURITY_SMACK_NETFILTER)
 /**
  * smk_ipv6_port_label - Smack port access table management
  * @sock: socket
@@ -2368,7 +2368,7 @@ auditout:
 	rc = smk_bu_note("IPv6 port check", skp, object, MAY_WRITE, rc);
 	return rc;
 }
-#endif /* !CONFIG_SECURITY_SMACK_NETFILTER */
+#endif /* CONFIG_IPV6 && !CONFIG_SECURITY_SMACK_NETFILTER */
 
 /**
  * smack_inode_setsecurity - set smack xattrs
@@ -2429,10 +2429,10 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 	} else
 		return -EOPNOTSUPP;
 
-#ifndef CONFIG_SECURITY_SMACK_NETFILTER
+#if IS_ENABLED(CONFIG_IPV6) && !defined(CONFIG_SECURITY_SMACK_NETFILTER)
 	if (sock->sk->sk_family == PF_INET6)
 		smk_ipv6_port_label(sock, NULL);
-#endif
+#endif /* CONFIG_IPV6 && !CONFIG_SECURITY_SMACK_NETFILTER */
 
 	return 0;
 }
@@ -2474,12 +2474,14 @@ static int smack_socket_post_create(struct socket *sock, int family,
 static int smack_socket_bind(struct socket *sock, struct sockaddr *address,
 				int addrlen)
 {
+#if IS_ENABLED(CONFIG_IPV6)
 	if (sock->sk != NULL && sock->sk->sk_family == PF_INET6)
 		smk_ipv6_port_label(sock, address);
+#endif
 
 	return 0;
 }
-#endif
+#endif /* !CONFIG_SECURITY_SMACK_NETFILTER */
 
 /**
  * smack_socket_connect - connect access check
@@ -2508,10 +2510,10 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 	case PF_INET6:
 		if (addrlen < sizeof(struct sockaddr_in6))
 			return -EINVAL;
-#ifndef CONFIG_SECURITY_SMACK_NETFILTER
+#if IS_ENABLED(CONFIG_IPV6) && !defined(CONFIG_SECURITY_SMACK_NETFILTER)
 		rc = smk_ipv6_port_check(sock->sk, (struct sockaddr_in6 *)sap,
 						SMK_CONNECTING);
-#endif
+#endif /* CONFIG_IPV6 && !CONFIG_SECURITY_SMACK_NETFILTER */
 		break;
 	}
 	return rc;
@@ -3394,9 +3396,9 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 				int size)
 {
 	struct sockaddr_in *sip = (struct sockaddr_in *) msg->msg_name;
-#ifndef CONFIG_SECURITY_SMACK_NETFILTER
+#if IS_ENABLED(CONFIG_IPV6) && !defined(CONFIG_SECURITY_SMACK_NETFILTER)
 	struct sockaddr_in6 *sap = (struct sockaddr_in6 *) msg->msg_name;
-#endif
+#endif /* CONFIG_IPV6 && !CONFIG_SECURITY_SMACK_NETFILTER */
 	int rc = 0;
 
 	/*
@@ -3410,9 +3412,9 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 		rc = smack_netlabel_send(sock->sk, sip);
 		break;
 	case AF_INET6:
-#ifndef CONFIG_SECURITY_SMACK_NETFILTER
+#if IS_ENABLED(CONFIG_IPV6) && !defined(CONFIG_SECURITY_SMACK_NETFILTER)
 		rc = smk_ipv6_port_check(sock->sk, sap, SMK_SENDING);
-#endif
+#endif /* CONFIG_IPV6 && !CONFIG_SECURITY_SMACK_NETFILTER */
 		break;
 	}
 	return rc;
@@ -3503,6 +3505,7 @@ static struct smack_known *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 	return smack_net_ambient;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static int smk_skb_to_addr_ipv6(struct sk_buff *skb, struct sockaddr_in6 *sip)
 {
 	u8 nexthdr;
@@ -3549,6 +3552,7 @@ static int smk_skb_to_addr_ipv6(struct sk_buff *skb, struct sockaddr_in6 *sip)
 	}
 	return proto;
 }
+#endif /* CONFIG_IPV6 */
 
 /**
  * smack_socket_sock_rcv_skb - Smack packet delivery access check
@@ -3562,13 +3566,15 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	struct netlbl_lsm_secattr secattr;
 	struct socket_smack *ssp = sk->sk_security;
 	struct smack_known *skp = NULL;
-	struct sockaddr_in6 sadd;
 	int rc = 0;
-	int proto;
 	struct smk_audit_info ad;
 #ifdef CONFIG_AUDIT
 	struct lsm_network_audit net;
 #endif
+#if IS_ENABLED(CONFIG_IPV6)
+	struct sockaddr_in6 sadd;
+	int proto;
+#endif /* CONFIG_IPV6 */
 
 	switch (sk->sk_family) {
 	case PF_INET:
@@ -3617,6 +3623,7 @@ access_check:
 		if (rc != 0)
 			netlbl_skbuff_err(skb, rc, 0);
 		break;
+#if IS_ENABLED(CONFIG_IPV6)
 	case PF_INET6:
 		proto = smk_skb_to_addr_ipv6(skb, &sadd);
 		if (proto != IPPROTO_UDP && proto != IPPROTO_TCP)
@@ -3639,6 +3646,7 @@ access_check:
 		rc = smk_ipv6_port_check(sk, &sadd, SMK_RECEIVING);
 #endif /* CONFIG_SECURITY_SMACK_NETFILTER */
 		break;
+#endif /* CONFIG_IPV6 */
 	}
 
 	return rc;
@@ -3702,8 +3710,10 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
 	if (skb != NULL) {
 		if (skb->protocol == htons(ETH_P_IP))
 			family = PF_INET;
+#if IS_ENABLED(CONFIG_IPV6)
 		else if (skb->protocol == htons(ETH_P_IPV6))
 			family = PF_INET6;
+#endif /* CONFIG_IPV6 */
 	}
 	if (family == PF_UNSPEC && sock != NULL)
 		family = sock->sk->sk_family;
@@ -3732,11 +3742,13 @@ static int smack_socket_getpeersec_dgram(struct socket *sock,
 		}
 		netlbl_secattr_destroy(&secattr);
 		break;
+#if IS_ENABLED(CONFIG_IPV6)
 	case PF_INET6:
 #ifdef CONFIG_SECURITY_SMACK_NETFILTER
 		s = skb->secmark;
-#endif
+#endif /* CONFIG_SECURITY_SMACK_NETFILTER */
 		break;
+#endif /* CONFIG_IPV6 */
 	}
 	*secid = s;
 	if (s == 0)
@@ -3792,6 +3804,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 	struct lsm_network_audit net;
 #endif
 
+#if IS_ENABLED(CONFIG_IPV6)
 	if (family == PF_INET6) {
 		/*
 		 * Handle mapped IPv4 packets arriving
@@ -3803,6 +3816,7 @@ static int smack_inet_conn_request(struct sock *sk, struct sk_buff *skb,
 		else
 			return 0;
 	}
+#endif /* CONFIG_IPV6 */
 
 	netlbl_secattr_init(&secattr);
 	rc = netlbl_skbuff_getattr(skb, family, &secattr);
-- 
1.9.1

