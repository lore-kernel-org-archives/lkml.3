Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab3EGQFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 12:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3EGQFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 12:05:46 -0400
Date: Tue, 7 May 2013 18:07:06 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jake Edge <jake@lwn.net>, linux-wireless@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3.10] iwl4965: workaround connection regression on passive
 channel
Message-ID: <20130507160705.GC1576@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
 <20130506123805.GA1602@redhat.com>
 <20130506083759.556dac76@chukar.edge2.net>
 <20130506153044.GB1602@redhat.com>
 <1367854279.8434.13.camel@jlt4.sipsolutions.net>
 <1367855046.8434.16.camel@jlt4.sipsolutions.net>
 <20130507084241.GA1581@redhat.com>
 <1367934810.8328.30.camel@jlt4.sipsolutions.net>
 <20130507153525.GB1576@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130507153525.GB1576@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jake reported that since commit 1672c0e31917f49d31d30d79067103432bc20cc7
"mac80211: start auth/assoc timeout on frame status", he is unable to
connect to his AP, which is configured to use passive channel.

After switch to passive channel 4965 firmware drops any TX packet until
it receives beacon. Before commit 1672c0e3 we waited on channel and
retransmit packet after 200ms, that makes we receive beacon on the
meantime and association process succeed. New mac80211 behaviour cause
that any ASSOC frame fail immediately on iwl4965 and we can not
associate.

This patch restore old mac80211 behaviour for iwl4965, by removing
IEEE80211_HW_REPORTS_TX_ACK_STATUS feature. This feature will be
added again to iwl4965 driver, when different, more complex
workaround for this firmware issue, will be added to the driver.

Cc: stable@vger.kernel.org # 3.9
Bisected-by: Jake Edge <jake@lwn.net>
Reported-and-tested-by: Jake Edge <jake@lwn.net>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index b8f82e6..9a95045 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5741,8 +5741,7 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	hw->flags =
 	    IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_AMPDU_AGGREGATION |
 	    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC | IEEE80211_HW_SPECTRUM_MGMT |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | IEEE80211_HW_SUPPORTS_PS |
-	    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
+	    IEEE80211_HW_SUPPORTS_PS | IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 	if (il->cfg->sku & IL_SKU_N)
 		hw->flags |=
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
-- 
1.7.11.7

