Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3GYAtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 20:49:45 -0400
Received: from smtp105.biz.mail.bf1.yahoo.com ([98.139.221.43]:20431 "HELO
	smtp105.biz.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752871Ab3GYAtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 20:49:42 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: P7NjBcYVM1m3gz3mvQc4fFAYs8bi1TnY.t1dIw5snMVOk8U
 D3NAj4.Z_hx6QDQNEr0i0mUjIdOZG78Zk8gWFguN6q8I32tdA3VnPhEkPnNR
 CWT38v9nCyRPk3Sna8adE7ehSlTbVo98fKzD5I.4wWuYg1QcvwiyRKKBfzZ2
 jN.760zta5tF1CO1sMtXMmRjeyJPvt2xW6pYOPX6xukTxqth3BVfozjETano
 Lzto65LEFzfn3r5P3sKFohFd7AZnq6OijAOFDMxA58z8C6f_eNVpl_ZpBmyk
 yiFRDnoCQi4xeu82.fYkgKXNmcdXoY40veOSQU8eKwxpD_k3B22ycZvL4A7z
 4APby_49_TYj_G_rreF1gPxaNm9IMUoXiBRl46Q0xEiaulVA56R9AbjqLbTd
 TlM8PokhDm_iSkr13xEEpofo.OClub6Ph26CtkKAnLXWr8JTux2mesSCr12E
 0rKOMe.oCc6lT42aHyzm03vsXdxdBENPknCukpwzvw0KC_8O0A35fDqXyDIx
 aPg.CDQKklDlw.iW88atZxYsTTNnaeakUj6wN5pZep3U_6f7NoCrUQ9Q3JA-
 -
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp105.biz.mail.bf1.yahoo.com with SMTP; 24 Jul 2013 17:49:41 -0700 PDT
Message-ID: <51F07623.4070904@schaufler-ca.com>
Date: Wed, 24 Jul 2013 17:49:39 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>
CC: Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Smack: IPv6 casting error fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] Smack: IPv6 casting error fix

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

