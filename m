Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3HRUqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:46:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756290Ab3HRUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 16/45] mac80211: continue using disabled channels while connected
Date: Sun, 18 Aug 2013 13:36:05 -0700
Message-Id: <20130818203622.145334675@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit ddfe49b42d8ad4bfdf92d63d4a74f162660d878d upstream.

In case the AP has different regulatory information than we do,
it can happen that we connect to an AP based on e.g. the world
roaming regulatory data, and then update our database with the
AP's country information disables the channel the AP is using.
If this happens on an HT AP, the bandwidth tracking code will
hit the WARN_ON() and disconnect. Since that's not very useful,
ignore the channel-disable flag in bandwidth tracking.

Reported-by: Chris Wright <chrisw@sous-sol.org>
Tested-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -361,8 +361,17 @@ out:
 	if (ret & IEEE80211_STA_DISABLE_VHT)
 		vht_chandef = *chandef;
 
+	/*
+	 * Ignore the DISABLED flag when we're already connected and only
+	 * tracking the APs beacon for bandwidth changes - otherwise we
+	 * might get disconnected here if we connect to an AP, update our
+	 * regulatory information based on the AP's country IE and the
+	 * information we have is wrong/outdated and disables the channel
+	 * that we're actually using for the connection to the AP.
+	 */
 	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy, chandef,
-					IEEE80211_CHAN_DISABLED)) {
+					tracking ? 0 :
+						   IEEE80211_CHAN_DISABLED)) {
 		if (WARN_ON(chandef->width == NL80211_CHAN_WIDTH_20_NOHT)) {
 			ret = IEEE80211_STA_DISABLE_HT |
 			      IEEE80211_STA_DISABLE_VHT;


