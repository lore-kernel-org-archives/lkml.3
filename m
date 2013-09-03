Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab3ICHml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:42:41 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:44884 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502Ab3ICHmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:42:37 -0400
X-LoopCount0: from 10.48.28.48
X-IronPort-AV: E=Sophos;i="4.89,1012,1367989200"; 
   d="scan'208";a="249012955"
Date: Tue, 3 Sep 2013 10:42:32 +0300
From: Menny Hamburger <Menny_Hamburger@Dell.com>
Message-Id: <201309030742.r837gWBJ012538@bldhmenny.dell-idc.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Per IP network statistics: SNMP MIB subsets
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff -r -U 4 a/include/linux/snmp.h b/include/linux/snmp.h
--- a/include/linux/snmp.h	2013-09-01 09:03:35.355639246 +0300
+++ b/include/linux/snmp.h	2013-09-01 09:03:35.410960814 +0300
@@ -261,5 +261,18 @@
 	LINUX_MIB_XFRMOUTPOLERROR,		/* XfrmOutPolError */
 	__LINUX_MIB_XFRMMAX
 };
 
+enum {
+	SNMP_IPSTATS_MIB = 0,
+	SNMP_ICMP_MIB,
+	SNMP_ICMPMSG_MIB,
+	SNMP_ICMP6_MIB,
+	SNMP_ICMP6MSG_MIB,
+	SNMP_TCP_MIB,
+	SNMP_UDP_MIB,
+        SNMP_LINUX_MIB,
+	SNMP_LINUX_XFRM_MIB,
+	__SNMP_MIB_MAX,
+};
+
 #endif	/* _LINUX_SNMP_H */
diff -r -U 4 a/include/linux/sysctl.h b/include/linux/sysctl.h
--- a/include/linux/sysctl.h	2013-09-01 09:03:35.361639131 +0300
+++ b/include/linux/sysctl.h	2013-09-01 09:03:35.428631683 +0300
@@ -433,8 +433,11 @@
 	NET_TCP_AVAIL_CONG_CONTROL=122,
 	NET_TCP_ALLOWED_CONG_CONTROL=123,
 	NET_TCP_MAX_SSTHRESH=124,
 	NET_TCP_FRTO_RESPONSE=125,
+#ifdef CONFIG_NET_IPV4_SNMP_MAPPING
+	NET_IPV4_SNMP_MAP_LEVEL=126,
+#endif
 };
 
 enum {
 	NET_IPV4_ROUTE_FLUSH=1,
diff -r -U 4 a/include/net/snmp_map.h b/include/net/snmp_map.h
--- a/include/net/snmp_map.h	2013-09-01 09:03:35.367639297 +0300
+++ b/include/net/snmp_map.h	2013-09-01 09:03:35.442635908 +0300
@@ -0,0 +1,374 @@
+/*
+ *
+ *		SNMP MIB mapping for maintaining a subset of the statistical counters.
+ *
+ *		Menny Hamburger<menny_hamburger@dell.com>
+ *
+ *		The purpose of SNMP MIB mapping is to reduce the memory overhead of maintaining the full set
+ *		of counters, which is essential if we need to allocate counters dynamically.
+ *		A Mapping includes a u8 array that includes indecies into the per CPU counter array.
+ *
+ */
+
+
+#ifndef _SNMP_MAP_H
+#define _SNMP_MAP_H
+
+#ifdef CONFIG_NET_IPV4_SNMP_MAPPING
+
+#include <net/snmp.h>
+
+/*
+ * By keeping several levels of mappings, we define what counters will be maintained in each level.
+ * This helps reduce the CPU overhead of usage and memory allocation to a minimum in the default level.
+ */
+enum {
+        SNMP_MAP_LEVEL_DEFAULT,
+        SNMP_MAP_LEVEL_DIAG,
+        SNMP_MAP_LEVEL_MAX,
+};
+
+struct snmp_mib_mapped_data {
+	unsigned long mibs[0];
+};
+
+struct snmp_mib_mapped_data_aligned  {
+	unsigned long mibs[0];
+} __SNMP_MIB_ALIGN__;
+
+#ifndef SNMP_ARRAY_SZ
+#define SNMP_ARRAY_SZ 2
+#elif (SNMP_ARRAY_SZ == 1)
+#error "counters without Top/Bottom half separations are not yet supported"
+#endif
+
+#define DEFINE_SNMP_STAT_MAPPED(type, name)    \
+        __typeof__(type) *name[SNMP_ARRAY_SZ]
+#define DECLARE_SNMP_STAT_MAPPED(type, name)   \
+        extern __typeof__(type) *name[SNMP_ARRAY_SZ]
+
+#define DEFINE_SNMP_STAT_MAPPING(type, name)    \
+	u8 maplvl; \
+	u8 mibid; \
+	__typeof__(type) name
+
+struct ipstats_mib_mapping {
+	u8 mapping[__IPSTATS_MIB_MAX];
+};
+
+struct ipstats_mib_map {
+	DEFINE_SNMP_STAT_MAPPED(struct snmp_mib_mapped_data_aligned, stats);
+	DEFINE_SNMP_STAT_MAPPING(struct ipstats_mib_mapping, map);
+};
+
+
+
+struct icmp_mib_mapping {
+	u8 mapping[__ICMP_MIB_MAX];
+};
+
+struct icmp_mib_map {
+	DEFINE_SNMP_STAT_MAPPED(struct snmp_mib_mapped_data_aligned, stats);
+	DEFINE_SNMP_STAT_MAPPING(struct icmp_mib_mapping, map);
+};
+
+
+
+struct icmpmsg_mib_mapping {
+	u8 mapping[__ICMPMSG_MIB_MAX];
+};
+
+struct icmpmsg_mib_map {
+	DEFINE_SNMP_STAT_MAPPED(struct snmp_mib_mapped_data_aligned, stats);
+	DEFINE_SNMP_STAT_MAPPING(struct icmpmsg_mib_mapping, map);	
+};
+
+
+struct icmpv6_mib_mapping {
+	u8 mapping[__ICMP6_MIB_MAX];
+};
+
+struct icmpv6_mib_map {
+	DEFINE_SNMP_STAT_MAPPED(struct snmp_mib_mapped_data_aligned, stats);
+	DEFINE_SNMP_STAT_MAPPING(struct icmpv6_mib_mapping, map);
+};
+
+
+struct icmpv6msg_mib_mapping {
+	u8 mapping[__ICMP6MSG_MIB_MAX];
+};
+
+struct icmpv6msg_mib_map {
+	DEFINE_SNMP_STAT_MAPPED(struct snmp_mib_mapped_data_aligned, stats);
+	DEFINE_SNMP_STAT_MAPPING(struct icmpv6msg_mib_mapping, map);
+};
+
+
+struct tcp_mib_mapping {
+	u8 mapping[__TCP_MIB_MAX];
+};
+
+struct tcp_mib_map {
+	DEFINE_SNMP_STAT_MAPPED(struct snmp_mib_mapped_data_aligned, stats);
+	DEFINE_SNMP_STAT_MAPPING(struct tcp_mib_mapping, map);	
+};
+
+
+struct udp_mib_mapping {
+	u8 mapping[__UDP_MIB_MAX];
+};
+
+struct udp_mib_map {
+	DEFINE_SNMP_STAT_MAPPED(struct snmp_mib_mapped_data_aligned, stats);
+	DEFINE_SNMP_STAT_MAPPING(struct udp_mib_mapping, map);
+};
+
+
+struct linux_mib_mapping {
+	u8 mapping[__LINUX_MIB_MAX];
+};
+
+struct linux_mib_map {
+	DEFINE_SNMP_STAT_MAPPED(struct snmp_mib_mapped_data, stats);
+	DEFINE_SNMP_STAT_MAPPING(struct linux_mib_mapping, map);
+};
+
+
+struct linux_xfrm_mib_mapping {
+        u8 mapping[__LINUX_MIB_XFRMMAX];
+};
+
+struct linux_xfrm_mib_map {
+        DEFINE_SNMP_STAT_MAPPED(struct snmp_mib_mapped_data_aligned, stats);
+        DEFINE_SNMP_STAT_MAPPING(struct linux_xfrm_mib_mapping, map);
+};
+
+
+#define DEFINE_SNMP_MIB_MAP(type, name)    \
+	__typeof__(type) name; 
+
+
+union mib_mapping {
+	u8 mapping[0];
+	u8 ipstats_mapping[__IPSTATS_MIB_MAX];
+	u8 icmp_mapping[__ICMP_MIB_MAX];
+	u8 icmpmsg_mapping[__ICMPMSG_MIB_MAX];
+	u8 icmp6_mapping[__ICMP6_MIB_MAX];
+	u8 icmp6msg_mapping[__ICMP6MSG_MIB_MAX];
+	u8 tcp_mapping[__TCP_MIB_MAX];
+	u8 udp_mapping[__UDP_MIB_MAX];
+	u8 linux_mapping[__LINUX_MIB_MAX];
+	u8 linux_xfrm_mapping[__LINUX_MIB_XFRMMAX];
+};
+
+struct mib_mapped {
+	struct snmp_mib_mapped_data *stats[SNMP_ARRAY_SZ];
+};
+
+struct snmp_mib_map {
+        struct mib_mapped stats;
+        u8 maplvl;
+        u8 mibid;
+        union mib_mapping map;
+};
+
+/* Counter bitmap used to apply behavior on specific counters within an SNMP MIB */
+struct snmp_mib_map_bitmap_container {
+        unsigned long bitmap[0];
+};
+
+#define DEFINE_SNMP_MAP_BITMAP_CONTAINER(type) \
+	type##_map_bitmap_container { \
+		DECLARE_BITMAP(bitmap, sizeof(type##_mapping)); \
+	}
+
+DEFINE_SNMP_MAP_BITMAP_CONTAINER(struct ipstats_mib);
+DEFINE_SNMP_MAP_BITMAP_CONTAINER(struct icmp_mib);
+DEFINE_SNMP_MAP_BITMAP_CONTAINER(struct icmpmsg_mib);
+DEFINE_SNMP_MAP_BITMAP_CONTAINER(struct icmpv6_mib);
+DEFINE_SNMP_MAP_BITMAP_CONTAINER(struct icmpv6msg_mib);
+DEFINE_SNMP_MAP_BITMAP_CONTAINER(struct tcp_mib);
+DEFINE_SNMP_MAP_BITMAP_CONTAINER(struct udp_mib);
+DEFINE_SNMP_MAP_BITMAP_CONTAINER(struct linux_mib);
+DEFINE_SNMP_MAP_BITMAP_CONTAINER(struct linux_xfrm_mib);
+
+union snmp_mib_map_bitmaps {
+	struct snmp_mib_map_bitmap_container bmap;
+	struct ipstats_mib_map_bitmap_container ipstats_bmap;
+	struct icmp_mib_map_bitmap_container icmp_bmap;
+	struct icmpmsg_mib_map_bitmap_container icmpmsg_bmap;
+	struct icmpv6_mib_map_bitmap_container icmpv6_bmap;
+	struct icmpv6msg_mib_map_bitmap_container icmpv6msg_bmap;
+	struct tcp_mib_map_bitmap_container tcp_bmap;
+	struct udp_mib_map_bitmap_container udp_bmap;
+	struct linux_mib_map_bitmap_container linux_bmap;
+	struct linux_xfrm_mib_map_bitmap_container linux_xfrm_bmap;
+};
+
+
+
+
+/* Basic counter update macros just the original counters */
+#define SNMP_INC_STATS_MAP_BH(mib, field) SNMP_INC_STATS_BH(mib, field)
+#define SNMP_INC_STATS_MAP_USER(mib, field) SNMP_INC_STATS_USER(mib, field)
+#define SNMP_INC_STATS_MAP(mib, field) SNMP_INC_STATS(mib, field)
+#define SNMP_DEC_STATS_MAP(mib, field) SNMP_DEC_STATS(mib, field)
+#define SNMP_ADD_STATS_MAP(mib, field, addend) SNMP_ADD_STATS(mib, field, addend)
+#define SNMP_ADD_STATS_MAP_BH(mib, field, addend) SNMP_ADD_STATS_BH(mib, field, addend)
+#define SNMP_ADD_STATS_MAP_USER(mib, field, addend) SNMP_ADD_STATS_USER(mib, field, addend)
+
+#define SNMP_MAP_UNMAPPED 255
+
+static inline u8 
+snmp_map_get_mapping(struct snmp_mib_map *m, u8 field) 
+{
+	if (m != NULL) {
+		u8 mappedto = m->map.mapping[field];
+		if (mappedto != SNMP_MAP_UNMAPPED)
+			return mappedto;
+	}
+
+	return SNMP_MAP_UNMAPPED;
+}
+
+/* Macros that look up field in mapping and accesses it's location in the counter array */
+#define SNMP_INC_STATS_MAPPING_BH(m, field)   \
+	do { \
+		u8 mappedto = snmp_map_get_mapping((struct snmp_mib_map *) (m), field); \
+		if (mappedto != SNMP_MAP_UNMAPPED) \
+			SNMP_INC_STATS_MAP_BH((m)->stats.stats, mappedto); \
+	} while (0)
+#define SNMP_INC_STATS_MAPPING_USER(m, field)   \
+	do { \
+		u8 mappedto = snmp_map_get_mapping((struct snmp_mib_map *) (m), field); \
+		if (mappedto != SNMP_MAP_UNMAPPED) \
+			SNMP_INC_STATS_MAP_USER((m)->stats.stats, mappedto); \
+	} while (0)
+#define SNMP_INC_STATS_MAPPING(m, field)      \
+	do { \
+		u8 mappedto = snmp_map_get_mapping((struct snmp_mib_map *) (m), field); \
+		if (mappedto != SNMP_MAP_UNMAPPED) \
+			SNMP_INC_STATS_MAP((m)->stats.stats, mappedto); \
+	} while (0)
+#define SNMP_DEC_STATS_MAPPING(m, field)      \
+	do { \
+		u8 mappedto = snmp_map_get_mapping((struct snmp_mib_map *) (m), field); \
+		if (mappedto != SNMP_MAP_UNMAPPED) \
+			SNMP_DEC_STATS_MAP((m)->stats.stats,  mappedto); \
+	} while (0)
+#define SNMP_ADD_STATS_MAPPING(m, field, addend)      \
+	do { \
+		u8 mappedto = snmp_map_get_mapping((struct snmp_mib_map *) (m), field); \
+		if (mappedto != SNMP_MAP_UNMAPPED) \
+			SNMP_ADD_STATS_MAP((m)->stats.stats, mappedto, addend); \
+	} while (0)
+#define SNMP_ADD_STATS_MAPPING_BH(m, field, addend)   \
+	do { \
+		u8 mappedto = snmp_map_get_mapping((struct snmp_mib_map *) (m), field); \
+		if (mappedto != SNMP_MAP_UNMAPPED) \
+			SNMP_ADD_STATS_MAP_BH((m)->stats.stats, mappedto, addend); \
+	} while (0)
+#define SNMP_ADD_STATS_MAPPING_USER(m, field, addend)         \
+	do { \
+		u8 mappedto = snmp_map_get_mapping((struct snmp_mib_map *) (m), field); \
+		if (mappedto != SNMP_MAP_UNMAPPED) \
+			SNMP_ADD_STATS_MAP_USER((m)->stats.stats, mappedto, addend); \
+	} while (0)
+
+
+/* Register the labels used for displaying the counters */
+extern int snmp_map_register_labels(u8 mibid, const struct snmp_mib *labels, int n);
+
+/* 
+ * Define a global mapping for counters specified in 'mapping' per SNMP MIB and map level
+ * When mapping is NULL, the function maps all the counters not added in previous map levels, unless
+ * they are excluded via exmapping.
+ */
+extern int snmp_map_add_mapping(u8 maplvl, u8 mibid, u8 *mapping, int count, u8 *exmapping, int excount);
+/*
+ * Add an empty mapping - all counters are left SNMP_MAP_UNMAPPED. 
+ * This is used so upper layers can test that mapping is initialized even if it has no mappings.
+ */
+extern int snmp_map_add_empty_mapping(u8 maplvl, u8 mibid);
+/* Undefine a mapping for a specified SNMP MIB and map level */
+extern int snmp_map_del_mapping(u8 maplvl, u8 mibid);
+
+/*
+ * Get the number of counters currently registered for the specific SNMP MIB and map level.
+ * We use this when dumping the counters so we don't display any output if no counters were registered.
+ */
+extern int snmp_map_count(struct snmp_mib_map *m);
+
+/* 
+ * Initialize a mapping - no allocation yet.
+ * This must be called before allocating the counters to set the map level and SNMP MIB ID in a newly 
+ * allocated mapping.
+ */
+int snmp_map_init_map(u8 maplvl, u8 mibid, struct snmp_mib_map *m);
+
+/* Allocate per CPU counters */
+int  snmp_map_mib_init(struct snmp_mib_map *m);
+
+/* 
+ * In cases where a counter is both incremented and decremented, a specific counter may overflow when decremening zero.
+ * This can happen in two situation:
+ * 1) Missed increment
+ * 2) Counters are artificially decremented to zero.
+ * Since a counter value can be higher the LONG_MAX, we can't destinguish between an overflow and a real value in the 
+ * range of LONG_MAX - ULONG_MAX.  If we know that a specific counter is both incremented and decremented, 
+ * it is logical to assume that we will never reach LONG_MAX, so in this case we can test the value of the counter and zero
+ * it if it is negative.
+ *
+ * This function Displays the counters countained in a mapping.
+ * bitmap argument specifies which counters to test for negative and zero.
+ */
+extern int snmp_map_print_stats(struct seq_file *seq, struct snmp_mib_map *m, union snmp_mib_map_bitmaps *bitmap);
+/* Zero a negative counter */
+extern void snmp_map_zero_negative(struct snmp_mib_map *m, u8 field);
+
+/* Zero per CPU counters */
+void snmp_map_mib_zero(struct snmp_mib_map *m); 
+/* Free per CPU memory allocated for counters */
+void snmp_map_mib_free(struct snmp_mib_map *m); 
+
+/* Global map level used for determining the set of counters to be allocated and updated */
+extern int snmp_map_level;
+extern int snmp_map_level_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos);
+
+/*
+ * Maintain a global array that maps a field in specific MIB to a map level.
+ * The array is used to determine whether a specific counter needs to be updated in the current map level (snmp_map_level).
+ */
+struct snmp_map_mapper {
+        u32 len;
+	union mib_mapping map_map;	
+};
+
+extern struct snmp_map_mapper *map_mappings[__SNMP_MIB_MAX];
+
+static inline struct snmp_map_mapper *
+snmp_map_get_mapper(u8 mibid)
+{
+	return ((mibid >= __SNMP_MIB_MAX) ? NULL : map_mappings[mibid]);
+}
+
+static inline u8
+snmp_map_get_map_level(u8 mibid, u8 field)
+{
+	struct snmp_map_mapper *mapper = snmp_map_get_mapper(mibid);
+
+	return ((mapper != NULL) ? mapper->map_map.mapping[field] : SNMP_MAP_UNMAPPED);
+}
+
+/* Upper layers should test this before calling the actual macro that updates the counter. */
+static inline bool
+snmp_map_allow_update(u8 mibid, u8 field)
+{
+	u8 maplvl = snmp_map_get_map_level(mibid, field);
+
+	return ((maplvl == SNMP_MAP_UNMAPPED) ? false : maplvl <= snmp_map_level);
+}
+
+#endif
+
+#endif
diff -r -U 4 a/net/ipv4/Kconfig b/net/ipv4/Kconfig
--- a/net/ipv4/Kconfig	2013-09-01 09:03:35.373637542 +0300
+++ b/net/ipv4/Kconfig	2013-09-01 09:03:35.461631233 +0300
@@ -640,4 +640,14 @@
 	  on the Internet.
 
 	  If unsure, say N.
 
+config NET_IPV4_SNMP_MAPPING
+	boolean "Allow defining a subset of counters in a stat mib to reduce size"
+	depends on INET
+	default n
+	---help---
+	The statistics footprint in memory can be quite large due to the fact that
+	the counters are allocated per CPU and each counter is 8 bytes.
+	This feature enables allocation of only a subset of counters from within a stat mib
+	by defining a mapping between the whole range of counters to a smaller set.
+
diff -r -U 4 a/net/ipv4/Makefile b/net/ipv4/Makefile
--- a/net/ipv4/Makefile	2013-09-01 09:03:35.379639110 +0300
+++ b/net/ipv4/Makefile	2013-09-01 09:03:35.479601685 +0300
@@ -51,4 +51,6 @@
 obj-$(CONFIG_NETLABEL) += cipso_ipv4.o
 
 obj-$(CONFIG_XFRM) += xfrm4_policy.o xfrm4_state.o xfrm4_input.o \
 		      xfrm4_output.o
+obj-$(CONFIG_NET_IPV4_SNMP_MAPPING) += snmp_map.o
+
diff -r -U 4 a/net/ipv4/snmp_map.c b/net/ipv4/snmp_map.c
--- a/net/ipv4/snmp_map.c	2013-09-01 09:03:35.385639309 +0300
+++ b/net/ipv4/snmp_map.c	2013-09-01 09:03:35.494590279 +0300
@@ -0,0 +1,690 @@
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/sort.h>
+
+#include <net/ip.h>
+#include <net/snmp_map.h>
+
+/* Structures for maintaining mapping information on every (SNMP MIB, map level) */
+struct snmp_mib_map_info {
+	spinlock_t lock;
+	atomic_t initialized;
+	u32 len;
+	atomic_t count;
+	u8 mibid;
+	union mib_mapping map;
+};
+
+#define DEFINE_SNMP_MAP_INFO(type) \
+        type##_map_info { \
+		spinlock_t lock; \
+		atomic_t initialized; \
+		u32 len; \
+		atomic_t count; \
+		u8 mibid; \
+		type##_mapping map; \
+        }
+
+DEFINE_SNMP_MAP_INFO(struct ipstats_mib);
+DEFINE_SNMP_MAP_INFO(struct icmp_mib);
+DEFINE_SNMP_MAP_INFO(struct icmpmsg_mib);
+DEFINE_SNMP_MAP_INFO(struct icmpv6_mib);
+DEFINE_SNMP_MAP_INFO(struct icmpv6msg_mib);
+DEFINE_SNMP_MAP_INFO(struct tcp_mib);
+DEFINE_SNMP_MAP_INFO(struct udp_mib);
+DEFINE_SNMP_MAP_INFO(struct linux_mib);
+DEFINE_SNMP_MAP_INFO(struct linux_xfrm_mib);
+
+#define DECLARE_SNMP_MAP_INFO(type, mtype, name) \
+	__typeof__(type##_map_info) name  = { \
+		.lock = SPIN_LOCK_UNLOCKED, \
+		.initialized = ATOMIC_INIT(0), \
+		.len = sizeof(type##_mapping), \
+		.count = ATOMIC_INIT(0), \
+		.mibid = (mtype), \
+	}
+
+static DECLARE_SNMP_MAP_INFO(struct ipstats_mib, SNMP_IPSTATS_MIB, ipstats_map_info);
+static DECLARE_SNMP_MAP_INFO(struct icmp_mib, SNMP_ICMP_MIB, icmp_map_info);
+static DECLARE_SNMP_MAP_INFO(struct icmpmsg_mib, SNMP_ICMPMSG_MIB, icmpmsg_map_info);
+static DECLARE_SNMP_MAP_INFO(struct icmpv6_mib, SNMP_ICMP6_MIB, icmpv6_map_info);
+static DECLARE_SNMP_MAP_INFO(struct icmpv6msg_mib, SNMP_ICMP6MSG_MIB, icmpv6msg_map_info);
+static DECLARE_SNMP_MAP_INFO(struct tcp_mib, SNMP_TCP_MIB, tcp_map_info);
+static DECLARE_SNMP_MAP_INFO(struct udp_mib, SNMP_UDP_MIB, udp_map_info);
+static DECLARE_SNMP_MAP_INFO(struct linux_mib, SNMP_LINUX_MIB, linux_map_info);
+static DECLARE_SNMP_MAP_INFO(struct linux_xfrm_mib, SNMP_LINUX_XFRM_MIB, linux_xfrm_map_info);
+
+static struct snmp_mib_map_info *map_info_default[__SNMP_MIB_MAX] = {
+	(struct snmp_mib_map_info *) &ipstats_map_info,
+	(struct snmp_mib_map_info *) &icmp_map_info,
+	(struct snmp_mib_map_info *) &icmpmsg_map_info,
+	(struct snmp_mib_map_info *) &icmpv6_map_info,
+	(struct snmp_mib_map_info *) &icmpv6msg_map_info,
+	(struct snmp_mib_map_info *) &tcp_map_info,
+	(struct snmp_mib_map_info *) &udp_map_info,
+	(struct snmp_mib_map_info *) &linux_map_info,
+	(struct snmp_mib_map_info *) &linux_xfrm_map_info,
+};
+
+static DECLARE_SNMP_MAP_INFO(struct ipstats_mib, SNMP_IPSTATS_MIB, ipstats_map_info_diag);
+static DECLARE_SNMP_MAP_INFO(struct icmp_mib, SNMP_ICMP_MIB, icmp_map_info_diag);
+static DECLARE_SNMP_MAP_INFO(struct icmpmsg_mib, SNMP_ICMPMSG_MIB, icmpmsg_map_info_diag);
+static DECLARE_SNMP_MAP_INFO(struct icmpv6_mib, SNMP_ICMP6_MIB, icmpv6_map_info_diag);
+static DECLARE_SNMP_MAP_INFO(struct icmpv6msg_mib, SNMP_ICMP6MSG_MIB, icmpv6msg_map_info_diag);
+static DECLARE_SNMP_MAP_INFO(struct tcp_mib, SNMP_TCP_MIB, tcp_map_info_diag);
+static DECLARE_SNMP_MAP_INFO(struct udp_mib, SNMP_UDP_MIB, udp_map_info_diag);
+static DECLARE_SNMP_MAP_INFO(struct linux_mib, SNMP_LINUX_MIB, linux_map_info_diag);
+static DECLARE_SNMP_MAP_INFO(struct linux_xfrm_mib, SNMP_LINUX_XFRM_MIB, linux_xfrm_map_info_diag);
+
+static struct snmp_mib_map_info *map_info_diag[__SNMP_MIB_MAX] = {
+	(struct snmp_mib_map_info *) &ipstats_map_info_diag,
+	(struct snmp_mib_map_info *) &icmp_map_info_diag,
+	(struct snmp_mib_map_info *) &icmpmsg_map_info_diag,
+	(struct snmp_mib_map_info *) &icmpv6_map_info_diag,
+	(struct snmp_mib_map_info *) &icmpv6msg_map_info_diag,
+	(struct snmp_mib_map_info *) &tcp_map_info_diag,
+	(struct snmp_mib_map_info *) &udp_map_info_diag,
+	(struct snmp_mib_map_info *) &linux_map_info_diag,
+	(struct snmp_mib_map_info *) &linux_xfrm_map_info_diag,
+};
+
+static struct snmp_mib_map_info **map_info[] = {
+	map_info_default,
+	map_info_diag,
+};
+
+
+
+/* Structures for maintaining labels of each counter in every SNMP MIB */
+struct snmp_mib_map_labels {
+	u32 len;
+	u32 registered; 
+	char *names[0];
+};
+
+#define DEFINE_SNMP_MAP_LABELS(type) \
+	type##_labels { \
+		u32 len; \
+		u32 registered; \
+		char *names[sizeof(type##_mapping)]; \
+	}
+
+DEFINE_SNMP_MAP_LABELS(struct ipstats_mib);
+DEFINE_SNMP_MAP_LABELS(struct icmp_mib);
+DEFINE_SNMP_MAP_LABELS(struct icmpmsg_mib);
+DEFINE_SNMP_MAP_LABELS(struct icmpv6_mib);
+DEFINE_SNMP_MAP_LABELS(struct icmpv6msg_mib);
+DEFINE_SNMP_MAP_LABELS(struct tcp_mib);
+DEFINE_SNMP_MAP_LABELS(struct udp_mib);
+DEFINE_SNMP_MAP_LABELS(struct linux_mib);
+DEFINE_SNMP_MAP_LABELS(struct linux_xfrm_mib);
+
+#define DECLARE_SNMP_MAP_LABELS(type, name) \
+	__typeof__(type##_labels) name= { \
+		.len = sizeof(type##_mapping), \
+		.registered = 0, \
+	}
+
+static DECLARE_SNMP_MAP_LABELS(struct ipstats_mib, ipstats_labels);
+static DECLARE_SNMP_MAP_LABELS(struct icmp_mib, icmp_labels);
+static DECLARE_SNMP_MAP_LABELS(struct icmpmsg_mib, icmpmsg_labels);
+static DECLARE_SNMP_MAP_LABELS(struct icmpv6_mib, icmpv6_labels);
+static DECLARE_SNMP_MAP_LABELS(struct icmpv6msg_mib, icmpv6msg_labels);
+static DECLARE_SNMP_MAP_LABELS(struct tcp_mib, tcp_labels);
+static DECLARE_SNMP_MAP_LABELS(struct udp_mib, udp_labels);
+static DECLARE_SNMP_MAP_LABELS(struct linux_mib, linux_labels);
+static DECLARE_SNMP_MAP_LABELS(struct linux_xfrm_mib, linux_xfrm_labels);
+
+static DEFINE_SPINLOCK(snmp_map_label_lock);
+static struct snmp_mib_map_labels *map_labels[__SNMP_MIB_MAX] = {
+        (struct snmp_mib_map_labels *) &ipstats_labels,
+        (struct snmp_mib_map_labels *) &icmp_labels,
+        (struct snmp_mib_map_labels *) &icmpmsg_labels,
+        (struct snmp_mib_map_labels *) &icmpv6_labels,
+        (struct snmp_mib_map_labels *) &icmpv6msg_labels,
+        (struct snmp_mib_map_labels *) &tcp_labels,
+        (struct snmp_mib_map_labels *) &udp_labels,
+        (struct snmp_mib_map_labels *) &linux_labels,
+        (struct snmp_mib_map_labels *) &linux_xfrm_labels,
+};
+
+
+/* Structures for maitainig a mapping from each counter in an SNMP MIB to the assigned map level*/
+#define DEFINE_MAP_MAPPING(type) \
+	type##_map_mapping_info { \
+		u32 len; \
+		type##_mapping map_map; \
+	}
+
+DEFINE_MAP_MAPPING(struct ipstats_mib);
+DEFINE_MAP_MAPPING(struct icmp_mib);
+DEFINE_MAP_MAPPING(struct icmpmsg_mib);
+DEFINE_MAP_MAPPING(struct icmpv6_mib);
+DEFINE_MAP_MAPPING(struct icmpv6msg_mib);
+DEFINE_MAP_MAPPING(struct tcp_mib);
+DEFINE_MAP_MAPPING(struct udp_mib);
+DEFINE_MAP_MAPPING(struct linux_mib);
+DEFINE_MAP_MAPPING(struct linux_xfrm_mib);
+
+#define DECLARE_MAP_MAPPING(type, name) \
+	__typeof__(type##_map_mapping_info) name = { \
+		.len = sizeof(type##_mapping), \
+	}
+
+static DECLARE_MAP_MAPPING(struct ipstats_mib, ipstats_map_mapping);
+static DECLARE_MAP_MAPPING(struct icmp_mib, icmp_map_mapping);
+static DECLARE_MAP_MAPPING(struct icmpmsg_mib, icmpmsg_map_mapping);
+static DECLARE_MAP_MAPPING(struct icmpv6_mib, icmpv6_map_mapping);
+static DECLARE_MAP_MAPPING(struct icmpv6msg_mib, icmpv6msg_map_mapping);
+static DECLARE_MAP_MAPPING(struct tcp_mib, tcp_map_mapping);
+static DECLARE_MAP_MAPPING(struct udp_mib, udp_map_mapping);
+static DECLARE_MAP_MAPPING(struct linux_mib, lnx_map_mapping);
+static DECLARE_MAP_MAPPING(struct linux_xfrm_mib, lnx_xfrm_map_mapping);
+
+struct snmp_map_mapper *map_mappings[__SNMP_MIB_MAX] = {
+	(struct snmp_map_mapper *) &ipstats_map_mapping,
+	(struct snmp_map_mapper *) &icmp_map_mapping,
+	(struct snmp_map_mapper *) &icmpmsg_map_mapping,
+	(struct snmp_map_mapper *) &icmpv6_map_mapping,
+	(struct snmp_map_mapper *) &icmpv6msg_map_mapping,
+	(struct snmp_map_mapper *) &tcp_map_mapping,
+	(struct snmp_map_mapper *) &udp_map_mapping,
+	(struct snmp_map_mapper *) &lnx_map_mapping,
+	(struct snmp_map_mapper *) &lnx_xfrm_map_mapping,
+};
+EXPORT_SYMBOL(map_mappings);
+
+int snmp_map_level = SNMP_MAP_LEVEL_DEFAULT;
+EXPORT_SYMBOL(snmp_map_level);
+
+#define SNMP_MAP_PREFIX "snmp_map: "
+
+#ifdef SNMP_MAP_DEBUG
+#define snmp_map_dprintk(level, format...) \
+		printk(KERN_DEBUG SNMP_MAP_PREFIX format)
+#else
+#define snmp_map_dprintk(level, format...)
+#endif
+
+static inline struct snmp_mib_map_info *
+snmp_map_get_info(u8 maplvl, u8 mibid) 
+{
+	struct snmp_mib_map_info *info = NULL;
+
+	if (maplvl >= SNMP_MAP_LEVEL_MAX) {
+		printk(KERN_NOTICE SNMP_MAP_PREFIX "invalid map level %d\n", maplvl);
+		return NULL;
+	}
+
+	if (mibid >= __SNMP_MIB_MAX) {
+		printk(KERN_NOTICE SNMP_MAP_PREFIX "invalid SNMP MIB ID %d\n", mibid);
+		return NULL;
+	}
+
+	info = map_info[maplvl][mibid];
+
+	return info;
+}
+
+static inline struct snmp_mib_map_info *
+snmp_map_get_initialized_info(u8 maplvl, u8 mibid) 
+{
+	struct snmp_mib_map_info *info = snmp_map_get_info(maplvl, mibid);
+
+	return (((info != NULL) && (atomic_read(&info->initialized) == 1)) ? info : NULL);
+}
+
+static inline bool
+snmp_map_initialized(struct snmp_mib_map_info *info)
+{
+	return (atomic_read(&info->initialized) == 1);
+}
+
+int
+snmp_map_count(struct snmp_mib_map *m)
+{
+	struct snmp_mib_map_info *info = snmp_map_get_initialized_info(m->maplvl, m->mibid);
+
+	return ((info != NULL) ? atomic_read(&info->count): 0);
+}
+EXPORT_SYMBOL(snmp_map_count);
+		
+static int
+snmp_map_get_count(u8 maplvl, u8 mibid)
+{
+	struct snmp_mib_map_info *info = NULL;
+
+	if ((info = snmp_map_get_info(maplvl, mibid)) == NULL)
+		return -EINVAL;
+
+	return (atomic_read(&info->count));
+}
+
+static int
+snmp_map_size(u8 maplvl, u8 mibid)
+{
+	return (snmp_map_get_count(maplvl, mibid) * sizeof(unsigned long));
+}
+
+static inline void
+snmp_map_zero_mapping(u8 *mapping, int len)
+{
+	memset(mapping, SNMP_MAP_UNMAPPED, len);
+}
+
+static inline void
+snmp_map_copy_mapping(u8 *mapping, struct snmp_mib_map_info *info)
+{
+	memcpy(mapping, info->map.mapping, info->len * sizeof(info->map.mapping[0]));
+}
+
+int 
+snmp_map_register_labels(u8 mibid, const struct snmp_mib *l, int len)
+{
+	int err = 0, i;
+	static struct snmp_mib_map_labels *labels;
+
+	if (mibid >= __SNMP_MIB_MAX) {
+		printk(KERN_NOTICE SNMP_MAP_PREFIX "invalid SNMP MIB ID %d\n", mibid);
+		return -ENOENT;
+	}
+
+	labels = map_labels[mibid];
+	spin_lock(&snmp_map_label_lock);
+
+	if (labels->registered == 0)
+		memset(labels->names, 0, labels->len * sizeof(labels->names[0]));
+
+	for (i = 0; i < len; i++) {
+		if (l[i].name == NULL)
+			break;
+
+		if (l[i].entry < 1 || l[i].entry >= labels->len) {
+			printk(KERN_NOTICE SNMP_MAP_PREFIX "label counter %d not in range (%d-%d) for SNMP MIB %d\n",
+			       l[i].entry, 1, labels->len - 1, mibid);
+			continue;
+		}
+
+		if (labels->names[l[i].entry] != NULL) {
+			printk(KERN_NOTICE SNMP_MAP_PREFIX "overwritting counter label %s for SNMP MIB %d\n", l[i].name, mibid);
+			kfree(labels->names[l[i].entry]);
+		}
+
+		labels->names[l[i].entry] = kstrdup(l[i].name, GFP_KERNEL);
+		if (labels->names[l[i].entry] == NULL) {
+			err = -ENOMEM;
+			printk(KERN_NOTICE SNMP_MAP_PREFIX "OOM while trying to allocate labels for SNMP MIB %d\n", mibid);
+			break;
+		}
+
+		labels->registered++;
+	}
+	spin_unlock(&snmp_map_label_lock);
+
+	printk(KERN_INFO SNMP_MAP_PREFIX "registered %d labels for SNMP MIB %d\n", labels->registered, mibid);
+
+	return err;	
+}
+
+static int cmp_mappings(const void *va, const void *vb)
+{
+	const u8 *a = (const u8 *) va, *b = (const u8 *) vb;
+
+	return (*a == *b)? 0 : (*a > *b)? 1 : -1;
+}
+
+static void
+snmp_map_print_mapping(u8 maplvl, u8 mibid, u8 *m, int count, int len)
+{
+#ifdef SNMP_MAP_DEBUG
+	int i;
+	struct snmp_map_mapper *mapper;
+#endif
+
+	printk(KERN_INFO SNMP_MAP_PREFIX "registered map level %d, SNMP MIB %d with %d mappings\n", maplvl, mibid, count);
+
+#ifdef SNMP_MAP_DEBUG
+	printk(KERN_INFO SNMP_MAP_PREFIX "current mappings for SNMP MIB %d:\n", mibid);	
+	for (i = 1; i < len; i++) {
+		if (map_labels[mibid]->names[i] != NULL) 
+			printk("%s: %d, ", map_labels[mibid]->names[i], m[i]);
+		else
+			printk("%d: %d, ", i, m[i]);
+	}
+	printk("\n\n");
+
+	printk(KERN_INFO SNMP_MAP_PREFIX "current map level registration for SNMP MIB %d:\n", mibid);
+	mapper = snmp_map_get_mapper(mibid);
+	if (mapper) {
+		for (i = 1; i < len; i++) {
+			if (map_labels[mibid]->names[i] != NULL)
+				printk("%s: %d, ", map_labels[mibid]->names[i], mapper->map_map.mapping[i]);
+			else
+				printk("%d: %d, ", i, mapper->map_map.mapping[i]);
+		}
+		printk("\n\n");
+	}
+#endif
+}
+
+int  
+snmp_map_add_empty_mapping(u8 maplvl, u8 mibid) 
+{
+	struct snmp_mib_map_info *info;
+
+	info = snmp_map_get_info(maplvl, mibid);
+	if (info == NULL)
+		return -EINVAL;
+
+	if (snmp_map_initialized(info)) {
+		printk(KERN_NOTICE SNMP_MAP_PREFIX "map level %d, SNMP MIB %d is already initialized\n", maplvl, mibid);
+		return -EINVAL;
+	}
+
+	spin_lock(&info->lock);
+	
+	snmp_map_zero_mapping(info->map.mapping, info->len * sizeof(info->map.mapping[0]));
+
+	atomic_set(&info->initialized, 1);
+
+	spin_unlock(&info->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(snmp_map_add_empty_mapping);
+
+int
+snmp_map_add_mapping(u8 maplvl, u8 mibid, u8 *m, int c, u8 *me, int ce)
+{
+        int i, j, field, fields = c, count = c, mappedto = 0;
+	bool exclude = false;
+        struct snmp_mib_map_info *info;
+	struct snmp_map_mapper *mapper;
+
+        info = snmp_map_get_info(maplvl, mibid);
+	if (info == NULL) 
+		return -EINVAL;
+
+	if (snmp_map_initialized(info)) {
+                printk(KERN_NOTICE "snmp_map: map level %d, SNMP MIB %d is already initialized\n", maplvl, mibid);
+                return -EINVAL;
+        }
+
+	mapper = snmp_map_get_mapper(mibid);
+	if (unlikely(mapper == NULL))
+		return -EFAULT;
+
+	spin_lock(&info->lock);
+
+	snmp_map_zero_mapping(info->map.mapping, info->len * sizeof(info->map.mapping[0]));
+
+	if (m != NULL)
+		sort(m, count, sizeof(m[0]), cmp_mappings, NULL);
+	else
+		count = fields = info->len;
+
+	if (me != NULL)
+		sort(me, ce, sizeof(me[0]), cmp_mappings, NULL);
+
+	for (i = ((m != NULL) ? 0 : 1); i < count; i++) {
+		exclude = false;
+		field = ((m != NULL) ? m[i] : i);
+		if (field <= 0 || field >= info->len) {
+			printk(KERN_NOTICE SNMP_MAP_PREFIX "counter %d not in range (%d-%d) for SNMP MIB %d\n", 
+			       field, 1, info->len - 1, mibid);
+			fields -= 1;
+			continue;
+		}
+
+		if (me != NULL) {
+			for (j = 0; j < ce; j++) {
+				if (me[j] == field) {
+					exclude = true;
+					break;
+				}
+			}
+			if (exclude)  {
+				fields -= 1;
+				continue;
+			}
+		}
+			
+		/* A mapping can exist on only one level so we can have a one to one mapping from a field to a level */
+		if (mapper->map_map.mapping[field] == SNMP_MAP_UNMAPPED) {
+			info->map.mapping[field] = mappedto++;
+			mapper->map_map.mapping[field] = maplvl;
+		} else {
+			fields -= 1;
+			if (m != NULL)
+				printk(KERN_NOTICE SNMP_MAP_PREFIX "counter %d already mapped for SNMP MIB %d\n", field, mibid);
+		}
+	}			
+
+	if (fields > 0) {
+		atomic_set(&info->count, fields);
+		atomic_set(&info->initialized, 1);
+	}
+
+	spin_unlock(&info->lock);
+
+        if (fields > 0) {
+		snmp_map_print_mapping(maplvl, mibid, info->map.mapping, fields, info->len);
+	}
+
+        return 0;
+}
+EXPORT_SYMBOL(snmp_map_add_mapping);
+
+int 
+snmp_map_del_mapping(u8 maplvl, u8 mibid)
+{
+	struct snmp_mib_map_info *info;
+	int i;
+        struct snmp_map_mapper *mapper;
+
+	info = snmp_map_get_info(maplvl, mibid);
+	if (info == NULL)
+		return -EINVAL;
+
+	mapper = snmp_map_get_mapper(mibid);
+	if (unlikely(mapper == NULL))
+		return -EFAULT;
+
+	if (!snmp_map_initialized(info)) {
+		printk(KERN_NOTICE SNMP_MAP_PREFIX "map level %d, SNMP MIB %d is not initialized - nothing to delete\n", maplvl, mibid);
+		return 0;
+	}
+
+	spin_lock(&info->lock);
+	atomic_set(&info->initialized, 0);
+	atomic_set(&info->count, 0);
+	for (i = 0; i < info->len; i++) {
+		if (mapper->map_map.mapping[i] == maplvl) {
+			mapper->map_map.mapping[i] = SNMP_MAP_UNMAPPED;
+		}
+	}
+	snmp_map_zero_mapping(info->map.mapping, info->len * sizeof(info->map.mapping[0]));
+	spin_unlock(&info->lock);
+
+	printk(KERN_INFO SNMP_MAP_PREFIX "cleared map level %d, SNMP MIB %d mappings\n", maplvl, mibid);
+
+	return 0;
+}
+EXPORT_SYMBOL(snmp_map_del_mapping);
+
+int 
+snmp_map_init_map(u8 maplvl, u8 mibid, struct snmp_mib_map *m)
+{
+	struct snmp_mib_map_info *info;
+
+	info = snmp_map_get_info(maplvl, mibid);
+	if (info == NULL)
+		return -EINVAL;
+
+	m->maplvl = maplvl;
+	m->mibid = mibid;
+	snmp_map_copy_mapping(m->map.mapping, info);
+	m->stats.stats[0] = NULL;
+	m->stats.stats[1] = NULL;
+
+	return 0;	
+}
+
+int
+snmp_map_mib_init(struct snmp_mib_map *m)
+{
+	int err = -EINVAL, sz = snmp_map_size(m->maplvl, m->mibid);
+
+	if (sz == 0)
+		return 0;
+
+	if ((m->stats.stats[0] == NULL) && (m->stats.stats[1] == NULL))
+		err = snmp_mib_init((void **) &m->stats, sz);
+
+	return err;
+}
+
+void
+snmp_map_mib_free(struct snmp_mib_map *m)
+{
+	int sz = snmp_map_size(m->maplvl, m->mibid);
+
+	if (sz == 0)
+		return;
+
+	if ((m->stats.stats[0] != NULL) && (m->stats.stats[1] != NULL)) 
+		snmp_mib_free((void **) &m->stats);
+}
+
+void 
+snmp_map_mib_zero(struct snmp_mib_map *m)
+{
+	struct snmp_mib_map_info *info = NULL;
+	int sz;
+
+	if ((info = snmp_map_get_info(m->maplvl, m->mibid)) == NULL)
+		return;
+
+	if (!snmp_map_initialized(info))
+		return;
+
+	sz = atomic_read(&info->count) * sizeof(unsigned long);
+	if (sz > 0 && (m->stats.stats[0] != NULL ) && (m->stats.stats[1] != NULL)) {
+		unsigned long *p0, *p1;
+		int i;
+
+		for_each_possible_cpu(i) {
+			p0 = (unsigned long *) per_cpu_ptr(m->stats.stats[0], i);
+			p1 = (unsigned long *) per_cpu_ptr(m->stats.stats[1], i);
+			memset(p0, 0, sz);
+			memset(p1, 0, sz);
+			smp_mb();
+		}
+	}	
+}
+
+static unsigned long
+snmp_map_fold_field(struct snmp_mib_map *m, int mappedto, bool test_negative)
+{
+	unsigned long ures = 0;
+
+	if (m != NULL && snmp_map_count(m) != 0) {
+		ures = snmp_fold_field((void **) &m->stats, mappedto);
+		if (test_negative) {
+			long res = (long) ures;
+			if (res < 0) {
+				unsigned long *p = (unsigned long *) per_cpu_ptr(m->stats.stats[!in_softirq()], get_cpu());
+				p[mappedto] += (-res);
+				put_cpu();
+				ures = 0;
+			}
+		}
+	}
+
+	return ures;
+}
+
+void 
+snmp_map_zero_negative(struct snmp_mib_map *m, u8 field) 
+{
+	long res;
+	int mappedto = m->map.mapping[field];
+
+	res = (long) snmp_fold_field((void **) &m->stats, mappedto);
+	if (res < 0) {
+		unsigned long *p = (unsigned long *) per_cpu_ptr(m->stats.stats[!in_softirq()], get_cpu());
+		p[mappedto] += (-res);
+		put_cpu();
+	}
+}
+
+
+int
+snmp_map_print_stats(struct seq_file *seq, struct snmp_mib_map *m, union snmp_mib_map_bitmaps *b)
+{
+	int i;
+	struct snmp_mib_map_info *info;
+	unsigned long counter;
+	bool first = true;
+
+	info = snmp_map_get_info(m->maplvl, m->mibid);
+	if (info == NULL)
+		return -EINVAL;
+
+	if (snmp_map_initialized(info) && atomic_read(&info->count) > 0) {
+		for (i = 1; i < info->len; i++) {
+			int mappedto;
+			bool test_negative = ((b != NULL) && test_bit(i, b->bmap.bitmap));
+
+			mappedto = m->map.mapping[i];
+			if (mappedto != SNMP_MAP_UNMAPPED) {
+				counter = snmp_map_fold_field(m, mappedto, test_negative);
+				if (map_labels[m->mibid]->names[i] != NULL)
+					seq_printf(seq, "%s%s: %lu", (first) ? "" : ",  ", map_labels[m->mibid]->names[i], counter);
+				else
+					seq_printf(seq, "%s%d:  %lu", (first) ? "" : ",  ", i, counter);
+				first = false;
+			}
+		}
+
+		seq_putc(seq, '\n');
+	}
+
+	return 0;	
+}
+
+int
+snmp_map_level_handler(ctl_table *table, int write, void __user *buffer, size_t *length, loff_t *ppos)
+{
+	int oldval = snmp_map_level, err = 0;
+
+	proc_dointvec_minmax(table, write, buffer, length, ppos);
+	if (write) {
+		if (snmp_map_level < 0 || snmp_map_level >= SNMP_MAP_LEVEL_MAX) {
+			snmp_map_level = oldval;
+			printk(KERN_NOTICE SNMP_MAP_PREFIX "invalid map level (valid argument: %d - %d)\n", 0, SNMP_MAP_LEVEL_MAX - 1);
+			err = -EINVAL;
+		}
+		smp_mb();
+	}
+
+	return err;
+}
+
+static __init int
+snmp_map_init(void)
+{
+	int i;
+	struct snmp_map_mapper *mapper;
+
+	for (i = 0; i < __SNMP_MIB_MAX; i++) {
+		mapper = map_mappings[i];
+		snmp_map_zero_mapping(mapper->map_map.mapping, mapper->len * sizeof(mapper->map_map.mapping[0]));
+	}
+
+	return 0;
+}
+
+__initcall(snmp_map_init);
+
diff -r -U 4 a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c	2013-09-01 09:03:35.391639189 +0300
+++ b/net/ipv4/sysctl_net_ipv4.c	2013-09-01 09:03:35.511694388 +0300
@@ -814,8 +814,19 @@
 		.proc_handler	= proc_dointvec_minmax,
 		.strategy	= sysctl_intvec,
 		.extra1		= &zero
 	},
+#ifdef CONFIG_NET_IPV4_SNMP_MAPPING
+	{
+		.ctl_name       = NET_IPV4_SNMP_MAP_LEVEL,
+		.procname       = "perip_stats_diagnose",
+		.data           = &snmp_map_level,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = snmp_map_level_handler,
+		.strategy       = &sysctl_intvec,
+	},
+#endif
 	{ .ctl_name = 0 }
 };
 
 static struct ctl_table ipv4_net_table[] = {
