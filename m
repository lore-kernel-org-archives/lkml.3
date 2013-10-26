Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3JZUkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 16:40:42 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:51314 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3JZUki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 16:40:38 -0400
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, pali.rohar@gmail.com,
        David Gnedt <david.gnedt@davizone.at>
Subject: [PATCH 13/16] wl1251: enforce changed hw encryption support on monitor state change
Date: Sat, 26 Oct 2013 22:34:12 +0200
Message-Id: <1382819655-30430-14-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gnedt <david.gnedt@davizone.at>

The firmware doesn't support per packet encryption selection, so disable hw
encryption support completly while a monitor interface is present to support
injection of packets (which shouldn't get encrypted by hw).
To enforce the changed hw encryption support force a disassociation on
non-monitor interfaces.
For disassociation a workaround using hw connection monitor is employed,
which temporary enables hw connection manager flag.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
 drivers/net/wireless/ti/wl1251/main.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 174f403..f054741 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -685,6 +685,16 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 		wl->power_level = conf->power_level;
 	}
 
+	/*
+	 * Tell stack that connection is lost because hw encryption isn't
+	 * supported in monitor mode.
+	 * XXX This requires temporary enabling the hw connection monitor flag
+	 */
+	if ((changed & IEEE80211_CONF_CHANGE_MONITOR) && wl->vif) {
+		wl->hw->flags |= IEEE80211_HW_CONNECTION_MONITOR;
+		ieee80211_connection_loss(wl->vif);
+	}
+
 out_sleep:
 	wl1251_ps_elp_sleep(wl);
 
@@ -1116,6 +1126,9 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
+		/* XXX Disable temporary enabled hw connection monitor flag */
+		wl->hw->flags &= ~IEEE80211_HW_CONNECTION_MONITOR;
+
 		if (bss_conf->assoc) {
 			wl->beacon_int = bss_conf->beacon_int;
 
-- 
1.7.10.4

