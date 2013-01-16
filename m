Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab3APQJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:09:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab3APQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:09:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        Kiran Kumar Kella <kkiran@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 186/222] tcp: implement RFC 5961 3.2
Date: Wed, 16 Jan 2013 13:56:26 -0200
Message-Id: <1358351822-7675-187-git-send-email-herton.krzesinski@canonical.com>
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

commit 282f23c6ee343126156dd41218b22ece96d747e3 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 Documentation/networking/ip-sysctl.txt |    5 +++++
 include/linux/snmp.h                   |    1 +
 include/net/tcp.h                      |    1 +
 net/ipv4/proc.c                        |    1 +
 net/ipv4/sysctl_net_ipv4.c             |    7 +++++++
 net/ipv4/tcp_input.c                   |   31 ++++++++++++++++++++++++++++++-
 6 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 6f896b9..1514ea3 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -551,6 +551,11 @@ tcp_thin_dupack - BOOLEAN
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
index 2e68f5b..594638e 100644
--- a/include/linux/snmp.h
+++ b/include/linux/snmp.h
@@ -234,6 +234,7 @@ enum
 	LINUX_MIB_TCPREQQFULLDROP,		/* TCPReqQFullDrop */
 	LINUX_MIB_TCPRETRANSFAIL,		/* TCPRetransFail */
 	LINUX_MIB_TCPRCVCOALESCE,			/* TCPRcvCoalesce */
+	LINUX_MIB_TCPCHALLENGEACK,		/* TCPChallengeACK */
 	__LINUX_MIB_MAX
 };
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index e79aa48..851f8fa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -253,6 +253,7 @@ extern int sysctl_tcp_cookie_size;
 extern int sysctl_tcp_thin_linear_timeouts;
 extern int sysctl_tcp_thin_dupack;
 extern int sysctl_tcp_early_retrans;
+extern int sysctl_tcp_challenge_ack_limit;
 
 extern atomic_long_t tcp_memory_allocated;
 extern struct percpu_counter tcp_sockets_allocated;
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 8af0d44..d589468 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -258,6 +258,7 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPReqQFullDrop", LINUX_MIB_TCPREQQFULLDROP),
 	SNMP_MIB_ITEM("TCPRetransFail", LINUX_MIB_TCPRETRANSFAIL),
 	SNMP_MIB_ITEM("TCPRcvCoalesce", LINUX_MIB_TCPRCVCOALESCE),
+	SNMP_MIB_ITEM("TCPChallengeACK", LINUX_MIB_TCPCHALLENGEACK),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index ef32956..e6791f2 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -591,6 +591,13 @@ static struct ctl_table ipv4_table[] = {
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
index 4a3cac8..3749e0e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -88,6 +88,9 @@ int sysctl_tcp_app_win __read_mostly = 31;
 int sysctl_tcp_adv_win_scale __read_mostly = 1;
 EXPORT_SYMBOL(sysctl_tcp_adv_win_scale);
 
+/* rfc5961 challenge ack rate limiting */
+int sysctl_tcp_challenge_ack_limit = 100;
+
 int sysctl_tcp_stdurg __read_mostly;
 int sysctl_tcp_rfc1337 __read_mostly;
 int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
@@ -5428,6 +5431,23 @@ out:
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
@@ -5464,7 +5484,16 @@ static int tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 
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
 
-- 
1.7.9.5

