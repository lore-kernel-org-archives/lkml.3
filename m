Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaANA1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:27:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaANA1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 37/62] net: Loosen constraints for recalculating checksum in skb_segment()
Date: Mon, 13 Jan 2014 16:27:02 -0800
Message-Id: <20140114002711.518466117@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@verge.net.au>

[ Upstream commit 1cdbcb7957cf9e5f841dbcde9b38fd18a804208b ]

This is a generic solution to resolve a specific problem that I have observed.

If the encapsulation of an skb changes then ability to offload checksums
may also change. In particular it may be necessary to perform checksumming
in software.

An example of such a case is where a non-GRE packet is received but
is to be encapsulated and transmitted as GRE.

Another example relates to my proposed support for for packets
that are non-MPLS when received but MPLS when transmitted.

The cost of this change is that the value of the csum variable may be
checked when it previously was not. In the case where the csum variable is
true this is pure overhead. In the case where the csum variable is false it
leads to software checksumming, which I believe also leads to correct
checksums in transmitted packets for the cases described above.

Further analysis:

This patch relies on the return value of can_checksum_protocol()
being correct and in turn the return value of skb_network_protocol(),
used to provide the protocol parameter of can_checksum_protocol(),
being correct. It also relies on the features passed to skb_segment()
and in turn to can_checksum_protocol() being correct.

I believe that this problem has not been observed for VLANs because it
appears that almost all drivers, the exception being xgbe, set
vlan_features such that that the checksum offload support for VLAN packets
is greater than or equal to that of non-VLAN packets.

I wonder if the code in xgbe may be an oversight and the hardware does
support checksumming of VLAN packets.  If so it may be worth updating the
vlan_features of the driver as this patch will force such checksums to be
performed in software rather than hardware.

Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2854,7 +2854,7 @@ struct sk_buff *skb_segment(struct sk_bu
 						 doffset + tnl_hlen);
 
 		if (fskb != skb_shinfo(skb)->frag_list)
-			continue;
+			goto perform_csum_check;
 
 		if (!sg) {
 			nskb->ip_summed = CHECKSUM_NONE;
@@ -2918,6 +2918,7 @@ skip_fraglist:
 		nskb->len += nskb->data_len;
 		nskb->truesize += nskb->data_len;
 
+perform_csum_check:
 		if (!csum) {
 			nskb->csum = skb_checksum(nskb, doffset,
 						  nskb->len - doffset, 0);


