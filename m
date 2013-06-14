Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3FNB5H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:57:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:63049 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab3FNB5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:57:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,863,1363158000"; 
   d="scan'208";a="349633172"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v4 net-next 1/4] net: change sysctl_net_ll_poll into an
 unsigned int
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
Date: Fri, 14 Jun 2013 04:56:49 +0300
Message-ID: <20130614015648.3500.85865.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130614015638.3500.61523.stgit@ladj378.jer.intel.com>
References: <20130614015638.3500.61523.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason for sysctl_net_ll_poll to be an unsigned long.
Change it into an unsigned int.
Fix the proc handler.

Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
---

 include/net/ll_poll.h      |    5 +++--
 net/core/sysctl_net_core.c |    4 ++--
 net/socket.c               |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/ll_poll.h b/include/net/ll_poll.h
index bc262f8..44e2f70 100644
--- a/include/net/ll_poll.h
+++ b/include/net/ll_poll.h
@@ -34,7 +34,7 @@
 #ifdef CONFIG_NET_LL_RX_POLL
 
 struct napi_struct;
-extern unsigned long sysctl_net_ll_poll __read_mostly;
+extern unsigned int sysctl_net_ll_poll __read_mostly;
 
 /* return values from ndo_ll_poll */
 #define LL_FLUSH_FAILED		-1
@@ -45,7 +45,8 @@ extern unsigned long sysctl_net_ll_poll __read_mostly;
 
 static inline cycles_t ll_end_time(void)
 {
-	return TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll) + get_cycles();
+	return (cycles_t)TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll)
+			+ get_cycles();
 }
 
 static inline bool sk_valid_ll(struct sock *sk)
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 637a42e..ce9acc2 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -289,9 +289,9 @@ static struct ctl_table net_core_table[] = {
 	{
 		.procname	= "low_latency_poll",
 		.data		= &sysctl_net_ll_poll,
-		.maxlen		= sizeof(unsigned long),
+		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax
+		.proc_handler	= proc_dointvec
 	},
 #endif
 #endif /* CONFIG_NET */
diff --git a/net/socket.c b/net/socket.c
index 21fd29f..caaffa1 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -107,7 +107,7 @@
 #include <net/ll_poll.h>
 
 #ifdef CONFIG_NET_LL_RX_POLL
-unsigned long sysctl_net_ll_poll __read_mostly;
+unsigned int sysctl_net_ll_poll __read_mostly;
 EXPORT_SYMBOL_GPL(sysctl_net_ll_poll);
 #endif
 

