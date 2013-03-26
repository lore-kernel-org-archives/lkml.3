Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab3CZRuG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:50:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3CZRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:19 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3c1krPLN0WoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=xDdocfs2hmQA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=VPS0CfSAAAAA:8 a=rkWN_4n9J8LXjtNkltUA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=Hb87az3203AA:10 a=ek6Pf8U5snHA40KO:21 a=UsMzzgWe9do79yT_:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173607.156044905@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Jesse Gross <jesse@nicira.com>,
        Cong Wang <amwang@redhat.com>
Subject: [PATCH 45/86] vlan: adjust vlan_set_encap_proto() for its callers
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0045-vlan-adjust-vlan_set_encap_proto-for-its-callers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit da8c87241c26aac81a64c7e4d21d438a33018f4e ]

There are two places to call vlan_set_encap_proto():
vlan_untag() and __pop_vlan_tci().

vlan_untag() assumes skb->data points after mac addr, otherwise
the following code

        vhdr = (struct vlan_hdr *) skb->data;
        vlan_tci = ntohs(vhdr->h_vlan_TCI);
        __vlan_hwaccel_put_tag(skb, vlan_tci);

        skb_pull_rcsum(skb, VLAN_HLEN);

won't be correct. But __pop_vlan_tci() assumes points _before_
mac addr.

In vlan_set_encap_proto(), it looks for some magic L2 value
after mac addr:

        rawp = skb->data;
        if (*(unsigned short *) rawp == 0xFFFF)
	...

Therefore __pop_vlan_tci() is obviously wrong.

A quick fix is avoiding using skb->data in vlan_set_encap_proto(),
use 'vhdr+1' is always correct in both cases.

Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Gross <jesse@nicira.com>
Signed-off-by: Cong Wang <amwang@redhat.com>
Acked-by: Jesse Gross <jesse@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/linux/if_vlan.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 561e130..9b0c614 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -327,7 +327,7 @@ static inline void vlan_set_encap_proto(struct sk_buff *skb,
 					struct vlan_hdr *vhdr)
 {
 	__be16 proto;
-	unsigned char *rawp;
+	unsigned short *rawp;
 
 	/*
 	 * Was a VLAN packet, grab the encapsulated protocol, which the layer
@@ -340,8 +340,8 @@ static inline void vlan_set_encap_proto(struct sk_buff *skb,
 		return;
 	}
 
-	rawp = skb->data;
-	if (*(unsigned short *) rawp == 0xFFFF)
+	rawp = (unsigned short *)(vhdr + 1);
+	if (*rawp == 0xFFFF)
 		/*
 		 * This is a magic hack to spot IPX packets. Older Novell
 		 * breaks the protocol design and runs IPX over 802.3 without
-- 
1.7.10.4


