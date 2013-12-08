Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161003Ab3LHJ3F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:29:05 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:60911 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3LHJ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:27:32 -0500
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
Subject: [PATCH v2 12/16] wl1251: enforce changed hw encryption support on monitor state change
Date: Sun,  8 Dec 2013 10:25:10 +0100
Message-Id: <1386494714-21070-13-git-send-email-pali.rohar@gmail.com>
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

The firmware doesn't support per packet encryption selection, so disable hw
encryption support completely while a monitor interface is present to support
injection of packets (which shouldn't get encrypted by hw).
To enforce the changed hw encryption support force a disassociation on
non-monitor interfaces.
For disassociation a workaround using hw connection monitor is employed,
which temporary enables hw connection manager flag.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index bb6e873..1ef264c 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -688,6 +688,16 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		wl->power_level = conf->power_level;
 	}
 
+	/*
+	 * Tell stack that connection is lost because hw encryption isn't
+	 * supported in monitor mode.
+	 * This requires temporary enabling of the hw connection monitor flag
+	 */
+	if ((changed & IEEE80211_CONF_CHANGE_MONITOR) && wl->vif) {
+		wl->hw->flags |= IEEE80211_HW_CONNECTION_MONITOR;
+		ieee80211_connection_loss(wl->vif);
+	}
+
 out_sleep:
 	wl1251_ps_elp_sleep(wl);
 
@@ -1120,6 +1130,9 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
+		/* Disable temporary enabled hw connection monitor flag */
+		wl->hw->flags &= ~IEEE80211_HW_CONNECTION_MONITOR;
+
 		if (bss_conf->assoc) {
 			wl->beacon_int = bss_conf->beacon_int;
 
-- 
1.7.9.5

