Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936258Ab3DKVBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:01:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28463 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935776Ab3DKUtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:19 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zYsSAi00c9QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=W59Ql2eiLhcA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=C6B5YpUAi4drOx_c:21 a=R0JEeycFJsnKixFP:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202601.227628984@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [ 092/171 ] mac80211: always synchronize_net() during station removal
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0092-mac80211-always-synchronize_net-during-station-remov.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 27a737ff7cb062fb9cbceba9b44d60aa74862bfa ]

If there are keys left during station removal, then a
synchronize_net() will be done (for each key, I have a
patch to address this for 3.10), otherwise it won't be
done at all which causes issues because the station
could be used for TX while it's being removed from the
driver -- that might confuse the driver.

Fix this by always doing synchronize_net() if no key
was present any more.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/mac80211/sta_info.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 31aa8b8..d82dec3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -656,6 +656,7 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
 	struct ieee80211_sub_if_data *sdata;
 	int ret, i, ac;
 	struct tid_ampdu_tx *tid_tx;
+	bool have_key = false;
 
 	might_sleep();
 
@@ -683,12 +684,19 @@ int __must_check __sta_info_destroy(struct sta_info *sta)
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
1.7.10.4


