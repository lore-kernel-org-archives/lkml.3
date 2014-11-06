Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaKFXXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:23:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58450 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbaKFWhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Benc <jbenc@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 009/162] openvswitch: fix panic with multiple vlan headers
Date: Thu,  6 Nov 2014 14:34:33 -0800
Message-Id: <1415313426-9622-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 2ba5af42a7b59ef01f9081234d8855140738defd ]

When there are multiple vlan headers present in a received frame, the first
one is put into vlan_tci and protocol is set to ETH_P_8021Q. Anything in the
skb beyond the VLAN TPID may be still non-linear, including the inner TCI
and ethertype. While ovs_flow_extract takes care of IP and IPv6 headers, it
does nothing with ETH_P_8021Q. Later, if OVS_ACTION_ATTR_POP_VLAN is
executed, __pop_vlan_tci pulls the next vlan header into vlan_tci.

This leads to two things:

1. Part of the resulting ethernet header is in the non-linear part of the
   skb. When eth_type_trans is called later as the result of
   OVS_ACTION_ATTR_OUTPUT, kernel BUGs in __skb_pull. Also, __pop_vlan_tci
   is in fact accessing random data when it reads past the TPID.

2. network_header points into the ethernet header instead of behind it.
   mac_len is set to a wrong value (10), too.

Reported-by: Yulong Pei <ypei@redhat.com>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/openvswitch/actions.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 65cfaa8..07c4ae3 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -42,6 +42,9 @@ static int do_execute_actions(struct datapath *dp, struct sk_buff *skb,
 
 static int make_writable(struct sk_buff *skb, int write_len)
 {
+	if (!pskb_may_pull(skb, write_len))
+		return -ENOMEM;
+
 	if (!skb_cloned(skb) || skb_clone_writable(skb, write_len))
 		return 0;
 
@@ -70,6 +73,8 @@ static int __pop_vlan_tci(struct sk_buff *skb, __be16 *current_tci)
 
 	vlan_set_encap_proto(skb, vhdr);
 	skb->mac_header += VLAN_HLEN;
+	if (skb_network_offset(skb) < ETH_HLEN)
+		skb_set_network_header(skb, ETH_HLEN);
 	skb_reset_mac_len(skb);
 
 	return 0;
-- 
1.9.1

