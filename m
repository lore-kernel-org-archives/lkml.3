Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab3FJEaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 00:30:09 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37449 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3FJEaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 00:30:07 -0400
Date: Sun, 9 Jun 2013 23:29:59 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
To: johannes@sipsolutions.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcalvinowens@gmail.com
Subject: [PATCH] mac80211: Fix bogus RCU warning from ieee80211_get_tx_rates
 (Was: Re: rcu)
Message-ID: <20130610042959.GA1902@gmail.com>
References: <20130609225120.GA2789@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130609225120.GA2789@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rate_control_fill_sta_table(), whose sole caller is ieee80211_get_tx_rates(),
is guaranteed by mac80211 not to be called concurrently with
rate_control_set_rates() [1], the sole function that touches the rate table
pointer/data in struct ieee80211_sta. The RCU dereference is therefore safe.

[1]: See commit f6b3d85f7f6d6

Signed-off-by: Calvin Owens <jcalvinowens@gmail.com>
---
 net/mac80211/rate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index d3f414f..585297d 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -539,7 +539,7 @@ static void rate_control_fill_sta_table(struct ieee80211_sta *sta,
 	int i;
 
 	if (sta && !info->control.skip_table)
-		ratetbl = rcu_dereference(sta->rates);
+		ratetbl = rcu_dereference_protected(sta->rates, true);
 
 	/* Fill remaining rate slots with data from the sta rate table. */
 	max_rates = min_t(int, max_rates, IEEE80211_TX_RATE_TABLE_SIZE);
-- 
1.8.2.1

