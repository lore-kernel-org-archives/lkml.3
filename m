Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3ICQYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:24:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46460 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163Ab3ICQYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:32 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wright <chrisw@sous-sol.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 01/58] mac80211: fix infinite loop in ieee80211_determine_chantype
Date: Tue,  3 Sep 2013 09:23:05 -0700
Message-Id: <1378225442-20654-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

commit b56e4b857c5210e848bfb80e074e5756a36cd523 upstream.

Commit "3d9646d mac80211: fix channel selection bug" introduced a possible
infinite loop by moving the out target above the chandef_downgrade
while loop.  When we downgrade to NL80211_CHAN_WIDTH_20_NOHT, we jump
back up to re-run the while loop...indefinitely.  Replace goto with
break and carry on.  This may not be sufficient to connect to the AP,
but will at least keep the cpu from livelocking.  Thanks to Derek Atkins
as an extra pair of debugging eyes.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a1a7997..a67fe0f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3410,7 +3410,7 @@ out:
 		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
 			ret = IEEE80211_STA_DISABLE_HT |
 			      IEEE80211_STA_DISABLE_VHT;
-			goto out;
+			break;
 		}
 
 		ret |= chandef_downgrade(chandef);
-- 
1.8.1.2

