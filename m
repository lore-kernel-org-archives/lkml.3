Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab3JKUua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:50:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab3JKTje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:39:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Drake <dsd@laptop.org>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 001/110] mwifiex: fix memory corruption when unsetting multicast list
Date: Fri, 11 Oct 2013 12:37:41 -0700
Message-Id: <20131011193807.761429386@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit 6390d88529835a8ad3563fe01a5da89fa52d6db2 upstream.

When trying to unset a previously-set multicast list (i.e. the new list
has 0 entries), mwifiex_set_multicast_list() was calling down to
mwifiex_request_set_multicast_list() while leaving
mcast_list.num_multicast_addr as an uninitialized value.

We were arriving at mwifiex_cmd_mac_multicast_adr() which would then
proceed to do an often huge memcpy of
mcast_list.num_multicast_addr*ETH_ALEN bytes, causing memory corruption
and hard to debug crashes.

Fix this by setting mcast_list.num_multicast_addr to 0 when no multicast
list is provided. Similarly, fix up the logic in
mwifiex_request_set_multicast_list() to unset the multicast list that
was previously sent to the hardware in such cases.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/main.c      |    5 ++---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   18 ++++++++----------
 2 files changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -559,9 +559,8 @@ static void mwifiex_set_multicast_list(s
 		mcast_list.mode = MWIFIEX_ALL_MULTI_MODE;
 	} else {
 		mcast_list.mode = MWIFIEX_MULTICAST_MODE;
-		if (netdev_mc_count(dev))
-			mcast_list.num_multicast_addr =
-				mwifiex_copy_mcast_addr(&mcast_list, dev);
+		mcast_list.num_multicast_addr =
+			mwifiex_copy_mcast_addr(&mcast_list, dev);
 	}
 	mwifiex_request_set_multicast_list(priv, &mcast_list);
 }
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -104,16 +104,14 @@ int mwifiex_request_set_multicast_list(s
 		} else {
 			priv->curr_pkt_filter &=
 				~HostCmd_ACT_MAC_ALL_MULTICAST_ENABLE;
-			if (mcast_list->num_multicast_addr) {
-				dev_dbg(priv->adapter->dev,
-					"info: Set multicast list=%d\n",
-				       mcast_list->num_multicast_addr);
-				/* Send multicast addresses to firmware */
-				ret = mwifiex_send_cmd_async(priv,
-					HostCmd_CMD_MAC_MULTICAST_ADR,
-					HostCmd_ACT_GEN_SET, 0,
-					mcast_list);
-			}
+			dev_dbg(priv->adapter->dev,
+				"info: Set multicast list=%d\n",
+				mcast_list->num_multicast_addr);
+			/* Send multicast addresses to firmware */
+			ret = mwifiex_send_cmd_async(priv,
+				HostCmd_CMD_MAC_MULTICAST_ADR,
+				HostCmd_ACT_GEN_SET, 0,
+				mcast_list);
 		}
 	}
 	dev_dbg(priv->adapter->dev,


