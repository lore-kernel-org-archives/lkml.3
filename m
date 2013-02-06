Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280Ab3BFW7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:59:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3BFW6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:58:55 -0500
Date: Thu, 7 Feb 2013 01:02:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org
Cc: Eilon Greenstein <eilong@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, linux-driver@qlogic.com,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, bhutchings@solarflare.com,
        eric.dumazet@gmail.com
Subject: [PATCH 2/2] qlcnic: set gso_type
Message-ID: <f262d9330d22447ed8fd487ad7b28d668efbf333.1360191528.git.mst@redhat.com>
References: <cover.1360191528.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1360191528.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qlcnic set gso_size but not gso type. This leads to crashes
in macvtap.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
This one I only compiled - don't have qlogic hardware.

 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index bb4311e..370049c 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -1043,8 +1043,13 @@ qlcnic_process_lro(struct qlcnic_adapter *adapter,
 	th->seq = htonl(seq_number);
 	length = skb->len;
 
-	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP)
+	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP) {
 		skb_shinfo(skb)->gso_size = qlcnic_get_lro_sts_mss(sts_data1);
+		if (skb->protocol == ETH_P_IPV6)
+			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
+		else
+			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
+	}
 
 	if (vid != 0xffff)
 		__vlan_hwaccel_put_tag(skb, vid);
-- 
MST
