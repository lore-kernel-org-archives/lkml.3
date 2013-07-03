Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab3GCSsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:48:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933041Ab3GCSlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:03 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Dah-UCACYiwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9qmkh5PoAQgA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184053.548792547@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [054/141] mac80211: close AP_VLAN interfaces before unregistering all
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0054-mac80211-close-AP_VLAN-interfaces-before-unregisteri.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c8aa22db0112f640ac6631347f850879c621840b ]

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

Cc: stable@vger.kernel.org [2.6.33+]
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/mac80211/iface.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c93d395..9217a94 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1521,6 +1521,15 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 
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
1.7.10.4


