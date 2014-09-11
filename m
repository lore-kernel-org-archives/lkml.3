Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbaIKObe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:31:34 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:65243 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaIKOat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:30:49 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com, lisovy@gmail.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 1/4] mac80211: OCB mode + join and leave handling
Date: Thu, 11 Sep 2014 16:30:19 +0200
Message-Id: <1410445822-6559-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the devices compliant to the IEEE 802.11p
(dot11OCBActivated=true) should operate in the OCB
(Outside the Context of a BSS) mode. This makes it
possible to communicate without the need for
association/authentication. All participants use the
wildcard BSSID (set to all 1's).

In OCB mode there are no extra configuration options
besides the channel (center frequency and width) used
for the communication. The channel must be known a priori.
This is set when joining the network explicitly with the
'ocb join' command.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/mac80211.h       |   2 +
 include/uapi/linux/nl80211.h |   3 +
 net/mac80211/Kconfig         |  11 ++
 net/mac80211/Makefile        |   3 +-
 net/mac80211/cfg.c           |  14 +++
 net/mac80211/chan.c          |   1 +
 net/mac80211/debug.h         |  10 ++
 net/mac80211/driver-ops.h    |   3 +-
 net/mac80211/ieee80211_i.h   |  20 ++++
 net/mac80211/iface.c         |  20 ++++
 net/mac80211/ocb.c           | 236 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c            |  33 ++++++
 net/mac80211/tx.c            |  15 +++
 net/mac80211/util.c          |   4 +
 14 files changed, 373 insertions(+), 2 deletions(-)
 create mode 100644 net/mac80211/ocb.c

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c6e6a68..255ba85 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -263,6 +263,7 @@ struct ieee80211_vif_chanctx_switch {
  * @BSS_CHANGED_BANDWIDTH: The bandwidth used by this interface changed,
  *	note that this is only called when it changes after the channel
  *	context had been assigned.
+ * @BSS_CHANGED_OCB: OCB join status changed
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -287,6 +288,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_P2P_PS		= 1<<19,
 	BSS_CHANGED_BEACON_INFO		= 1<<20,
 	BSS_CHANGED_BANDWIDTH		= 1<<21,
+	BSS_CHANGED_OCB			= 1<<22,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 29c4399..cdf9ba4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2031,6 +2031,8 @@ enum nl80211_attrs {
  *	and therefore can't be created in the normal ways, use the
  *	%NL80211_CMD_START_P2P_DEVICE and %NL80211_CMD_STOP_P2P_DEVICE
  *	commands to create and destroy one
+ * @NL80211_IF_TYPE_OCB: Outside Context of a BSS
+ *	this mode corresponds to the MIB variable dot11OCBActivated=true
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -2050,6 +2052,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_P2P_CLIENT,
 	NL80211_IFTYPE_P2P_GO,
 	NL80211_IFTYPE_P2P_DEVICE,
+	NL80211_IFTYPE_OCB,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index aeb6a48..b0d7684 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -169,6 +169,17 @@ config MAC80211_HT_DEBUG
 
 	  Do not select this option.
 
+config MAC80211_OCB_DEBUG
+	bool "Verbose OCB debugging"
+	depends on MAC80211_DEBUG_MENU
+	---help---
+	  Selecting this option causes mac80211 to print out
+	  very verbose OCB debugging messages. It should not
+	  be selected on production systems as those messages
+	  are remotely triggerable.
+
+	  Do not select this option.
+
 config MAC80211_IBSS_DEBUG
 	bool "Verbose IBSS debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 7273d27..e53671b 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -27,7 +27,8 @@ mac80211-y := \
 	event.o \
 	chan.o \
 	trace.o mlme.o \
-	tdls.o
+	tdls.o \
+	ocb.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 101ae6c..3ec87bd 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -229,6 +229,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_OCB:
 		/* shouldn't happen */
 		WARN_ON_ONCE(1);
 		break;
@@ -1955,6 +1956,17 @@ static int ieee80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	return ieee80211_ibss_leave(IEEE80211_DEV_TO_SUB_IF(dev));
 }
 
+static int ieee80211_join_ocb(struct wiphy *wiphy, struct net_device *dev,
+			      struct ocb_setup *setup)
+{
+	return ieee80211_ocb_join(IEEE80211_DEV_TO_SUB_IF(dev), setup);
+}
+
+static int ieee80211_leave_ocb(struct wiphy *wiphy, struct net_device *dev)
+{
+	return ieee80211_ocb_leave(IEEE80211_DEV_TO_SUB_IF(dev));
+}
+
 static int ieee80211_set_mcast_rate(struct wiphy *wiphy, struct net_device *dev,
 				    int rate[IEEE80211_NUM_BANDS])
 {
@@ -3541,6 +3553,8 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.join_mesh = ieee80211_join_mesh,
 	.leave_mesh = ieee80211_leave_mesh,
 #endif
+	.join_ocb = ieee80211_join_ocb,
+	.leave_ocb = ieee80211_leave_ocb,
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
 	.set_monitor_channel = ieee80211_set_monitor_channel,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index bd01a9f..32636de 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -672,6 +672,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_MESH_POINT:
+		case NL80211_IFTYPE_OCB:
 			break;
 		default:
 			WARN_ON_ONCE(1);
diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
index 493d680..1956b31 100644
--- a/net/mac80211/debug.h
+++ b/net/mac80211/debug.h
@@ -2,6 +2,12 @@
 #define __MAC80211_DEBUG_H
 #include <net/cfg80211.h>
 
+#ifdef CONFIG_MAC80211_OCB_DEBUG
+#define MAC80211_OCB_DEBUG 1
+#else
+#define MAC80211_OCB_DEBUG 0
+#endif
+
 #ifdef CONFIG_MAC80211_IBSS_DEBUG
 #define MAC80211_IBSS_DEBUG 1
 #else
@@ -131,6 +137,10 @@ do {									\
 	_sdata_dbg(MAC80211_HT_DEBUG && net_ratelimit(),		\
 		   sdata, fmt, ##__VA_ARGS__)
 
+#define ocb_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_OCB_DEBUG,					\
+		   sdata, fmt, ##__VA_ARGS__)
+
 #define ibss_dbg(sdata, fmt, ...)					\
 	_sdata_dbg(MAC80211_IBSS_DEBUG,					\
 		   sdata, fmt, ##__VA_ARGS__)
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 196d48c..7abe44e 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -214,7 +214,8 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 				    BSS_CHANGED_BEACON_ENABLED) &&
 			 sdata->vif.type != NL80211_IFTYPE_AP &&
 			 sdata->vif.type != NL80211_IFTYPE_ADHOC &&
-			 sdata->vif.type != NL80211_IFTYPE_MESH_POINT))
+			 sdata->vif.type != NL80211_IFTYPE_MESH_POINT &&
+			 sdata->vif.type != NL80211_IFTYPE_OCB))
 		return;
 
 	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_P2P_DEVICE ||
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c2aaec4..ea6a601 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -82,6 +82,8 @@ struct ieee80211_fragment_entry {
 	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
 };
 
+/* Used in OCB mode */
+static const u8 bssid_wildcard[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 struct ieee80211_bss {
 	u32 device_ts_beacon, device_ts_presp;
@@ -546,6 +548,14 @@ struct ieee80211_if_ibss {
 	} state;
 };
 
+struct ieee80211_if_ocb {
+	struct timer_list housekeeping_timer;
+	unsigned long wrkq_flags;
+
+	spinlock_t incomplete_lock;
+	struct list_head incomplete_stations;
+};
+
 /**
  * struct ieee80211_mesh_sync_ops - Extensible synchronization framework interface
  *
@@ -839,6 +849,7 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_managed mgd;
 		struct ieee80211_if_ibss ibss;
 		struct ieee80211_if_mesh mesh;
+		struct ieee80211_if_ocb ocb;
 		u32 mntr_flags;
 	} u;
 
@@ -1471,6 +1482,15 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata);
 
+/* OCB code */
+void ieee80211_ocb_work(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
+			     const u8 *bssid, const u8 *addr, u32 supp_rates);
+void ieee80211_ocb_setup_sdata(struct ieee80211_sub_if_data *sdata);
+int ieee80211_ocb_join(struct ieee80211_sub_if_data *sdata,
+		       struct ocb_setup *setup);
+int ieee80211_ocb_leave(struct ieee80211_sub_if_data *sdata);
+
 /* mesh code */
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index af23722..590763b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -259,6 +259,15 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 	list_for_each_entry(nsdata, &local->interfaces, list) {
 		if (nsdata != sdata && ieee80211_sdata_running(nsdata)) {
 			/*
+			 * Only OCB and monitor mode may coexist
+			 */
+			if ((sdata->vif.type == NL80211_IFTYPE_OCB &&
+			     nsdata->vif.type != NL80211_IFTYPE_MONITOR) ||
+			    (sdata->vif.type != NL80211_IFTYPE_MONITOR &&
+			     nsdata->vif.type == NL80211_IFTYPE_OCB))
+				return -EBUSY;
+
+			/*
 			 * Allow only a single IBSS interface to be up at any
 			 * time. This is restricted because beacon distribution
 			 * cannot work properly if both are in the same IBSS.
@@ -521,6 +530,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_OCB:
 		/* no special treatment */
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -631,6 +641,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_MESH_POINT:
+		case NL80211_IFTYPE_OCB:
 			netif_carrier_off(dev);
 			break;
 		case NL80211_IFTYPE_WDS:
@@ -1279,6 +1290,9 @@ static void ieee80211_iface_work(struct work_struct *work)
 			break;
 		ieee80211_mesh_work(sdata);
 		break;
+	case NL80211_IFTYPE_OCB:
+		ieee80211_ocb_work(sdata);
+		break;
 	default:
 		break;
 	}
@@ -1349,6 +1363,10 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
 		ieee80211_sta_setup_sdata(sdata);
 		break;
+	case NL80211_IFTYPE_OCB:
+		sdata->vif.bss_conf.bssid = bssid_wildcard;
+		ieee80211_ocb_setup_sdata(sdata);
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 		ieee80211_ibss_setup_sdata(sdata);
@@ -1396,6 +1414,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could maybe also all others here?
 		 * Just not sure how that interacts
@@ -1411,6 +1430,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could probably support everything
 		 * but WDS here (WDS do_open can fail
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
new file mode 100644
index 0000000..bb51140
--- /dev/null
+++ b/net/mac80211/ocb.c
@@ -0,0 +1,236 @@
+/*
+ * OCB mode implementation
+ *
+ * Copyright: (c) 2014 Czech Technical University in Prague
+ *            (c) 2014 Volkswagen Group Research
+ * Author:    Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
+ * Funded by: Volkswagen Group Research
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/if_ether.h>
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/etherdevice.h>
+#include <linux/rtnetlink.h>
+#include <net/mac80211.h>
+#include <asm/unaligned.h>
+
+#include "ieee80211_i.h"
+#include "driver-ops.h"
+#include "rate.h"
+
+#define IEEE80211_OCB_HOUSEKEEPING_INTERVAL		(60 * HZ)
+#define IEEE80211_OCB_PEER_INACTIVITY_LIMIT		(240 * HZ)
+#define IEEE80211_OCB_MAX_STA_ENTRIES			128
+
+enum ocb_deferred_task_flags {
+	OCB_WORK_HOUSEKEEPING,
+};
+
+void ieee80211_ocb_rx_no_sta(struct ieee80211_sub_if_data *sdata,
+			     const u8 *bssid, const u8 *addr,
+			     u32 supp_rates)
+{
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_supported_band *sband;
+	enum nl80211_bss_scan_width scan_width;
+	struct sta_info *sta;
+	int band;
+
+	/* XXX: Consider removing the least recently used entry and
+	 *      allow new one to be added.
+	 */
+	if (local->num_sta >= IEEE80211_OCB_MAX_STA_ENTRIES) {
+		net_info_ratelimited("%s: No room for a new OCB STA entry %pM\n",
+				     sdata->name, addr);
+		return;
+	}
+
+	ocb_dbg(sdata, "Adding new OCB station %pM\n", addr);
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (WARN_ON_ONCE(!chanctx_conf)) {
+		rcu_read_unlock();
+		return;
+	}
+	band = chanctx_conf->def.chan->band;
+	scan_width = cfg80211_chandef_to_scan_width(&chanctx_conf->def);
+	rcu_read_unlock();
+
+	sta = sta_info_alloc(sdata, addr, GFP_KERNEL);
+	if (!sta)
+		return;
+
+	sta->last_rx = jiffies;
+
+	/* Add only mandatory rates for now */
+	sband = local->hw.wiphy->bands[band];
+	sta->sta.supp_rates[band] = ieee80211_mandatory_rates(sband, scan_width);
+	/* sta->sta.supp_rates[band] |= supp_rates; */
+
+	spin_lock(&ifocb->incomplete_lock);
+	list_add(&sta->list, &ifocb->incomplete_stations);
+	spin_unlock(&ifocb->incomplete_lock);
+	ieee80211_queue_work(&local->hw, &sdata->work);
+}
+
+/* TODO: Almost the same as ieee80211_ibss_finish_sta()
+ *       Maybe use the same function for both?
+ */
+static struct sta_info *ieee80211_ocb_finish_sta(struct sta_info *sta)
+	__acquires(RCU)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u8 addr[ETH_ALEN];
+
+	ether_addr_copy(addr, sta->sta.addr);
+
+	ocb_dbg(sdata, "Adding new IBSS station %pM (dev=%s)\n",
+		addr, sdata->name);
+
+	sta_info_move_state(sta, IEEE80211_STA_AUTH);
+	sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+	sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+
+	rate_control_rate_init(sta);
+
+	/* If it fails, maybe we raced another insertion? */
+	if (sta_info_insert_rcu(sta))
+		return sta_info_get(sdata, addr);
+	return sta;
+}
+
+static void ieee80211_ocb_housekeeping(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+
+	ocb_dbg(sdata, "Running ocb housekeeping\n");
+
+	ieee80211_sta_expire(sdata, IEEE80211_OCB_PEER_INACTIVITY_LIMIT);
+
+	mod_timer(&ifocb->housekeeping_timer,
+		  round_jiffies(jiffies + IEEE80211_OCB_HOUSEKEEPING_INTERVAL));
+}
+
+void ieee80211_ocb_work(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+	struct sta_info *sta;
+
+	sdata_lock(sdata);
+
+	spin_lock_bh(&ifocb->incomplete_lock);
+	while (!list_empty(&ifocb->incomplete_stations)) {
+		sta = list_first_entry(&ifocb->incomplete_stations,
+				       struct sta_info, list);
+		list_del(&sta->list);
+		spin_unlock_bh(&ifocb->incomplete_lock);
+
+		ieee80211_ocb_finish_sta(sta);
+		rcu_read_unlock();
+		spin_lock_bh(&ifocb->incomplete_lock);
+	}
+	spin_unlock_bh(&ifocb->incomplete_lock);
+
+	if (test_and_clear_bit(OCB_WORK_HOUSEKEEPING, &ifocb->wrkq_flags))
+		ieee80211_ocb_housekeeping(sdata);
+
+	sdata_unlock(sdata);
+}
+
+static void ieee80211_ocb_housekeeping_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata = (void *)data;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+
+	set_bit(OCB_WORK_HOUSEKEEPING, &ifocb->wrkq_flags);
+
+	ieee80211_queue_work(&local->hw, &sdata->work);
+}
+
+void ieee80211_ocb_setup_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+
+	setup_timer(&ifocb->housekeeping_timer,
+		    ieee80211_ocb_housekeeping_timer,
+		    (unsigned long)sdata);
+	INIT_LIST_HEAD(&ifocb->incomplete_stations);
+	spin_lock_init(&ifocb->incomplete_lock);
+}
+
+int ieee80211_ocb_join(struct ieee80211_sub_if_data *sdata,
+		       struct ocb_setup *setup)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+	u32 changed = BSS_CHANGED_OCB;
+	int err;
+
+	sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+	sdata->smps_mode = IEEE80211_SMPS_OFF;
+	sdata->needed_rx_chains = sdata->local->rx_chains;
+
+	mutex_lock(&sdata->local->mtx);
+	err = ieee80211_vif_use_channel(sdata, &setup->chandef,
+					IEEE80211_CHANCTX_EXCLUSIVE);
+	mutex_unlock(&sdata->local->mtx);
+	if (err)
+		return err;
+
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	set_bit(OCB_WORK_HOUSEKEEPING, &ifocb->wrkq_flags);
+	ieee80211_queue_work(&local->hw, &sdata->work);
+
+	netif_carrier_on(sdata->dev);
+	return 0;
+}
+
+int ieee80211_ocb_leave(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	sta_info_flush(sdata);
+
+	spin_lock_bh(&ifocb->incomplete_lock);
+	while (!list_empty(&ifocb->incomplete_stations)) {
+		sta = list_first_entry(&ifocb->incomplete_stations,
+				       struct sta_info, list);
+		list_del(&sta->list);
+		spin_unlock_bh(&ifocb->incomplete_lock);
+
+		sta_info_free(local, sta);
+		spin_lock_bh(&ifocb->incomplete_lock);
+	}
+	spin_unlock_bh(&ifocb->incomplete_lock);
+
+	netif_carrier_off(sdata->dev);
+	clear_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_OCB);
+
+#if 0 /* TODO */
+	drv_leave_ocb(local, sdata);
+#endif
+	mutex_lock(&sdata->local->mtx);
+	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&sdata->local->mtx);
+
+	skb_queue_purge(&sdata->skb_queue);
+
+	del_timer_sync(&sdata->u.ocb.housekeeping_timer);
+
+	return 0;
+}
+
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b04ca40..58975f7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1032,6 +1032,7 @@ ieee80211_rx_h_check(struct ieee80211_rx_data *rx)
 		      ieee80211_is_pspoll(hdr->frame_control)) &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_ADHOC &&
 		     rx->sdata->vif.type != NL80211_IFTYPE_WDS &&
+		     rx->sdata->vif.type != NL80211_IFTYPE_OCB &&
 		     (!rx->sta || !test_sta_flag(rx->sta, WLAN_STA_ASSOC)))) {
 		/*
 		 * accept port control frames from the AP even when it's not
@@ -1272,6 +1273,11 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 				sta->last_rx_rate_vht_nss = status->vht_nss;
 			}
 		}
+	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
+		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
+						NL80211_IFTYPE_OCB);
+		if (ieee80211_bssid_match(bssid, bssid_wildcard))
+			sta->last_rx = jiffies;
 	} else if (!is_multicast_ether_addr(hdr->addr1)) {
 		/*
 		 * Mesh beacons will update last_rx when if they are found to
@@ -2820,6 +2826,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 
 	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
 	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+	    sdata->vif.type != NL80211_IFTYPE_OCB &&
 	    sdata->vif.type != NL80211_IFTYPE_STATION)
 		return RX_DROP_MONITOR;
 
@@ -3130,6 +3137,32 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 						 BIT(rate_idx));
 		}
 		break;
+	case NL80211_IFTYPE_OCB:
+		if (!bssid)
+			return false;
+		if (ieee80211_is_beacon(hdr->frame_control)) {
+			return false;
+		} else if (!ieee80211_bssid_match(bssid, bssid_wildcard)) {
+			ocb_dbg(sdata, "BSSID mismatch in OCB mode!\n");
+			return false;
+		} else if (!multicast &&
+			   !ether_addr_equal(sdata->dev->dev_addr, hdr->addr1)) {
+			/* if we are in promisc mode we also accept
+			 * packets not destined for us
+			 */
+			if (!(sdata->dev->flags & IFF_PROMISC))
+				return false;
+			rx->flags &= ~IEEE80211_RX_RA_MATCH;
+		} else if (!rx->sta) {
+			int rate_idx;
+			if (status->flag & RX_FLAG_HT)
+				rate_idx = 0; /* TODO: HT rates */
+			else
+				rate_idx = status->rate_idx;
+			ieee80211_ocb_rx_no_sta(sdata, bssid, hdr->addr2,
+						BIT(rate_idx));
+		}
+		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (!multicast &&
 		    !ether_addr_equal(sdata->vif.addr, hdr->addr1)) {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2f7754c..2352f3a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -296,6 +296,9 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 		 */
 		return TX_DROP;
 
+	if (tx->sdata->vif.type == NL80211_IFTYPE_OCB)
+		return TX_CONTINUE;
+
 	if (tx->sdata->vif.type == NL80211_IFTYPE_WDS)
 		return TX_CONTINUE;
 
@@ -2013,6 +2016,17 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			goto fail_rcu;
 		band = chanctx_conf->def.chan->band;
 		break;
+	case NL80211_IFTYPE_OCB:
+		/* DA SA BSSID */
+		memcpy(hdr.addr1, skb->data, ETH_ALEN);
+		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
+		memset(hdr.addr3, 0xff, ETH_ALEN);
+		hdrlen = 24;
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (!chanctx_conf)
+			goto fail_rcu;
+		band = chanctx_conf->def.chan->band;
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		/* DA SA BSSID */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -2057,6 +2071,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 	 * EAPOL frames from the local station.
 	 */
 	if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
+		     (sdata->vif.type != NL80211_IFTYPE_OCB) &&
 		     !multicast && !authorized &&
 		     (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
 		      !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))) {
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3c61060..3eb4151 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1813,6 +1813,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			ieee80211_bss_info_change_notify(sdata, changed);
 			sdata_unlock(sdata);
 			break;
+		case NL80211_IFTYPE_OCB:
+			changed |= BSS_CHANGED_OCB;
+			ieee80211_bss_info_change_notify(sdata, changed);
+			break;
 		case NL80211_IFTYPE_ADHOC:
 			changed |= BSS_CHANGED_IBSS;
 			/* fall through */
-- 
2.0.0.rc4

