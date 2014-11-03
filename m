Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaKCJde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 04:33:34 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:37120 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaKCJd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 04:33:29 -0500
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com, lisovy@gmail.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 2/2] mac80211: 802.11p OCB mode support
Date: Mon,  3 Nov 2014 10:33:19 +0100
Message-Id: <1415007199-31506-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1415007199-31506-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1415007199-31506-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 802.11p OCB (Outside the Context of a BSS) mode
support.

When communicating in OCB mode a mandatory wildcard BSSID
(48 '1' bits) is used.

The EDCA parameters handling function was changed to support
802.11p specific values.

The insertion of a newly discovered STAs is done in the similar way
as in the IBSS mode -- through the deferred insertion.

The OCB mode uses a periodic 'housekeeping task' for expiration of
disconnected STAs (in the similar manner as in the MESH mode).

New Kconfig option for verbose OCB debugging outputs is added.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/mac80211.h     |   2 +
 net/mac80211/Kconfig       |  11 ++
 net/mac80211/Makefile      |   3 +-
 net/mac80211/cfg.c         |  13 +++
 net/mac80211/chan.c        |   1 +
 net/mac80211/debug.h       |  10 ++
 net/mac80211/driver-ops.h  |   3 +-
 net/mac80211/ieee80211_i.h |  29 ++++++
 net/mac80211/iface.c       |  20 +++-
 net/mac80211/ocb.c         | 250 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c          |  35 +++++++
 net/mac80211/tx.c          |  15 +++
 net/mac80211/util.c        |  30 ++++--
 net/mac80211/wme.c         |   4 +
 14 files changed, 417 insertions(+), 9 deletions(-)
 create mode 100644 net/mac80211/ocb.c

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1614b2f..34ab261 100644
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
+	BSS_CHANGED_OCB                 = 1<<22,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 67cf812..75cc680 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -176,6 +176,17 @@ config MAC80211_HT_DEBUG
 
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
index 643a10a..57a38fc 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2019,6 +2019,17 @@ static int ieee80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
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
@@ -3690,6 +3701,8 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.join_mesh = ieee80211_join_mesh,
 	.leave_mesh = ieee80211_leave_mesh,
 #endif
+	.join_ocb = ieee80211_join_ocb,
+	.leave_ocb = ieee80211_leave_ocb,
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
 	.set_monitor_channel = ieee80211_set_monitor_channel,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index ff1f877..c7c5142 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -675,6 +675,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
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
index 3df28e0..4bb96bb 100644
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
index eb42529..fbd6bee 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -577,6 +577,25 @@ struct ieee80211_if_ibss {
 };
 
 /**
+ * struct ieee80211_if_ocb - OCB mode state
+ *
+ * @housekeeping_timer: timer for periodic invocation of a housekeeping task
+ * @wrkq_flags: OCB deferred task action
+ * @incomplete_lock: delayed STA insertion lock
+ * @incomplete_stations: list of STAs waiting for delayed insertion
+ * @joined: indication if the interface is connected to an OCB network
+ */
+struct ieee80211_if_ocb {
+	struct timer_list housekeeping_timer;
+	unsigned long wrkq_flags;
+
+	spinlock_t incomplete_lock;
+	struct list_head incomplete_stations;
+
+	bool joined;
+};
+
+/**
  * struct ieee80211_mesh_sync_ops - Extensible synchronization framework interface
  *
  * these declarations define the interface, which enables
@@ -869,6 +888,7 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_managed mgd;
 		struct ieee80211_if_ibss ibss;
 		struct ieee80211_if_mesh mesh;
+		struct ieee80211_if_ocb ocb;
 		u32 mntr_flags;
 	} u;
 
@@ -1505,6 +1525,15 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
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
index d69e753..6b631c0 100644
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
@@ -1283,6 +1292,9 @@ static void ieee80211_iface_work(struct work_struct *work)
 			break;
 		ieee80211_mesh_work(sdata);
 		break;
+	case NL80211_IFTYPE_OCB:
+		ieee80211_ocb_work(sdata);
+		break;
 	default:
 		break;
 	}
@@ -1302,6 +1314,9 @@ static void ieee80211_recalc_smps_work(struct work_struct *work)
 static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 				  enum nl80211_iftype type)
 {
+	static const u8 bssid_wildcard[ETH_ALEN] = {0xff, 0xff, 0xff,
+						    0xff, 0xff, 0xff};
+
 	/* clear type-dependent union */
 	memset(&sdata->u, 0, sizeof(sdata->u));
 
@@ -1354,7 +1369,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		ieee80211_sta_setup_sdata(sdata);
 		break;
 	case NL80211_IFTYPE_OCB:
-		/* to be implemented in the future */
+		sdata->vif.bss_conf.bssid = bssid_wildcard;
+		ieee80211_ocb_setup_sdata(sdata);
 		break;
 	case NL80211_IFTYPE_ADHOC:
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
@@ -1403,6 +1419,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could maybe also all others here?
 		 * Just not sure how that interacts
@@ -1418,6 +1435,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could probably support everything
 		 * but WDS here (WDS do_open can fail
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
new file mode 100644
index 0000000..358d5f9
--- /dev/null
+++ b/net/mac80211/ocb.c
@@ -0,0 +1,250 @@
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
+/**
+ * enum ocb_deferred_task_flags - mac80211 OCB deferred tasks
+ * @OCB_WORK_HOUSEKEEPING: run the periodic OCB housekeeping tasks
+ *
+ * These flags are used in @wrkq_flags field of &struct ieee80211_if_ocb
+ */
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
+	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
+	if (!sta)
+		return;
+
+	sta->last_rx = jiffies;
+
+	/* Add only mandatory rates for now */
+	sband = local->hw.wiphy->bands[band];
+	sta->sta.supp_rates[band] =
+		ieee80211_mandatory_rates(sband, scan_width);
+
+	spin_lock(&ifocb->incomplete_lock);
+	list_add(&sta->list, &ifocb->incomplete_stations);
+	spin_unlock(&ifocb->incomplete_lock);
+	ieee80211_queue_work(&local->hw, &sdata->work);
+}
+
+static struct sta_info *ieee80211_ocb_finish_sta(struct sta_info *sta)
+	__acquires(RCU)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u8 addr[ETH_ALEN];
+
+	memcpy(addr, sta->sta.addr, ETH_ALEN);
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
+	if (ifocb->joined != true)
+		return;
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
+	if (ifocb->joined == true)
+		return -EINVAL;
+
+	sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
+	sdata->smps_mode = IEEE80211_SMPS_OFF;
+	sdata->needed_rx_chains = sdata->local->rx_chains;
+
+	mutex_lock(&sdata->local->mtx);
+	err = ieee80211_vif_use_channel(sdata, &setup->chandef,
+					IEEE80211_CHANCTX_SHARED);
+	mutex_unlock(&sdata->local->mtx);
+	if (err)
+		return err;
+
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	ifocb->joined = true;
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
+	ifocb->joined = false;
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
+	mutex_lock(&sdata->local->mtx);
+	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&sdata->local->mtx);
+
+	skb_queue_purge(&sdata->skb_queue);
+
+	del_timer_sync(&sdata->u.ocb.housekeeping_timer);
+	/* If the timer fired while we waited for it, it will have
+	 * requeued the work. Now the work will be running again
+	 * but will not rearm the timer again because it checks
+	 * whether we are connected to the network or not -- at this
+	 * point we shouldn't be anymore.
+	 */
+
+	return 0;
+}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index b04ca40..bc63aa0 100644
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
@@ -1272,6 +1273,12 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 				sta->last_rx_rate_vht_nss = status->vht_nss;
 			}
 		}
+	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
+		u8 *bssid = ieee80211_get_bssid(hdr, rx->skb->len,
+						NL80211_IFTYPE_OCB);
+		/* OCB uses wild-card BSSID */
+		if (is_broadcast_ether_addr(bssid))
+			sta->last_rx = jiffies;
 	} else if (!is_multicast_ether_addr(hdr->addr1)) {
 		/*
 		 * Mesh beacons will update last_rx when if they are found to
@@ -2820,6 +2827,7 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_data *rx)
 
 	if (!ieee80211_vif_is_mesh(&sdata->vif) &&
 	    sdata->vif.type != NL80211_IFTYPE_ADHOC &&
+	    sdata->vif.type != NL80211_IFTYPE_OCB &&
 	    sdata->vif.type != NL80211_IFTYPE_STATION)
 		return RX_DROP_MONITOR;
 
@@ -3130,6 +3138,33 @@ static bool prepare_for_handlers(struct ieee80211_rx_data *rx,
 						 BIT(rate_idx));
 		}
 		break;
+	case NL80211_IFTYPE_OCB:
+		if (!bssid)
+			return false;
+		if (ieee80211_is_beacon(hdr->frame_control)) {
+			return false;
+		} else if (!is_broadcast_ether_addr(bssid)) {
+			ocb_dbg(sdata, "BSSID mismatch in OCB mode!\n");
+			return false;
+		} else if (!multicast &&
+			   !ether_addr_equal(sdata->dev->dev_addr,
+					     hdr->addr1)) {
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
index 900632a2..3ffd91f 100644
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
+		eth_broadcast_addr(hdr.addr3);
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
index d7d69c8..91e16b4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1101,6 +1101,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	int ac;
 	bool use_11b, enable_qos;
+	bool is_ocb; /* Use another EDCA parameters if dot11OCBActivated=true */
 	int aCWmin, aCWmax;
 
 	if (!local->ops->conf_tx)
@@ -1125,6 +1126,8 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	 */
 	enable_qos = (sdata->vif.type != NL80211_IFTYPE_STATION);
 
+	is_ocb = (sdata->vif.type == NL80211_IFTYPE_OCB);
+
 	/* Set defaults according to 802.11-2007 Table 7-37 */
 	aCWmax = 1023;
 	if (use_11b)
@@ -1146,7 +1149,10 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 				qparam.cw_max = aCWmax;
 				qparam.cw_min = aCWmin;
 				qparam.txop = 0;
-				qparam.aifs = 7;
+				if (is_ocb)
+					qparam.aifs = 9;
+				else
+					qparam.aifs = 7;
 				break;
 			/* never happens but let's not leave undefined */
 			default:
@@ -1154,21 +1160,32 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 				qparam.cw_max = aCWmax;
 				qparam.cw_min = aCWmin;
 				qparam.txop = 0;
-				qparam.aifs = 3;
+				if (is_ocb)
+					qparam.aifs = 6;
+				else
+					qparam.aifs = 3;
 				break;
 			case IEEE80211_AC_VI:
 				qparam.cw_max = aCWmin;
 				qparam.cw_min = (aCWmin + 1) / 2 - 1;
-				if (use_11b)
+				if (is_ocb)
+					qparam.txop = 0;
+				else if (use_11b)
 					qparam.txop = 6016/32;
 				else
 					qparam.txop = 3008/32;
-				qparam.aifs = 2;
+
+				if (is_ocb)
+					qparam.aifs = 3;
+				else
+					qparam.aifs = 2;
 				break;
 			case IEEE80211_AC_VO:
 				qparam.cw_max = (aCWmin + 1) / 2 - 1;
 				qparam.cw_min = (aCWmin + 1) / 4 - 1;
-				if (use_11b)
+				if (is_ocb)
+					qparam.txop = 0;
+				else if (use_11b)
 					qparam.txop = 3264/32;
 				else
 					qparam.txop = 1504/32;
@@ -1842,7 +1859,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			sdata_unlock(sdata);
 			break;
 		case NL80211_IFTYPE_OCB:
-			/* to be implemented in the future */
+			changed |= BSS_CHANGED_OCB;
+			ieee80211_bss_info_change_notify(sdata, changed);
 			break;
 		case NL80211_IFTYPE_ADHOC:
 			changed |= BSS_CHANGED_IBSS;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index d3c5672..fdf52db 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -148,6 +148,10 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_ADHOC:
 		ra = skb->data;
 		break;
+	case NL80211_IFTYPE_OCB:
+		/* all stations are required to support WME */
+		qos = true;
+		break;
 	default:
 		break;
 	}
-- 
2.0.0.rc4

