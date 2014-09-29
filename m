Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaI2ERd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:17:33 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:39451
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaI2ERc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:17:32 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH net 1/1 V2] hyperv: Fix a bug in netvsc_start_xmit()
Date: Sun, 28 Sep 2014 22:16:43 -0700
Message-Id: <1411967803-29233-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the packet is successfully sent, we should not touch the skb 
as it may have been freed. This patch is based on the work done by 
Long Li <longli@microsoft.com>.

In this version of the patch I have fixed issues pointed out by David.
David, please queue this up for stable.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Long Li <longli@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index a9c5eaa..0fcb5e7 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -387,6 +387,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	int  hdr_offset;
 	u32 net_trans_info;
 	u32 hash;
+	u32 skb_length = skb->len;
 
 
 	/* We will atmost need two pages to describe the rndis
@@ -562,7 +563,7 @@ do_send:
 
 drop:
 	if (ret == 0) {
-		net->stats.tx_bytes += skb->len;
+		net->stats.tx_bytes += skb_length;
 		net->stats.tx_packets++;
 	} else {
 		kfree(packet);
-- 
1.7.4.1

