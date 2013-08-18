Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab3HRUez (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:34:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284Ab3HRUex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 15/45] mac80211: fix infinite loop in ieee80211_determine_chantype
Date: Sun, 18 Aug 2013 13:36:04 -0700
Message-Id: <20130818203622.078014637@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -366,7 +366,7 @@ out:
 		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
 			ret = IEEE80211_STA_DISABLE_HT |
 			      IEEE80211_STA_DISABLE_VHT;
-			goto out;
+			break;
 		}
 
 		ret |= chandef_downgrade(chandef);


