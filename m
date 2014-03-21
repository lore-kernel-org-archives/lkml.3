Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbaCUADR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:03:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905AbaCUADJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 010/149] tun: remove bogus hardware vlan acceleration flags from vlan_features
Date: Thu, 20 Mar 2014 17:02:53 -0700
Message-Id: <20140321000437.300999969@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

[ Upstream commit 6671b2240c54585d4afb5286a29f1569fe5e40a8 ]

Even though only the outer vlan tag can be HW accelerated in the transmission
path, in the TUN/TAP driver vlan_features mirrors hw_features, which happens
to have the NETIF_F_HW_VLAN_?TAG_TX flags set. Because of this, during packet
tranmisssion through a stacked vlan device dev_hard_start_xmit, (incorrectly)
assuming that the vlan device supports hardware vlan acceleration, does not
add the vlan header to the skb payload and the inner vlan tags are lost
(vlan_tci contains the outer vlan tag when userspace reads the packet from
the tap device).

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1651,7 +1651,9 @@ static int tun_set_iff(struct net *net,
 				   TUN_USER_FEATURES | NETIF_F_HW_VLAN_CTAG_TX |
 				   NETIF_F_HW_VLAN_STAG_TX;
 		dev->features = dev->hw_features;
-		dev->vlan_features = dev->features;
+		dev->vlan_features = dev->features &
+				     ~(NETIF_F_HW_VLAN_CTAG_TX |
+				       NETIF_F_HW_VLAN_STAG_TX);
 
 		INIT_LIST_HEAD(&tun->disabled);
 		err = tun_attach(tun, file, false);


