Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab3IEUjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:39:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab3IEU20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>, Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 23/36] mac80211: add a flag to indicate CCK support for HT clients
Date: Thu,  5 Sep 2013 13:27:52 -0700
Message-Id: <20130905202704.983113071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 2dfca312a91631311c1cf7c090246cc8103de038 upstream.

brcm80211 cannot handle sending frames with CCK rates as part of an
A-MPDU session. Other drivers may have issues too. Set the flag in all
drivers that have been tested with CCK rates.

This fixes a reported brcmsmac regression introduced in
commit ef47a5e4f1aaf1d0e2e6875e34b2c9595897bef6
"mac80211/minstrel_ht: fix cck rate sampling"

Reported-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/init.c    |    3 ++-
 drivers/net/wireless/ath/carl9170/main.c |    3 ++-
 drivers/net/wireless/rt2x00/rt2800lib.c  |    3 ++-
 include/net/mac80211.h                   |    1 +
 net/mac80211/rc80211_minstrel_ht.c       |    3 +++
 5 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -767,7 +767,8 @@ void ath9k_set_hw_capab(struct ath_softc
 		IEEE80211_HW_PS_NULLFUNC_STACK |
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS |
-		IEEE80211_HW_SUPPORTS_RC_TABLE;
+		IEEE80211_HW_SUPPORTS_RC_TABLE |
+		IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1857,7 +1857,8 @@ void *carl9170_alloc(size_t priv_size)
 		     IEEE80211_HW_SUPPORTS_PS |
 		     IEEE80211_HW_PS_NULLFUNC_STACK |
 		     IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC |
-		     IEEE80211_HW_SIGNAL_DBM;
+		     IEEE80211_HW_SIGNAL_DBM |
+		     IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
 
 	if (!modparam_noht) {
 		/*
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5912,7 +5912,8 @@ static int rt2800_probe_hw_mode(struct r
 	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_PS_NULLFUNC_STACK |
 	    IEEE80211_HW_AMPDU_AGGREGATION |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
+	    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
+	    IEEE80211_HW_SUPPORTS_HT_CCK_RATES;
 
 	/*
 	 * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1484,6 +1484,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_RC_TABLE			= 1<<24,
 	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
+	IEEE80211_HW_SUPPORTS_HT_CCK_RATES		= 1<<27,
 };
 
 /**
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -828,6 +828,9 @@ minstrel_ht_update_cck(struct minstrel_p
 	if (sband->band != IEEE80211_BAND_2GHZ)
 		return;
 
+	if (!(mp->hw->flags & IEEE80211_HW_SUPPORTS_HT_CCK_RATES))
+		return;
+
 	mi->cck_supported = 0;
 	mi->cck_supported_short = 0;
 	for (i = 0; i < 4; i++) {


