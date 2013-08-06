Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3HFKxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:53:07 -0400
Received: from tundra.namei.org ([65.99.196.166]:50601 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954Ab3HFKxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:53:05 -0400
Date: Tue, 6 Aug 2013 20:52:07 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Casey Schaufler <casey@schaufler-ca.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] Smack: IPv6 casting error fix for 3.11
In-Reply-To: <CA+55aFyii4yLORxxXKME6DgtmBsFbh8yN5SZjvDHLNOpj2+PqA@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1308062051070.13931@tundra.namei.org>
References: <52000942.9010702@schaufler-ca.com> <CA+55aFyii4yLORxxXKME6DgtmBsFbh8yN5SZjvDHLNOpj2+PqA@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Aug 2013, Linus Torvalds wrote:

> Why does this have the (largely same) commit message twice?

I don't know exactly, but here it is in pullable form, with the shorter of 
the two messages.


The following changes since commit c095ba7224d8edc71dcef0d655911399a8bd4a3f:

  Linux 3.11-rc4 (2013-08-04 13:46:46 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Casey Schaufler (1):
      Smack: IPv6 casting error fix for 3.11

 security/smack/smack_lsm.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)


---

commit 6ea062475a9a2ea6e1394487fa0e51b3459957d1
Author: Casey Schaufler <casey@schaufler-ca.com>
Date:   Mon Aug 5 13:21:22 2013 -0700

    Smack: IPv6 casting error fix for 3.11
    
    The original implementation of the Smack IPv6 port based
    local controls works most of the time using a sockaddr as
    a temporary variable, but not always as it overflows in
    some circumstances. The correct data is a sockaddr_in6.
    A struct sockaddr isn't as large as a struct sockaddr_in6.
    There would need to be casting one way or the other. This
    patch gets it the right way.
    
    Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

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
