Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3AMRps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:45:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35048 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755586Ab3AMRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:44 -0500
Message-Id: <20130113174304.168405660@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:35 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <edumazet@google.com>,
        Kiran Kumar Kella <kkiran@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 40/49] tcp: implement RFC 5961 3.2
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 282f23c6ee343126156dd41218b22ece96d747e3 ]

Implement the RFC 5691 mitigation against Blind
Reset attack using RST bit.

Idea is to validate incoming RST sequence,
to match RCV.NXT value, instead of previouly accepted
window : (RCV.NXT <= SEG.SEQ < RCV.NXT+RCV.WND)

If sequence is in window but not an exact match, send
a "challenge ACK", so that the other part can resend an
RST with the appropriate sequence.

Add a new sysctl, tcp_challenge_ack_limit, to limit
number of challenge ACK sent per second.

Add a new SNMP counter to count number of challenge acks sent.
(netstat -s | grep TCPChallengeACK)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kiran Kumar Kella <kkiran@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/networking/ip-sysctl.txt |  5 +++++
 include/linux/snmp.h                   |  1 +
 include/net/tcp.h                      |  1 +
 net/ipv4/proc.c                        |  1 +
 net/ipv4/sysctl_net_ipv4.c             |  7 +++++++
 net/ipv4/tcp_input.c                   | 31 ++++++++++++++++++++++++++++++-
 6 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index a4399f5..3b979c6 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -524,6 +524,11 @@ tcp_thin_dupack - BOOLEAN
 	Documentation/networking/tcp-thin.txt
 	Default: 0
 
+tcp_challenge_ack_limit - INTEGER
+	Limits number of Challenge ACK sent per second, as recommended
+	in RFC 5961 (Improving TCP's Robustness to Blind In-Window Attacks)
+	Default: 100
+
 UDP variables:
 
 udp_mem - vector of 3 INTEGERs: min, pressure, max
diff --git a/include/linux/snmp.h b/include/linux/snmp.h
index e16557a..6e310bb 100644
--- a/include/linux/snmp.h
+++ b/include/linux/snmp.h
@@ -233,6 +233,7 @@ enum
 	LINUX_MIB_TCPTIMEWAITOVERFLOW,		/* TCPTimeWaitOverflow */
 	LINUX_MIB_TCPREQQFULLDOCOOKIES,		/* TCPReqQFullDoCookies */
 	LINUX_MIB_TCPREQQFULLDROP,		/* TCPReqQFullDrop */
+	LINUX_MIB_TCPCHALLENGEACK,		/* TCPChallengeACK */
 	__LINUX_MIB_MAX
 };
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index bb18c4d..0768715 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -251,6 +251,7 @@ extern int sysctl_tcp_max_ssthresh;
 extern int sysctl_tcp_cookie_size;
 extern int sysctl_tcp_thin_linear_timeouts;
 extern int sysctl_tcp_thin_dupack;
+extern int sysctl_tcp_challenge_ack_limit;
 
 extern atomic_long_t tcp_memory_allocated;
 extern struct percpu_counter tcp_sockets_allocated;
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 466ea8b..f46c478 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -257,6 +257,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPTimeWaitOverflow", LINUX_MIB_TCPTIMEWAITOVERFLOW),
 	SNMP_MIB_ITEM("TCPReqQFullDoCookies", LINUX_MIB_TCPREQQFULLDOCOOKIES),
 	SNMP_MIB_ITEM("TCPReqQFullDrop", LINUX_MIB_TCPREQQFULLDROP),
+	SNMP_MIB_ITEM("TCPChallengeACK", LINUX_MIB_TCPCHALLENGEACK),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 69fd720..5485077 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -552,6 +552,13 @@ static struct ctl_table ipv4_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec
 	},
+	{
+		.procname	= "tcp_challenge_ack_limit",
+		.data		= &sysctl_tcp_challenge_ack_limit,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
 #ifdef CONFIG_NET_DMA
 	{
 		.procname	= "tcp_dma_copybreak",
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a08a621..a0d3b88 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -86,6 +86,9 @@ int sysctl_tcp_app_win __read_mostly = 31;
 int sysctl_tcp_adv_win_scale __read_mostly = 1;
 EXPORT_SYMBOL(sysctl_tcp_adv_win_scale);
 
+/* rfc5961 challenge ack rate limiting */
+int sysctl_tcp_challenge_ack_limit = 100;
+
 int sysctl_tcp_stdurg __read_mostly;
 int sysctl_tcp_rfc1337 __read_mostly;
 int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
@@ -5240,6 +5243,23 @@ out:
 }
 #endif /* CONFIG_NET_DMA */
 
+static void tcp_send_challenge_ack(struct sock *sk)
+{
+	/* unprotected vars, we dont care of overwrites */
+	static u32 challenge_timestamp;
+	static unsigned int challenge_count;
+	u32 now = jiffies / HZ;
+
+	if (now != challenge_timestamp) {
+		challenge_timestamp = now;
+		challenge_count = 0;
+	}
+	if (++challenge_count <= sysctl_tcp_challenge_ack_limit) {
+		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPCHALLENGEACK);
+		tcp_send_ack(sk);
+	}
+}
+
 /* Does PAWS and seqno based validation of an incoming segment, flags will
  * play significant role here.
  */
@@ -5276,7 +5296,16 @@ static int tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 
 	/* Step 2: check RST bit */
 	if (th->rst) {
-		tcp_reset(sk);
+		/* RFC 5961 3.2 :
+		 * If sequence number exactly matches RCV.NXT, then
+		 *     RESET the connection
+		 * else
+		 *     Send a challenge ACK
+		 */
+		if (TCP_SKB_CB(skb)->seq == tp->rcv_nxt)
+			tcp_reset(sk);
+		else
+			tcp_send_challenge_ack(sk);
 		goto discard;
 	}
 


