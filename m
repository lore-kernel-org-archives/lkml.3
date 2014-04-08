Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbaDHSv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:51:56 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:51575
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408AbaDHSvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:51:52 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH net 3/3] Drivers: net: hyperv: Address UDP checksum issues
Date: Tue,  8 Apr 2014 12:46:11 -0700
Message-Id: <1396986371-12137-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1396986371-12137-1-git-send-email-kys@microsoft.com>
References: <1396986332-12098-1-git-send-email-kys@microsoft.com>
 <1396986371-12137-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ws2008r2 does not support UDP checksum offload. Thus, we cannnot turn on
UDP offload in the host. Also, on ws2012 and ws2012 r2, there appear to be
an issue with UDP checksum offload.
Fix this issue by computing the UDP checksum in the Hyper-V driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   |    1 +
 drivers/net/hyperv/netvsc_drv.c   |   19 ++++++++++++++++++-
 drivers/net/hyperv/rndis_filter.c |   12 +++++++++++-
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 13010b4..d18f711d 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -747,6 +747,7 @@ struct ndis_oject_header {
 #define NDIS_TCP_LARGE_SEND_OFFLOAD_IPV4	0
 #define NDIS_TCP_LARGE_SEND_OFFLOAD_IPV6	1
 
+#define VERSION_4_OFFLOAD_SIZE			22
 /*
  * New offload OIDs for NDIS 6
  */
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 6f39baa..8e3919b 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -398,7 +398,24 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 		csum_info->transmit.tcp_checksum = 1;
 		csum_info->transmit.tcp_header_offset = hdr_offset;
 	} else if (net_trans_info & INFO_UDP) {
-		csum_info->transmit.udp_checksum = 1;
+		/* UDP checksum offload is not supported on ws2008r2.
+		 * Furthermore, on ws2012 and ws2012r2, there are some
+		 * issues with udp checksum offload from Linux guests.
+		 * (these are host issues).
+		 * For now compute the checksum here.
+		 */
+		struct udphdr *uh = udp_hdr(skb);
+		u16 udp_len = ntohs(uh->len);
+
+		uh->check = 0;
+		uh->check = csum_tcpudp_magic(ip_hdr(skb)->saddr,
+					      ip_hdr(skb)->daddr,
+					      udp_len, IPPROTO_UDP,
+					      csum_partial(uh, udp_len, 0));
+		if (uh->check == 0)
+			uh->check = CSUM_MANGLED_0;
+
+		csum_info->transmit.udp_checksum = 0;
 	}
 	goto do_send;
 
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 4a37e3d..143a98c 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -641,6 +641,16 @@ int rndis_filter_set_offload_params(struct hv_device *hdev,
 	struct rndis_set_complete *set_complete;
 	u32 extlen = sizeof(struct ndis_offload_params);
 	int ret, t;
+	u32 vsp_version = nvdev->nvsp_version;
+
+	if (vsp_version <= NVSP_PROTOCOL_VERSION_4) {
+		extlen = VERSION_4_OFFLOAD_SIZE;
+		/* On NVSP_PROTOCOL_VERSION_4 and below, we do not support
+		 * UDP checksum offload.
+		 */
+		req_offloads->udp_ip_v4_csum = 0;
+		req_offloads->udp_ip_v6_csum = 0;
+	}
 
 	request = get_rndis_request(rdev, RNDIS_MSG_SET,
 		RNDIS_MESSAGE_SIZE(struct rndis_set_request) + extlen);
@@ -674,7 +684,7 @@ int rndis_filter_set_offload_params(struct hv_device *hdev,
 	} else {
 		set_complete = &request->response_msg.msg.set_complete;
 		if (set_complete->status != RNDIS_STATUS_SUCCESS) {
-			netdev_err(ndev, "Fail to set MAC on host side:0x%x\n",
+			netdev_err(ndev, "Fail to set offload on host side:0x%x\n",
 				   set_complete->status);
 			ret = -EINVAL;
 		}
-- 
1.7.4.1

