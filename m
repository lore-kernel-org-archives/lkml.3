Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab3BZX6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933059Ab3BZX6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cong Wang <amwang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Gross <jesse@nicira.com>
Subject: [ 136/150] vlan: adjust vlan_set_encap_proto() for its callers
Date: Tue, 26 Feb 2013 15:56:33 -0800
Message-Id: <20130226235538.457554484@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Cong Wang <amwang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Gross <jesse@nicira.com>
Acked-by: Jesse Gross <jesse@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/if_vlan.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -331,7 +331,7 @@ static inline void vlan_set_encap_proto(
 					struct vlan_hdr *vhdr)
 {
 	__be16 proto;
-	unsigned char *rawp;
+	unsigned short *rawp;
 
 	/*
 	 * Was a VLAN packet, grab the encapsulated protocol, which the layer
@@ -344,8 +344,8 @@ static inline void vlan_set_encap_proto(
 		return;
 	}
 
-	rawp = skb->data;
-	if (*(unsigned short *) rawp == 0xFFFF)
+	rawp = (unsigned short *)(vhdr + 1);
+	if (*rawp == 0xFFFF)
 		/*
 		 * This is a magic hack to spot IPX packets. Older Novell
 		 * breaks the protocol design and runs IPX over 802.3 without


