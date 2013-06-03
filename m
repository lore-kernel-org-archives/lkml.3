Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504Ab3FCWTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:19:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab3FCWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:15 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RBhR3_ey-McA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=54Z1rsfS-xYA:10 a=Op-mwl0xAAAA:8 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8 a=vmLDa1wCAAAA:8 a=KmqCZUEVAza2QQZapJAA:9 a=d4CUUju0HPYA:10 a=9RRF0ttvEvMA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221156.305216649@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Drake <dsd@laptop.org>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [24/65] mwifiex: fix setting of multicast filter
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0024-mwifiex-fix-setting-of-multicast-filter.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

[ Upstream commit ccd384b10420ac81ba3fb9b0a7d18272c7173552 ]

A small bug in this code was causing the ALLMULTI filter to be set
when in fact we were just wanting to program a selective multicast list
to the hardware.

Fix that bug and remove a redundant if condition in the code that
follows.

This fixes wakeup behaviour when multicast WOL is enabled. Previously,
all multicast packets would wake up the system. Now, only those that the
host intended to receive trigger wakeups.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Cc: <stable@vger.kernel.org>
Acked-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index fb21360..667598e 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -106,7 +106,7 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	} else {
 		/* Multicast */
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
-		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
+		if (mcast_list->mode == MWIFIEX_ALL_MULTI_MODE) {
 			dev_dbg(priv->adapter->dev,
 				"info: Enabling All Multicast!\n");
 			priv->curr_pkt_filter |=
@@ -118,20 +118,11 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 				dev_dbg(priv->adapter->dev,
 					"info: Set multicast list=%d\n",
 				       mcast_list->num_multicast_addr);
-				/* Set multicast addresses to firmware */
-				if (old_pkt_filter == priv->curr_pkt_filter) {
-					/* Send request to firmware */
-					ret = mwifiex_send_cmd_async(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET, 0,
-						mcast_list);
-				} else {
-					/* Send request to firmware */
-					ret = mwifiex_send_cmd_async(priv,
-						HostCmd_CMD_MAC_MULTICAST_ADR,
-						HostCmd_ACT_GEN_SET, 0,
-						mcast_list);
-				}
+				/* Send multicast addresses to firmware */
+				ret = mwifiex_send_cmd_async(priv,
+					HostCmd_CMD_MAC_MULTICAST_ADR,
+					HostCmd_ACT_GEN_SET, 0,
+					mcast_list);
 			}
 		}
 	}
-- 
1.7.10.4


