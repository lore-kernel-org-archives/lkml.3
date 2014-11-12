Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbaKLVAP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 16:00:15 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:51317
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbaKLVAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 16:00:13 -0500
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next,v2] hyperv: Add processing of MTU reduced by the host
Date: Wed, 12 Nov 2014 14:07:44 -0800
Message-Id: <1415830064-1440-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the host uses packet encapsulation feature, the MTU may be reduced by the
host due to headroom reservation for encapsulation. This patch handles this
new MTU value.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc.c       |    3 ++-
 drivers/net/hyperv/netvsc_drv.c   |    5 +++--
 drivers/net/hyperv/rndis_filter.c |    9 +++++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 7d76c95..6b46311 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -440,7 +440,8 @@ static int negotiate_nvsp_ver(struct hv_device *device,
 	/* NVSPv2 only: Send NDIS config */
 	memset(init_packet, 0, sizeof(struct nvsp_message));
 	init_packet->hdr.msg_type = NVSP_MSG2_TYPE_SEND_NDIS_CONFIG;
-	init_packet->msg.v2_msg.send_ndis_config.mtu = net_device->ndev->mtu;
+	init_packet->msg.v2_msg.send_ndis_config.mtu = net_device->ndev->mtu +
+						       ETH_HLEN;
 	init_packet->msg.v2_msg.send_ndis_config.capability.ieee8021q = 1;
 
 	ret = vmbus_sendpacket(device->channel, init_packet,
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 3295e4e..15d82ed 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -699,9 +699,10 @@ static int netvsc_change_mtu(struct net_device *ndev, int mtu)
 		return -ENODEV;
 
 	if (nvdev->nvsp_version >= NVSP_PROTOCOL_VERSION_2)
-		limit = NETVSC_MTU;
+		limit = NETVSC_MTU - ETH_HLEN;
 
-	if (mtu < 68 || mtu > limit)
+	/* Hyper-V hosts don't support MTU < ETH_DATA_LEN (1500) */
+	if (mtu < ETH_DATA_LEN || mtu > limit)
 		return -EINVAL;
 
 	nvdev->start_remove = true;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index ccce6f2..7b2c5d1 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -998,6 +998,7 @@ int rndis_filter_device_add(struct hv_device *dev,
 	int t;
 	struct ndis_recv_scale_cap rsscap;
 	u32 rsscap_size = sizeof(struct ndis_recv_scale_cap);
+	u32 mtu, size;
 
 	rndis_device = get_rndis_device();
 	if (!rndis_device)
@@ -1029,6 +1030,14 @@ int rndis_filter_device_add(struct hv_device *dev,
 		return ret;
 	}
 
+	/* Get the MTU from the host */
+	size = sizeof(u32);
+	ret = rndis_filter_query_device(rndis_device,
+					RNDIS_OID_GEN_MAXIMUM_FRAME_SIZE,
+					&mtu, &size);
+	if (ret == 0 && size == sizeof(u32))
+		net_device->ndev->mtu = mtu;
+
 	/* Get the mac address */
 	ret = rndis_filter_query_device_mac(rndis_device);
 	if (ret != 0) {
-- 
1.7.1

