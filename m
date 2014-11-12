Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934788AbaKLCeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:34:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934922AbaKLBrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:47:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Karl Beldan <karl.beldan@rivierawaves.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 181/203] mac80211: fix typo in starting baserate for rts_cts_rate_idx
Date: Wed, 12 Nov 2014 10:17:31 +0900
Message-Id: <20141112011550.991578277@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -462,7 +462,7 @@ static void rate_fixup_ratelist(struct i
 	 */
 	if (!(rates[0].flags & IEEE80211_TX_RC_MCS)) {
 		u32 basic_rates = vif->bss_conf.basic_rates;
-		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
+		s8 baserate = basic_rates ? ffs(basic_rates) - 1 : 0;
 
 		rate = &sband->bitrates[rates[0].idx];
 


