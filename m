Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3ICHmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:42:40 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:44884 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3ICHmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:42:38 -0400
X-LoopCount0: from 10.48.28.48
X-IronPort-AV: E=Sophos;i="4.89,1012,1367989200"; 
   d="scan'208";a="249012957"
Date: Tue, 3 Sep 2013 10:42:32 +0300
From: Menny Hamburger <Menny_Hamburger@Dell.com>
Message-Id: <201309030742.r837gWk0012544@bldhmenny.dell-idc.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Per IP network statistics: socket API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff -r -U 4 a/include/net/ip.h b/include/net/ip.h
--- a/include/net/ip.h	2013-08-27 17:15:42.952712200 +0300
+++ b/include/net/ip.h	2013-08-27 17:15:43.027698865 +0300
@@ -189,13 +189,20 @@
 #define IP_ADD_STATS(net, field, val)	SNMP_ADD_STATS((net)->mib.ip_statistics, field, val)
 #define IP_ADD_STATS_BH(net, field, val) SNMP_ADD_STATS_BH((net)->mib.ip_statistics, field, val)
 #define IP_UPD_PO_STATS(net, field, val) SNMP_UPD_PO_STATS((net)->mib.ip_statistics, field, val)
 #define IP_UPD_PO_STATS_BH(net, field, val) SNMP_UPD_PO_STATS_BH((net)->mib.ip_statistics, field, val)
-#define NET_INC_STATS(net, field)	SNMP_INC_STATS((net)->mib.net_statistics, field)
-#define NET_INC_STATS_BH(net, field)	SNMP_INC_STATS_BH((net)->mib.net_statistics, field)
-#define NET_INC_STATS_USER(net, field) 	SNMP_INC_STATS_USER((net)->mib.net_statistics, field)
-#define NET_ADD_STATS_BH(net, field, adnd) SNMP_ADD_STATS_BH((net)->mib.net_statistics, field, adnd)
-#define NET_ADD_STATS_USER(net, field, adnd) SNMP_ADD_STATS_USER((net)->mib.net_statistics, field, adnd)
+
+#define __NET_INC_STATS(net, field)     SNMP_INC_STATS((net)->mib.net_statistics, field)
+#define __NET_INC_STATS_BH(net, field)  SNMP_INC_STATS_BH((net)->mib.net_statistics, field)
+#define __NET_INC_STATS_USER(net, field)        SNMP_INC_STATS_USER((net)->mib.net_statistics, field)
+#define __NET_ADD_STATS_BH(net, field, adnd) SNMP_ADD_STATS_BH((net)->mib.net_statistics, field, adnd)
+#define __NET_ADD_STATS_USER(net, field, adnd) SNMP_ADD_STATS_USER((net)->mib.net_statistics, field, adnd)
+
+#define NET_INC_STATS(net, field) __NET_INC_STATS(net, field)
+#define NET_INC_STATS_BH(net, field)  __NET_INC_STATS_BH(net, field)
+#define NET_INC_STATS_USER(net, field) __NET_INC_STATS_USER(net, field)
+#define NET_ADD_STATS_BH(net, field, adnd) __NET_ADD_STATS_BH(net, field, adnd)
+#define NET_ADD_STATS_USER(net, field, adnd) __NET_ADD_STATS_USER(net, field, adnd)
 
 extern unsigned long snmp_fold_field(void *mib[], int offt);
 extern int snmp_mib_init(void *ptr[2], size_t mibsize);
 extern void snmp_mib_free(void *ptr[2]);
diff -r -U 4 a/include/net/stat_sk_hashtable.h b/include/net/stat_sk_hashtable.h
--- a/include/net/stat_sk_hashtable.h	2013-08-27 17:15:42.958691937 +0300
+++ b/include/net/stat_sk_hashtable.h	2013-08-27 17:15:43.041673380 +0300
@@ -0,0 +1,664 @@
+/*
+ *		Per-ip statistics socket interface to hashtables
+ *
+ *		Menny Hamburger<menny_hamburger@dell.com>
+ */
+
+#ifndef _STAT_SK_HASHTABLE_H
+#define _STAT_SK_HASHTABLE_H
+
+#ifdef CONFIG_NET_IPV4_SOCK_STATS
+
+#include <net/ipv6.h>
+#include <net/stat_hashtable.h>
+
+#define STAT_NET_INITVAL(net) 0
+/* Not sure if we need an intival different than 0 - leave it here in case we do */
+//#define STAT_NET_INITVAL(net)	inet_ehash_secret + net_hash_mix(net)
+#define STAT_SOCK_INITVAL(sk)	STAT_NET_INITVAL(sock_net(sk))
+#define STAT_SK_INITVAL		STAT_SOCK_INITVAL(sk)
+
+/* This function is used to pass insert calls onto stat_hash_get_entry given a pointer to the cookie contained in sock. */
+extern int stat_hash_insert(u32 initval, struct stat_hash_addr *addr, bool existing, 
+			    int alloc_flag, struct stat_hash_cookie *cookie);
+
+#define STAT_SK_PREFIX "stat_sk_hash: "
+
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLE_DEBUG
+#define stat_sk_dprintk(level, format...) \
+	if ((stat_hash_debug_level) >= (level)) \
+		printk(KERN_DEBUG STAT_SK_PREFIX format)
+#else
+#define stat_sk_dprintk(level, format...)
+#endif
+
+
+/* Direction of data transfer - used when inserting a new entry into the hash */
+enum {
+	STAT_HASH_SK_IN = 1,
+	STAT_HASH_SK_OUT,
+	STAT_HASH_SK_DONTCARE,
+	STAT_HASH_SK_INOUT,
+};
+
+/*
+ * Filter out addresses from entering the hashtable.
+ * The current filter code tests that the the remote address is not on the loopback.
+ * When the remote address is on the loopback, the address is filtered out by default because of the potential overhead 
+ * of updating their counters - specifically counters that are incremented each time a packet comes in or goes out.
+ * net_stat_hash_loopback can be toggled via sysctl to allow loopback remote addresses to enter the hash.
+ * The direction is needed in order to identify the remote address from the two addresses defined in struct stat_hash_addr.
+ */
+extern int stat_hash_filter_addr(struct stat_hash_addr *addr, u8 direction);
+
+/* Access the cookie contained in the socket */
+static inline struct stat_hash_cookie *
+sk_cookie(struct sock *sk)
+{
+	if (sk == NULL)
+		return NULL;
+
+	return &sk_extended(sk)->hash_cookie;
+}
+
+/* Clone the cookie from one socket to another */
+static inline void 
+sk_cookie_clone(struct sock *newsk, struct sock *sk)
+{
+	stat_hash_copy_cookie_atomic(sk_cookie(newsk), sk_cookie(sk));
+}
+
+static inline bool 
+sk_operation_allowed(u16 family)
+{
+	/* 
+	 * We only start inserting into the hashtable when it is specifically requested by the user.
+	 * Control is done using stat_hash_start_data_collection/stat_hash_stop_data_collection methods.
+	 */
+        if (!stat_hash_data_collection_started) {
+                stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG, "data collection has not been started\n");
+                return false;
+        }
+
+ 	/* Data collection can be toggled on and off via sysctl */
+        if (!net_stat_hashtable) {
+                stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG, "hashing is disabled\n");
+                return false;
+        }
+
+	/* IPV6 support */
+	if (family == AF_INET6) {
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+		if (net_stat_hashtable_ipv6 == 0) {
+			stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG, "disabled statistics hashing for address family %d\n", family);
+			return false;
+		}
+#else
+		stat_sk_dprintk(STAT_HASH_MESSAGE_NOTICE, "unsupported family %d\n", family);
+		return false;
+#endif
+	}
+
+	return true;	
+}
+
+/* Process IPV4 address before inserting it into the hashtable, possibly filtering it out */
+static inline struct stat_hash_addr *
+sk_addr_ipv4(u16 family, __be32 saddr, __be32 daddr, struct stat_hash_addr *addr, u8 direction)
+{
+	if (!sk_operation_allowed(family)) 
+		return NULL;
+
+	addr->family = family;
+	addr->saddr.ip = saddr;
+	addr->daddr.ip = daddr;
+
+	if ((direction == STAT_HASH_SK_DONTCARE) || (stat_hash_filter_addr(addr, direction) == 0))
+		return addr;
+	 
+
+	return NULL;
+}
+
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+/* Process IPV6 address before inserting it into the hashtable, possibly filtering out */
+static inline struct stat_hash_addr *
+sk_addr_ipv6(u16 family, struct in6_addr *saddr, struct in6_addr *daddr, struct stat_hash_addr *addr, u8 direction)
+{
+	if (!sk_operation_allowed(family))
+		return NULL;
+
+	addr->family = family;
+	ipv6_addr_copy(&addr->saddr.in6, saddr);
+	ipv6_addr_copy(&addr->daddr.in6, daddr);
+
+	if ((direction == STAT_HASH_SK_DONTCARE) || (stat_hash_filter_addr(addr, direction) == 0))
+		return addr;
+
+        return NULL;
+}
+#endif
+
+/* Pre-process address taken from inet_sk/inet6_sk of the socket */
+static inline struct stat_hash_addr *
+sk_addr_inet(struct sock *sk, struct stat_hash_addr *addr, u8 direction)
+{
+	struct stat_hash_addr *addr_out = NULL;
+
+	switch (sk->sk_family) {
+		case AF_INET:
+			addr_out = sk_addr_ipv4(sk->sk_family, inet_sk(sk)->saddr, inet_sk(sk)->daddr, addr, direction);
+			break;
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+		case AF_INET6:
+			addr_out = sk_addr_ipv6(sk->sk_family, &inet6_sk(sk)->saddr, &inet6_sk(sk)->daddr, addr, direction);
+			break;
+#endif
+		default:
+			break;
+
+	}
+
+	return addr_out;
+}
+
+/* 
+ * Acquire address from socket buffer so we can use it to lookup the entry in the hash table.
+ * We use this when a a socket (and it's containing cookie) are not available.
+ */
+static inline struct stat_hash_addr *
+skb_addr(struct sk_buff *skb, struct stat_hash_addr *addr)
+{
+	if (skb == NULL)
+		return NULL;
+
+	if ((ntohs(skb->protocol) == ETH_P_IP) || (skb->protocol == ETH_P_IP)) {
+		addr->family = AF_INET;
+		addr->saddr.ip = ip_hdr(skb)->saddr;
+		addr->daddr.ip = ip_hdr(skb)->daddr;
+		return addr;
+	}
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+	if (net_stat_hashtable_ipv6 != 0) {
+		if ((ntohs(skb->protocol) == ETH_P_IPV6) || (skb->protocol == ETH_P_IPV6)) {
+			addr->family = AF_INET6;
+			ipv6_addr_copy(&addr->saddr.in6, &ipv6_hdr(skb)->saddr);
+			ipv6_addr_copy(&addr->daddr.in6, &ipv6_hdr(skb)->daddr);
+			return addr;
+		}
+	}
+#endif
+
+	return NULL;
+}
+
+/* Init the hash cookie contained in the socket */
+#define STAT_HASH_SK_INIT(sk)    STAT_INIT_COOKIE(sk_cookie(sk))	
+#define STAT_HASH_COOKIE_CLONE(newsk, sk)	\
+			sk_cookie_clone((struct sock *) (newsk), (struct sock *) (sk))
+
+/*
+ * Basic macro used for acquiering a cookie of either an existing entry or a new entry in the hashtable.
+ * STAT_COOKIE_EMPTY makes sure that we do not operate on a socket that contains a non zero cookie 
+ * (non zero sequence number). This also ensures that when cookie is polluted we won't use it again during
+ * the lifetime of the socket.
+ */
+#define STAT_HASH_SK_INSERT_BASE(sk, direction, existing, alloc_flag)	\
+			if (STAT_COOKIE_EMPTY(sk_cookie(sk))) \
+				do { \
+					struct stat_hash_addr addr, *addr_in; \
+					addr_in = sk_addr_inet(sk, &addr, direction); \
+					if (addr_in) \
+						stat_hash_insert(STAT_SK_INITVAL, (&addr), existing, \
+								 alloc_flag, sk_cookie(sk)); \
+				}  while (0)
+
+
+
+/* 
+ * Insert a new address entry into the hash if it doesn't already exist, possibly
+ * allocating the per CPU counters in one or more of the mappings.
+ * Should not be called from within an atomic context or inside a spinlock.
+ */
+#define STAT_HASH_SK_INSERT_NONATOMIC(sk, direction) \
+	STAT_HASH_SK_INSERT_BASE(sk, direction, false, STAT_HASH_ALLOC_FLAG_ALLOC)
+
+
+/*
+ *  Insert a new address entry into the hash if it doesn't already exist, possibly 
+ *  allocating the per CPU counters in one or more of the mappings.
+ *  Should be used withing spinlocks or when we are sure we are in an atomic context.
+ */
+#define STAT_HASH_SK_INSERT_ATOMIC(sk, direction) \
+	STAT_HASH_SK_INSERT_BASE(sk, direction, false, STAT_HASH_ALLOC_FLAG_DELAYED_ALLOC) 
+
+/* 
+ * Insert a new address entry into the hash if it doesn't already exist, possibly
+ * allocating the per CPU counters in one or more of the mappings.
+ * If call is from is an atomic context, per CPU allocation is done in delayed work.
+ * Not intended to be used within spinlocks.
+ */
+#define STAT_HASH_SK_INSERT(sk, direction) \
+	STAT_HASH_SK_INSERT_BASE(sk, direction, false, \
+			 (in_atomic() ? STAT_HASH_ALLOC_FLAG_DELAYED_ALLOC : \
+					STAT_HASH_ALLOC_FLAG_ALLOC))
+
+
+/*
+ * Store cookie associated with an existing entry in the hashtable, possibly 
+ * allocating the per CPU counters in one or more of the mappings.
+ * Should not be called from within an atomic context or inside a spinlock.
+ */
+#define STAT_HASH_SK_INSERT_EXISTING_NONATOMIC(sk) \
+	STAT_HASH_SK_INSERT_BASE(sk, STAT_HASH_SK_DONTCARE, true, STAT_HASH_ALLOC_FLAG_ALLOC)	
+
+/*
+ * Store cookie associated with an existing entry in the hashtable, possibly
+ * allocating the per CPU counters in one or more of the mappings with delayed work.
+ * Should be used withing spinlocks or when we are sure we are in an atomic context.
+ */
+#define STAT_HASH_SK_INSERT_EXISTING_ATOMIC(sk) \
+	STAT_HASH_SK_INSERT_BASE(sk, STAT_HASH_SK_DONTCARE, true, STAT_HASH_ALLOC_FLAG_DELAYED_ALLOC)
+
+/*
+ * Store cookie associated with an existing entry in the hashtable, possibly
+ * allocating the per CPU counters in one or more of the mappings.
+ * If call is from is an atomic context, per CPU allocation is done in delayed work.
+ * Not intended to be used within spinlocks.
+ */
+#define STAT_HASH_SK_INSERT_EXISTING(sk) \
+	STAT_HASH_SK_INSERT_BASE(sk, STAT_HASH_SK_DONTCARE, true, \
+			 (in_atomic() ? STAT_HASH_ALLOC_FLAG_DELAYED_ALLOC : \
+					STAT_HASH_ALLOC_FLAG_ALLOC))
+
+/* 
+ * Store cookie associated with an existing entry in the hashtable without modifying
+ * the entry. This is used in those frequent and sensitive places where we want to make sure that the socket 
+ * contains a cookie, but we don't want any per CPU allocation to take place.
+ * It can be used several times on the same socket due to STAT_COOKIE_EMPTY test.
+ */
+#define STAT_HASH_SK_INSERT_EXISTING_NOALLOC(sk) \
+	STAT_HASH_SK_INSERT_BASE(sk, STAT_HASH_SK_DONTCARE, true, STAT_HASH_ALLOC_FLAG_NOALLOC)
+					  
+
+/*************************************************************************************
+ * Replacement to NET_INC, NET_ADD macros to interract with hashed Linux MIB counters.
+ *************************************************************************************/
+
+/* Macros that interract with Linux MIB via cookie contained in struct sock */
+
+/* Update Linux MIB counter via a "struct sock *" of any name */
+#define __NET_INC_SOCK_STATS(sk, net, field)  \
+	if (snmp_map_allow_update(SNMP_LINUX_MIB, field)) \
+		SNMP_INC_STATS_HASH(sk_cookie(sk), lnx_stats, field)
+#define __NET_INC_SOCK_STATS_BH(sk, net, field)  \
+	if (snmp_map_allow_update(SNMP_LINUX_MIB, field)) \
+		SNMP_INC_STATS_HASH_BH(sk_cookie(sk), lnx_stats, field)
+#define __NET_INC_SOCK_STATS_USER(sk, net, field)  \
+	if (snmp_map_allow_update(SNMP_LINUX_MIB, field)) \
+		SNMP_INC_STATS_HASH_USER(sk_cookie(sk), lnx_stats, field)
+#define __NET_ADD_SOCK_STATS_BH(sk, net, field, adnd) \
+	if (snmp_map_allow_update(SNMP_LINUX_MIB, field)) \
+		SNMP_ADD_STATS_HASH_BH(sk_cookie(sk), lnx_stats, field, adnd)
+#define __NET_ADD_SOCK_STATS_USER(sk, net, field, adnd) \
+	if (snmp_map_allow_update(SNMP_LINUX_MIB, field)) \
+		SNMP_ADD_STATS_HASH_USER(sk_cookie(sk), lnx_stats, field, adnd)
+
+
+/* Update Linux MIB counter via a "struct sock *" of any name + update original counter */
+#define NET_INC_SOCK_STATS(sk, net, field)  \
+	do { \
+		__NET_INC_STATS(net, field); \
+		__NET_INC_SOCK_STATS((sk), net, field); \
+        } while (0)
+#define NET_INC_SOCK_STATS_BH(sk, net, field) \
+	do { \
+		__NET_INC_STATS_BH(net, field); \
+		__NET_INC_SOCK_STATS_BH((sk), net, field); \
+	} while (0)
+#define NET_INC_SOCK_STATS_USER(sk, net, field) \
+	do { \
+		__NET_INC_STATS_USER(net, field); \
+		__NET_INC_SOCK_STATS_USER((sk), net, field); \
+	} while (0)
+#define NET_ADD_SOCK_STATS_BH(sk, net, field, adnd) \
+	do { \
+		__NET_ADD_STATS_BH(net, field, adnd); \
+		__NET_ADD_SOCK_STATS_BH((sk), net, field, adnd); \
+	} while (0)
+#define NET_ADD_SOCK_STATS_USER(sk, net, field, adnd) \
+	do { \
+		__NET_ADD_STATS_USER(net, field, adnd); \
+		__NET_ADD_SOCK_STATS_USER((sk), net, field, adnd); \
+	} while (0)
+
+/*
+ * Update Linux MIB counter via a "struct sock *" named sk.
+ * This is the case in most situations so these macros are used for overriding the originals.
+ */
+#define NET_INC_SK_STATS(net, field)                 NET_INC_SOCK_STATS(sk, net, field)
+#define NET_INC_SK_STATS_BH(net, field)              NET_INC_SOCK_STATS_BH(sk, net, field)
+#define NET_INC_SK_STATS_USER(net, field)            NET_INC_SOCK_STATS_USER(sk, net, field)
+#define NET_ADD_SK_STATS_BH(net, field, adnd)        NET_ADD_SOCK_STATS_BH(sk, net, field, adnd)
+#define NET_ADD_SK_STATS_USER(net, field, adnd)      NET_ADD_SOCK_STATS_USER(sk, net, field, adnd)
+
+
+/* Macros that interract with Linux MIB via socket buffer */
+
+/* Update Linux MIB counter via a "struct sk_buff *" of any name */
+#define __NET_INC_SKBUFF_STATS(skb, net, field) \
+	do { \
+		if (snmp_map_allow_update(SNMP_LINUX_MIB, field))  { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_INC_STATS_HASH_ADDR(STAT_NET_INITVAL(net), addr_in, lnx_stats, field); \
+		} \
+	} while (0)
+#define __NET_INC_SKBUFF_STATS_BH(skb, net, field) \
+	do { \
+		if (snmp_map_allow_update(SNMP_LINUX_MIB, field))  { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_INC_STATS_HASH_ADDR_BH(STAT_NET_INITVAL(net), addr_in, lnx_stats, field); \
+		} \
+	} while (0)
+#define __NET_INC_SKBUFF_STATS_USER(skb, net, field) \
+	do { \
+		if (snmp_map_allow_update(SNMP_LINUX_MIB, field))  { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_INC_STATS_HASH_ADDR_USER(STAT_NET_INITVAL(net), addr_in, lnx_stats, field); \
+		} \
+	} while (0)
+#define __NET_ADD_SKBUFF_STATS_BH(skb, net, field, adnd) \
+	do { \
+		if (snmp_map_allow_update(SNMP_LINUX_MIB, field))  { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_ADD_STATS_HASH_ADDR_BH(STAT_NET_INITVAL(net), addr_in, lnx_stats, field, adnd); \
+		} \
+	} while (0)
+#define __NET_ADD_SKBUFF_STATS_USER(skb, net, field, adnd) \
+	do { \
+		if (snmp_map_allow_update(SNMP_LINUX_MIB, field))  { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_ADD_STATS_HASH_ADDR_USER(STAT_NET_INITVAL(net), addr_in, lnx_stats, field, adnd); \
+		} \
+	} while (0)
+
+
+/* Update Linux MIB counter via a "struct sk_buff *" of any name + update original counter */
+#define NET_INC_SKBUFF_STATS(skb, field) \
+	do { \
+		__NET_INC_STATS(net, field); \
+		__NET_INC_SKBUFF_STATS((skb), net, field); \
+	} while (0)
+#define NET_INC_SKBUFF_STATS_BH(skb, net, field) \
+	do { \
+		__NET_INC_STATS_BH(net, field); \
+		__NET_INC_SKBUFF_STATS_BH((skb), net, field); \
+	} while (0)
+#define NET_INC_SKBUFF_STATS_USER(skb, net, field) \
+	do { \
+		__NET_INC_STATS_USER(net, field); \
+		__NET_INC_SKBUFF_STATS_USER((skb), net, field); \
+	} while (0)
+#define NET_ADD_SKBUFF_STATS_BH(skb, net, field, adnd) \
+	do { \
+		__NET_ADD_STATS_BH(net, field, adnd); \
+		__NET_ADD_SKBUFF_STATS_BH((skb), net, field, adnd); \
+	} while (0)
+#define NET_ADD_SKBUFF_STATS_USER(skb, net, field, adnd) \
+	do { \
+		__NET_ADD_STATS_USER(net, field, adnd); \
+		__NET_ADD_SKBUFF_STATS_USER((skb), net, field, adnd); \
+	} while (0)
+
+
+/* Update Linux MIB counter via a "struct sk_buff *" named skb. */
+#define NET_INC_SKB_STATS(net, field)			NET_INC_SKBUFF_STATS(skb, net, field)
+#define NET_INC_SKB_STATS_BH(net, field)		NET_INC_SKBUFF_STATS_BH(skb, net, field)
+#define NET_INC_SKB_STATS_USER(net, field)		NET_INC_SKBUFF_STATS_USER(skb, net, field)
+#define NET_ADD_SKB_STATS_BH(net, field, adnd)		NET_ADD_SKBUFF_STATS_BH(skb, net, field, adnd)
+#define NET_ADD_SKB_STATS_USER(net, field, adnd)	NET_ADD_SKBUFF_STATS_USER(skb, net, field, adnd)
+
+
+/*********************************************************************************************
+ * Replacement to TCP_INC, TCP_DEC, TCP__ADD macros to interract with hashed TCP MIB counters.
+ *********************************************************************************************/
+
+/* Macros that interract with TCP MIB via cookie contained in struct sock */
+
+/* Update TCP MIB counter via a "struct sock *" of any name */
+#define __TCP_INC_SOCK_STATS(sk, net, field)  \
+	if (snmp_map_allow_update(SNMP_TCP_MIB, field)) \
+		SNMP_INC_STATS_HASH(sk_cookie(sk), tcp_stats, field)
+#define __TCP_INC_SOCK_STATS_BH(sk, net, field)  \
+	if (snmp_map_allow_update(SNMP_TCP_MIB, field)) \
+		SNMP_INC_STATS_HASH_BH(sk_cookie(sk), tcp_stats, field)
+#define __TCP_INC_SOCK_STATS_USER(sk, net, field)  \
+	if (snmp_map_allow_update(SNMP_TCP_MIB, field)) \
+		SNMP_INC_STATS_HASH_USER(sk_cookie(sk), tcp_stats, field)
+#define __TCP_DEC_SOCK_STATS(sk, net, field)  \
+	if (snmp_map_allow_update(SNMP_TCP_MIB, field)) \
+		SNMP_DEC_STATS_HASH(sk_cookie(sk), tcp_stats, field)
+#define __TCP_ADD_SOCK_STATS_BH(sk, net, field, val)  \
+	if (snmp_map_allow_update(SNMP_TCP_MIB, field)) \
+		SNMP_ADD_STATS_HASH_BH(sk_cookie(sk), tcp_stats, field, val)
+#define __TCP_ADD_SOCK_STATS_USER(sk, net, field, val)  \
+	if (snmp_map_allow_update(SNMP_TCP_MIB, field)) \
+		SNMP_ADD_STATS_HASH_USER(sk_cookie(sk), tcp_stats, field, val)
+
+/* Update TCP MIB counter via a "struct sock *" of any name + update original counter */
+#define TCP_INC_SOCK_STATS(sk, net, field)  \
+	do { \
+		__TCP_INC_STATS(net, field); \
+		__TCP_INC_SOCK_STATS((sk), net, field); \
+	} while (0)
+#define TCP_INC_SOCK_STATS_BH(sk, net, field) \
+	do { \
+		__TCP_INC_STATS_BH(net, field); \
+		__TCP_INC_SOCK_STATS_BH((sk), net, field); \
+	} while (0)
+#define TCP_INC_SOCK_STATS_USER(sk, net, field) \
+	do { \
+		__TCP_INC_STATS_USER(net, field); \
+		__TCP_INC_SOCK_STATS_USER((sk), net, field); \
+	} while (0)
+#define TCP_DEC_SOCK_STATS(sk, net, field)  \
+	do { \
+		__TCP_DEC_STATS(net, field); \
+		__TCP_DEC_SOCK_STATS((sk), net, field); \
+	} while (0)
+#define TCP_ADD_SOCK_STATS_BH(sk, net, field, adnd) \
+	do { \
+		__TCP_ADD_STATS_BH(net, field, adnd); \
+		__TCP_ADD_SOCK_STATS_BH((sk), net, field, adnd); \
+	} while (0)
+#define TCP_ADD_SOCK_STATS_USER(sk, net, field, adnd) \
+	do { \
+		__TCP_ADD_STATS_USER(net, field, adnd); \
+		__TCP_ADD_SOCK_STATS_USER((sk), net, field, adnd); \
+	} while (0)
+
+/*
+ * Update TCP MIB counter via a "struct sock *" named sk.
+ * This is the case in most situations so these macros are used for overriding the originals.
+ */
+#define TCP_INC_SK_STATS(net, field)			TCP_INC_SOCK_STATS(sk, net, field)
+#define TCP_INC_SK_STATS_BH(net, field)			TCP_INC_SOCK_STATS_BH(sk, net, field)
+#define TCP_INC_SK_STATS_USER(net, field)		TCP_INC_SOCK_STATS_USER(sk, net, field)
+#define TCP_DEC_SK_STATS(net, field)			TCP_DEC_SOCK_STATS(sk, net, field)
+#define TCP_ADD_SK_STATS_BH(net, field, adnd)		TCP_ADD_SOCK_STATS_BH(sk, net, field, adnd)
+#define TCP_ADD_SK_STATS_USER(net, field, adnd)		TCP_ADD_SOCK_STATS_USER(sk, net, field, adnd)
+
+/* Macros that interract with Linux TCP via socket buffer */
+
+/* Update TCP MIB counter via a "struct sk_buff *" of any name */
+#define __TCP_INC_SKBUFF_STATS(skb, net, field) \
+	do { \
+		if (snmp_map_allow_update(SNMP_TCP_MIB, field)) { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_INC_STATS_HASH_ADDR(STAT_NET_INITVAL(net), addr_in, tcp_stats, field); \
+		} \
+	} while (0)
+#define __TCP_INC_SKBUFF_STATS_BH(skb, net, field) \
+	do { \
+		if (snmp_map_allow_update(SNMP_TCP_MIB, field)) { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_INC_STATS_HASH_ADDR_BH(STAT_NET_INITVAL(net), addr_in, tcp_stats, field); \
+		} \
+	} while (0)
+#define __TCP_INC_SKBUFF_STATS_USER(skb, net, field) \
+	do { \
+		if (snmp_map_allow_update(SNMP_TCP_MIB, field)) { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_INC_STATS_HASH_ADDR_USER(STAT_NET_INITVAL(net), addr_in, tcp_stats, field); \
+		} \
+	} while (0)
+#define __TCP_DEC_SKBUFF_STATS(skb, net, field) \
+	do { \
+		if (snmp_map_allow_update(SNMP_TCP_MIB, field)) { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_DEC_STATS_HASH_ADDR(STAT_NET_INITVAL(net), addr_in, tcp_stats, field); \
+		} \
+	} while (0)
+#define __TCP_ADD_SKBUFF_STATS_BH(skb, net, field, adnd) \
+	do { \
+		if (snmp_map_allow_update(SNMP_TCP_MIB, field)) { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_ADD_STATS_HASH_ADDR_BH(STAT_NET_INITVAL(net), addr_in, tcp_stats, field, adnd); \
+		} \
+	} while (0)
+#define __TCP_ADD_SKBUFF_STATS_USER(skb, net, field, adnd) \
+	do { \
+		if (snmp_map_allow_update(SNMP_TCP_MIB, field)) { \
+			struct stat_hash_addr addr, *addr_in; \
+			addr_in = skb_addr((skb), &addr); \
+			if (addr_in) \
+				SNMP_ADD_STATS_HASH_ADDR_USER(STAT_NET_INITVAL(net), addr_in, tcp_stats, field, adnd); \
+		} \
+	} while (0)
+
+
+/* Update TCP MIB counter via a "struct sk_buff *" of any name + update original counter */
+#define TCP_INC_SKBUFF_STATS(skb, net, field) \
+	do { \
+		__TCP_INC_STATS(net, field); \
+		__TCP_INC_SKBUFF_STATS((skb), net, field); \
+	} while (0)
+#define TCP_INC_SKBUFF_STATS_BH(skb, net, field) \
+	do { \
+		__TCP_INC_STATS_BH(net, field); \
+		__TCP_INC_SKBUFF_STATS_BH((skb), net, field); \
+	} while (0)
+#define TCP_INC_SKBUFF_STATS_USER(skb, net, field) \
+	do { \
+		__TCP_INC_STATS_USER(net, field); \
+		__TCP_INC_SKBUFF_STATS_USER((skb), net, field); \
+	} while (0)
+#define TCP_DEC_SKBUFF_STATS(skb, net, field) \
+	do { \
+		__TCP_DEC_STATS(net, field); \
+		__TCP_DEC_SKBUFF_STATS((skb), net, field); \
+	} while (0)
+#define TCP_ADD_SKBUFF_STATS_BH(skb, net, field, adnd) \
+	do { \
+		__TCP_ADD_STATS_BH(net, field, adnd); \
+		__TCP_ADD_SKBUFF_STATS_BH((skb), net, field, adnd); \
+	} while (0)
+#define TCP_ADD_SKBUFF_STATS_USER(skb, net, field, adnd) \
+	do { \
+		__TCP_ADD_STATS_USER(net, field, adnd); \
+		__TCP_ADD_SKBUFF_STATS_USER((skb), net, field, adnd); \
+	} while (0)
+
+
+/* Update TCP MIB counter via a "struct sk_buff *" named skb. */
+#define TCP_INC_SKB_STATS(net, field)			TCP_INC_SKBUFF_STATS(skb, net, field)
+#define TCP_INC_SKB_STATS_BH(net, field)		TCP_INC_SKBUFF_STATS_BH(skb, net, field)
+#define TCP_INC_SKB_STATS_USER(net, field)		TCP_INC_SKBUFF_STATS_USER(skb, net, field)
+#define TCP_DEC_SKB_STATS(net, field)			TCP_DEC_SKBUFF_STATS(skb, net, field)
+#define TCP_ADD_SKB_STATS_BH(net, field, adnd)		TCP_ADD_SKBUFF_STATS_BH(skb, net, field, adnd)
+#define TCP_ADD_SKB_STATS_USER(net, field, adnd)	TCP_ADD_SKBUFF_STATS_USER(skb, net, field, adnd)
+
+#else
+
+#define STAT_HASH_SK_INIT(sk) 
+#define STAT_HASH_COOKIE_CLONE(newsk, sk)                          
+#define STAT_HASH_SK_INSERT(sk, direction)
+#define STAT_HASH_SK_INSERT_ATOMIC(sk, direction)
+#define STAT_HASH_SK_INSERT_EXISTING(sk)
+#define STAT_HASH_SK_INSERT_EXISTING_NOALLOC(sk)
+
+#define NET_INC_SOCK_STATS(sk, net, field) __NET_INC_STATS(net, field)
+#define NET_INC_SOCK_STATS_BH(sk, net, field) __NET_INC_STATS_BH(net, field)
+#define NET_INC_SOCK_STATS_USER(sk, net, field) __NET_INC_STATS_USER(net, field)
+#define NET_ADD_SOCK_STATS_BH(sk, net, field, adnd) __NET_ADD_STATS_BH(net, field, adnd)
+#define NET_ADD_SOCK_STATS_USER(sk, net, field, adnd) __NET_ADD_STATS_USER(net, field, adnd)
+
+#define NET_INC_SK_STATS(net, field)  __NET_INC_STATS(net, field)
+#define NET_INC_SK_STATS_BH(net, field)  __NET_INC_STATS_BH(net, field)
+#define NET_INC_SK_STATS_USER(net, field)  __NET_INC_STATS_USER(net, field)
+#define NET_ADD_SK_STATS_BH(net, field, adnd)  __NET_ADD_STATS_BH(net, field, adnd)
+#define NET_ADD_SK_STATS_USER(net, field, adnd)  __NET_ADD_STATS_USER(net, field, adnd)
+
+#define NET_INC_SKBUFF_STATS(skb, net, field) __NET_INC_STATS(net, field)
+#define NET_INC_SKBUFF_STATS_BH(skb, net, field) __NET_INC_STATS_BH(net, field)
+#define NET_INC_SKBUFF_STATS_USER(skb, net, field) __NET_INC_STATS_USER(net, field)
+#define NET_ADD_SKBUFF_STATS_BH(skb, net, field, adnd) __NET_ADD_STATS_BH(net, field, adnd)
+#define NET_ADD_SKBUFF_STATS_USER(skb, net, field, adnd) __NET_ADD_STATS_USER(net, field, adnd)
+
+#define NET_INC_SKB_STATS(net, field)  __NET_INC_STATS(net, field)
+#define NET_INC_SKB_STATS_BH(net, field)   __NET_INC_STATS_BH(net, field)
+#define NET_INC_SKB_STATS_USER(net, field) __NET_INC_STATS_USER(net, field)
+#define NET_ADD_SKB_STATS_BH(net, field, adnd)  __NET_ADD_STATS_BH(net, field, adnd)
+#define NET_ADD_SKB_STATS_USER(net, field, adnd)  __NET_ADD_STATS_USER(net, field, adnd)
+
+#define TCP_INC_SOCK_STATS(sk, net, field) __TCP_INC_STATS(net, field)
+#define TCP_INC_SOCK_STATS_BH(sk, net, field) __TCP_INC_STATS_BH(net, field)
+#define TCP_INC_SOCK_STATS_USER(sk, net, field) __TCP_INC_STATS_USER(net, field)
+#define TCP_DEC_SOCK_STATS(sk, net, field) __TCP_DEC_STATS(net, field)
+#define TCP_ADD_SOCK_STATS_BH(sk, net, field, val) __TCP_ADD_STATS_BH(net, field, val)
+#define TCP_ADD_SOCK_STATS_USER(sk, net, field, val) __TCP_ADD_STATS_USER(net, field, val)
+
+#define TCP_INC_SK_STATS(net, field)  __TCP_INC_STATS(net, field)
+#define TCP_INC_SK_STATS_BH(net, field)  __TCP_INC_STATS_BH(net, field)
+#define TCP_INC_SK_STATS_USER(net, field)  __TCP_INC_STATS_USER(net, field)
+#define TCP_DEC_SK_STATS(net, field)  __TCP_DEC_STATS(net, field)
+#define TCP_ADD_SK_STATS_BH(net, field, val)  __TCP_ADD_STATS_BH(net, field, val)
+#define TCP_ADD_SK_STATS_USER(net, field, val)  __TCP_ADD_STATS_USER(net, field, val)
+
+#define TCP_INC_SKBUFF_STATS(skb, net, field) __TCP_INC_STATS(net, field)
+#define TCP_INC_SKBUFF_STATS_BH(skb, net, field) __TCP_INC_STATS_BH(net, field)
+#define TCP_INC_SKBUFF_STATS_USER(skb, net, field) __TCP_INC_STATS_USER(net, field)
+#define TCP_DEC_SKBUFF_STATS(skb, net, field) __TCP_DEC_STATS(net, field)
+#define TCP_ADD_SKBUFF_STATS_BH(skb, net, field, adnd) __TCP_ADD_STATS_BH(net, field, val)
+#define TCP_ADD_SKBUFF_STATS_USER(skb, net, field, adnd) __TCP_ADD_STATS_USER(net, field, val)
+
+#define TCP_INC_SKB_STATS(net, field)  __TCP_INC_STATS(net, field)
+#define TCP_INC_SKB_STATS_BH(net, field)  __TCP_INC_STATS_BH(net, field)
+#define TCP_INC_SKB_STATS_USER(net, field)  __TCP_INC_STATS_USER(net, field)
+#define TCP_DEC_SKB_STATS(net, field)  __TCP_DEC_STATS(net, field)
+#define TCP_ADD_SKB_STATS_BH(net, field, val)  __TCP_ADD_STATS_BH(net, field, val)
+#define TCP_ADD_SKB_STATS_USER(net, field, val)  __TCP_ADD_STATS_USER(net, field, val)
+
+#endif
+
+#endif
diff -r -U 4 a/include/net/stat_sk_hashtable_net_overrides.h b/include/net/stat_sk_hashtable_net_overrides.h
--- a/include/net/stat_sk_hashtable_net_overrides.h	2013-08-27 17:15:42.965623755 +0300
+++ b/include/net/stat_sk_hashtable_net_overrides.h	2013-08-27 17:15:43.055664650 +0300
@@ -0,0 +1,26 @@
+#ifndef _STAT_SK_HASHTABLE_NET_OVERRIDES_H
+#define _STAT_SK_HASHTABLE_NET_OVERRIDES_H
+
+#include <net/stat_sk_hashtable.h>
+
+#ifdef CONFIG_NET_IPV4_SOCK_STATS
+
+#undef NET_INC_STATS
+#define NET_INC_STATS(net, field) NET_INC_SK_STATS(net, field)
+
+#undef NET_INC_STATS_BH
+#define NET_INC_STATS_BH(net, field) NET_INC_SK_STATS_BH(net, field)
+
+#undef NET_INC_STATS_USER
+#define NET_INC_STATS_USER(net, field)  NET_INC_SK_STATS_USER(net, field)
+
+#undef NET_ADD_STATS_BH
+#define NET_ADD_STATS_BH(net, field, adnd) NET_ADD_SK_STATS_BH(net, field, adnd)
+
+#undef NET_ADD_STATS_USER
+#define NET_ADD_STATS_USER(net, field, adnd) NET_ADD_SK_STATS_USER(net, field, adnd)
+
+#endif
+
+#endif
+
diff -r -U 4 a/include/net/stat_sk_hashtable_tcp_overrides.h b/include/net/stat_sk_hashtable_tcp_overrides.h
--- a/include/net/stat_sk_hashtable_tcp_overrides.h	2013-08-27 17:15:42.972623592 +0300
+++ b/include/net/stat_sk_hashtable_tcp_overrides.h	2013-08-27 17:15:43.069671924 +0300
@@ -0,0 +1,29 @@
+#ifndef _STAT_SK_HASHTABLE_TCP_OVERRIDES_H
+#define _STAT_SK_HASHTABLE_TCP_OVERRIDES_H
+
+#include <net/stat_sk_hashtable.h>
+
+#ifdef CONFIG_NET_IPV4_SOCK_STATS
+
+#undef TCP_INC_STATS
+#define TCP_INC_STATS(net, field) TCP_INC_SK_STATS(net, field)
+
+#undef TCP_INC_STATS_BH
+#define TCP_INC_STATS_BH(net, field) TCP_INC_SK_STATS_BH(net, field)
+
+#undef TCP_INC_STATS_USER
+#define TCP_INC_STATS_USER(net, field) TCP_INC_SK_STATS_USER(net, field)
+
+#undef TCP_DEC_STATS
+#define TCP_DEC_STATS(net, field) TCP_DEC_SK_STATS(net, field)
+
+#undef TCP_ADD_STATS_BH
+#define TCP_ADD_STATS_BH(net, field, val) TCP_ADD_SK_STATS_BH(net, field, val)
+
+#undef TCP_ADD_STATS_USER
+#define TCP_ADD_STATS_USER(net, field, val) TCP_ADD_SK_STATS_USER(net, field, val)
+
+#endif
+
+#endif
+
diff -r -U 4 a/include/net/stat_sk_hashtable_undo_overrides.h b/include/net/stat_sk_hashtable_undo_overrides.h
--- a/include/net/stat_sk_hashtable_undo_overrides.h	2013-08-27 17:15:42.979623650 +0300
+++ b/include/net/stat_sk_hashtable_undo_overrides.h	2013-08-27 17:15:43.084645034 +0300
@@ -0,0 +1,49 @@
+#ifdef CONFIG_NET_IPV4_SOCK_STATS
+
+#undef NET_INC_STATS
+#undef NET_INC_STATS_BH
+#undef NET_INC_STATS_USER
+#undef NET_ADD_STATS_BH
+#undef NET_ADD_STATS_USER
+
+#define NET_INC_STATS(net, field) __NET_INC_STATS(net, field)
+#define NET_INC_STATS_BH(net, field) __NET_INC_STATS_BH(net, field)
+#define NET_INC_STATS_USER(net, field)  __NET_INC_STATS_USER(net, field)
+#define NET_ADD_STATS_BH(net, field, adnd) __NET_ADD_STATS_BH(net, field, adnd)
+#define NET_ADD_STATS_USER(net, field, adnd) __NET_ADD_STATS_USER(net, field, adnd)
+
+#undef TCP_INC_STATS
+#undef TCP_INC_STATS_BH
+#undef TCP_INC_STATS_USER
+#undef TCP_DEC_STATS
+#undef TCP_ADD_STATS_BH
+#undef TCP_ADD_STATS_USER
+
+#define TCP_INC_STATS(net, field) __TCP_INC_STATS(net, field)
+#define TCP_INC_STATS_BH(net, field) __TCP_INC_STATS_BH(net, field)
+#define TCP_INC_STATS_USER(net, field) __TCP_INC_STATS_USER(net, field)
+#define TCP_DEC_STATS(net, field) __TCP_DEC_STATS(net, field)
+#define TCP_ADD_STATS_BH(net, field, val) __TCP_ADD_STATS_BH(net, field, val)
+#define TCP_ADD_STATS_USER(net, field, val) __TCP_ADD_STATS_USER(net, field, val)
+
+#undef STAT_HASH_SK_INIT
+#undef STAT_HASH_COOKIE_CLONE
+#undef STAT_HASH_SK_INSERT_NONATOMIC
+#undef STAT_HASH_SK_INSERT_ATOMIC
+#undef STAT_HASH_SK_INSERT
+#undef STAT_HASH_SK_INSERT_EXISTING_NONATOMIC
+#undef STAT_HASH_SK_INSERT_EXISTING_ATOMIC
+#undef STAT_HASH_SK_INSERT_EXISTING
+#undef STAT_HASH_SK_INSERT_EXISTING_NOALLOC
+
+#define STAT_HASH_SK_INIT(sk)
+#define STAT_HASH_COOKIE_CLONE(newsk, sk)
+#define STAT_HASH_SK_INSERT_NONATOMIC(sk, direction) 
+#define STAT_HASH_SK_INSERT_ATOMIC(sk, direction) 
+#define STAT_HASH_SK_INSERT(sk, direction) 
+#define STAT_HASH_SK_INSERT_EXISTING_NONATOMIC(sk) 
+#define STAT_HASH_SK_INSERT_EXISTING_ATOMIC(sk) 
+#define STAT_HASH_SK_INSERT_EXISTING(sk) 
+#define STAT_HASH_SK_INSERT_EXISTING_NOALLOC(sk)
+
+#endif
diff -r -U 4 a/include/net/tcp.h b/include/net/tcp.h
--- a/include/net/tcp.h	2013-08-27 17:15:42.986623640 +0300
+++ b/include/net/tcp.h	2013-08-27 17:15:43.103606236 +0300
@@ -297,12 +297,17 @@
 }
 
 extern struct proto tcp_prot;
 
-#define TCP_INC_STATS(net, field)	SNMP_INC_STATS((net)->mib.tcp_statistics, field)
-#define TCP_INC_STATS_BH(net, field)	SNMP_INC_STATS_BH((net)->mib.tcp_statistics, field)
-#define TCP_DEC_STATS(net, field)	SNMP_DEC_STATS((net)->mib.tcp_statistics, field)
-#define TCP_ADD_STATS_USER(net, field, val) SNMP_ADD_STATS_USER((net)->mib.tcp_statistics, field, val)
+#define __TCP_INC_STATS(net, field)	SNMP_INC_STATS((net)->mib.tcp_statistics, field)
+#define __TCP_INC_STATS_BH(net, field)	SNMP_INC_STATS_BH((net)->mib.tcp_statistics, field)
+#define __TCP_DEC_STATS(net, field)	SNMP_DEC_STATS((net)->mib.tcp_statistics, field)
+#define __TCP_ADD_STATS_USER(net, field, val) SNMP_ADD_STATS_USER((net)->mib.tcp_statistics, field, val)
+
+#define TCP_INC_STATS(net, field)       __TCP_INC_STATS(net, field)
+#define TCP_INC_STATS_BH(net, field)    __TCP_INC_STATS_BH(net, field)
+#define TCP_DEC_STATS(net, field)       __TCP_DEC_STATS(net, field)
+#define TCP_ADD_STATS_USER(net, field, val) __TCP_ADD_STATS_USER(net, field, val)
 
 extern void			tcp_v4_err(struct sk_buff *skb, u32);
 
 extern void			tcp_shutdown (struct sock *sk, int how);
@@ -1108,12 +1113,12 @@
 
 static inline void tcp_mib_init(struct net *net)
 {
 	/* See RFC 2012 */
-	TCP_ADD_STATS_USER(net, TCP_MIB_RTOALGORITHM, 1);
-	TCP_ADD_STATS_USER(net, TCP_MIB_RTOMIN, TCP_RTO_MIN*1000/HZ);
-	TCP_ADD_STATS_USER(net, TCP_MIB_RTOMAX, TCP_RTO_MAX*1000/HZ);
-	TCP_ADD_STATS_USER(net, TCP_MIB_MAXCONN, -1);
+	__TCP_ADD_STATS_USER(net, TCP_MIB_RTOALGORITHM, 1);
+	__TCP_ADD_STATS_USER(net, TCP_MIB_RTOMIN, TCP_RTO_MIN*1000/HZ);
+	__TCP_ADD_STATS_USER(net, TCP_MIB_RTOMAX, TCP_RTO_MAX*1000/HZ);
+	__TCP_ADD_STATS_USER(net, TCP_MIB_MAXCONN, -1);
 }
 
 /* from STCP */
 static inline void tcp_clear_retrans_hints_partial(struct tcp_sock *tp)
diff -r -U 4 a/net/ipv4/Kconfig b/net/ipv4/Kconfig
--- a/net/ipv4/Kconfig	2013-08-27 17:15:42.993704555 +0300
+++ b/net/ipv4/Kconfig	2013-08-27 17:15:43.129606087 +0300
@@ -669,4 +669,13 @@
 	default n
 	---help---
 	Debug statistics hash table functionality
 
+config NET_IPV4_SOCK_STATS
+	boolean "Access stat hashtable from socket structure"
+	depends on NET_IPV4_STAT_HASHTABLES
+	default y
+	---help---
+	Stores the cookie for accessing the statistics hash in the socket structure.
+
+
+
diff -r -U 4 a/net/ipv4/Makefile b/net/ipv4/Makefile
--- a/net/ipv4/Makefile	2013-08-27 17:15:42.999718205 +0300
+++ b/net/ipv4/Makefile	2013-08-27 17:15:43.151652445 +0300
@@ -53,5 +53,6 @@
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
 		      xfrm4_output.o
 obj-$(CONFIG_NET_IPV4_SNMP_MAPPING) += snmp_map.o
 obj-$(CONFIG_NET_IPV4_STAT_HASHTABLES) += stat_hashtable.o
+obj-$(CONFIG_NET_IPV4_SOCK_STATS) += stat_sk_hashtable.o
 
diff -r -U 4 a/net/ipv4/stat_sk_hashtable.c b/net/ipv4/stat_sk_hashtable.c
--- a/net/ipv4/stat_sk_hashtable.c	2013-08-27 17:15:43.005707986 +0300
+++ b/net/ipv4/stat_sk_hashtable.c	2013-08-27 17:15:43.165606451 +0300
@@ -0,0 +1,148 @@
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+
+#include <net/inet_connection_sock.h>
+#include <net/inet_hashtables.h>
+#include <net/secure_seq.h>
+#include <net/ip.h>
+
+#if defined(CONFIG_IPV6) || defined (CONFIG_IPV6_MODULE)
+#include <linux/in6.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#endif
+
+#include <net/snmp_map.h>
+#include <net/stat_hashtable.h>
+#include <net/stat_sk_hashtable.h>
+
+static inline bool 
+ipv4_addr_loopback(__be32 addr)
+{
+	return (addr & htonl(0xff000000)) == htonl(0x7f000000);
+}
+
+static int
+stat4_hash_filter_addr(struct stat_hash_addr *addr, u8 direction)
+{
+	__be32 local_addr;
+	__be32 remote_addr;
+
+	if (direction == STAT_HASH_SK_IN) {
+		local_addr = addr->daddr.ip;
+		remote_addr = addr->saddr.ip;
+	} else { 	/* STAT_HASH_SK_OUT + STAT_HASH_SK_INOUT */
+		local_addr = addr->saddr.ip;
+		remote_addr = addr->daddr.ip;
+	}
+
+	if (remote_addr == 0) {
+		stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG, "zero IPV4 address\n");
+		return -EINVAL;
+	}
+
+	if (net_stat_hash_loopback == 0) {
+		if (local_addr == remote_addr) {
+			stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG, "local and remote IPV4 addresses are the same\n");
+			return -EINVAL;
+		}
+
+		if (ipv4_addr_loopback(remote_addr)) {
+			stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG, "IPV4 address is on the loopback\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+	
+static int 
+stat6_hash_filter_address(struct stat_hash_addr *addr, u8 direction)
+{
+	struct in6_addr local_addr;
+	struct in6_addr remote_addr;
+	struct in6_addr zero_addr;
+
+	if (net_stat_hashtable_ipv6 == 0) {
+		stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG_VERBOSE, "disabled hashing for address family %d\n", addr->family);
+		return -EINVAL;
+	}
+
+	memset(&zero_addr, 0, sizeof(zero_addr));
+	if (direction == STAT_HASH_SK_IN) {
+		ipv6_addr_copy(&local_addr, &addr->daddr.in6);
+		ipv6_addr_copy(&remote_addr, &addr->saddr.in6);
+	} else { 	/* STAT_HASH_SK_OUT + STAT_HASH_SK_INOUT */
+		ipv6_addr_copy(&local_addr, &addr->saddr.in6);
+		ipv6_addr_copy(&remote_addr, &addr->daddr.in6);
+	}
+
+	if (!memcmp(&zero_addr, &remote_addr, sizeof(zero_addr)))  {
+		stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG, "zero IPV6 address\n");
+		return -EINVAL;
+	}
+
+	if (net_stat_hash_loopback == 0) {
+		if (ipv6_addr_equal(&local_addr, &remote_addr)) {
+			stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG, "local and remote IPV6 addresses are the same\n");
+			return -EINVAL;
+		}
+
+		if (ipv6_addr_loopback(&remote_addr)) {
+			stat_sk_dprintk(STAT_HASH_MESSAGE_DEBUG, "IPV6 address is on the loopback\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+int
+stat_hash_filter_addr(struct stat_hash_addr *addr, u8 direction)
+{
+	int rc = -EINVAL;
+
+	switch (addr->family) {
+                case AF_INET:
+			rc = stat4_hash_filter_addr(addr, direction);
+                        break;
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+		case AF_INET6:
+			rc = stat6_hash_filter_address(addr, direction);
+			break;
+#endif
+                default:
+			break;
+        }
+
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLE_DEBUG
+	if (stat_hash_debug_level >= STAT_HASH_MESSAGE_DEBUG_VERBOSE) {
+		printk("%s address: ", (rc == 0) ? "accepted" : "rejected");
+		stat_hash_dump_address(addr);
+	}
+#endif
+
+	return rc;
+}
+EXPORT_SYMBOL(stat_hash_filter_addr);
+
+int 
+stat_hash_insert(u32 initval, struct stat_hash_addr *addr, bool existing, 
+		 int alloc_flag, struct stat_hash_cookie *cookie)
+{
+	struct stat_hash_entry *entry = NULL;
+	struct stat_hash_cookie ck;
+	int err = -EFAULT;
+
+	STAT_INIT_COOKIE(&ck);
+	if ((entry = stat_hash_get_entry(initval, addr, existing, alloc_flag, &ck)) != NULL) {
+		stat_hash_copy_cookie_atomic(cookie, &ck);
+		err = 0;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(stat_hash_insert);
