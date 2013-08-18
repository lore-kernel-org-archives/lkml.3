Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3HRUfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:35:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3HRUfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 29/45] nl80211: fix another nl80211_fam.attrbuf race
Date: Sun, 18 Aug 2013 13:36:18 -0700
Message-Id: <20130818203623.022154197@linuxfoundation.org>
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

commit c319d50bfcf678c2857038276d9fab3c6646f3bf upstream.

This is similar to the race Linus had reported, but in this case
it's an older bug: nl80211_prepare_wdev_dump() uses the wiphy
index in cb->args[0] as it is and thus parses the message over
and over again instead of just once because 0 is the first valid
wiphy index. Similar code in nl80211_testmode_dump() correctly
offsets the wiphy_index by 1, do that here as well.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -471,10 +471,12 @@ static int nl80211_prepare_wdev_dump(str
 			goto out_unlock;
 		}
 		*rdev = wiphy_to_dev((*wdev)->wiphy);
-		cb->args[0] = (*rdev)->wiphy_idx;
+		/* 0 is the first index - add 1 to parse only once */
+		cb->args[0] = (*rdev)->wiphy_idx + 1;
 		cb->args[1] = (*wdev)->identifier;
 	} else {
-		struct wiphy *wiphy = wiphy_idx_to_wiphy(cb->args[0]);
+		/* subtract the 1 again here */
+		struct wiphy *wiphy = wiphy_idx_to_wiphy(cb->args[0] - 1);
 		struct wireless_dev *tmp;
 
 		if (!wiphy) {


