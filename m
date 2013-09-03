Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab3ICHwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:52:10 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:27446 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab3ICHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:52:08 -0400
X-LoopCount0: from 10.48.28.48
X-IronPort-AV: E=Sophos;i="4.89,1012,1367989200"; 
   d="scan'208";a="271601850"
Date: Tue, 3 Sep 2013 10:42:32 +0300
From: Menny Hamburger <Menny_Hamburger@Dell.com>
Message-Id: <201309030742.r837gWZX012547@bldhmenny.dell-idc.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Per IP network statistics: usage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff -r -U 4 a/include/net/ip.h b/include/net/ip.h
--- a/include/net/ip.h	2013-08-25 15:51:01.609307946 +0300
+++ b/include/net/ip.h	2013-08-25 15:51:01.692293432 +0300
@@ -202,8 +202,10 @@
 #define NET_INC_STATS_USER(net, field) __NET_INC_STATS_USER(net, field)
 #define NET_ADD_STATS_BH(net, field, adnd) __NET_ADD_STATS_BH(net, field, adnd)
 #define NET_ADD_STATS_USER(net, field, adnd) __NET_ADD_STATS_USER(net, field, adnd)
 
+#include <net/stat_sk_hashtable_net_overrides.h>
+
 extern unsigned long snmp_fold_field(void *mib[], int offt);
 extern int snmp_mib_init(void *ptr[2], size_t mibsize);
 extern void snmp_mib_free(void *ptr[2]);
 
diff -r -U 4 a/include/net/sock.h b/include/net/sock.h
--- a/include/net/sock.h	2013-08-25 15:51:01.615295421 +0300
+++ b/include/net/sock.h	2013-08-25 15:51:01.708293434 +0300
@@ -59,8 +59,12 @@
 #include <asm/atomic.h>
 #include <net/dst.h>
 #include <net/checksum.h>
 
+#ifdef CONFIG_NET_IPV4_SOCK_STATS
+#include <net/stat_hashtable_cookie.h>
+#endif
+
 /*
  * This structure really needs to be cleaned up.
  * Most of it is for TCP, and not used by any of
  * the other protocols.
@@ -351,8 +355,12 @@
 	 * sk_rcvqueues_full(), sk_set_min_ttl(), etc. would break for
 	 * existing modules. */
 	__u8			rcv_tos;
 	u32			icsk_user_timeout;
+
+#ifdef CONFIG_NET_IPV4_SOCK_STATS
+	struct stat_hash_cookie hash_cookie;
+#endif
 };
 
 #define __sk_tx_queue_mapping(sk) \
 	sk_extended(sk)->__sk_common_extended.skc_tx_queue_mapping
diff -r -U 4 a/include/net/tcp.h b/include/net/tcp.h
--- a/include/net/tcp.h	2013-08-25 15:51:01.621293957 +0300
+++ b/include/net/tcp.h	2013-08-25 15:51:01.727293408 +0300
@@ -307,8 +307,10 @@
 #define TCP_INC_STATS_BH(net, field)    __TCP_INC_STATS_BH(net, field)
 #define TCP_DEC_STATS(net, field)       __TCP_DEC_STATS(net, field)
 #define TCP_ADD_STATS_USER(net, field, val) __TCP_ADD_STATS_USER(net, field, val)
 
+#include <net/stat_sk_hashtable_tcp_overrides.h>
+
 extern void			tcp_v4_err(struct sk_buff *skb, u32);
 
 extern void			tcp_shutdown (struct sock *sk, int how);
 
diff -r -U 4 a/net/core/sock.c b/net/core/sock.c
--- a/net/core/sock.c	2013-08-25 15:51:01.627303626 +0300
+++ b/net/core/sock.c	2013-08-25 15:51:01.744299451 +0300
@@ -133,8 +133,10 @@
 #ifdef CONFIG_INET
 #include <net/tcp.h>
 #endif
 
+#include <net/stat_sk_hashtable.h>
+
 /*
  * Each address family might have different locking rules, so we have
  * one slock key per address family:
  */
@@ -1105,8 +1107,10 @@
 		atomic_set(&sk->sk_wmem_alloc, 1);
 
 		sock_update_classid(sk);
 		sock_update_netprioidx(sk);
+
+		STAT_HASH_SK_INIT(sk);
 	}
 
 	return sk;
 }
@@ -1255,8 +1259,10 @@
 
 		if (sock_flag(newsk, SOCK_TIMESTAMP) ||
 		    sock_flag(newsk, SOCK_TIMESTAMPING_RX_SOFTWARE))
 			net_enable_timestamp();
+
+		STAT_HASH_SK_INIT(newsk);
 	}
 out:
 	return newsk;
 }
diff -r -U 4 a/net/ipv4/arp.c b/net/ipv4/arp.c
--- a/net/ipv4/arp.c	2013-08-25 15:51:01.633309737 +0300
+++ b/net/ipv4/arp.c	2013-08-25 15:51:01.761359596 +0300
@@ -426,9 +426,9 @@
 
 	if (ip_route_output_key(net, &rt, &fl) < 0)
 		return 1;
 	if (rt->u.dst.dev != dev) {
-		NET_INC_STATS_BH(net, LINUX_MIB_ARPFILTER);
+		__NET_INC_STATS_BH(net, LINUX_MIB_ARPFILTER);
 		flag = 1;
 	}
 	ip_rt_put(rt);
 	return flag;
diff -r -U 4 a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
--- a/net/ipv4/inet_timewait_sock.c	2013-08-25 15:51:01.639297975 +0300
+++ b/net/ipv4/inet_timewait_sock.c	2013-08-25 15:51:01.774487246 +0300
@@ -171,9 +171,9 @@
 		__inet_twsk_del_dead_node(tw);
 		spin_unlock(&twdr->death_lock);
 		__inet_twsk_kill(tw, twdr->hashinfo);
 #ifdef CONFIG_NET_NS
-		NET_INC_STATS_BH(twsk_net(tw), LINUX_MIB_TIMEWAITED);
+		__NET_INC_STATS_BH(twsk_net(tw), LINUX_MIB_TIMEWAITED);
 #endif
 		inet_twsk_put(tw);
 		killed++;
 		spin_lock(&twdr->death_lock);
@@ -192,9 +192,9 @@
 	}
 
 	twdr->tw_count -= killed;
 #ifndef CONFIG_NET_NS
-	NET_ADD_STATS_BH(&init_net, LINUX_MIB_TIMEWAITED, killed);
+	__NET_ADD_STATS_BH(&init_net, LINUX_MIB_TIMEWAITED, killed);
 #endif
 	return ret;
 }
 
@@ -387,9 +387,9 @@
 						       &twdr->twcal_row[slot]) {
 				__inet_twsk_del_dead_node(tw);
 				__inet_twsk_kill(tw, twdr->hashinfo);
 #ifdef CONFIG_NET_NS
-				NET_INC_STATS_BH(twsk_net(tw), LINUX_MIB_TIMEWAITKILLED);
+				__NET_INC_STATS_BH(twsk_net(tw), LINUX_MIB_TIMEWAITKILLED);
 #endif
 				inet_twsk_put(tw);
 				killed++;
 			}
diff -r -U 4 a/net/ipv4/tcp.c b/net/ipv4/tcp.c
--- a/net/ipv4/tcp.c	2013-08-25 15:51:01.645293122 +0300
+++ b/net/ipv4/tcp.c	2013-08-25 15:51:01.787393766 +0300
@@ -1756,8 +1756,10 @@
 void tcp_set_state(struct sock *sk, int state)
 {
 	int oldstate = sk->sk_state;
 
+	STAT_HASH_SK_INSERT_EXISTING_NOALLOC(sk);
+
 	switch (state) {
 	case TCP_ESTABLISHED:
 		if (oldstate != TCP_ESTABLISHED)
 			TCP_INC_STATS(sock_net(sk), TCP_MIB_CURRESTAB);
diff -r -U 4 a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
--- a/net/ipv4/tcp_ipv4.c	2013-08-25 15:51:01.651303464 +0300
+++ b/net/ipv4/tcp_ipv4.c	2013-08-25 15:51:01.804255105 +0300
@@ -248,8 +248,10 @@
 							   usin->sin_port);
 
 	inet->id = tp->write_seq ^ jiffies;
 
+	STAT_HASH_SK_INSERT_ATOMIC(sk, STAT_HASH_SK_OUT);
+
 	err = tcp_connect(sk);
 	rt = NULL;
 	if (err)
 		goto failure;
@@ -633,10 +635,10 @@
 	net = dev_net(skb_dst(skb)->dev);
 	ip_send_reply(net->ipv4.tcp_sock, skb,
 		      &arg, arg.iov[0].iov_len);
 
-	TCP_INC_STATS_BH(net, TCP_MIB_OUTSEGS);
-	TCP_INC_STATS_BH(net, TCP_MIB_OUTRSTS);
+	TCP_INC_SOCK_STATS_BH(net->ipv4.tcp_sock, net, TCP_MIB_OUTSEGS);
+	TCP_INC_SOCK_STATS_BH(net->ipv4.tcp_sock, net, TCP_MIB_OUTRSTS);
 }
 
 /* The code following below sending ACKs in SYN-RECV and TIME-WAIT states
    outside socket context is ugly, certainly. What can I do?
@@ -708,9 +710,9 @@
 
 	ip_send_reply(net->ipv4.tcp_sock, skb,
 		      &arg, arg.iov[0].iov_len);
 
-	TCP_INC_STATS_BH(net, TCP_MIB_OUTSEGS);
+	TCP_INC_SOCK_STATS_BH(net->ipv4.tcp_sock, net, TCP_MIB_OUTSEGS);
 }
 
 static void tcp_v4_timewait_ack(struct sock *sk, struct sk_buff *skb)
 {
@@ -1272,8 +1274,10 @@
 	tmp_opt.tstamp_ok = tmp_opt.saw_tstamp;
 
 	tcp_openreq_init(req, &tmp_opt, skb);
 
+	STAT_HASH_SK_INSERT_ATOMIC(sk, STAT_HASH_SK_IN);
+
 	ireq = inet_rsk(req);
 	ireq->loc_addr = daddr;
 	ireq->rmt_addr = saddr;
 	ireq->no_srccheck = inet_sk(sk)->transparent;
@@ -1435,8 +1439,10 @@
 		goto exit;
 	}
 	__inet_hash_nolisten(newsk);
 
+	STAT_HASH_SK_INSERT_ATOMIC(newsk, STAT_HASH_SK_IN);
+
 	return newsk;
 
 exit_overflow:
 	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
@@ -1580,17 +1586,17 @@
 int tcp_v4_rcv(struct sk_buff *skb)
 {
 	const struct iphdr *iph;
 	struct tcphdr *th;
-	struct sock *sk;
+	struct sock *sk = NULL;
 	int ret;
 	struct net *net = dev_net(skb->dev);
 
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
 	/* Count it even if it's bad */
-	TCP_INC_STATS_BH(net, TCP_MIB_INSEGS);
+	TCP_INC_SKB_STATS_BH(net, TCP_MIB_INSEGS);
 
 	if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
 		goto discard_it;
 
diff -r -U 4 a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
--- a/net/ipv4/tcp_minisocks.c	2013-08-25 15:51:01.656293235 +0300
+++ b/net/ipv4/tcp_minisocks.c	2013-08-25 15:51:01.817254458 +0300
@@ -244,9 +244,9 @@
 		return TCP_TW_SYN;
 	}
 
 	if (paws_reject)
-		NET_INC_STATS_BH(twsk_net(tw), LINUX_MIB_PAWSESTABREJECTED);
+		__NET_INC_STATS_BH(twsk_net(tw), LINUX_MIB_PAWSESTABREJECTED);
 
 	if (!th->rst) {
 		/* In this case we must reset the TIMEWAIT timer.
 		 *
diff -r -U 4 a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
--- a/net/ipv6/inet6_hashtables.c	2013-08-25 15:51:01.662303572 +0300
+++ b/net/ipv6/inet6_hashtables.c	2013-08-25 15:51:01.830264020 +0300
@@ -22,8 +22,12 @@
 #include <net/inet6_hashtables.h>
 #include <net/secure_seq.h>
 #include <net/ip.h>
 
+#ifndef CONFIG_IPV6_STAT_HASHTABLES
+#include <net/stat_sk_hashtable_undo_overrides.h>
+#endif
+
 void __inet6_hash(struct sock *sk)
 {
 	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
 
diff -r -U 4 a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
--- a/net/ipv6/syncookies.c	2013-08-25 15:51:01.668316079 +0300
+++ b/net/ipv6/syncookies.c	2013-08-25 15:51:01.843250995 +0300
@@ -20,8 +20,12 @@
 #include <linux/kernel.h>
 #include <net/ipv6.h>
 #include <net/tcp.h>
 
+#ifndef CONFIG_IPV6_STAT_HASHTABLES
+#include <net/stat_sk_hashtable_undo_overrides.h>
+#endif
+
 extern int sysctl_tcp_syncookies;
 extern __u32 syncookie_secret[2][16-4+SHA_DIGEST_WORDS];
 
 #define COOKIEBITS 24	/* Upper bits store count */
diff -r -U 4 a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
--- a/net/ipv6/tcp_ipv6.c	2013-08-25 15:51:01.674293247 +0300
+++ b/net/ipv6/tcp_ipv6.c	2013-08-25 15:51:01.859250310 +0300
@@ -69,8 +69,12 @@
 
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
 
+#ifndef CONFIG_IPV6_STAT_HASHTABLES
+#include <net/stat_sk_hashtable_undo_overrides.h>
+#endif
+
 static void	tcp_v6_send_reset(struct sock *sk, struct sk_buff *skb);
 static void	tcp_v6_reqsk_send_ack(struct sock *sk, struct sk_buff *skb,
 				      struct request_sock *req);
 
@@ -301,8 +305,10 @@
 							     np->daddr.s6_addr32,
 							     inet->sport,
 							     inet->dport);
 
+	STAT_HASH_SK_INSERT_ATOMIC(sk, STAT_HASH_SK_OUT);
+
 	err = tcp_connect(sk);
 	if (err)
 		goto late_failure;
 
@@ -1064,11 +1070,11 @@
 	if (!ip6_dst_lookup(ctl_sk, &dst, &fl)) {
 		if (xfrm_lookup(net, &dst, &fl, NULL, 0) >= 0) {
 			skb_dst_set(buff, dst);
 			ip6_xmit(ctl_sk, buff, &fl, NULL, 0);
-			TCP_INC_STATS_BH(net, TCP_MIB_OUTSEGS);
+			TCP_INC_SKB_STATS_BH(net, TCP_MIB_OUTSEGS);
 			if (rst)
-				TCP_INC_STATS_BH(net, TCP_MIB_OUTRSTS);
+				TCP_INC_SKB_STATS_BH(net, TCP_MIB_OUTRSTS);
 			return;
 		}
 	}
 
@@ -1210,8 +1216,10 @@
 	tmp_opt.user_mss = tp->rx_opt.user_mss;
 
 	tcp_parse_options(skb, &tmp_opt, 0);
 
+	STAT_HASH_SK_INSERT_ATOMIC(sk, STAT_HASH_SK_IN);
+
 	if (want_cookie && !tmp_opt.saw_tstamp)
 		tcp_clear_options(&tmp_opt);
 
 	tmp_opt.tstamp_ok = tmp_opt.saw_tstamp;
@@ -1329,8 +1337,10 @@
 		   Sync it now.
 		 */
 		tcp_sync_mss(newsk, inet_csk(newsk)->icsk_pmtu_cookie);
 
+		STAT_HASH_SK_INSERT_ATOMIC(newsk, STAT_HASH_SK_IN);
+
 		return newsk;
 	}
 
 	treq = inet6_rsk(req);
@@ -1640,9 +1650,9 @@
 static int tcp_v6_rcv(struct sk_buff *skb)
 {
 	struct tcphdr *th;
 	struct ipv6hdr *hdr;
-	struct sock *sk;
+	struct sock *sk = NULL;
 	int ret;
 	struct net *net = dev_net(skb->dev);
 
 	if (skb->pkt_type != PACKET_HOST)
@@ -1650,9 +1660,9 @@
 
 	/*
 	 *	Count it even if it's bad.
 	 */
-	TCP_INC_STATS_BH(net, TCP_MIB_INSEGS);
+	TCP_INC_SKB_STATS_BH(net, TCP_MIB_INSEGS);
 
 	if (!pskb_may_pull(skb, sizeof(struct tcphdr)))
 		goto discard_it;
 
