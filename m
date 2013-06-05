Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655Ab3FEVNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:13:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932639Ab3FEVNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:13:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [ 43/44] mac80211: close AP_VLAN interfaces before unregistering all
Date: Wed,  5 Jun 2013 14:12:41 -0700
Message-Id: <20130605211226.347586513@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605211221.858177087@linuxfoundation.org>
References: <20130605211221.858177087@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/iface.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1257,6 +1257,15 @@ void ieee80211_remove_interfaces(struct
 
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


