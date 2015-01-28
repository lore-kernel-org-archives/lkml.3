Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965409AbbA2CiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:38:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47017 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965400AbbA2Ch6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:58 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Graf <tgraf@suug.ch>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 009/139] net: Reset secmark when scrubbing packet
Date: Wed, 28 Jan 2015 14:19:12 -0800
Message-Id: <1422483682-15393-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Graf <tgraf@suug.ch>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ddbb949..6e42045 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3568,6 +3568,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->local_df = 0;
 	skb_dst_drop(skb);
 	skb->mark = 0;
+	skb_init_secmark(skb);
 	secpath_reset(skb);
 	nf_reset(skb);
 	nf_reset_trace(skb);
-- 
1.9.1

