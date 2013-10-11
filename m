Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab3JKKo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:44:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58830 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3JKKoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Drake <dsd@laptop.org>, "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 095/100] mwifiex: fix memory corruption when unsetting multicast list
Date: Fri, 11 Oct 2013 11:42:05 +0100
Message-Id: <1381488130-30235-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/main.c      |  5 ++---
 drivers/net/wireless/mwifiex/sta_ioctl.c | 18 ++++++++----------
 2 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 4be4d43..20e50e5 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -571,9 +571,8 @@ static void mwifiex_set_multicast_list(struct net_device *dev)
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
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index fc6ae9b..2ea3a20 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -113,16 +113,14 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
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
-- 
1.8.3.2

