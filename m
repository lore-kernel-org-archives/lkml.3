Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaKFWm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:42:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaKFWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 113/162] mac80211: fix typo in starting baserate for rts_cts_rate_idx
Date: Thu,  6 Nov 2014 14:36:17 -0800
Message-Id: <1415313426-9622-114-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Beldan <karl.beldan@rivierawaves.com>

commit c7abf25af0f41be4b50d44c5b185d52eea360cb8 upstream.

It affects non-(V)HT rates and can lead to selecting an rts_cts rate
that is not a basic rate or way superior to the reference rate (ATM
rates[0] used for the 1st attempt of the protected frame data).

E.g, assuming drivers register growing (bitrate) sorted tables of
ieee80211_rate-s, having :
- rates[0].idx == d'2 and basic_rates == b'10100
will select rts_cts idx b'10011 & ~d'(BIT(2)-1), i.e. 1, likewise
- rates[0].idx == d'2 and basic_rates == b'10001
will select rts_cts idx b'10000
The first is not a basic rate and the second is > rates[0].

Also, wrt severity of the addressed misbehavior, ATM we only have one
rts_cts_rate_idx rather than one per rate table entry, so this idx might
still point to bitrates > rates[1..MAX_RATES].

Fixes: 5253ffb8c9e1 ("mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates")
Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/rate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 22b223f..74350c3 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -462,7 +462,7 @@ static void rate_fixup_ratelist(struct ieee80211_vif *vif,
 	 */
 	if (!(rates[0].flags & IEEE80211_TX_RC_MCS)) {
 		u32 basic_rates = vif->bss_conf.basic_rates;
-		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
+		s8 baserate = basic_rates ? ffs(basic_rates) - 1 : 0;
 
 		rate = &sband->bitrates[rates[0].idx];
 
-- 
1.9.1

