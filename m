Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaB1TRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:17:07 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:2745 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbaB1TRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:17:04 -0500
X-IronPort-AV: E=Sophos;i="4.97,563,1389744000"; 
   d="scan'208";a="105108196"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Jesse Gross <jesse@nicira.com>, <pshelar@nicira.com>, <tgraf@redhat.com>,
        <dev@openvswitch.org>
CC: <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH] openvswitch: Orphan frags before sending to userspace via Netlink to avoid guest stall
Date: Fri, 28 Feb 2014 19:16:56 +0000
Message-ID: <1393615016-9187-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel datapath now switched to zerocopy Netlink messages, but that also
means that the pages on frags array are sent straight to userspace. If those
pages came outside the kernel, we have to swap them out with local copies.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 net/openvswitch/datapath.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 36f8872..ffb563c 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -464,6 +464,12 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 	}
 	nla->nla_len = nla_attr_size(skb->len);
 
+	if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC))) {
+		err = -ENOMEM;
+		skb_tx_error(skb);
+		goto out;
+	}
+
 	skb_zerocopy(user_skb, skb, skb->len, hlen);
 
 	/* Pad OVS_PACKET_ATTR_PACKET if linear copy was performed */
