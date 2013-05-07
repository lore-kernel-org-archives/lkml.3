Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab3EGOIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:08:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42291 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab3EGNlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 049/118] netfilter: don't reset nf_trace in nf_reset()
Date: Tue,  7 May 2013 14:38:15 +0100
Message-Id: <1367933964-1564-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit 124dff01afbdbff251f0385beca84ba1b9adda68 upstream.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/skbuff.h | 7 +++++++
 net/core/dev.c         | 1 +
 2 files changed, 8 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5af4bef..e1c1e64 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2404,6 +2404,13 @@ static inline void nf_reset(struct sk_buff *skb)
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
diff --git a/net/core/dev.c b/net/core/dev.c
index 845a83a..196bc5f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1627,6 +1627,7 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
 	skb->mark = 0;
 	secpath_reset(skb);
 	nf_reset(skb);
+	nf_reset_trace(skb);
 	return netif_rx(skb);
 }
 EXPORT_SYMBOL_GPL(dev_forward_skb);
-- 
1.8.1.2

