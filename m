Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3HEUVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:21:36 -0400
Received: from smtp105.biz.mail.ne1.yahoo.com ([98.138.207.12]:49081 "HELO
	smtp105.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754491Ab3HEUVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:21:35 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: XjYpPncVM1lc1ER08jU2SxK8z_9knAfji5bV06hmotrzr6S
 31xd1jeJQrlbGEsLem65YEVnWYehRFcD8jXXVEYUkzNF23olUvUS99C_wYHq
 L7txJNRXGT7d3tFbpLDOl6hzXmd_vLV.9a7SEJHNGtsPbb3RW0n6dSkD4N74
 PSofvmk9GGqcruawX66otY.0ohbUsgqx39AdZPl8GHRzQEKpL2Zuzd2Xkidg
 _35G4D2b9GdOnnSdeYBfbW7tARJ4TU0JapLl_EEt.8pMXuCcvzWBjy_mr8li
 bMZoO7QqwWRcE2qYBk7uq7MR3B6RxDwro0Ua9jyD8Z0fe3_iWCdibRiIWIiD
 0_SXXlP8fOHg4lvLeSUWPHP9jh9oHFaCoN7e4qkLbAGE1EV1LGrX7c6m2nMZ
 bs1w5jIIbTGLWkRmuwP55sYDn6rRbPow5HmM1FpPhk51m7inZTFPgFyeFcDV
 iP9SVZZcQBZpgPvIwh0vKnFtVq6Z2aoP88HP6CNzQDmImPUDcShFUGTAWey9
 KnRth72tWQCdc5qMyXQvnlRZ3xyWDTfB8hM9U28PAkSd5Rh85t0joAJWAuGs
 VuFX_Cy7bnj8TaQcvyd1ZHH_FZnqbjW8-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp105.biz.mail.ne1.yahoo.com with SMTP; 05 Aug 2013 13:21:34 -0700 PDT
Message-ID: <52000942.9010702@schaufler-ca.com>
Date: Mon, 05 Aug 2013 13:21:22 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>, LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: IPv6 casting error fix for 3.11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Smack: IPv6 casting error fix for 3.11

The original implementation of the Smack IPv6 port based
local controls works most of the time using a sockaddr as
a temporary variable, but not always as it overflows in
some circumstances. The correct data is a sockaddr_in6.
A struct sockaddr isn't as large as a struct sockaddr_in6.
There would need to be casting one way or the other. This
patch gets it the right way.

This problem required some effort to make occur in development
with 3.10, but hits every time in 3.11. This patch should go
into 3.11.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
Subject: [PATCH] Smack: IPv6 casting error fix

The original implementation of the Smack IPv6 port based
local controls works most of the time using a sockaddr as
a temporary variable, but not always as it overflows in
some circumstances. The correct data is a sockaddr_in6.
A struct sockaddr isn't as large as a struct sockaddr_in6.
There would need to be casting one way or the other. This
patch gets it the right way.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---
 security/smack/smack_lsm.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 3f7682a..eefbd10 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1998,12 +1998,11 @@ static void smk_ipv6_port_label(struct socket *sock, struct sockaddr *address)
  *
  * Create or update the port list entry
  */
-static int smk_ipv6_port_check(struct sock *sk, struct sockaddr *address,
+static int smk_ipv6_port_check(struct sock *sk, struct sockaddr_in6 *address,
 				int act)
 {
 	__be16 *bep;
 	__be32 *be32p;
-	struct sockaddr_in6 *addr6;
 	struct smk_port_label *spp;
 	struct socket_smack *ssp = sk->sk_security;
 	struct smack_known *skp;
@@ -2025,10 +2024,9 @@ static int smk_ipv6_port_check(struct sock *sk, struct sockaddr *address,
 	/*
 	 * Get the IP address and port from the address.
 	 */
-	addr6 = (struct sockaddr_in6 *)address;
-	port = ntohs(addr6->sin6_port);
-	bep = (__be16 *)(&addr6->sin6_addr);
-	be32p = (__be32 *)(&addr6->sin6_addr);
+	port = ntohs(address->sin6_port);
+	bep = (__be16 *)(&address->sin6_addr);
+	be32p = (__be32 *)(&address->sin6_addr);
 
 	/*
 	 * It's remote, so port lookup does no good.
@@ -2060,9 +2058,9 @@ auditout:
 	ad.a.u.net->family = sk->sk_family;
 	ad.a.u.net->dport = port;
 	if (act == SMK_RECEIVING)
-		ad.a.u.net->v6info.saddr = addr6->sin6_addr;
+		ad.a.u.net->v6info.saddr = address->sin6_addr;
 	else
-		ad.a.u.net->v6info.daddr = addr6->sin6_addr;
+		ad.a.u.net->v6info.daddr = address->sin6_addr;
 #endif
 	return smk_access(skp, object, MAY_WRITE, &ad);
 }
@@ -2201,7 +2199,8 @@ static int smack_socket_connect(struct socket *sock, struct sockaddr *sap,
 	case PF_INET6:
 		if (addrlen < sizeof(struct sockaddr_in6))
 			return -EINVAL;
-		rc = smk_ipv6_port_check(sock->sk, sap, SMK_CONNECTING);
+		rc = smk_ipv6_port_check(sock->sk, (struct sockaddr_in6 *)sap,
+						SMK_CONNECTING);
 		break;
 	}
 	return rc;
@@ -3034,7 +3033,7 @@ static int smack_socket_sendmsg(struct socket *sock, struct msghdr *msg,
 				int size)
 {
 	struct sockaddr_in *sip = (struct sockaddr_in *) msg->msg_name;
-	struct sockaddr *sap = (struct sockaddr *) msg->msg_name;
+	struct sockaddr_in6 *sap = (struct sockaddr_in6 *) msg->msg_name;
 	int rc = 0;
 
 	/*
@@ -3121,9 +3120,8 @@ static struct smack_known *smack_from_secattr(struct netlbl_lsm_secattr *sap,
 	return smack_net_ambient;
 }
 
-static int smk_skb_to_addr_ipv6(struct sk_buff *skb, struct sockaddr *sap)
+static int smk_skb_to_addr_ipv6(struct sk_buff *skb, struct sockaddr_in6 *sip)
 {
-	struct sockaddr_in6 *sip = (struct sockaddr_in6 *)sap;
 	u8 nexthdr;
 	int offset;
 	int proto = -EINVAL;
@@ -3181,7 +3179,7 @@ static int smack_socket_sock_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	struct netlbl_lsm_secattr secattr;
 	struct socket_smack *ssp = sk->sk_security;
 	struct smack_known *skp;
-	struct sockaddr sadd;
+	struct sockaddr_in6 sadd;
 	int rc = 0;
 	struct smk_audit_info ad;
 #ifdef CONFIG_AUDIT

