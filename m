Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab3D2TDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:03:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759810Ab3D2TDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:03:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/34] netfilter: dont reset nf_trace in nf_reset()
Date: Mon, 29 Apr 2013 12:02:32 -0700
Message-Id: <20130429184703.755059070@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130429184700.845644077@linuxfoundation.org>
References: <20130429184700.845644077@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/skbuff.h |    7 +++++++
 net/core/dev.c         |    1 +
 2 files changed, 8 insertions(+)

--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2392,6 +2392,13 @@ static inline void nf_reset(struct sk_bu
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
@@ -1628,6 +1628,7 @@ int dev_forward_skb(struct net_device *d
 	skb->mark = 0;
 	secpath_reset(skb);
 	nf_reset(skb);
+	nf_reset_trace(skb);
 	return netif_rx(skb);
 }
 EXPORT_SYMBOL_GPL(dev_forward_skb);


