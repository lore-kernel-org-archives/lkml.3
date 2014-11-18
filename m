Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbaKRORH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:17:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbaKROK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Karl Beldan <karl.beldan@rivierawaves.com>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 186/206] mac80211: fix typo in starting baserate for rts_cts_rate_idx
Date: Tue, 18 Nov 2014 15:09:01 +0100
Message-Id: <94f13cde9717b4fc28fffc8f9aa4c411ccf4ab3c.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karl Beldan <karl.beldan@rivierawaves.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/rate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index e126605cec66..8753b77d4223 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -454,7 +454,7 @@ static void rate_fixup_ratelist(struct ieee80211_vif *vif,
 	 */
 	if (!(rates[0].flags & IEEE80211_TX_RC_MCS)) {
 		u32 basic_rates = vif->bss_conf.basic_rates;
-		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
+		s8 baserate = basic_rates ? ffs(basic_rates) - 1 : 0;
 
 		rate = &sband->bitrates[rates[0].idx];
 
-- 
2.1.3

