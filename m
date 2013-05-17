Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3EQV4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:56:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab3EQVu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:50:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 11/33] ath9k: fix key allocation error handling for powersave keys
Date: Fri, 17 May 2013 14:49:55 -0700
Message-Id: <20130517214918.065244208@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517214916.821259930@linuxfoundation.org>
References: <20130517214916.821259930@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4ef69d0394cba8caa9f75d3f2e53429bfb8b3045 upstream.

If no keycache slots are available, ath_key_config can return -ENOSPC.
If the key index is not checked for errors, it can lead to logspam that
looks like this: "ath: wiphy0: keyreset: keycache entry 228 out of range"
This can cause follow-up errors if the invalid keycache index gets
used for tx.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1791,6 +1791,7 @@ static int ath9k_sta_add(struct ieee8021
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 	struct ieee80211_key_conf ps_key = { };
+	int key;
 
 	ath_node_attach(sc, sta);
 
@@ -1798,7 +1799,9 @@ static int ath9k_sta_add(struct ieee8021
 	    vif->type != NL80211_IFTYPE_AP_VLAN)
 		return 0;
 
-	an->ps_key = ath_key_config(common, vif, sta, &ps_key);
+	key = ath_key_config(common, vif, sta, &ps_key);
+	if (key > 0)
+		an->ps_key = key;
 
 	return 0;
 }
@@ -1815,6 +1818,7 @@ static void ath9k_del_ps_key(struct ath_
 	    return;
 
 	ath_key_delete(common, &ps_key);
+	an->ps_key = 0;
 }
 
 static int ath9k_sta_remove(struct ieee80211_hw *hw,


