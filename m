Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaEHRXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:23:43 -0400
Received: from shelob.surriel.com ([74.92.59.67]:53761 "EHLO
	shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaEHRXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:23:41 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: [PATCH 1/4] numa,x86: store maximum numa node distance
Date: Thu,  8 May 2014 13:23:28 -0400
Message-Id: <1399569811-14362-2-git-send-email-riel@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1399569811-14362-1-git-send-email-riel@redhat.com>
References: <1399569811-14362-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

Store the maximum node distance, so the numa placement code can do
better placement on systems with complex numa topology.

The function max_node_distance will return LOCAL_DISTANCE if the
system has simple NUMA topology, with only a single level of
remote distance.

Signed-off-by: Rik van Riel <riel@redhat.com>
Tested-by: Chegu Vinod <chegu_vinod@hp.com>
---
 arch/x86/include/asm/topology.h |  3 +++
 arch/x86/mm/numa.c              | 25 +++++++++++++++++++++++++
 include/linux/topology.h        |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 0e8f04f..3ed2464 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -95,6 +95,9 @@ extern void setup_node_to_cpumask_map(void);
 extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 
+extern int max_node_distance(void);
+#define max_node_distance max_node_distance
+
 #else /* !CONFIG_NUMA */
 
 static inline int numa_node_id(void)
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 1d045f9..525cde9 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -34,6 +34,8 @@ __initdata
 
 static int numa_distance_cnt;
 static u8 *numa_distance;
+static int numa_max_distance;
+static bool numa_complex_topology;
 
 static __init int numa_setup(char *opt)
 {
@@ -357,6 +359,19 @@ void __init numa_reset_distance(void)
 		memblock_free(__pa(numa_distance), size);
 	numa_distance_cnt = 0;
 	numa_distance = NULL;	/* enable table creation */
+	numa_max_distance = LOCAL_DISTANCE;
+	numa_complex_topology = false;
+}
+
+static void __init numa_set_max_distance(int distance)
+{
+	/* Remember the maximum node distance seen. */
+	if (distance > numa_max_distance)
+		numa_max_distance = distance;
+
+	/* Do we see any values in-between local distance and the maximum? */
+	if (distance != LOCAL_DISTANCE && distance != numa_max_distance)
+		numa_complex_topology = true;
 }
 
 static int __init numa_alloc_distance(void)
@@ -437,6 +452,16 @@ void __init numa_set_distance(int from, int to, int distance)
 	}
 
 	numa_distance[from * numa_distance_cnt + to] = distance;
+
+	numa_set_max_distance(distance);
+}
+
+int max_node_distance(void)
+{
+	if (!numa_complex_topology)
+		return LOCAL_DISTANCE;
+
+	return numa_max_distance;
 }
 
 int __node_distance(int from, int to)
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7062330..6781b8d 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -54,6 +54,9 @@ int arch_update_cpu_topology(void);
 #ifndef node_distance
 #define node_distance(from,to)	((from) == (to) ? LOCAL_DISTANCE : REMOTE_DISTANCE)
 #endif
+#ifndef max_node_distance
+#define max_node_distance() (LOCAL_DISTANCE)
+#endif
 #ifndef RECLAIM_DISTANCE
 /*
  * If the distance between nodes in a system is larger than RECLAIM_DISTANCE
-- 
1.8.5.3

