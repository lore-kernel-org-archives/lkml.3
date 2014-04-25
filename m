Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaDYRto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:49:44 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57817
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754106AbaDYRtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:49:41 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@kernel.org
Subject: [PATCH net-next 1/1]  hyperv: Properly handle checksum offload
Date: Fri, 25 Apr 2014 11:45:14 -0700
Message-Id: <1398451514-25593-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do checksum offload only if the client of the driver wants checksum to be
offloaded. Also Windows hosts support ip header checksum offload as well -
take advantage of that.

This patch fixes a bug that is exposed in gateway scenarios.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Cc: stable@kernel.org
---
 drivers/net/hyperv/netvsc_drv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 939e3af..706b341 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -467,6 +467,9 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	if (skb_is_gso(skb))
 		goto do_lso;
 
+	if (skb->ip_summed != CHECKSUM_PARTIAL)
+		goto do_send;
+
 	rndis_msg_size += NDIS_CSUM_PPI_SIZE;
 	ppi = init_ppi_data(rndis_msg, NDIS_CSUM_PPI_SIZE,
 			    TCPIP_CHKSUM_PKTINFO);
@@ -474,6 +477,9 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	csum_info = (struct ndis_tcp_ip_checksum_info *)((void *)ppi +
 			ppi->ppi_offset);
 
+	ip_hdr(skb)->check = 0;
+	csum_info->transmit.ip_header_checksum = 1;
+
 	if (net_trans_info & (INFO_IPV4 << 16))
 		csum_info->transmit.is_ipv4 = 1;
 	else
-- 
1.7.4.1

