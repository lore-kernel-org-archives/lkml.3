Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967607Ab3HIB67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:58:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967555Ab3HIB6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [ 039/102] mac80211/minstrel_ht: fix cck rate sampling
Date: Thu,  8 Aug 2013 18:57:15 -0700
Message-Id: <20130809015019.033002672@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 1cd158573951f737fbc878a35cb5eb47bf9af3d5 upstream.

The CCK group needs special treatment to set the right flags and rate
index. Add this missing check to prevent setting broken rates for tx
packets.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rc80211_minstrel_ht.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -804,10 +804,18 @@ minstrel_ht_get_rate(void *priv, struct
 
 	sample_group = &minstrel_mcs_groups[sample_idx / MCS_GROUP_RATES];
 	info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+	rate->count = 1;
+
+	if (sample_idx / MCS_GROUP_RATES == MINSTREL_CCK_GROUP) {
+		int idx = sample_idx % ARRAY_SIZE(mp->cck_rates);
+		rate->idx = mp->cck_rates[idx];
+		rate->flags = 0;
+		return;
+	}
+
 	rate->idx = sample_idx % MCS_GROUP_RATES +
 		    (sample_group->streams - 1) * MCS_GROUP_RATES;
 	rate->flags = IEEE80211_TX_RC_MCS | sample_group->flags;
-	rate->count = 1;
 }
 
 static void


