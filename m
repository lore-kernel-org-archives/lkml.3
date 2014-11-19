Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbaKSVze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:55:34 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:38299 "HELO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932991AbaKSVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:55:29 -0500
From: Joe Stringer <joestringer@nicira.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, pshelar@nicira.com, dev@openvswitch.org
Subject: [PATCHv3 net] openvswitch: Don't validate IPv6 label masks.
Date: Wed, 19 Nov 2014 13:54:49 -0800
Message-Id: <1416434089-47062-1-git-send-email-joestringer@nicira.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When userspace doesn't provide a mask, OVS datapath generates a fully
unwildcarded mask for the flow by copying the flow and setting all bits
in all fields. For IPv6 label, this creates a mask that matches on the
upper 12 bits, causing the following error:

openvswitch: netlink: Invalid IPv6 flow label value (value=ffffffff, max=fffff)

This patch ignores the label validation check for masks, avoiding this
error.

Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
v3: Alternative approach.
    Was "openvswitch: Fix mask generation for IPv6 labels."
v2: OR lower 20 bits (upper 12 bits remain from earlier memdup)
---
 net/openvswitch/flow_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index fa4ec2e..089b195 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -690,7 +690,7 @@ static int ovs_key_from_nlattrs(struct sw_flow_match *match, u64 attrs,
 			return -EINVAL;
 		}
 
-		if (ipv6_key->ipv6_label & htonl(0xFFF00000)) {
+		if (!is_mask && ipv6_key->ipv6_label & htonl(0xFFF00000)) {
 			OVS_NLERR("IPv6 flow label %x is out of range (max=%x).\n",
 				  ntohl(ipv6_key->ipv6_label), (1 << 20) - 1);
 			return -EINVAL;
-- 
1.7.10.4

