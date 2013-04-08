Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935909Ab3DHJwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:52:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935853Ab3DHJwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 083/102] mac80211: always synchronize_net() during station removal
Date: Mon,  8 Apr 2013 10:50:38 +0100
Message-Id: <1365414657-29191-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/sta_info.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fec8eab..91eb0c5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -664,6 +664,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata;
 	int ret, i, ac;
 	struct tid_ampdu_tx *tid_tx;
+	bool have_key = false;
 
 	might_sleep();
 
@@ -691,12 +692,19 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
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
-- 
1.8.1.2

