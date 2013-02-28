Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab3B1Ovn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:51:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42587 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab3B1Ovb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>, Jesse Gross <jesse@nicira.com>,
        Cong Wang <amwang@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 136/139] vlan: adjust vlan_set_encap_proto() for its callers
Date: Thu, 28 Feb 2013 14:44:46 +0000
Message-Id: <1362062689-2567-137-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

commit da8c87241c26aac81a64c7e4d21d438a33018f4e upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/if_vlan.h | 6 +++---
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
1.8.1.2

