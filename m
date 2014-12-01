Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbaLAUTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:19:09 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:50055
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932196AbaLAUTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:19:07 -0500
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next] hyperv: Add support for vNIC hot removal
Date: Mon,  1 Dec 2014 13:28:39 -0800
Message-Id: <1417469319-7356-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper handling of the vNIC hot removal event, which includes
a rescind-channel-offer message from the host side that triggers vNIC close and
removal. In this case, the notices to the host during close and removal is not
necessary because the channel is rescinded. This patch blocks these unnecessary 
messages, and lets vNIC removal process complete normally.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel_mgmt.c         |    2 ++
 drivers/net/hyperv/netvsc.c       |    3 +++
 drivers/net/hyperv/rndis_filter.c |    3 +++
 include/linux/hyperv.h            |    2 ++
 4 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index a2d1a96..191a6a3 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -517,6 +517,8 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 		/* Just return here, no channel found */
 		return;
 
+	channel->rescind = true;
+
 	/* work is initialized for vmbus_process_rescind_offer() from
 	 * vmbus_process_offer() where the channel got created */
 	queue_work(channel->controlwq, &channel->work);
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 6fc834e..dd867e6 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -764,6 +764,9 @@ int netvsc_send(struct hv_device *device,
 		out_channel = device->channel;
 	packet->channel = out_channel;
 
+	if (out_channel->rescind)
+		return -ENODEV;
+
 	if (packet->page_buf_cnt) {
 		ret = vmbus_sendpacket_pagebuffer(out_channel,
 						  packet->page_buf,
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 7b2c5d1..ec0c40a 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -958,6 +958,9 @@ static int rndis_filter_close_device(struct rndis_device *dev)
 		return 0;
 
 	ret = rndis_filter_set_packet_filter(dev, 0);
+	if (ret == -ENODEV)
+		ret = 0;
+
 	if (ret == 0)
 		dev->state = RNDIS_DEV_INITIALIZED;
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 08cfaff..476c685 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -650,6 +650,8 @@ struct vmbus_channel {
 	u8 monitor_grp;
 	u8 monitor_bit;
 
+	bool rescind; /* got rescind msg */
+
 	u32 ringbuffer_gpadlhandle;
 
 	/* Allocated memory for ring buffer */
-- 
1.7.1

