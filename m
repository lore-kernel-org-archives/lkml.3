Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3BQWzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45661 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119Ab3BQWzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:19 -0500
Message-Id: <20130217225002.974821217@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:12 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Bing Zhao <bzhao@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 11/66] mwifiex: fix incomplete scan in case of IE parsing error
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/scan.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1594,7 +1594,7 @@ int mwifiex_ret_802_11_scan(struct mwifi
 		dev_err(adapter->dev, "SCAN_RESP: too many AP returned (%d)\n",
 		       scan_rsp->number_of_sets);
 		ret = -1;
-		goto done;
+		goto check_next_scan;
 	}
 
 	bytes_left = le16_to_cpu(scan_rsp->bss_descript_size);
@@ -1663,7 +1663,8 @@ int mwifiex_ret_802_11_scan(struct mwifi
 		if (!beacon_size || beacon_size > bytes_left) {
 			bss_info += bytes_left;
 			bytes_left = 0;
-			return -1;
+			ret = -1;
+			goto check_next_scan;
 		}
 
 		/* Initialize the current working beacon pointer for this BSS
@@ -1716,7 +1717,7 @@ int mwifiex_ret_802_11_scan(struct mwifi
 				dev_err(priv->adapter->dev, "%s: in processing"
 					" IE, bytes left < IE length\n",
 					__func__);
-				goto done;
+				goto check_next_scan;
 			}
 			if (element_id == WLAN_EID_DS_PARAMS) {
 				channel = *(u8 *) (current_ptr +
@@ -1782,6 +1783,7 @@ int mwifiex_ret_802_11_scan(struct mwifi
 		}
 	}
 
+check_next_scan:
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	if (list_empty(&adapter->scan_pending_q)) {
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
@@ -1812,7 +1814,6 @@ int mwifiex_ret_802_11_scan(struct mwifi
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
 	}
 
-done:
 	return ret;
 }
 


