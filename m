Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab3FNNdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:33:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:7901 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3FNNdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:33:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,866,1363158000"; 
   d="scan'208";a="353445729"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v5 net-next 2/4] net: convert low latency sockets to
 sched_clock()
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Avner Ben Hanoch <avnerb@mellanox.com>, Or Kehati <ork@mellanox.com>,
        sockperf-dev@googlegroups.com, Eliezer Tamir <eliezer@tamir.org.il>
Date: Fri, 14 Jun 2013 16:33:35 +0300
Message-ID: <20130614133335.6126.8092.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130614133314.6126.77315.stgit@ladj378.jer.intel.com>
References: <20130614133314.6126.77315.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use sched_clock() instead of get_cycles().
We can use sched_clock() because we don't care much about accuracy.
Remove the dependency on X86_TSC

Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---

 include/net/ll_poll.h |   33 +++++++++++++++++----------------
 net/Kconfig           |    1 -
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/include/net/ll_poll.h b/include/net/ll_poll.h
index 44e2f70..6930cbd 100644
--- a/include/net/ll_poll.h
+++ b/include/net/ll_poll.h
@@ -21,10 +21,6 @@
  * e1000-devel Mailing List <e1000-devel@lists.sourceforge.net>
  */
 
-/*
- * For now this depends on CONFIG_X86_TSC
- */
-
 #ifndef _LINUX_NET_LL_POLL_H
 #define _LINUX_NET_LL_POLL_H
 
@@ -40,13 +36,19 @@ extern unsigned int sysctl_net_ll_poll __read_mostly;
 #define LL_FLUSH_FAILED		-1
 #define LL_FLUSH_BUSY		-2
 
-/* we don't mind a ~2.5% imprecision */
-#define TSC_MHZ (tsc_khz >> 10)
-
-static inline cycles_t ll_end_time(void)
+/* we can use sched_clock() because we don't care much about precision
+ * we only care that the average is bounded
+ */
+static inline u64 ll_end_time(void)
 {
-	return (cycles_t)TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll)
-			+ get_cycles();
+	u64 end_time = ACCESS_ONCE(sysctl_net_ll_poll);
+
+	/* we don't mind a ~2.5% imprecision
+	 * sysctl_net_ll_poll is a u_int so this can't overflow
+	 */
+	end_time = (end_time << 10) + sched_clock();
+
+	return end_time;
 }
 
 static inline bool sk_valid_ll(struct sock *sk)
@@ -55,16 +57,15 @@ static inline bool sk_valid_ll(struct sock *sk)
 	       !need_resched() && !signal_pending(current);
 }
 
-static inline bool can_poll_ll(cycles_t end_time)
+static inline bool can_poll_ll(u64 end_time)
 {
-	return !time_after((unsigned long)get_cycles(),
-			    (unsigned long)end_time);
+	return !time_after64(sched_clock(), end_time);
 }
 
 static inline bool sk_poll_ll(struct sock *sk, int nonblock)
 {
-	cycles_t end_time = ll_end_time();
 	const struct net_device_ops *ops;
+	u64 end_time = ll_end_time();
 	struct napi_struct *napi;
 	int rc = false;
 
@@ -117,7 +118,7 @@ static inline void sk_mark_ll(struct sock *sk, struct sk_buff *skb)
 
 #else /* CONFIG_NET_LL_RX_POLL */
 
-static inline cycles_t ll_end_time(void)
+static inline u64 ll_end_time(void)
 {
 	return 0;
 }
@@ -140,7 +141,7 @@ static inline void sk_mark_ll(struct sock *sk, struct sk_buff *skb)
 {
 }
 
-static inline bool can_poll_ll(cycles_t end_time)
+static inline bool can_poll_ll(u64 end_time)
 {
 	return false;
 }
diff --git a/net/Kconfig b/net/Kconfig
index d6a9ce6..e591668 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -245,7 +245,6 @@ config NETPRIO_CGROUP
 
 config NET_LL_RX_POLL
 	bool "Low Latency Receive Poll"
-	depends on X86_TSC
 	default n
 	---help---
 	  Support Low Latency Receive Queue Poll.

