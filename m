Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab3EQV4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:56:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab3EQVu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Drake <dsd@laptop.org>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 13/33] mwifiex: fix setting of multicast filter
Date: Fri, 17 May 2013 14:49:57 -0700
Message-Id: <20130517214918.255347423@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -100,7 +100,7 @@ int mwifiex_request_set_multicast_list(s
 	} else {
 		/* Multicast */
 		priv->curr_pkt_filter &= ~HostCmd_ACT_MAC_PROMISCUOUS_ENABLE;
-		if (mcast_list->mode == MWIFIEX_MULTICAST_MODE) {
+		if (mcast_list->mode == MWIFIEX_ALL_MULTI_MODE) {
 			dev_dbg(priv->adapter->dev,
 				"info: Enabling All Multicast!\n");
 			priv->curr_pkt_filter |=
@@ -112,20 +112,11 @@ int mwifiex_request_set_multicast_list(s
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


