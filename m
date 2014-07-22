Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaGVWYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:24:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44563 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbaGVWYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:24:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 104/116] b43: fix frequency reported on G-PHY with /new/ firmware
Date: Tue, 22 Jul 2014 15:21:55 -0700
Message-Id: <1406067727-19683-105-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/b43/xmit.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index e85d34b..ebcce00 100644
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
1.9.1

