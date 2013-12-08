Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab3LHJ2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:28:38 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:44405 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab3LHJ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:27:28 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 09/16] wl1251: fix channel switching in monitor mode
Date: Sun,  8 Dec 2013 10:25:07 +0100
Message-Id: <1386494714-21070-10-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gnedt <david.gnedt@davizone.at>

Use the ENABLE_RX command for channel switching when no interface is present
(monitor mode only).
The advantage of ENABLE_RX is that it leaves the tx data path disabled in
firmware, whereas the usual JOIN command seems to transmit some frames at
firmware level.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 1223bc6..b6f11b8 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -616,8 +616,19 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (channel != wl->channel) {
 		wl->channel = channel;
 
-		ret = wl1251_join(wl, wl->bss_type, wl->channel,
-				  wl->beacon_int, wl->dtim_period);
+		/*
+		 * Use ENABLE_RX command for channel switching when no
+		 * interface is present (monitor mode only).
+		 * This leaves the tx path disabled in firmware, whereas
+		 * the usual JOIN command seems to transmit some frames
+		 * at firmware level.
+		 */
+		if (wl->vif == NULL) {
+			ret = wl1251_cmd_data_path_rx(wl, wl->channel, 1);
+		} else {
+			ret = wl1251_join(wl, wl->bss_type, wl->channel,
+					  wl->beacon_int, wl->dtim_period);
+		}
 		if (ret < 0)
 			goto out_sleep;
 	}
-- 
1.7.9.5

