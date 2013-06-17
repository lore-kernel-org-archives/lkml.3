Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3FQSBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:01:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152Ab3FQRbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 02/84] mac80211: close AP_VLAN interfaces before unregistering all
Date: Mon, 17 Jun 2013 10:30:06 -0700
Message-Id: <1371490288-23167-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit c8aa22db0112f640ac6631347f850879c621840b upstream.

Since Eric's commit efe117ab8 ("Speedup ieee80211_remove_interfaces")
there's a bug in mac80211 when it unregisters with AP_VLAN interfaces
up. If the AP_VLAN interface was registered after the AP it belongs
to (which is the typical case) and then we get into this code path,
unregister_netdevice_many() will crash because it isn't prepared to
deal with interfaces being closed in the middle of it. Exactly this
happens though, because we iterate the list, find the AP master this
AP_VLAN belongs to and dev_close() the dependent VLANs. After this,
unregister_netdevice_many() won't pick up the fact that the AP_VLAN
is already down and will do it again, causing a crash.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/iface.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8be854e..00bd646 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1657,6 +1657,15 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 
 	ASSERT_RTNL();
 
+	/*
+	 * Close all AP_VLAN interfaces first, as otherwise they
+	 * might be closed while the AP interface they belong to
+	 * is closed, causing unregister_netdevice_many() to crash.
+	 */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			dev_close(sdata->dev);
+
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
-- 
1.8.1.2

