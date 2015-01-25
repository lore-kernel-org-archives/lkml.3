Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbbAYTDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:03:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57698 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbbAYSJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Graf <tgraf@suug.ch>, Flavio Leitner <fbl@sysclose.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 017/183] net: Reset secmark when scrubbing packet
Date: Sun, 25 Jan 2015 10:05:39 -0800
Message-Id: <20150125180810.924072326@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4040,6 +4040,7 @@ void skb_scrub_packet(struct sk_buff *sk
 	skb->ignore_df = 0;
 	skb_dst_drop(skb);
 	skb->mark = 0;
+	skb_init_secmark(skb);
 	secpath_reset(skb);
 	nf_reset(skb);
 	nf_reset_trace(skb);


