Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab3ETLFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:05:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56264 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3ETKxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Drake <dsd@laptop.org>, "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 073/115] mwifiex: fix setting of multicast filter
Date: Mon, 20 May 2013 11:51:13 +0100
Message-Id: <1369047116-9378-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit ccd384b10420ac81ba3fb9b0a7d18272c7173552 upstream.

A small bug in this code was causing the ALLMULTI filter to be set
when in fact we were just wanting to program a selective multicast list
to the hardware.

Fix that bug and remove a redundant if condition in the code that
follows.

This fixes wakeup behaviour when multicast WOL is enabled. Previously,
all multicast packets would wake up the system. Now, only those that the
host intended to receive trigger wakeups.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index a5db9f1a..fc6ae9b 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -105,7 +105,7 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 	} else {
 		/* Multicast */
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
-		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
+		if (mcast_list->mode == MWIFIEX_ALL_MULTI_MODE) {
 			dev_dbg(priv->adapter->dev,
 				"info: Enabling All Multicast!\n");
 			priv->curr_pkt_filter |=
@@ -117,20 +117,11 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
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
1.8.1.2

