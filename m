Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab3LSM2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:28:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45006 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab3LSL6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bob Copeland <me@bobcopeland.com>, Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 121/208] Revert "mac80211: allow disable power save in mesh"
Date: Thu, 19 Dec 2013 11:53:39 +0000
Message-Id: <1387454106-19326-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit 2d3db210860f1df099a35b1dd54cca35454e0361 upstream.

This reverts commit ee1f668136b2fb6640ee2d54c2a525ea41f98211.

The aformentioned commit added a check to allow
'iw wlan0 set power_save off' to work for mesh interfaces.

However, this is problematic because it also allows
'iw wlan0 set power_save on', which will crash in short order
because all of the subsequent code manipulates sdata->u.mgd.

The power-saving states for mesh interfaces can be manipulated
through the mesh config, e.g:
'iw wlan0 set mesh_param mesh_power_save=active' (which,
despite the name, actualy disables power saving since the
setting refers to the type of sleep the interface undergoes).

Fixes: ee1f668136b2 ("mac80211: allow disable power save in mesh")
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/cfg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a4b2154..98871d7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2374,8 +2374,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-	    sdata->vif.type != NL80211_IFTYPE_MESH_POINT)
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
-- 
1.8.3.2

