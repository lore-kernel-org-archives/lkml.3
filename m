Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab3FQWGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 18:06:16 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:50086
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3FQWGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 18:06:15 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Jun 2013 18:06:15 EDT
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: [PATCH net] Fix the VLAN_TAG_PRESENT in netvsc_recv_callback()
Date: Mon, 17 Jun 2013 15:36:49 -0700
Message-Id: <1371508609-22780-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should call __vlan_hwaccel_put_tag() only if the packet
comes from vlan, otherwise VLAN_TAG_PRESENT will always be
added.

Reported-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/net/hyperv/netvsc_drv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index ab2307b..4dccead 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -285,7 +285,9 @@ int netvsc_recv_callback(struct hv_device *device_obj,
 
 	skb->protocol = eth_type_trans(skb, net);
 	skb->ip_summed = CHECKSUM_NONE;
-	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), packet->vlan_tci);
+	if (packet->vlan_tci & VLAN_TAG_PRESENT)
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+				       packet->vlan_tci);
 
 	net->stats.rx_packets++;
 	net->stats.rx_bytes += packet->total_data_buflen;
-- 
1.7.4.1

