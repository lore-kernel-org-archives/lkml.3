Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbaFTVcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:32:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35782 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961AbaFTVcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:32:12 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Brett Rudley <brudley@broadcom.com>, Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] net/wireless/brcm80211/brcmfmac: Make return type reflect actual semantics
Date: Fri, 20 Jun 2014 23:32:03 +0200
Message-Id: <1403299923-21533-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applying ++ to a bool is equivalent to setting it true, regardless of
its initial value (bools are not uint1_t). Hence the function
wl_get_vif_state_all can only ever return true/false. The only
in-tree caller uses its return value as a boolean. So update its
return type, and since the list traversal and bit testing have no side
effects, just return true immediately.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---

Notes:
    Alternatively, if the function is supposed to return a count, the
    one-line fix would be
    
    -	bool result = 0;
    +	u32 result = 0;

 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c | 7 +++----
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d8fa276..ec5f8c5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -5625,16 +5625,15 @@ enum nl80211_iftype brcmf_cfg80211_get_iftype(struct brcmf_if *ifp)
 	return wdev->iftype;
 }
 
-u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state)
+bool wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state)
 {
 	struct brcmf_cfg80211_vif *vif;
-	bool result = 0;
 
 	list_for_each_entry(vif, &cfg->vif_list, list) {
 		if (test_bit(state, &vif->sme_state))
-			result++;
+			return true;
 	}
-	return result;
+	return false;
 }
 
 static inline bool vif_event_equals(struct brcmf_cfg80211_vif_event *event,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 283c525..c702e4e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -477,7 +477,7 @@ const struct brcmf_tlv *
 brcmf_parse_tlvs(const void *buf, int buflen, uint key);
 u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
 			struct ieee80211_channel *ch);
-u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state);
+bool wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state);
 void brcmf_cfg80211_arm_vif_event(struct brcmf_cfg80211_info *cfg,
 				  struct brcmf_cfg80211_vif *vif);
 bool brcmf_cfg80211_vif_event_armed(struct brcmf_cfg80211_info *cfg);
-- 
1.9.2

