Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaJMC0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:26:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbaJMC0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yulong Pei <ypei@redhat.com>, Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 11/37] openvswitch: fix panic with multiple vlan headers
Date: Mon, 13 Oct 2014 04:24:08 +0200
Message-Id: <20141013022400.770743473@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/actions.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -42,6 +42,9 @@ static int do_execute_actions(struct dat
 
 static int make_writable(struct sk_buff *skb, int write_len)
 {
+	if (!pskb_may_pull(skb, write_len))
+		return -ENOMEM;
+
 	if (!skb_cloned(skb) || skb_clone_writable(skb, write_len))
 		return 0;
 
@@ -70,6 +73,8 @@ static int __pop_vlan_tci(struct sk_buff
 
 	vlan_set_encap_proto(skb, vhdr);
 	skb->mac_header += VLAN_HLEN;
+	if (skb_network_offset(skb) < ETH_HLEN)
+		skb_set_network_header(skb, ETH_HLEN);
 	skb_reset_mac_len(skb);
 
 	return 0;


