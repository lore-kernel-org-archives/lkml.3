Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3IWTNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:13:15 -0400
Received: from a194-110.smtp-out.amazonses.com ([199.255.194.110]:43547 "EHLO
	a194-110.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430Ab3IWTMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:12:51 -0400
Message-Id: <000001414c3d064a-ebe0610b-6951-4a74-bd33-8480e3e1e364-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 23 Sep 2013 19:12:50 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [pchecks v1 2/4] Use raw cpu ops for calls that would trigger with checks
References: <20130923191256.584672290@linux.com>
X-SES-Outgoing: 199.255.194.110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These location triggered during testing with KVM.

These are fetches without preemption off where we judged that
to be more performance efficient or where other means of
providing synchronization (BH handling) are available.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/topology.h
===================================================================
--- linux.orig/include/linux/topology.h	2013-09-12 13:26:29.216103951 -0500
+++ linux/include/linux/topology.h	2013-09-12 13:41:30.762358687 -0500
@@ -182,7 +182,7 @@ DECLARE_PER_CPU(int, numa_node);
 /* Returns the number of the current Node. */
 static inline int numa_node_id(void)
 {
-	return __this_cpu_read(numa_node);
+	return raw_cpu_read(numa_node);
 }
 #endif
 
@@ -239,7 +239,7 @@ static inline void set_numa_mem(int node
 /* Returns the number of the nearest Node with memory */
 static inline int numa_mem_id(void)
 {
-	return __this_cpu_read(_numa_mem_);
+	return raw_cpu_read(_numa_mem_);
 }
 #endif
 
Index: linux/include/net/snmp.h
===================================================================
--- linux.orig/include/net/snmp.h	2013-09-12 13:26:29.216103951 -0500
+++ linux/include/net/snmp.h	2013-09-12 13:26:29.208104037 -0500
@@ -126,7 +126,7 @@ struct linux_xfrm_mib {
 	extern __typeof__(type) __percpu *name[SNMP_ARRAY_SZ]
 
 #define SNMP_INC_STATS_BH(mib, field)	\
-			__this_cpu_inc(mib[0]->mibs[field])
+			raw_cpu_inc(mib[0]->mibs[field])
 
 #define SNMP_INC_STATS_USER(mib, field)	\
 			this_cpu_inc(mib[0]->mibs[field])
@@ -141,7 +141,7 @@ struct linux_xfrm_mib {
 			this_cpu_dec(mib[0]->mibs[field])
 
 #define SNMP_ADD_STATS_BH(mib, field, addend)	\
-			__this_cpu_add(mib[0]->mibs[field], addend)
+			raw_cpu_add(mib[0]->mibs[field], addend)
 
 #define SNMP_ADD_STATS_USER(mib, field, addend)	\
 			this_cpu_add(mib[0]->mibs[field], addend)
Index: linux/kernel/hrtimer.c
===================================================================
--- linux.orig/kernel/hrtimer.c	2013-09-12 13:26:29.216103951 -0500
+++ linux/kernel/hrtimer.c	2013-09-12 13:26:29.212103994 -0500
@@ -538,7 +538,7 @@ static inline int hrtimer_is_hres_enable
  */
 static inline int hrtimer_hres_active(void)
 {
-	return __this_cpu_read(hrtimer_bases.hres_active);
+	return raw_cpu_read(hrtimer_bases.hres_active);
 }
 
 /*

