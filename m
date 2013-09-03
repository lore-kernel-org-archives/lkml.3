Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab3ICJSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:18:20 -0400
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:61755 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759630Ab3ICJSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:18:18 -0400
X-LoopCount0: from 10.48.28.48
X-IronPort-AV: E=Sophos;i="4.89,1013,1367989200"; 
   d="scan'208";a="271755721"
From: Menny Hamburger <Menny_Hamburger@Dell.com>
Message-Id: <201309030918.r839IDR0013978@bldimenny.dell-idc.com>
Date: Tue, 03 Sep 2013 12:18:13 +0300
To: linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/4] Per IP network statistics: sysctl numbers
 inconsistency with patch 1
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff -r -U 4 a/include/linux/sysctl.h b/include/linux/sysctl.h
--- a/include/linux/sysctl.h	2013-09-02 12:44:17.415733555 +0300
+++ b/include/linux/sysctl.h	2013-09-02 12:44:17.537622128 +0300
@@ -436,8 +436,16 @@
 	NET_TCP_FRTO_RESPONSE=125,
 #ifdef CONFIG_NET_IPV4_SNMP_MAPPING
 	NET_IPV4_SNMP_MAP_LEVEL=126,
 #endif
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+	NET_IPV4_STAT_HASHTABLE_ENABLE=127,
+	NET_IPV4_STAT_HASHTABLE_DEBUG_LEVEL=128,
+	NET_IPV4_STAT_HASHTABLE_LOOPBACK=129,
+	NET_IPV4_STAT_HASHTABLE_DELETE=130,
+	NET_IPV4_STAT_HASHTABLE_ZERO=131,
+	NET_IPV4_STAT_HASHTABLE_MAX=132,
+#endif
 };
 
 enum {
 	NET_IPV4_ROUTE_FLUSH=1,
@@ -592,8 +600,13 @@
 	NET_IPV6_RTR_PROBE_INTERVAL=21,
 	NET_IPV6_ACCEPT_RA_RT_INFO_MAX_PLEN=22,
 	NET_IPV6_PROXY_NDP=23,
 	NET_IPV6_ACCEPT_SOURCE_ROUTE=25,
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+	NET_IPV6_STAT_HASHTABLE_ENABLE=26,
+        NET_IPV6_STAT_HASHTABLE_DELETE=27,
+        NET_IPV6_STAT_HASHTABLE_ZERO=28,
+#endif
 	__NET_IPV6_MAX
 };
 
 /* /proc/sys/net/ipv6/icmp */
diff -r -U 4 a/include/net/stat_hashtable_cookie.h b/include/net/stat_hashtable_cookie.h
--- a/include/net/stat_hashtable_cookie.h	2013-09-02 12:44:17.425622445 +0300
+++ b/include/net/stat_hashtable_cookie.h	2013-09-02 12:44:17.553639794 +0300
@@ -0,0 +1,67 @@
+#ifndef _STAT_HASHTABLE_COOKIE_H
+#define _STAT_HASHTABLE_COOKIE_H
+
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+
+struct stat_hash_cookie {
+	struct {
+		u16 family;
+		u16 bucket;
+	} hash;
+	atomic_t seq;
+};
+
+static inline void
+stat_hash_init_cookie(struct stat_hash_cookie *cookie) 
+{
+	memset(cookie, 0, sizeof(struct stat_hash_cookie));
+}
+
+#define STAT_INIT_COOKIE(cookie) stat_hash_init_cookie(cookie)
+
+static inline void 
+stat_hash_copy_cookie(struct stat_hash_cookie *tgt, struct stat_hash_cookie *src) 
+{
+	memcpy(tgt, src, sizeof(struct stat_hash_cookie));
+}
+
+static inline void
+stat_hash_copy_cookie_atomic(struct stat_hash_cookie *tgt, struct stat_hash_cookie *src)
+{
+	tgt->hash.family = src->hash.family;
+	tgt->hash.bucket = src->hash.bucket;
+	smp_mb();
+	atomic_set(&tgt->seq, src->seq.counter);
+	smp_mb();
+}
+
+#define STAT_COOKIE_POLLUTE_NOENT	(INT_MAX)
+
+static inline bool
+stat_hash_cookie_useable(struct stat_hash_cookie *cookie)
+{
+	u32 value = ((cookie != NULL) ? cookie->seq.counter : 0);
+
+	return (value && (value != STAT_COOKIE_POLLUTE_NOENT));
+}
+
+static inline void
+stat_hash_cookie_pollute(struct stat_hash_cookie *cookie, int code)
+{
+	smp_mb();
+	atomic_set(&cookie->seq, code);
+	smp_mb();
+}
+
+/* We use memory barriers to setup the cookie so we don't have to use atomics (locking) */
+#define STAT_COOKIE_EMPTY(cookie) \
+	((cookie)->seq.counter == 0)
+
+#else
+
+#define STAT_INIT_COOKIE(cookie)
+
+#endif
+
+#endif	
+
diff -r -U 4 a/include/net/stat_hashtable.h b/include/net/stat_hashtable.h
--- a/include/net/stat_hashtable.h	2013-09-02 12:44:17.432630047 +0300
+++ b/include/net/stat_hashtable.h	2013-09-02 12:44:17.569622398 +0300
@@ -0,0 +1,565 @@
+/*
+ *		Per-ip statistics hashtable implmentation
+ *
+ *              Menny Hamburger<menny_hamburger@dell.com>
+ */
+
+#ifndef _STAT_HASHMAP_H
+#define _STAT_HASHMAP_H
+
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+
+#include <linux/jhash.h>
+#include <net/snmp_map.h>
+#include <net/stat_hashtable_cookie.h>
+
+
+extern bool stat_hash_data_collection_started;
+extern int stat_hash_start_data_collection(void);
+extern void stat_hash_stop_data_collection(void);
+
+/* 
+ * Macros used for updating the statistics counters by use of a previousely stored cookie.
+ * Use of a cookie reduces CPU cycles by eliminating the need to call jhash when we need to update the counters
+ * contained in a hashtable entry (the cookie includes the bucket in which the entry is stored).
+ */
+#define MAP_FROM_COOKIE(cookie, m, field) \
+	struct snmp_mib_map *map = ((stat_hash_cookie_useable(cookie) ? stat_hash_##m##_ptr(cookie, field) : NULL))
+
+
+#define SNMP_INC_STATS_HASH_BH(cookie, m, field) \
+	do { \
+		MAP_FROM_COOKIE(cookie, m, field); \
+		SNMP_INC_STATS_MAPPING_BH(map, field); \
+	} while (0)
+#define SNMP_INC_STATS_HASH_USER(cookie, m, field) \
+	do { \
+		MAP_FROM_COOKIE(cookie, m, field); \
+		SNMP_INC_STATS_MAPPING_USER(map, field); \
+	} while (0)
+#define SNMP_INC_STATS_HASH(cookie, m, field) \
+	do { \
+		MAP_FROM_COOKIE(cookie, m, field); \
+		SNMP_INC_STATS_MAPPING(map, field); \
+	} while (0)
+#define SNMP_DEC_STATS_HASH(cookie, m, field) \
+	do { \
+		MAP_FROM_COOKIE(cookie, m, field); \
+		SNMP_DEC_STATS_MAPPING(map, field); \
+	} while (0)
+#define SNMP_ADD_STATS_HASH(cookie, m, field, addend) \
+	do { \
+		MAP_FROM_COOKIE(cookie, m, field); \
+		SNMP_ADD_STATS_MAPPING(map, field, addend); \
+	} while (0)
+#define SNMP_ADD_STATS_HASH_BH(cookie, m, field, addend) \
+	do { \
+		MAP_FROM_COOKIE(cookie, m, field); \
+		SNMP_ADD_STATS_MAPPING_BH(map, field, addend); \
+	} while (0)
+#define SNMP_ADD_STATS_HASH_USER(cookie, m, field, addend) \
+	do { \
+		MAP_FROM_COOKIE(cookie, m, field); \
+		SNMP_ADD_STATS_MAPPING_USER(map, field, addend); \
+	} while (0)
+
+/*
+ * Address definitions used for accessing the hash table.
+ * The address is used both when inserting a new entry into the hash (supplying a cookie to the caller), 
+ * or when we need to update the counters contained in a hash entry and don't have a cookie.
+ */
+union stat_hash_inet_addr {
+	__be32          ip;
+	struct in_addr  in;
+	__be32          ip6[4];
+	struct in6_addr in6;
+};
+
+struct stat_hash_addr {
+	u16 family;
+	union stat_hash_inet_addr saddr;
+	union stat_hash_inet_addr daddr;
+};
+
+/*  Macros used for updating the statistics counters by supplying an address */
+#define MAP_FROM_ADDRESS(initval, addr, m, field) \
+	struct snmp_mib_map *map = stat_hash_##m##_ptr_from_address(initval, addr, field)
+
+#define SNMP_INC_STATS_HASH_ADDR_BH(initval, addr, m, field) \
+	do { \
+		MAP_FROM_ADDRESS(initval, addr, m, field); \
+		SNMP_INC_STATS_MAPPING_BH(map, field); \
+	} while (0)
+#define SNMP_INC_STATS_HASH_ADDR_USER(initval, addr, m, field) \
+	do { \
+		MAP_FROM_ADDRESS(initval, addr, m, field); \
+		SNMP_INC_STATS_MAPPING_USER(map, field); \
+	} while (0)
+#define SNMP_INC_STATS_HASH_ADDR(initval, addr, m, field) \
+	do { \
+		MAP_FROM_ADDRESS(initval, addr, m, field); \
+		SNMP_INC_STATS_MAPPING(map, field); \
+	} while (0)
+#define SNMP_DEC_STATS_HASH_ADDR(initval, addr, m, field) \
+	do { \
+		MAP_FROM_ADDRESS(initval, addr, m, field); \
+		SNMP_DEC_STATS_MAPPING(map, field); \
+	} while (0)
+#define SNMP_ADD_STATS_HASH_ADDR(initval, addr, m, field, addend) \
+	do { \
+		MAP_FROM_ADDRESS(initval, addr, m, field); \
+		SNMP_ADD_STATS_MAPPING(map, field, addend); \
+	} while (0)
+#define SNMP_ADD_STATS_HASH_ADDR_BH(addr, m, field, addend) \
+	do { \
+		MAP_FROM_ADDRESS(initval, addr, m, field); \
+		SNMP_ADD_STATS_MAPPING_BH(map, field, addend); \
+	} while (0)
+#define SNMP_ADD_STATS_HASH_ADDR_USER(initval, addr, m, field, addend) \
+	do { \
+		MAP_FROM_ADDRESS(initval, addr, m, field); \
+		SNMP_ADD_STATS_MAPPING_USER(map, field, addend); \
+	} while (0)
+
+
+/* Available values for state member of stat_hash_entry_mappings */	
+enum {
+	STAT_HASH_MAPPING_STATE_NEW,
+	STAT_HASH_MAPPING_STATE_ENTRY,
+	STAT_HASH_MAPPING_STATE_ALLOCATING,
+	STAT_HASH_MAPPING_STATE_ALLOCATED,
+};
+
+struct stat_hash_entry_mappings;
+/* delayed work section of an entry, used for allocating the per CPU counters lazily if necassary */
+struct state_hash_entry_delayed {
+	struct stat_hash_entry_mappings *mapping;
+	struct delayed_work alloc_work;
+};
+	
+/* Data structure for storing counters of single mapping level */
+struct stat_hash_entry_mappings {
+	atomic_t state;
+	/* We are only interested in TCP statistics for now */
+	DEFINE_SNMP_MIB_MAP(struct tcp_mib_map, tcp_stats);
+	DEFINE_SNMP_MIB_MAP(struct linux_mib_map, lnx_stats);
+	struct state_hash_entry_delayed *delayed;
+};
+
+struct stat_hash_entry {
+	struct hlist_node hlist;
+	struct rcu_head rcu;
+
+	/* A sequence number used for identifying the entry using a previousely stored cookie */
+	u32 sequence;
+
+	/* The contained address */
+	struct stat_hash_addr addr;
+
+	/* the actual mappings that countain the per CPU counters for every available SNMP map level */
+	struct stat_hash_entry_mappings mappings[SNMP_MAP_LEVEL_MAX];
+};
+
+struct stat_hash_lookup_info {
+	int len;
+	/*
+ 	 * Sequence number assigned to the entry with the lowest number in the hashtable.
+ 	 * When hashtable is emptied and the entries are deleted using proc interface, this is updated.
+ 	 * If the sequence number specified in a cookie is less than then the value of this, it can only mean
+ 	 * that the hashtable was emptied at at least once (using the proc interface) and the entry we are looking 
+ 	 * for does not exist.
+ 	 */
+	u32 first_sequence;
+	struct hlist_head *htable;
+};
+
+enum {
+	STAT_HASH_IPV4_INFO,
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+	STAT_HASH_IPV6_INFO,
+#endif
+	STAT_HASH_INFO_MAX,
+};
+
+extern struct stat_hash_lookup_info *stat_lookup_info[STAT_HASH_INFO_MAX];
+
+static inline struct stat_hash_lookup_info *
+stat_hash_get_lookup_info(u16 family)
+{
+	struct stat_hash_lookup_info *info = NULL;
+
+	switch (family) {
+		case AF_INET:
+			info = stat_lookup_info[STAT_HASH_IPV4_INFO];
+			break;
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+		case AF_INET6:
+			info = stat_lookup_info[STAT_HASH_IPV6_INFO];
+			break;
+#endif
+		default:
+			break;
+	}
+
+	return info;
+}
+
+static inline struct snmp_mib_map *
+stat_hash_get_mapping(struct stat_hash_entry_mappings *mapping, u8 mibid)
+{
+	struct snmp_mib_map *map = NULL;
+
+	switch (mibid) {
+		case SNMP_TCP_MIB:
+			map = (struct snmp_mib_map *) &mapping->tcp_stats;
+			break;
+		case SNMP_LINUX_MIB:
+			map = (struct snmp_mib_map *) &mapping->lnx_stats;
+			break;
+		default:
+			break;
+	}
+
+	return map;
+}
+
+static inline bool
+stat_hash_mapping_state_equals(struct stat_hash_entry_mappings *mapping, int state)
+{
+	return (state == atomic_read(&mapping->state));
+}
+
+static inline bool
+stat_hash_mapping_state_equals_nonatomic(struct stat_hash_entry_mappings *mapping, int state)
+{
+	return (state == mapping->state.counter);
+}
+
+static inline bool
+stat_hash_mapping_state(struct stat_hash_entry *entry, int maplvl, int state)
+{
+	return stat_hash_mapping_state_equals(&entry->mappings[maplvl], state);
+}
+
+static inline bool
+stat_hash_mapping_state_nonatomic(struct stat_hash_entry *entry, int maplvl, int state)
+{
+	return stat_hash_mapping_state_equals_nonatomic(&entry->mappings[maplvl], state);
+}
+
+static inline bool
+stat_hash_mapping_allocated(struct stat_hash_entry *entry, int maplvl)
+{
+	return stat_hash_mapping_state(entry, maplvl, STAT_HASH_MAPPING_STATE_ALLOCATED);
+}
+
+/* Non atomic version for use in lookup */
+static inline bool
+stat_hash_mapping_allocated_nonatomic(struct stat_hash_entry *entry, int maplvl)
+{
+	return stat_hash_mapping_state_nonatomic(entry, maplvl, STAT_HASH_MAPPING_STATE_ALLOCATED);
+}
+
+static inline bool
+stat_hash_any_allocated(struct stat_hash_entry *entry)
+{
+	int i;
+
+	for (i = 0; i < SNMP_MAP_LEVEL_MAX; i++) {
+		if (stat_hash_mapping_allocated(entry, i))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Lookup function for accessing a hash entry using a previousely stored cookie.
+ * This is the preferred method for accessing the hashtables and should be used always
+ * unless we don't have access to a cookie. 
+ */ 
+static inline struct snmp_mib_map *
+stat_hash_lookup_by_cookie(struct stat_hash_cookie *cookie, u8 mibid, u8 field)
+{
+	struct stat_hash_lookup_info *info;
+	struct stat_hash_entry *entry = NULL;
+	struct hlist_head *head;
+	struct hlist_node *pos;
+
+        info = stat_hash_get_lookup_info(cookie->hash.family);
+        if (info == NULL)
+                return NULL;
+
+	/*
+ 	 * If the requested entry was deleted from the hashtable, we want the container to stop using the cookie for looking up 
+ 	 * the hash entry, or in other words we want to pollute the cookie so it will no longer be used.
+ 	 */
+	if (cookie->seq.counter < info->first_sequence) {
+		stat_hash_cookie_pollute(cookie, STAT_COOKIE_POLLUTE_NOENT);
+		return NULL;
+	}
+
+	head = &info->htable[cookie->hash.bucket];
+	hlist_for_each_entry_rcu(entry, pos, head, hlist) {
+		if (entry->sequence == cookie->seq.counter) {
+			int maplvl = snmp_map_get_map_level(mibid, field);
+			if ((maplvl != SNMP_MAP_UNMAPPED) && stat_hash_mapping_allocated_nonatomic(entry, maplvl)) {
+				return stat_hash_get_mapping(&entry->mappings[maplvl], mibid);
+			}
+		}
+	}
+
+	return NULL;
+}
+
+
+/*************************************************************************************
+ * Helper functions for looking up an entry in the hashtable by address
+ *************************************************************************************/
+
+
+static inline u16 stat4_ehashfn(u16 sz, u32 initval, struct stat_hash_addr *addr)
+{
+	return jhash_2words(addr->saddr.ip, addr->daddr.ip, initval) & (sz - 1);
+}
+
+
+static inline void
+stat4_reverse_address(struct stat_hash_addr *tgt, struct stat_hash_addr *src)
+{
+	tgt->saddr.ip = src->daddr.ip;
+	tgt->daddr.ip = src->saddr.ip;
+}
+
+static inline bool
+stat4_compare_entry_addr(struct stat_hash_entry *entry, struct stat_hash_addr *addr)
+{
+	return (entry->addr.saddr.ip == addr->saddr.ip) && (entry->addr.daddr.ip == addr->daddr.ip);
+}
+
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+static inline u16 
+stat6_ehashfn(u16 sz, u32 initval, struct stat_hash_addr *addr)
+{
+	u32 key[4];
+
+	key[0] = (__force u32)(&addr->saddr.in6)->s6_addr32[2];
+	key[1] = (__force u32)(&addr->saddr.in6)->s6_addr32[3];
+	key[2] = (__force u32)(&addr->daddr.in6)->s6_addr32[2];
+	key[3] = (__force u32)(&addr->daddr.in6)->s6_addr32[3];
+
+	return jhash2(key, 4, initval) & (sz - 1);
+}
+
+static inline void
+stat6_reverse_address(struct stat_hash_addr *tgt, struct stat_hash_addr *src)
+{
+	ipv6_addr_copy(&tgt->saddr.in6, &src->daddr.in6);
+	ipv6_addr_copy(&tgt->daddr.in6, &src->saddr.in6);
+}
+
+static inline bool
+stat6_compare_entry_addr(struct stat_hash_entry *entry, struct stat_hash_addr *addr)
+{
+	return ((ipv6_addr_equal(&entry->addr.saddr.in6, &addr->saddr.in6) &&
+		 ipv6_addr_equal(&entry->addr.daddr.in6, &addr->daddr.in6)));
+}
+#endif
+
+static inline u16
+stat_hash_bucket(int len, u32 initval, struct stat_hash_addr *addr)
+{
+	if (addr->family == AF_INET)
+		return stat4_ehashfn(len, initval, addr);
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+	else 
+		return stat6_ehashfn(len, initval, addr);
+#endif	
+}
+
+static inline bool
+stat_hash_match(struct stat_hash_entry *entry, struct stat_hash_addr *addr)
+{
+	if (addr->family == AF_INET)
+		return stat4_compare_entry_addr(entry, addr);
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+	else
+		return stat6_compare_entry_addr(entry, addr);
+#endif
+}
+
+static inline void
+stat_hash_reverse_address(struct stat_hash_addr *tgt, struct stat_hash_addr *src)
+{
+	tgt->family = src->family;
+	if (src->family == AF_INET)
+		stat4_reverse_address(tgt, src);
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+	else
+		stat6_reverse_address(tgt, src);
+#endif
+}
+
+static inline struct stat_hash_entry *
+stat_hash_lookup_addr(u32 initval, struct stat_hash_addr *addr, u16 *bucket_in)
+{
+	struct stat_hash_lookup_info *info;
+	struct hlist_head *head;
+	struct hlist_node *pos;
+	struct stat_hash_entry *entry;
+	struct stat_hash_addr raddr;
+	u16 bucket;
+
+	info = stat_hash_get_lookup_info(addr->family);
+	if (info == NULL)
+		return NULL;
+
+	bucket = stat_hash_bucket(info->len, initval, addr);
+	if (bucket_in != NULL)
+		*bucket_in = bucket;
+
+	head = &info->htable[bucket];
+	hlist_for_each_entry_rcu(entry, pos, head, hlist) {
+		if (stat_hash_match(entry, addr))
+			return entry;
+	}
+
+	/* There is a single hash entry for both in and out traffic */
+	stat_hash_reverse_address(&raddr, addr);
+	bucket = stat_hash_bucket(info->len, initval, &raddr);
+	if (bucket_in != NULL)
+		*bucket_in = bucket;
+
+	head = &info->htable[bucket];
+	hlist_for_each_entry_rcu(entry, pos, head, hlist) {
+		if (stat_hash_match(entry, &raddr))
+			return entry;
+	}
+
+	return NULL;
+}
+
+
+
+/*
+ * Lookup function for accessing a hash entry using an address.
+ * This method uses jhash for recomputing the hash bucket using a suppliyed address,
+ * thus tskes some more cpu and should only be used if we don't have a cookie to work with.
+ */
+static inline struct snmp_mib_map *
+stat_hash_lookup_by_address(int initval, struct stat_hash_addr *addr, u8 mibid, u8 field)
+{
+	struct stat_hash_entry *entry = NULL;
+	
+	entry = stat_hash_lookup_addr(initval, addr, NULL);
+	if (entry) {
+		int maplvl = snmp_map_get_map_level(mibid, field);
+		if ((maplvl != SNMP_MAP_UNMAPPED) && stat_hash_mapping_allocated_nonatomic(entry, maplvl)) {
+			return stat_hash_get_mapping(&entry->mappings[maplvl], mibid);
+		}
+	}
+
+	return NULL;
+}
+
+/* Helper function to access specific SNMP MIB statistics in the hash entry by cookie */
+static inline struct snmp_mib_map *
+stat_hash_tcp_stats_ptr(struct stat_hash_cookie *cookie, u8 field)
+{
+	return stat_hash_lookup_by_cookie(cookie, SNMP_TCP_MIB, field);
+}
+
+static inline struct snmp_mib_map *
+stat_hash_lnx_stats_ptr(struct stat_hash_cookie *cookie, u8 field)
+{
+	return stat_hash_lookup_by_cookie(cookie, SNMP_LINUX_MIB, field);
+}
+
+/* Helper function to access specific SNMP MIB statistics in the hash entry by address */
+static inline struct snmp_mib_map *
+stat_hash_tcp_stats_ptr_from_address(int initval, struct stat_hash_addr *addr, u8 field)
+{
+	return stat_hash_lookup_by_address(initval, addr, SNMP_TCP_MIB, field);
+}
+
+static inline struct snmp_mib_map *
+stat_hash_lnx_stats_ptr_from_address(int initval, struct stat_hash_addr *addr, u8 field)
+{
+	return stat_hash_lookup_by_address(initval, addr, SNMP_LINUX_MIB, field);
+}
+
+/* possible flags for alloc_flag argument to stat_hash_get_entry */
+enum {
+	/*
+ 	 * If an entry containing the address does not exists - don't allocate a new one.
+ 	 * If an entry does exists, don't try to add new mapping levels to it (sort of a "read only" flag).
+ 	 */
+	STAT_HASH_ALLOC_FLAG_NOALLOC,
+	/*
+ 	 * If an entry doesn't exists we will allocate it and add it to the hashtable,
+ 	 * where the per CPU counters are allocated for all mappings up to snmp_map_level.
+ 	 * If an entry exists, missing per CPU counters up to snmp_map_level will be allocated.
+ 	 */
+	STAT_HASH_ALLOC_FLAG_ALLOC,
+	/*
+ 	 * If an entry doesn't exists we will allocate it and add it to the hashtable,
+ 	 * where the per CPU counters are allocated for all mappings up to snmp_map_level in delayed work.
+ 	 */
+	STAT_HASH_ALLOC_FLAG_DELAYED_ALLOC,
+};
+
+/*
+ * Main entry point for inserting an entry containing a specified address into the statistics hashtable.
+ * Arguments:
+ * initval:    used by jhash
+ * existing:   were expecting an entry containing the address to exists, if it doesn't we do not try to allocate insert a new entry.
+ * alloc_flag: used for specifying how an entry per CPU counters should be allocated per mapping level (stat_hash_entry_mappings)
+ * 	       SNMP MIB per CPU counters are allocated with GFP_KERNEL, which is not suitible for allocation inside an atomic context
+ * 	       or spinlock. Instead of revising the infrastructure with an option to allocate the counters with GFP_ATOMIC,
+ * 	       we add an option to allocate the counters lazily using delayed work.
+ */
+struct stat_hash_entry *
+stat_hash_get_entry(u32 initval, struct stat_hash_addr *addr, 
+		    bool existing, int alloc_flag, struct stat_hash_cookie *cookie);
+
+
+
+
+
+/* Used for printing the IP address for debugging purposes */
+void stat_hash_dump_address(struct stat_hash_addr *addr);
+
+extern int net_stat_hashtable;
+extern int net_stat_hash_loopback;
+extern int net_stat_ipv4_sysctl_hash_delete;
+extern int net_stat_ipv4_sysctl_hash_zero;
+extern int stat_hash_enable_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos);
+extern int stat_hash_ipv4_delete_hash_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos);
+extern int stat_hash_ipv4_zero_hash_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos);
+
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+extern int net_stat_hashtable_ipv6;
+extern int net_stat_ipv6_sysctl_hash_delete;
+extern int net_stat_ipv6_sysctl_hash_zero;
+extern int stat_hash_ipv6_delete_hash_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos);
+extern int stat_hash_ipv6_zero_hash_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos);
+#endif
+
+extern int stat_hash_sysctl_hash_max[STAT_HASH_INFO_MAX];
+
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLE_DEBUG
+enum {
+	STAT_HASH_MESSAGE_ERROR,
+	STAT_HASH_MESSAGE_WARNING,
+	STAT_HASH_MESSAGE_NOTICE,
+	STAT_HASH_MESSAGE_INFO,
+	STAT_HASH_MESSAGE_DEBUG,
+	STAT_HASH_MESSAGE_DEBUG_VERBOSE,
+};
+
+extern int stat_hash_debug_level;
+#endif
+
+#endif
+
+#endif
diff -r -U 4 a/kernel/sysctl_check.c b/kernel/sysctl_check.c
--- a/kernel/sysctl_check.c	2013-09-02 12:44:17.440680048 +0300
+++ b/kernel/sysctl_check.c	2013-09-02 12:44:17.586622176 +0300
@@ -541,8 +541,11 @@
 	{ NET_NF_CONNTRACK_FRAG6_TIMEOUT,	"nf_conntrack_frag6_timeout" },
 	{ NET_NF_CONNTRACK_FRAG6_LOW_THRESH,	"nf_conntrack_frag6_low_thresh" },
 	{ NET_NF_CONNTRACK_FRAG6_HIGH_THRESH,	"nf_conntrack_frag6_high_thresh" },
 	{ NET_IPV6_MLD_MAX_MSF,		"mld_max_msf" },
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+	{ NET_CORE_STAT_HASHTABLE_IPV6, 	"stat_hash_ipv6" },
+#endif
 	{ 2088 /* IPQ_QMAX */,		"ip6_queue_maxlen" },
 	{}
 };
 
diff -r -U 4 a/net/ipv4/Kconfig b/net/ipv4/Kconfig
--- a/net/ipv4/Kconfig	2013-09-02 12:44:17.452622191 +0300
+++ b/net/ipv4/Kconfig	2013-09-02 12:44:17.612729975 +0300
@@ -650,4 +650,23 @@
 	the counters are allocated per CPU and each counter is 8 bytes.
 	This feature enables allocation of only a subset of counters from within a stat mib
 	by defining a mapping between the whole range of counters to a smaller set.
 
+config NET_IPV4_STAT_HASHTABLES
+	boolean "Define a hash table to hold per-ip IPV4 statistics"
+	depends on NET_IPV4_SNMP_MAPPING
+	default y
+	---help---
+	Define a hash table to hold per-ip IPV4 statistics
+
+config NET_IPV4_STAT_HASHTABLE_SIZE
+	int "Define size of per-ip statistics hashtable"
+	depends on NET_IPV4_STAT_HASHTABLES
+	default "2048"
+
+config NET_IPV4_STAT_HASHTABLE_DEBUG
+	boolean "Debug statistics hash table functionality"
+	depends on NET_IPV4_STAT_HASHTABLES
+	default n
+	---help---
+	Debug statistics hash table functionality
+
diff -r -U 4 a/net/ipv4/Makefile b/net/ipv4/Makefile
--- a/net/ipv4/Makefile	2013-09-02 12:44:17.459626370 +0300
+++ b/net/ipv4/Makefile	2013-09-02 12:44:17.636812490 +0300
@@ -52,5 +52,6 @@
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
 		      xfrm4_output.o
 obj-$(CONFIG_NET_IPV4_SNMP_MAPPING) += snmp_map.o
+obj-$(CONFIG_NET_IPV4_STAT_HASHTABLES) += stat_hashtable.o
 
diff -r -U 4 a/net/ipv4/proc.c b/net/ipv4/proc.c
--- a/net/ipv4/proc.c	2013-09-02 12:44:17.467626639 +0300
+++ b/net/ipv4/proc.c	2013-09-02 12:44:17.651769979 +0300
@@ -44,8 +44,12 @@
 #include <linux/seq_file.h>
 #include <net/sock.h>
 #include <net/raw.h>
 
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+#include <net/snmp_map.h>
+#endif
+
 /*
  *	Report socket allocation statistics [mea@utu.fi]
  */
 static int sockstat_seq_show(struct seq_file *seq, void *v)
@@ -450,19 +454,43 @@
 	.llseek	 = seq_lseek,
 	.release = single_release_net,
 };
 
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+extern int show_hash4_info(struct seq_file *, void *v);
+
+static int stat4_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_hash4_info, NULL);
+}
+
+static const struct file_operations stat4_hash_seq_fops = {
+	.owner  = THIS_MODULE,
+	.open   = stat4_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+#endif
+
 static __net_init int ip_proc_init_net(struct net *net)
 {
 	if (!proc_net_fops_create(net, "sockstat", S_IRUGO, &sockstat_seq_fops))
 		goto out_sockstat;
 	if (!proc_net_fops_create(net, "netstat", S_IRUGO, &netstat_seq_fops))
 		goto out_netstat;
 	if (!proc_net_fops_create(net, "snmp", S_IRUGO, &snmp_seq_fops))
 		goto out_snmp;
-
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+	if (!proc_net_fops_create(net, "perip", S_IRUGO, &stat4_hash_seq_fops))
+		goto out_hash;
+#endif
 	return 0;
 
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+out_hash:
+	proc_net_remove(net, "snmp");
+#endif
 out_snmp:
 	proc_net_remove(net, "netstat");
 out_netstat:
 	proc_net_remove(net, "sockstat");
@@ -471,8 +499,11 @@
 }
 
 static __net_exit void ip_proc_exit_net(struct net *net)
 {
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+	proc_net_remove(net, "perip");
+#endif
 	proc_net_remove(net, "snmp");
 	proc_net_remove(net, "netstat");
 	proc_net_remove(net, "sockstat");
 }
@@ -483,7 +514,11 @@
 };
 
 int __init ip_misc_proc_init(void)
 {
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+	snmp_map_register_labels(SNMP_TCP_MIB, snmp4_tcp_list, sizeof(snmp4_tcp_list) / sizeof(struct snmp_mib));
+	snmp_map_register_labels(SNMP_LINUX_MIB, snmp4_net_list, sizeof(snmp4_net_list) / sizeof(struct snmp_mib));
+#endif
 	return register_pernet_subsys(&ip_proc_ops);
 }
 
diff -r -U 4 a/net/ipv4/stat_hashtable.c b/net/ipv4/stat_hashtable.c
--- a/net/ipv4/stat_hashtable.c	2013-09-02 12:44:17.474632471 +0300
+++ b/net/ipv4/stat_hashtable.c	2013-09-02 12:44:17.667792078 +0300
@@ -0,0 +1,876 @@
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/wait.h>
+#include <linux/seq_file.h>
+#include <linux/ip.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/socket.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <linux/jhash.h>
+#include <linux/bitmap.h>
+#include <linux/kthread.h>
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+#include <linux/in6.h>
+#include <linux/ipv6.h>
+#include <net/ipv6.h>
+#endif
+
+#include <net/stat_hashtable.h>
+
+int net_stat_hashtable = 1;
+EXPORT_SYMBOL(net_stat_hashtable);
+
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLE_DEBUG
+int stat_hash_debug_level = 0;
+EXPORT_SYMBOL(stat_hash_debug_level);
+#endif
+
+bool stat_hash_data_collection_started = false;
+EXPORT_SYMBOL(stat_hash_data_collection_started);
+
+int net_stat_hash_loopback = 0;
+int net_stat_ipv4_sysctl_hash_delete;
+int net_stat_ipv4_sysctl_hash_zero;
+
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+int net_stat_hashtable_ipv6 = 0;
+EXPORT_SYMBOL(net_stat_hashtable_ipv6);
+
+int net_stat_ipv6_sysctl_hash_delete;
+EXPORT_SYMBOL(net_stat_ipv6_sysctl_hash_delete);
+
+int net_stat_ipv6_sysctl_hash_zero;
+EXPORT_SYMBOL(net_stat_ipv6_sysctl_hash_zero);
+#endif
+
+#define STAT_HASH_MAX_DEFAULT 1024
+int stat_hash_sysctl_hash_max[STAT_HASH_INFO_MAX] = { 
+	STAT_HASH_MAX_DEFAULT, 
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+	STAT_HASH_MAX_DEFAULT 
+#endif
+};
+
+#define STAT_HASH_PREFIX "stat_hash: "
+
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLE_DEBUG
+#define stat_dprintk(level, format...) \
+	if ((stat_hash_debug_level) >= (level)) \
+		printk(KERN_DEBUG STAT_HASH_PREFIX format)
+#else
+#define stat_dprintk(level, format...)
+#endif
+
+#define atomic_set_mb(v,i) \
+	do { \
+		smp_mb(); \
+		atomic_set(v,i); \
+		smp_mb(); \
+	} while (0)
+
+typedef void (*stat_hash_copy_entry_addr_t)(struct stat_hash_entry *entry, struct stat_hash_addr *addr);
+typedef void (*stat_hash_print_t)(struct stat_hash_addr *addr);
+typedef void (*stat_hash_print_seq_t)(struct seq_file *seq, struct stat_hash_entry *entry);
+
+static void stat_hash_alloc_delayed(struct work_struct *);
+
+struct stat_hash_access_info {
+	spinlock_t lock;
+	atomic_t sequence;
+	atomic_t count;
+	int *max;
+	stat_hash_print_t print;
+	stat_hash_print_seq_t print_seq;
+	stat_hash_copy_entry_addr_t copy;
+	void *lock_bitmap;
+};
+
+static void stat4_copy_entry_addr(struct stat_hash_entry *entry, struct stat_hash_addr *addr);
+static void stat4_dump_address(struct stat_hash_addr *addr);
+static void stat4_dump_entry_address(struct seq_file *seq, struct stat_hash_entry *entry);
+
+#define STAT4_HASH_TABLE_SIZE  CONFIG_NET_IPV4_STAT_HASHTABLE_SIZE
+static struct hlist_head stat4_hashtable[STAT4_HASH_TABLE_SIZE];
+static DECLARE_BITMAP(stat4_hashtable_lock_bitmap, STAT4_HASH_TABLE_SIZE);
+static struct stat_hash_access_info stat4_access_info = {
+	.lock = SPIN_LOCK_UNLOCKED,
+	.sequence = ATOMIC_INIT(0),
+	.count = ATOMIC_INIT(0),
+	.max = &stat_hash_sysctl_hash_max[STAT_HASH_IPV4_INFO],
+	.print = stat4_dump_address,
+	.print_seq = stat4_dump_entry_address,
+	.copy = stat4_copy_entry_addr,
+	.lock_bitmap = stat4_hashtable_lock_bitmap,
+};
+
+struct stat_hash_lookup_info stat4_lookup_info = {
+	.len = STAT4_HASH_TABLE_SIZE,	
+	.first_sequence = 0,
+	.htable = stat4_hashtable,
+};
+
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+
+static void stat6_copy_entry_addr(struct stat_hash_entry *entry, struct stat_hash_addr *addr);
+static void stat6_dump_address(struct stat_hash_addr *addr);
+static void stat6_dump_entry_address(struct seq_file *seq, struct stat_hash_entry *entry);
+
+#define STAT6_HASH_TABLE_SIZE  CONFIG_NET_IPV4_STAT_HASHTABLE_SIZE
+static struct hlist_head stat6_hashtable[STAT6_HASH_TABLE_SIZE];
+static DECLARE_BITMAP(stat6_hashtable_lock_bitmap, STAT6_HASH_TABLE_SIZE);
+static struct stat_hash_access_info stat6_access_info = {
+	.lock = SPIN_LOCK_UNLOCKED,
+	.sequence = ATOMIC_INIT(0),
+	.count = ATOMIC_INIT(0),
+	.max = &stat_hash_sysctl_hash_max[STAT_HASH_IPV6_INFO],
+	.print = stat6_dump_address,
+	.print_seq = stat6_dump_entry_address,
+	.copy = stat6_copy_entry_addr,
+	.lock_bitmap = stat6_hashtable_lock_bitmap,
+};
+
+struct stat_hash_lookup_info stat6_lookup_info = {
+	.len = STAT6_HASH_TABLE_SIZE,
+	.first_sequence = 0,
+	.htable = stat6_hashtable,
+};
+#endif
+
+static struct stat_hash_access_info *stat_access_info[] = {
+	&stat4_access_info,
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+	&stat6_access_info,
+#endif
+};
+
+struct stat_hash_lookup_info *stat_lookup_info[STAT_HASH_INFO_MAX] = {
+	&stat4_lookup_info,
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+	&stat6_lookup_info,
+#endif
+};
+EXPORT_SYMBOL(stat_lookup_info);
+
+static inline struct stat_hash_access_info *
+stat_hash_get_access_info(u16 family)
+{
+	struct stat_hash_access_info *info = NULL;
+
+	switch (family) {
+		case AF_INET:
+			info = stat_access_info[STAT_HASH_IPV4_INFO];
+			break;
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+		case AF_INET6:
+			info = stat_access_info[STAT_HASH_IPV6_INFO];
+			break;
+#endif
+		default:
+			stat_dprintk(STAT_HASH_MESSAGE_NOTICE, "unsupported family %d\n", family);
+			break;
+	}
+
+	return info;	
+}
+
+static inline int
+stat_hash_get_info(u16 family, struct stat_hash_access_info **access_info, 
+		   struct stat_hash_lookup_info **lookup_info)
+{
+	struct stat_hash_access_info *a = stat_hash_get_access_info(family);
+	struct stat_hash_lookup_info *l = stat_hash_get_lookup_info(family);
+
+	if (a == NULL || l == NULL)
+		return -EINVAL;
+
+	*access_info = a;
+	*lookup_info = l;
+
+	return 0;
+}
+
+static void stat_destroy(struct stat_hash_entry *entry);
+
+/*
+ * Helper functions shared by both ipv4 and ipv6
+ */
+static struct stat_hash_entry *
+__alloc_stat_entry(void)
+{
+	struct stat_hash_entry *entry = NULL;
+	int err, i;
+
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (entry == NULL) {
+		printk(KERN_NOTICE STAT_HASH_PREFIX "OOM while allocating a new hash entry\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	INIT_RCU_HEAD(&entry->rcu);
+
+	for (i = 0; i < SNMP_MAP_LEVEL_MAX; i++) {
+		entry->mappings[i].delayed = kzalloc(sizeof(struct state_hash_entry_delayed), GFP_ATOMIC);
+		if (entry->mappings[i].delayed == NULL) {
+			printk(KERN_NOTICE STAT_HASH_PREFIX "OOM while allocating delayed work section for a new hash entry\n");
+			err = -ENOMEM;
+			goto out_destroy;
+		}
+		entry->mappings[i].state.counter = STAT_HASH_MAPPING_STATE_ENTRY;
+		entry->mappings[i].delayed->mapping = &entry->mappings[i];
+		INIT_DELAYED_WORK(&entry->mappings[i].delayed->alloc_work, stat_hash_alloc_delayed);
+	}
+	
+	return entry;
+
+out_destroy:
+	for (i = 0; i < SNMP_MAP_LEVEL_MAX; i++) {
+		if (entry->mappings[i].delayed != NULL) 
+			kfree(entry->mappings[i].delayed);
+	}
+	kfree(entry);
+out:
+	return ERR_PTR(err);
+}
+
+static int
+stat_alloc_mibs(struct stat_hash_entry_mappings *mapping)
+{
+	int err, maplvl;
+	struct stat_hash_entry *entry;
+
+        maplvl = mapping->tcp_stats.maplvl;
+	entry = container_of(mapping, struct stat_hash_entry, mappings[maplvl]);
+
+	if ((err = snmp_map_mib_init((struct snmp_mib_map *) &mapping->tcp_stats)) < 0)
+		goto out_err;
+
+	if ((err = snmp_map_mib_init((struct snmp_mib_map *) &mapping->lnx_stats)) < 0)
+		goto out_free_tcp_mib;
+
+	stat_dprintk(STAT_HASH_MESSAGE_INFO, "mapping %d has been allocated for entry sequence %d\n",
+		     maplvl, entry->sequence);
+
+	return 0;
+
+out_free_tcp_mib:
+	snmp_map_mib_free((struct snmp_mib_map *) &mapping->tcp_stats);
+out_err:
+
+	return err;
+}
+
+static void
+stat_free_mibs(struct stat_hash_entry *entry)
+{
+	int i;
+
+	for (i = SNMP_MAP_LEVEL_MAX - 1; i > 0; i--) {
+		smp_mb();
+		if (atomic_cmpxchg(&entry->mappings[i].state, STAT_HASH_MAPPING_STATE_ALLOCATED,
+		    STAT_HASH_MAPPING_STATE_ENTRY) == STAT_HASH_MAPPING_STATE_ALLOCATED) {
+			smp_mb();
+			snmp_map_mib_free((struct snmp_mib_map *) &entry->mappings[i].tcp_stats);
+			snmp_map_mib_free((struct snmp_mib_map *) &entry->mappings[i].lnx_stats);
+		}
+	}
+}
+
+static int 
+stat_hash_alloc_counters(struct stat_hash_entry_mappings *mapping)
+{
+	int err;
+
+	if ((err = stat_alloc_mibs(mapping)) < 0)
+		return err;
+
+	/* We don't need the delayed allocation stuff any more */
+	kfree(mapping->delayed);
+	mapping->delayed = NULL;
+
+	atomic_set_mb(&mapping->state, STAT_HASH_MAPPING_STATE_ALLOCATED);
+
+	return 0;
+}
+
+#define STAT_DELAYED_ALLOC_PERIOD ((2 * HZ)/3)
+static void 
+stat_hash_alloc_delayed(struct work_struct *work)
+{
+	int err, maplvl;
+	struct stat_hash_entry *entry;
+	struct state_hash_entry_delayed *delayed = container_of(work, struct state_hash_entry_delayed, alloc_work.work);
+	struct stat_hash_entry_mappings *mapping = delayed->mapping;
+
+	maplvl = mapping->tcp_stats.maplvl;
+	entry = container_of(mapping, struct stat_hash_entry, mappings[maplvl]);
+
+	stat_dprintk(STAT_HASH_MESSAGE_INFO, "proccessing delayed allocation for entry sequence %d, mapping %d\n",
+		     entry->sequence, maplvl);
+
+	if ((err = stat_hash_alloc_counters(mapping)) < 0) {
+		printk(KERN_NOTICE STAT_HASH_PREFIX "error %d while allocating mapping %d for entry sequence %d\n",
+		       err, maplvl, entry->sequence);
+
+		atomic_set_mb(&mapping->state, STAT_HASH_MAPPING_STATE_ENTRY);
+	}
+}
+
+static int
+stat_hash_alloc_mappings(struct stat_hash_entry *entry, int alloc_flag)
+{
+	int err = 0, i, map_level = snmp_map_level, again = 0;
+	struct stat_hash_entry_mappings *mapping;
+
+	for (i = 0; i <= map_level; i++) {
+		mapping = &entry->mappings[i];
+		smp_mb();
+		if (atomic_cmpxchg(&mapping->state, STAT_HASH_MAPPING_STATE_ENTRY, 
+				   STAT_HASH_MAPPING_STATE_ALLOCATING) == STAT_HASH_MAPPING_STATE_ENTRY) {
+			smp_mb();
+			if (alloc_flag == STAT_HASH_ALLOC_FLAG_ALLOC) {
+				if ((err = stat_hash_alloc_counters(mapping)) < 0)
+					goto out_rollback;
+			} else {
+				stat_dprintk(STAT_HASH_MESSAGE_INFO, "scheduled delayed allocation for entry sequence %d, mapping %d\n",
+					     entry->sequence, i);
+
+				schedule_delayed_work(&mapping->delayed->alloc_work, STAT_DELAYED_ALLOC_PERIOD);
+			}
+		} else {
+			again = 1;
+			continue;
+		}
+	}
+
+	return ((again) ? -EAGAIN : err);
+
+out_rollback:
+	atomic_set_mb(&mapping->state, STAT_HASH_MAPPING_STATE_ENTRY);
+
+	printk(KERN_NOTICE STAT_HASH_PREFIX "error %d while allocating mapping %d for entry sequence %d\n",
+	       err, i, entry->sequence);
+
+	return err;
+}
+
+static int
+stat_hash_init_mappings(struct stat_hash_entry *entry) 
+{
+	int err = 0, i;
+	struct stat_hash_entry_mappings *mapping;
+
+	for (i = 0; i < SNMP_MAP_LEVEL_MAX; i++) {
+		mapping = &entry->mappings[i];
+		if ((err = snmp_map_init_map(i, SNMP_TCP_MIB, (struct snmp_mib_map *) &mapping->tcp_stats)) < 0)
+			break;
+
+		if ((err = snmp_map_init_map(i, SNMP_LINUX_MIB, (struct snmp_mib_map *) &mapping->lnx_stats)) < 0)
+			break;
+	}
+
+	if (err != 0)
+		 printk(KERN_NOTICE STAT_HASH_PREFIX "error %d while initializing mapping %d for new entry\n",
+			err, i); 
+
+	return err;
+}
+
+static struct stat_hash_cookie *
+stat_fill_cookie(struct stat_hash_entry *entry, u16 family, u16 bucket, struct stat_hash_cookie *cookie)
+{
+	if (cookie != NULL) {
+		cookie->hash.family = family;
+		cookie->hash.bucket = bucket;
+		atomic_set_mb(&cookie->seq, entry->sequence);
+	}
+
+	return cookie;		
+}
+
+/*
+ * IPV4 stat hashtable
+ */
+static void
+stat4_copy_entry_addr(struct stat_hash_entry *entry, struct stat_hash_addr *addr)
+{
+	entry->addr.family = addr->family;
+	entry->addr.saddr.ip = addr->saddr.ip;
+	entry->addr.daddr.ip = addr->daddr.ip;
+}
+
+static void
+stat4_dump_address(struct stat_hash_addr *addr)
+{
+	printk(KERN_NOTICE STAT_HASH_PREFIX "IPV4 address pair: %pI4, %pI4\n", &addr->saddr, &addr->daddr);
+}
+
+static void
+stat4_dump_entry_address(struct seq_file *seq, struct stat_hash_entry *entry)
+{
+	seq_printf(seq, "%pI4, %pI4", &entry->addr.saddr, &entry->addr.daddr);
+}
+
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+static void
+stat6_copy_entry_addr(struct stat_hash_entry *entry, struct stat_hash_addr *addr)
+{
+	entry->addr.family = addr->family;
+	ipv6_addr_copy(&entry->addr.saddr.in6, &addr->saddr.in6);
+	ipv6_addr_copy(&entry->addr.daddr.in6, &addr->daddr.in6);
+}
+
+static void
+stat6_dump_address(struct stat_hash_addr *addr)
+{
+	printk(KERN_NOTICE STAT_HASH_PREFIX "IPV6 addresss pair: %pI6, %pI6\n", &addr->saddr.in6, &addr->daddr.in6);
+}
+
+static void
+stat6_dump_entry_address(struct seq_file *seq, struct stat_hash_entry *entry)
+{
+	seq_printf(seq, "%pI6, %pI6", &entry->addr.saddr.in6, &entry->addr.daddr.in6);
+}
+#endif
+
+static struct stat_hash_entry *
+stat_hash_alloc_entry(u32 initval, struct stat_hash_addr *addr)
+{
+	struct stat_hash_entry *entry = NULL;
+	struct stat_hash_access_info *access_info;
+	struct stat_hash_lookup_info *lookup_info;
+
+	if (stat_hash_get_info(addr->family, &access_info, &lookup_info) < 0)
+		return NULL;
+
+	entry = __alloc_stat_entry();
+	if (entry && !IS_ERR(entry)) {
+		entry->sequence = atomic_inc_return(&access_info->sequence);
+		access_info->copy(entry, addr);
+	}
+
+	return entry;	
+}
+
+static bool
+stat_hash_all_processed_allocate(struct stat_hash_entry *entry)
+{
+	int i, map_level = snmp_map_level;
+
+	for (i = 0; i < map_level; i++) {
+		if (!stat_hash_mapping_state(entry, i, STAT_HASH_MAPPING_STATE_ALLOCATING) ||
+		    !stat_hash_mapping_state(entry, i, STAT_HASH_MAPPING_STATE_ALLOCATED))
+			return false;
+	}
+
+	return true;
+}
+
+struct stat_hash_entry *
+stat_hash_get_entry(u32 initval, struct stat_hash_addr *addr, 
+		    bool existing, int alloc_flag, struct stat_hash_cookie *cookie)
+{
+        struct stat_hash_access_info *access_info = NULL;
+	struct stat_hash_lookup_info *lookup_info = NULL;
+        struct stat_hash_entry *entry = NULL;
+        u16 bucket = 0;
+        int err;
+
+	if (stat_hash_get_info(addr->family, &access_info, &lookup_info) < 0)
+		return NULL;
+
+	/* Fail here if we are looking for an existing entry and it does not exists */
+	entry = stat_hash_lookup_addr(initval, addr, &bucket);
+
+
+	if (existing && (entry == NULL)) {
+		stat_dprintk(STAT_HASH_MESSAGE_DEBUG, "hash entry does not exist - unable to reuse\n");
+		return NULL;
+	}
+
+	/* 
+ 	 * If we find an entry reuse it, possibly allocating additional map levels.
+ 	 */
+	if (entry != NULL) {
+		stat_fill_cookie(entry, addr->family, bucket, cookie);
+		stat_dprintk(STAT_HASH_MESSAGE_DEBUG, "reusining entry (family = %d, bucket = %d, sequence = %d)\n",
+			     cookie->hash.family, cookie->hash.bucket, entry->sequence);
+
+		if (!stat_hash_all_processed_allocate(entry)) {		
+			if ((err = stat_hash_alloc_mappings(entry, alloc_flag)) < 0) {
+				if (err == -EAGAIN) {
+					stat_dprintk(STAT_HASH_MESSAGE_DEBUG, "mapping not in correct state for alloc (family = %d, bucket = %d, sequence = %d)\n",
+					     cookie->hash.family, cookie->hash.bucket, entry->sequence);
+				} else {
+					stat_dprintk(STAT_HASH_MESSAGE_NOTICE, "error %d while allocating mapping (family = %d, bucket = %d, sequence = %d)\n",
+						     err, cookie->hash.family, cookie->hash.bucket, entry->sequence);
+				}
+			}
+		}
+	
+		return entry;
+	}
+
+ 	/* we cannot allocate a new entry - bail out */
+	if (alloc_flag == STAT_HASH_ALLOC_FLAG_NOALLOC) {
+		stat_dprintk(STAT_HASH_MESSAGE_INFO, "cannot allocate a new entry at this stage\n");
+		return NULL;
+	}
+
+	if (atomic_read(&access_info->count) >= *(access_info->max)) {
+		stat_dprintk(STAT_HASH_MESSAGE_NOTICE, "insert failed - reached maximum entry count\n");
+		return NULL;
+	}
+
+	bucket = stat_hash_bucket(lookup_info->len, initval, addr);
+	if (test_and_set_bit(bucket, access_info->lock_bitmap)) {
+		stat_dprintk(STAT_HASH_MESSAGE_INFO, "insert failed - bucket lock held\n");
+		return NULL;
+	}
+
+	/* Allocate a new entry for the supplied address. */
+	entry = stat_hash_alloc_entry(initval, addr);
+	if (IS_ERR(entry)) 
+		goto err_unlock;
+	else {
+		if ((err = stat_hash_init_mappings(entry)) < 0) 
+			goto err_destroy;
+
+		if ((err = stat_hash_alloc_mappings(entry, alloc_flag)) < 0) 
+			goto err_destroy;
+
+		stat_fill_cookie(entry, addr->family, bucket, cookie);
+		stat_dprintk(STAT_HASH_MESSAGE_NOTICE, "new entry added (family = %d, bucket = %d, sequence = %d)\n",
+			     cookie->hash.family, cookie->hash.bucket, entry->sequence);
+
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLE_DEBUG
+		if (stat_hash_debug_level >= STAT_HASH_MESSAGE_NOTICE)
+			access_info->print(addr);
+#endif
+		spin_lock(&access_info->lock);
+		hlist_add_head_rcu(&entry->hlist, &lookup_info->htable[bucket]);
+		atomic_inc(&access_info->count);
+		spin_unlock(&access_info->lock);
+		clear_bit(bucket, access_info->lock_bitmap);
+		smp_mb();
+		
+	}					
+
+	return entry;
+
+err_destroy:
+	kfree(entry);
+err_unlock:
+	clear_bit(bucket, access_info->lock_bitmap);
+	smp_mb();
+
+	return NULL;
+}
+
+void 
+stat_hash_dump_address(struct stat_hash_addr *addr)
+{
+	struct stat_hash_access_info *info;
+
+	info = stat_hash_get_access_info(addr->family);
+	if (info == NULL)
+		return;
+
+	info->print(addr);
+}
+
+static void
+stat_destroy_rcu(struct rcu_head *head)
+{
+	struct stat_hash_entry *entry = container_of(head, struct stat_hash_entry, rcu);
+	stat_free_mibs(entry);
+	kfree(entry);
+}
+
+static void
+stat_destroy(struct stat_hash_entry *entry)
+{
+	hlist_del_rcu(&entry->hlist);
+	call_rcu(&entry->rcu, stat_destroy_rcu);
+}
+
+static void
+stat_zero(struct stat_hash_entry *entry, int maplvl)
+{
+	if (stat_hash_mapping_allocated(entry, maplvl)) {
+		snmp_map_mib_zero((struct snmp_mib_map *) &entry->mappings[maplvl].tcp_stats);
+		snmp_map_mib_zero((struct snmp_mib_map *) &entry->mappings[maplvl].lnx_stats);
+	}
+}
+
+static void
+stat_hash_dump_stats(struct seq_file *seq, struct stat_hash_entry *entry)
+{
+	int i, initialized = 0, map_level = snmp_map_level;
+	union snmp_mib_map_bitmaps test_negative;
+
+	if (!stat_hash_any_allocated(entry))
+		return;
+
+	/* Setup counters to be tested for negative value and possibly zeroed prior to display */
+	memset(&test_negative, 0, sizeof(union snmp_mib_map_bitmaps));
+	set_bit(TCP_MIB_CURRESTAB, test_negative.bmap.bitmap);
+
+	for (i = 0; i <= map_level; i++) {
+		if (stat_hash_mapping_allocated(entry, i)) {
+			if (snmp_map_count((struct snmp_mib_map *) &entry->mappings[i].tcp_stats) > 0) {
+				if (0 == initialized++) 
+					seq_printf(seq, "Tcp:\n");
+				snmp_map_print_stats(seq, (struct snmp_mib_map *) &entry->mappings[i].tcp_stats, &test_negative);
+			}
+		}
+	}
+	if (initialized > 0)
+		seq_putc(seq, '\n');
+
+	initialized = 0;
+	for (i = 0; i <= map_level; i++) {
+		if (stat_hash_mapping_allocated(entry, i)) {
+			if (snmp_map_count((struct snmp_mib_map *) &entry->mappings[i].lnx_stats) > 0) {
+				if (0 == initialized++)
+					seq_printf(seq, "TcpExt:\n");
+				snmp_map_print_stats(seq, (struct snmp_mib_map *) &entry->mappings[i].lnx_stats, NULL);
+			}
+		}
+	}
+	if (initialized > 0)
+		seq_putc(seq, '\n');
+}
+
+static void 
+stat_hash_show_entry(u16 family, struct seq_file *seq, struct stat_hash_entry *entry)
+{
+	struct stat_hash_access_info *info;
+
+	info = stat_hash_get_access_info(family);
+	if (info == NULL)
+		return;
+
+	info->print_seq(seq, entry);
+	seq_printf(seq, ":\n");
+	stat_hash_dump_stats(seq, entry);
+	seq_putc(seq, '\n');
+}
+
+static void 
+stat_hash_delete_all(u16 family)
+{
+	struct stat_hash_access_info *access_info;
+	struct stat_hash_lookup_info *lookup_info;
+	struct hlist_head *htable;
+	struct hlist_head *head;
+	struct hlist_node *pos, *n;
+	struct stat_hash_entry *entry;
+	int i;
+
+	if (stat_hash_get_info(family, &access_info, &lookup_info) < 0)
+		return;
+
+	htable = lookup_info->htable;
+
+	spin_lock(&access_info->lock);
+	for (i = 0; i < lookup_info->len; i++) {
+		head = &htable[i];
+		hlist_for_each_entry_safe(entry, pos, n, head, hlist) 
+			stat_destroy(entry);
+	}
+	lookup_info->first_sequence = atomic_read(&access_info->sequence);
+	atomic_set_mb(&access_info->count, 0);
+	spin_unlock(&access_info->lock);
+}
+
+static void
+stat_hash_zero_mapping(u16 family, int maplvl)
+{
+	struct stat_hash_access_info *access_info;
+        struct stat_hash_lookup_info *lookup_info;
+	struct hlist_head *htable;
+	struct hlist_head *head;
+	struct hlist_node *pos;
+	struct stat_hash_entry *entry;
+	int i;
+
+	if (stat_hash_get_info(family, &access_info, &lookup_info) < 0)
+		return;
+
+	htable = lookup_info->htable;
+
+	spin_lock(&access_info->lock);
+	for (i = 0; i < lookup_info->len; i++) {
+		head = &htable[i];
+		hlist_for_each_entry(entry, pos, head, hlist)
+			stat_zero(entry, maplvl);
+	}
+	spin_unlock(&access_info->lock);
+}
+
+static void 
+stat_hash_iter(u16 family, struct seq_file *seq)
+{
+	struct stat_hash_lookup_info *lookup_info = NULL;
+	struct stat_hash_entry *entry;
+	struct hlist_head *head;
+	struct hlist_node *pos;
+	struct hlist_head *htable;
+	int i;
+
+	lookup_info = stat_hash_get_lookup_info(family);
+	if (lookup_info == NULL)
+		return;
+
+	htable = lookup_info->htable;	
+
+	for (i = 0; i < lookup_info->len; i++) {
+		head = &htable[i];
+		hlist_for_each_entry_rcu(entry, pos, head, hlist) {
+			stat_hash_show_entry(family, seq, entry);
+                }
+        }
+}
+
+int 
+show_hash4_info(struct seq_file *seq, void *v)
+{
+	stat_hash_iter(AF_INET, seq);	
+	return 0;
+}
+
+int 
+show_hash6_info(struct seq_file *seq, void *v)
+{
+        stat_hash_iter(AF_INET6, seq);
+        return 0;
+}
+EXPORT_SYMBOL(show_hash6_info);
+
+static int 
+stat_hash_delete_hash_handler(u16 family, int *var, ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int err = 0;
+
+	if (!write)
+		err = -EINVAL;
+	else {
+		err = proc_dointvec_minmax(table, write, buffer, length, ppos);
+		if (err == 0) {
+			if (*var <= 0) {
+				printk(KERN_WARNING "invalid argument (valid argument > 0)\n");
+				err = -EINVAL;
+			} else
+				stat_hash_delete_all(family);
+		}
+	}
+
+        return err;
+}
+
+int
+stat_hash_ipv4_delete_hash_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos)
+{
+	return stat_hash_delete_hash_handler(AF_INET, &net_stat_ipv4_sysctl_hash_delete, table, write, buffer, length, ppos);
+}
+
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+int
+stat_hash_ipv6_delete_hash_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos)
+{
+	return stat_hash_delete_hash_handler(AF_INET6, &net_stat_ipv6_sysctl_hash_delete, table, write, buffer, length, ppos);
+}
+EXPORT_SYMBOL(stat_hash_ipv6_delete_hash_handler);
+#endif
+
+static int 
+stat_hash_zero_hash_handler(u16 family, int *var, ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int err = 0;
+
+	if (!write)
+		err = -EINVAL;
+	else {
+		err = proc_dointvec_minmax(table, write, buffer, length, ppos);
+		if (err == 0) {
+			if (*var < 0 || *var >= SNMP_MAP_LEVEL_MAX) {
+				printk(KERN_WARNING "invalid map level (valid argument: %d - %d)\n", 0, SNMP_MAP_LEVEL_MAX - 1);
+				err = -EINVAL;
+			} else
+				stat_hash_zero_mapping(family, *var);
+                }
+        }
+
+        return err;
+}
+
+int
+stat_hash_ipv4_zero_hash_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos)
+{
+	return stat_hash_zero_hash_handler(AF_INET, &net_stat_ipv4_sysctl_hash_zero, table, write, buffer, length, ppos);
+}
+
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+int
+stat_hash_ipv6_zero_hash_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos)
+{
+	return stat_hash_zero_hash_handler(AF_INET6, &net_stat_ipv6_sysctl_hash_zero, table, write, buffer, length, ppos);
+}
+EXPORT_SYMBOL(stat_hash_ipv6_zero_hash_handler);
+#endif
+
+int 
+stat_hash_enable_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos) 
+{
+	int err = proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if ((err == 0) && write)
+		smp_mb();
+
+	return err;
+}
+
+int 
+stat_hash_start_data_collection(void)
+{
+	int err = 0;
+
+	if (stat_hash_data_collection_started) {
+		printk(KERN_NOTICE STAT_HASH_PREFIX "data collection already started\n");
+		return 0;
+	}
+
+	stat_hash_data_collection_started = true;
+	smp_mb();
+
+	return err;
+}
+EXPORT_SYMBOL(stat_hash_start_data_collection);
+
+void
+stat_hash_stop_data_collection(void)
+{
+	if (!stat_hash_data_collection_started) {
+		printk(KERN_NOTICE STAT_HASH_PREFIX "data collection was not started\n");
+		return;
+	}
+
+	stat_hash_data_collection_started = false;
+	smp_mb();
+}
+EXPORT_SYMBOL(stat_hash_stop_data_collection);
+
+static __init int
+stat_hash_init(void)
+{
+	memset(stat4_hashtable_lock_bitmap, 0, sizeof(stat4_hashtable_lock_bitmap));
+	memset(stat6_hashtable_lock_bitmap, 0, sizeof(stat6_hashtable_lock_bitmap));
+        return 0;
+}
+
+__initcall(stat_hash_init);
+
diff -r -U 4 a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c	2013-09-02 12:44:17.481628441 +0300
+++ b/net/ipv4/sysctl_net_ipv4.c	2013-09-02 12:44:17.687767866 +0300
@@ -825,8 +825,64 @@
 		.proc_handler   = snmp_map_level_handler,
 		.strategy       = &sysctl_intvec,
 	},
 #endif
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+	{
+		.ctl_name       = NET_IPV4_STAT_HASHTABLE_ENABLE,
+		.procname       = "perip_stats",
+		.data           = &net_stat_hashtable,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler	= stat_hash_enable_handler,
+		.strategy       = &sysctl_intvec,
+	},
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLE_DEBUG
+	{
+		.ctl_name       = NET_IPV4_STAT_HASHTABLE_DEBUG_LEVEL,
+		.procname       = "perip_stats_debug",
+		.data           = &stat_hash_debug_level,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec
+	},
+#endif
+	{
+		.ctl_name       = NET_IPV4_STAT_HASHTABLE_LOOPBACK,
+		.procname       = "perip_stats_loopback",
+		.data           = &net_stat_hash_loopback,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec
+	},
+	{
+		.ctl_name       = NET_IPV4_STAT_HASHTABLE_DELETE,
+		.procname       = "perip_stats_delete_entries",
+		.data           = &net_stat_ipv4_sysctl_hash_delete,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = stat_hash_ipv4_delete_hash_handler,
+		.strategy       = &sysctl_intvec,
+	},
+	{
+		.ctl_name       = NET_IPV4_STAT_HASHTABLE_ZERO,
+		.procname       = "perip_stats_zero_counters",
+		.data           = &net_stat_ipv4_sysctl_hash_zero,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = stat_hash_ipv4_zero_hash_handler,
+		.strategy       = &sysctl_intvec,
+	},
+	{
+		.ctl_name       = NET_IPV4_STAT_HASHTABLE_MAX,
+		.procname       = "perip_stats_max_entries",
+		.data           = &stat_hash_sysctl_hash_max,
+		.maxlen         = sizeof(stat_hash_sysctl_hash_max),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.strategy       = &sysctl_intvec,
+	},
+#endif
 	{ .ctl_name = 0 }
 };
 
 static struct ctl_table ipv4_net_table[] = {
diff -r -U 4 a/net/ipv6/Kconfig b/net/ipv6/Kconfig
--- a/net/ipv6/Kconfig	2013-09-02 12:44:17.491622411 +0300
+++ b/net/ipv6/Kconfig	2013-09-02 12:44:17.708919635 +0300
@@ -216,5 +216,12 @@
 	---help---
 	  Support for IPv6 PIM multicast routing protocol PIM-SMv2.
 	  If unsure, say N.
 
+config IPV6_STAT_HASHTABLES
+	boolean "Define a hash table to hold per-ip IPV6 statistics"
+	depends on IPV6 && NET_IPV4_STAT_HASHTABLES
+	default y
+	---help---
+	Define a hash table to hold per-ip IPV6 statistics
+
 endif # IPV6
diff -r -U 4 a/net/ipv6/proc.c b/net/ipv6/proc.c
--- a/net/ipv6/proc.c	2013-09-02 12:44:17.498640683 +0300
+++ b/net/ipv6/proc.c	2013-09-02 12:44:17.724867731 +0300
@@ -231,8 +231,25 @@
 	.llseek	 = seq_lseek,
 	.release = single_release,
 };
 
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+extern int show_hash6_info(struct seq_file *, void *v);
+
+static int stat6_open(struct inode *inode, struct file *file)
+{
+        return single_open(file, show_hash6_info, NULL);
+}
+
+static const struct file_operations stat6_hash_seq_fops = {
+        .owner  = THIS_MODULE,
+        .open   = stat6_open,
+        .read    = seq_read,
+        .llseek  = seq_lseek,
+        .release = single_release,
+};
+#endif
+
 int snmp6_register_dev(struct inet6_dev *idev)
 {
 	struct proc_dir_entry *p;
 	struct net *net;
@@ -278,10 +295,20 @@
 
 	net->mib.proc_net_devsnmp6 = proc_mkdir("dev_snmp6", net->proc_net);
 	if (!net->mib.proc_net_devsnmp6)
 		goto proc_dev_snmp6_fail;
+
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+	if (!proc_net_fops_create(net, "perip6", S_IRUGO, &stat6_hash_seq_fops))
+		goto proc_hash6_fail;
+#endif
+
 	return 0;
 
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+proc_hash6_fail:
+	proc_net_remove(net, "dev_snmp6");
+#endif
 proc_snmp6_fail:
 	proc_net_remove(net, "sockstat6");
 proc_dev_snmp6_fail:
 	proc_net_remove(net, "dev_snmp6");
@@ -292,8 +319,11 @@
 {
 	proc_net_remove(net, "sockstat6");
 	proc_net_remove(net, "dev_snmp6");
 	proc_net_remove(net, "snmp6");
+#ifdef CONFIG_NET_IPV4_STAT_HASHTABLES
+	proc_net_remove(net, "perip6");
+#endif
 }
 
 static struct pernet_operations ipv6_proc_ops = {
 	.init = ipv6_proc_init_net,
diff -r -U 4 a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
--- a/net/ipv6/reassembly.c	2013-09-02 12:44:17.505628399 +0300
+++ b/net/ipv6/reassembly.c	2013-09-02 12:44:17.741702887 +0300
@@ -53,8 +53,12 @@
 #include <net/ndisc.h>
 #include <net/addrconf.h>
 #include <net/inet_frag.h>
 
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+#include <net/ip.h>
+#endif
+
 struct ip6frag_skb_cb
 {
 	struct inet6_skb_parm	h;
 	int			offset;
@@ -589,8 +593,36 @@
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 		.strategy	= sysctl_jiffies,
 	},
+#ifdef CONFIG_IPV6_STAT_HASHTABLES
+        {
+		.ctl_name       = NET_IPV6_STAT_HASHTABLE_ENABLE,
+		.procname       = "perip_stats_ipv6",
+		.data           = &net_stat_hashtable_ipv6,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec
+        },
+	{
+		.ctl_name       = NET_IPV6_STAT_HASHTABLE_DELETE,
+		.procname       = "perip_stats_delete_entries",
+		.data           = &net_stat_ipv6_sysctl_hash_delete,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = stat_hash_ipv6_delete_hash_handler,
+		.strategy       = &sysctl_intvec,
+	},
+	{
+		.ctl_name       = NET_IPV6_STAT_HASHTABLE_ZERO,
+		.procname       = "perip_stats_zero_counters",
+		.data           = &net_stat_ipv6_sysctl_hash_zero,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = stat_hash_ipv6_zero_hash_handler,
+		.strategy       = &sysctl_intvec,
+	},
+#endif
 	{ }
 };
 
 static struct ctl_table ip6_frags_ctl_table[] = {
