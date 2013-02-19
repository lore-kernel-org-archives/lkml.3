Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934020Ab3BSSvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:51:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54224 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934004Ab3BSSvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:51:13 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 19/81] mwifiex: fix incomplete scan in case of IE parsing error
Date: Tue, 19 Feb 2013 15:48:42 -0300
Message-Id: <1361299784-8830-20-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 8a7d7cbf7b5ff9912ef50b3e94c9ad9f37b1c75f upstream.

A scan request is split into multiple scan commands queued in
scan_pending_q. Each scan command will be sent to firmware and
its response is handlded one after another.

If any error is detected while parsing IE in command response
buffer the remaining data will be ignored and error is returned.

We should check if there is any more scan commands pending in
the queue before returning error. This ensures that we will call
cfg80211_scan_done if this is the last scan command, or send
next scan command in scan_pending_q to firmware.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/mwifiex/scan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 74f0457..9ca1b9c 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1553,7 +1553,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		dev_err(adapter->dev, "SCAN_RESP: too many AP returned (%d)\n",
 			scan_rsp->number_of_sets);
 		ret = -1;
-		goto done;
+		goto check_next_scan;
 	}
 
 	bytes_left = le16_to_cpu(scan_rsp->bss_descript_size);
@@ -1624,7 +1624,8 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		if (!beacon_size || beacon_size > bytes_left) {
 			bss_info += bytes_left;
 			bytes_left = 0;
-			return -1;
+			ret = -1;
+			goto check_next_scan;
 		}
 
 		/* Initialize the current working beacon pointer for this BSS
@@ -1680,7 +1681,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 				dev_err(priv->adapter->dev,
 					"%s: bytes left < IE length\n",
 					__func__);
-				goto done;
+				goto check_next_scan;
 			}
 			if (element_id == WLAN_EID_DS_PARAMS) {
 				channel = *(u8 *) (current_ptr +
@@ -1744,6 +1745,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		}
 	}
 
+check_next_scan:
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	if (list_empty(&adapter->scan_pending_q)) {
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
@@ -1782,7 +1784,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
 	}
 
-done:
 	return ret;
 }
 
-- 
1.7.9.5

