Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3EJOUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57025 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271Ab3EJOUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Patrick McHardy" <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.782497562@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [092/118] netfilter: don't reset nf_trace in nf_reset()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

[ Upstream commit 124dff01afbdbff251f0385beca84ba1b9adda68 ]

Commit 130549fe ("netfilter: reset nf_trace in nf_reset") added code
to reset nf_trace in nf_reset(). This is wrong and unnecessary.

nf_reset() is used in the following cases:

- when passing packets up the the socket layer, at which point we want to
  release all netfilter references that might keep modules pinned while
  the packet is queued. nf_trace doesn't matter anymore at this point.

- when encapsulating or decapsulating IPsec packets. We want to continue
  tracing these packets after IPsec processing.

- when passing packets through virtual network devices. Only devices on
  that encapsulate in IPv4/v6 matter since otherwise nf_trace is not
  used anymore. Its not entirely clear whether those packets should
  be traced after that, however we've always done that.

- when passing packets through virtual network devices that make the
  packet cross network namespace boundaries. This is the only cases
  where we clearly want to reset nf_trace and is also what the
  original patch intended to fix.

Add a new function nf_reset_trace() and use it in dev_forward_skb() to
fix this properly.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/skbuff.h | 7 +++++++
 net/core/dev.c         | 1 +
 2 files changed, 8 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2367,6 +2367,13 @@ static inline void nf_reset(struct sk_bu
 #endif
 }
 
+static inline void nf_reset_trace(struct sk_buff *skb)
+{
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE)
+	skb->nf_trace = 0;
+#endif
+}
+
 /* Note: This doesn't put any conntrack and bridge info in dst. */
 static inline void __nf_copy(struct sk_buff *dst, const struct sk_buff *src)
 {
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1619,6 +1619,7 @@ int dev_forward_skb(struct net_device *d
 	skb->mark = 0;
 	secpath_reset(skb);
 	nf_reset(skb);
+	nf_reset_trace(skb);
 	return netif_rx(skb);
 }
 EXPORT_SYMBOL_GPL(dev_forward_skb);

