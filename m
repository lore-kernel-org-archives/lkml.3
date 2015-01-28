Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762773AbbA2Kit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:38:49 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755412AbbA2JAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:15 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 062/176] net: Reset secmark when scrubbing packet
Date: Wed, 28 Jan 2015 15:28:12 +0100
Message-Id: <00c47292b1cdf7e721dccc5659879732eca6451a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit b8fb4e0648a2ab3734140342002f68fb0c7d1602 ]

skb_scrub_packet() is called when a packet switches between a context
such as between underlay and overlay, between namespaces, or between
L3 subnets.

While we already scrub the packet mark, connection tracking entry,
and cached destination, the security mark/context is left intact.

It seems wrong to inherit the security context of a packet when going
from overlay to underlay or across forwarding paths.

Signed-off-by: Thomas Graf <tgraf@suug.ch>
Acked-by: Flavio Leitner <fbl@sysclose.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a8cf33868f9c..17313d17a923 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3523,6 +3523,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->local_df = 0;
 	skb_dst_drop(skb);
 	skb->mark = 0;
+	skb_init_secmark(skb);
 	secpath_reset(skb);
 	nf_reset(skb);
 	nf_reset_trace(skb);
-- 
2.2.2

