Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab3FPWba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:31:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46297 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755499Ab3FPWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Sun, 16 Jun 2013 23:01:37 +0100
Message-ID: <lsq.1371420097.20924251@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [06/83] mac80211: close AP_VLAN interfaces before unregistering all
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/iface.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1242,6 +1242,15 @@ void ieee80211_remove_interfaces(struct
 
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

