Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530Ab3FCWTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:19:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30104 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758878Ab3FCWMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:12 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=QFGbgjh4F0sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Et1R_80RBKYA:10 a=jdP34snFAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=kvLdEOgq-jFY0uASci0A:9 a=9mtjllxcxZAA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221155.665495896@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [21/65] ath9k: fix key allocation error handling for powersave keys
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0021-ath9k-fix-key-allocation-error-handling-for-powersav.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

[ Upstream commit 4ef69d0394cba8caa9f75d3f2e53429bfb8b3045 ]

If no keycache slots are available, ath_key_config can return -ENOSPC.
If the key index is not checked for errors, it can lead to logspam that
looks like this: "ath: wiphy0: keyreset: keycache entry 228 out of range"
This can cause follow-up errors if the invalid keycache index gets
used for tx.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 61e08e6..e032723 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1292,6 +1292,7 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 	struct ieee80211_key_conf ps_key = { };
+	int key;
 
 	ath_node_attach(sc, sta, vif);
 
@@ -1299,7 +1300,9 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 	    vif->type != NL80211_IFTYPE_AP_VLAN)
 		return 0;
 
-	an->ps_key = ath_key_config(common, vif, sta, &ps_key);
+	key = ath_key_config(common, vif, sta, &ps_key);
+	if (key > 0)
+		an->ps_key = key;
 
 	return 0;
 }
@@ -1316,6 +1319,7 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
 	    return;
 
 	ath_key_delete(common, &ps_key);
+	an->ps_key = 0;
 }
 
 static int ath9k_sta_remove(struct ieee80211_hw *hw,
-- 
1.7.10.4


