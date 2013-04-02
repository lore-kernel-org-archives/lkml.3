Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050Ab3DBXSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:18:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825Ab3DBWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 024/124] mac80211: always synchronize_net() during station removal
Date: Tue,  2 Apr 2013 15:10:06 -0700
Message-Id: <20130402221107.006897389@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 27a737ff7cb062fb9cbceba9b44d60aa74862bfa upstream.

If there are keys left during station removal, then a
synchronize_net() will be done (for each key, I have a
patch to address this for 3.10), otherwise it won't be
done at all which causes issues because the station
could be used for TX while it's being removed from the
driver -- that might confuse the driver.

Fix this by always doing synchronize_net() if no key
was present any more.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/sta_info.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -756,6 +756,7 @@ int __must_check __sta_info_destroy(stru
 	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	int ret, i;
+	bool have_key = false;
 
 	might_sleep();
 
@@ -783,12 +784,19 @@ int __must_check __sta_info_destroy(stru
 	list_del_rcu(&sta->list);
 
 	mutex_lock(&local->key_mtx);
-	for (i = 0; i < NUM_DEFAULT_KEYS; i++)
+	for (i = 0; i < NUM_DEFAULT_KEYS; i++) {
 		__ieee80211_key_free(key_mtx_dereference(local, sta->gtk[i]));
-	if (sta->ptk)
+		have_key = true;
+	}
+	if (sta->ptk) {
 		__ieee80211_key_free(key_mtx_dereference(local, sta->ptk));
+		have_key = true;
+	}
 	mutex_unlock(&local->key_mtx);
 
+	if (!have_key)
+		synchronize_net();
+
 	sta->dead = true;
 
 	local->num_sta--;


