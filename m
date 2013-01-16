Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab3APQJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:09:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36798 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab3APQJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Kiran Kumar Kella <kkiran@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 187/222] tcp: implement RFC 5961 4.2
Date: Wed, 16 Jan 2013 13:56:27 -0200
Message-Id: <1358351822-7675-188-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 0c24604b68fc7810d429d6c3657b6f148270e528 upstream.

Implement the RFC 5691 mitigation against Blind
Reset attack using SYN bit.

Section 4.2 of RFC 5961 advises to send a Challenge ACK and drop
incoming packet, instead of resetting the session.

Add a new SNMP counter to count number of challenge acks sent
in response to SYN packets.
(netstat -s | grep TCPSYNChallenge)

Remove obsolete TCPAbortOnSyn, since we no longer abort a TCP session
because of a SYN flag.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kiran Kumar Kella <kkiran@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 include/linux/snmp.h |    2 +-
 net/ipv4/proc.c      |    2 +-
 net/ipv4/tcp_input.c |   32 +++++++++++++++-----------------
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/include/linux/snmp.h b/include/linux/snmp.h
index 594638e..a33f70f 100644
--- a/include/linux/snmp.h
+++ b/include/linux/snmp.h
@@ -208,7 +208,6 @@ enum
 	LINUX_MIB_TCPDSACKOFOSENT,		/* TCPDSACKOfoSent */
 	LINUX_MIB_TCPDSACKRECV,			/* TCPDSACKRecv */
 	LINUX_MIB_TCPDSACKOFORECV,		/* TCPDSACKOfoRecv */
-	LINUX_MIB_TCPABORTONSYN,		/* TCPAbortOnSyn */
 	LINUX_MIB_TCPABORTONDATA,		/* TCPAbortOnData */
 	LINUX_MIB_TCPABORTONCLOSE,		/* TCPAbortOnClose */
 	LINUX_MIB_TCPABORTONMEMORY,		/* TCPAbortOnMemory */
@@ -235,6 +234,7 @@ enum
 	LINUX_MIB_TCPRETRANSFAIL,		/* TCPRetransFail */
 	LINUX_MIB_TCPRCVCOALESCE,			/* TCPRcvCoalesce */
 	LINUX_MIB_TCPCHALLENGEACK,		/* TCPChallengeACK */
+	LINUX_MIB_TCPSYNCHALLENGE,		/* TCPSYNChallenge */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index d589468..2128975 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -232,7 +232,6 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPDSACKOfoSent", LINUX_MIB_TCPDSACKOFOSENT),
 	SNMP_MIB_ITEM("TCPDSACKRecv", LINUX_MIB_TCPDSACKRECV),
 	SNMP_MIB_ITEM("TCPDSACKOfoRecv", LINUX_MIB_TCPDSACKOFORECV),
-	SNMP_MIB_ITEM("TCPAbortOnSyn", LINUX_MIB_TCPABORTONSYN),
 	SNMP_MIB_ITEM("TCPAbortOnData", LINUX_MIB_TCPABORTONDATA),
 	SNMP_MIB_ITEM("TCPAbortOnClose", LINUX_MIB_TCPABORTONCLOSE),
 	SNMP_MIB_ITEM("TCPAbortOnMemory", LINUX_MIB_TCPABORTONMEMORY),
@@ -259,6 +258,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPRetransFail", LINUX_MIB_TCPRETRANSFAIL),
 	SNMP_MIB_ITEM("TCPRcvCoalesce", LINUX_MIB_TCPRCVCOALESCE),
 	SNMP_MIB_ITEM("TCPChallengeACK", LINUX_MIB_TCPCHALLENGEACK),
+	SNMP_MIB_ITEM("TCPSYNChallenge", LINUX_MIB_TCPSYNCHALLENGE),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3749e0e..e859775 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5451,8 +5451,8 @@ static void tcp_send_challenge_ack(struct sock *sk)
 /* Does PAWS and seqno based validation of an incoming segment, flags will
  * play significant role here.
  */
-static int tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
-			      const struct tcphdr *th, int syn_inerr)
+static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
+				  const struct tcphdr *th, int syn_inerr)
 {
 	const u8 *hash_location;
 	struct tcp_sock *tp = tcp_sk(sk);
@@ -5504,20 +5504,22 @@ static int tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 
 	/* step 3: check security and precedence [ignored] */
 
-	/* step 4: Check for a SYN in window. */
-	if (th->syn && !before(TCP_SKB_CB(skb)->seq, tp->rcv_nxt)) {
+	/* step 4: Check for a SYN
+	 * RFC 5691 4.2 : Send a challenge ack
+	 */
+	if (th->syn) {
 		if (syn_inerr)
 			TCP_INC_STATS_BH(sock_net(sk), TCP_MIB_INERRS);
-		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPABORTONSYN);
-		tcp_reset(sk);
-		return -1;
+		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
+		tcp_send_challenge_ack(sk);
+		goto discard;
 	}
 
-	return 1;
+	return true;
 
 discard:
 	__kfree_skb(skb);
-	return 0;
+	return false;
 }
 
 /*
@@ -5547,7 +5549,6 @@ int tcp_rcv_established(struct sock *sk, struct sk_buff *skb,
 			const struct tcphdr *th, unsigned int len)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
-	int res;
 
 	/*
 	 *	Header prediction.
@@ -5725,9 +5726,8 @@ slow_path:
 	 *	Standard slow path.
 	 */
 
-	res = tcp_validate_incoming(sk, skb, th, 1);
-	if (res <= 0)
-		return -res;
+	if (!tcp_validate_incoming(sk, skb, th, 1))
+		return 0;
 
 step5:
 	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
@@ -6045,7 +6045,6 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	int queued = 0;
-	int res;
 
 	tp->rx_opt.saw_tstamp = 0;
 
@@ -6100,9 +6099,8 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 		return 0;
 	}
 
-	res = tcp_validate_incoming(sk, skb, th, 0);
-	if (res <= 0)
-		return -res;
+	if (!tcp_validate_incoming(sk, skb, th, 0))
+		return 0;
 
 	/* step 5: check the ACK field */
 	if (th->ack) {
-- 
1.7.9.5

