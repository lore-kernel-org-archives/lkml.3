Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634Ab3LFXgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:36:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48776 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3LFXSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 129/152] rt2x00: fix a crash bug in the HT descriptor handling fix
Date: Fri,  6 Dec 2013 15:10:53 -0800
Message-Id: <1386371476-2477-130-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit b4089d6d8e71a7293e2192025dfa507a04f661c4 upstream.

Commit "rt2x00: fix HT TX descriptor settings regression"
assumes that the control parameter to rt2x00mac_tx is always non-NULL.
There is an internal call in rt2x00lib_bc_buffer_iter where NULL is
passed. Fix the resulting crash by adding an initialized dummy on-stack
ieee80211_tx_control struct.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index cdbfc30..a1789f5 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -181,6 +181,7 @@ static void rt2x00lib_autowakeup(struct work_struct *work)
 static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
+	struct ieee80211_tx_control control = {};
 	struct rt2x00_dev *rt2x00dev = data;
 	struct sk_buff *skb;
 
@@ -195,7 +196,7 @@ static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
 	 */
 	skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
 	while (skb) {
-		rt2x00mac_tx(rt2x00dev->hw, NULL, skb);
+		rt2x00mac_tx(rt2x00dev->hw, &control, skb);
 		skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
 	}
 }
-- 
1.8.3.2

