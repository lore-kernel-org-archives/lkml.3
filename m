Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3BGNJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:09:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413Ab3BGNJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:09:36 -0500
Date: Thu, 7 Feb 2013 15:13:13 +0200
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
Subject: [PATCHv2-net-3.8 2/3] qlcnic: set gso_type
Message-ID: <50a60e1293901965901edb46ae49e52da1d469d5.1360236441.git.mst@redhat.com>
References: <cover.1360236441.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1360236441.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qlcnic set gso_size but not gso type. This leads to crashes
in macvtap.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 6f82812..09aa310 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -986,8 +986,13 @@ qlcnic_process_lro(struct qlcnic_adapter *adapter,
 	th->seq = htonl(seq_number);
 	length = skb->len;
 
-	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP)
+	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP) {
 		skb_shinfo(skb)->gso_size = qlcnic_get_lro_sts_mss(sts_data1);
+		if (skb->protocol == htons(ETH_P_IPV6))
+			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
+		else
+			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
+	}
 
 	if (vid != 0xffff)
 		__vlan_hwaccel_put_tag(skb, vid);
-- 
MST

