Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab3BGNJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:09:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758369Ab3BGNJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:09:17 -0500
Date: Thu, 7 Feb 2013 15:13:22 +0200
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
Subject: [PATCHv2-net-3.8 3/3] bnx2x: set gso_type
Message-ID: <b9413cd3577c7b544cd522a6eb8ae6b037b20da6.1360236441.git.mst@redhat.com>
References: <cover.1360236441.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1360236441.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In LRO mode, bnx2x set gso_size but not gso type.
This leads to crashes in macvtap.
Commit cbf1de72324a8105ddcc3d9ce9acbc613faea17e
queued for 3.9 includes a more complete fix.
This is a minimal patch to avoid the crash, for 3.8.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index f771ddf..a5edac8 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -504,13 +504,11 @@ static int bnx2x_fill_frag_skb(struct bnx2x *bp, struct bnx2x_fastpath *fp,
 		skb_shinfo(skb)->gso_size = bnx2x_set_lro_mss(bp,
 					tpa_info->parsing_flags, len_on_bd);
 
-		/* set for GRO */
-		if (fp->mode == TPA_MODE_GRO)
-			skb_shinfo(skb)->gso_type =
-			    (GET_FLAG(tpa_info->parsing_flags,
-				      PARSING_FLAGS_OVER_ETHERNET_PROTOCOL) ==
-						PRS_FLAG_OVERETH_IPV6) ?
-				SKB_GSO_TCPV6 : SKB_GSO_TCPV4;
+		skb_shinfo(skb)->gso_type =
+			(GET_FLAG(tpa_info->parsing_flags,
+				  PARSING_FLAGS_OVER_ETHERNET_PROTOCOL) ==
+			 PRS_FLAG_OVERETH_IPV6) ?
+			SKB_GSO_TCPV6 : SKB_GSO_TCPV4;
 	}
 
 
-- 
MST
