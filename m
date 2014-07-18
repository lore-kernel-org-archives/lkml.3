Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030739AbaGRN24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:28:56 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17864 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935107AbaGRNQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:16:06 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 106/170] b43: fix frequency reported on G-PHY with /new/ firmware
Date: Fri, 18 Jul 2014 14:11:51 +0200
Message-Id: <c8708e6036357a1bd85fc25be12096609ab04891.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafał Miłecki <zajec5@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2fc68eb122c7ea6cd5be1fe7d6650c0beb2f4f40 upstream.

Support for firmware rev 508+ was added years ago, but we never noticed
it reports channel in a different way for G-PHY devices. Instead of
offset from 2400 MHz it simply passes channel id (AKA hw_value).

So far it was (most probably) affecting monitor mode users only, but
the following recent commit made it noticeable for quite everybody:

commit 3afc2167f60a327a2c1e1e2600ef209a3c2b75b7
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Tue Mar 4 16:50:13 2014 +0200

    cfg80211/mac80211: ignore signal if the frame was heard on wrong channel

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/b43/xmit.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index e85d34b76039..ebcce00ce067 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -810,9 +810,13 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
 		break;
 	case B43_PHYTYPE_G:
 		status.band = IEEE80211_BAND_2GHZ;
-		/* chanid is the radio channel cookie value as used
-		 * to tune the radio. */
-		status.freq = chanid + 2400;
+		/* Somewhere between 478.104 and 508.1084 firmware for G-PHY
+		 * has been modified to be compatible with N-PHY and others.
+		 */
+		if (dev->fw.rev >= 508)
+			status.freq = ieee80211_channel_to_frequency(chanid, status.band);
+		else
+			status.freq = chanid + 2400;
 		break;
 	case B43_PHYTYPE_N:
 	case B43_PHYTYPE_LP:
-- 
2.0.0

