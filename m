Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaESOt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:49:57 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39289 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbaESOtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:49:16 -0400
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [RFC 2/2] mac80211: Add new interface type for OCB mode
Date: Mon, 19 May 2014 16:49:05 +0200
Message-Id: <1400510945-24868-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1400510945-24868-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1400510945-24868-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new OCB mode (outside the context of the BSS) interface
type as well as functions necessary to open an interface
of that type.
When the interface is opened configure it in the way that
the beacons are disabled, receive filter accepts all frames
and the BSSID is set to all 1's.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/uapi/linux/nl80211.h |   3 ++
 net/mac80211/Makefile        |   3 +-
 net/mac80211/cfg.c           |   1 +
 net/mac80211/chan.c          |   2 +
 net/mac80211/driver-ops.h    |   3 +-
 net/mac80211/ieee80211_i.h   |  38 ++++++++++++++
 net/mac80211/iface.c         |  28 +++++++++++
 net/mac80211/ocb.c           | 115 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/util.c          |   5 ++
 net/wireless/util.c          |   1 +
 10 files changed, 197 insertions(+), 2 deletions(-)
 create mode 100644 net/mac80211/ocb.c

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 970c5df..5250267 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1994,6 +1994,8 @@ enum nl80211_attrs {
  *	and therefore can't be created in the normal ways, use the
  *	%NL80211_CMD_START_P2P_DEVICE and %NL80211_CMD_STOP_P2P_DEVICE
  *	commands to create and destroy one
+ * @NL80211_IF_TYPE_OCB: outside the context of a BSS
+ *	this mode corresponds to the MIB variable dot11OCBActivated=true
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -2013,6 +2015,7 @@ enum nl80211_iftype {
 	NL80211_IFTYPE_P2P_CLIENT,
 	NL80211_IFTYPE_P2P_GO,
 	NL80211_IFTYPE_P2P_DEVICE,
+	NL80211_IFTYPE_OCB,
 
 	/* keep last */
 	NUM_NL80211_IFTYPES,
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 1e46ffa..1b9d37f 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -26,7 +26,8 @@ mac80211-y := \
 	event.o \
 	chan.o \
 	trace.o mlme.o \
-	tdls.o
+	tdls.o \
+	ocb.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7c56445..91d16cd 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -228,6 +228,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case NUM_NL80211_IFTYPES:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_OCB:
 		/* shouldn't happen */
 		WARN_ON_ONCE(1);
 		break;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3702d64..6dd026d 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -253,6 +253,7 @@ ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_MESH_POINT:
+		case NL80211_IFTYPE_OCB:
 			width = vif->bss_conf.chandef.width;
 			break;
 		case NL80211_IFTYPE_UNSPECIFIED:
@@ -675,6 +676,7 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_MESH_POINT:
+		case NL80211_IFTYPE_OCB:
 			break;
 		default:
 			WARN_ON_ONCE(1);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index df1d502..ccf770d 100644
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
index 4668ce9..944ac24 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -529,6 +529,40 @@ struct ieee80211_if_ibss {
 };
 
 /**
+ * enum ocb_deferred_task_flags - mac80211 ocb deferred tasks
+ *
+ * @OCB_WORK_HOUSEKEEPING: run the periodic ocb housekeeping tasks
+ *  - expire station that has not been seen for long
+ */
+enum ocb_deferred_task_flags {
+	OCB_WORK_HOUSEKEEPING,
+};
+
+/**
+ * struct ieee80211_if_ocb - the specific struct for ocb-mode
+ *
+ * In this struct all ocb-specific information of an interface is stored.
+ *
+ * @timer: the timer used for all tasks in the ocb-code
+ * @work: holds the workqueue
+ * @skb_queue: holds all queued skb to be processed
+ * @wrkq_flags: bitmask telling what work is pending
+ * @timer_running: tells if the timer is running
+ * @bssid: holds the BSSID (IEEE802.11p defines this to be
+ *         ff:ff:ff:ff:ff:ff but this is more flexible)
+ */
+struct ieee80211_if_ocb {
+	struct timer_list timer;
+	struct work_struct work;
+
+	struct sk_buff_head skb_queue;
+
+	unsigned long wrkq_flags;
+	bool timer_running;
+	u8 bssid[ETH_ALEN];
+};
+
+/**
  * struct ieee80211_mesh_sync_ops - Extensible synchronization framework interface
  *
  * these declarations define the interface, which enables
@@ -802,6 +836,7 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_managed mgd;
 		struct ieee80211_if_ibss ibss;
 		struct ieee80211_if_mesh mesh;
+		struct ieee80211_if_ocb ocb;
 		u32 mntr_flags;
 	} u;
 
@@ -1421,6 +1456,9 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata);
 
+/* OCB code */
+void ieee80211_ocb_setup_sdata(struct ieee80211_sub_if_data *sdata);
+
 /* mesh code */
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 79fc988..03fcdf9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -258,6 +258,15 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
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
@@ -519,6 +528,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_OCB:
 		/* no special treatment */
 		break;
 	case NL80211_IFTYPE_UNSPECIFIED:
@@ -622,6 +632,17 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
 			changed |= ieee80211_reset_erp_info(sdata);
+
+		if (sdata->vif.type == NL80211_IFTYPE_OCB) {
+			/* Disable beacons */
+			sdata->vif.bss_conf.enable_beacon = false;
+			changed |= BSS_CHANGED_BEACON;
+
+			/* Receive all data frames */
+			local->fif_other_bss++;
+			ieee80211_configure_filter(local);
+		}
+
 		ieee80211_bss_info_change_notify(sdata, changed);
 
 		switch (sdata->vif.type) {
@@ -629,6 +650,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_MESH_POINT:
+		case NL80211_IFTYPE_OCB:
 			netif_carrier_off(dev);
 			break;
 		case NL80211_IFTYPE_WDS:
@@ -1324,6 +1346,10 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
 		ieee80211_sta_setup_sdata(sdata);
 		break;
+	case NL80211_IFTYPE_OCB:
+		ieee80211_ocb_setup_sdata(sdata);
+		sdata->vif.bss_conf.bssid = sdata->u.ocb.bssid;
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 		ieee80211_ibss_setup_sdata(sdata);
@@ -1371,6 +1397,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could maybe also all others here?
 		 * Just not sure how that interacts
@@ -1386,6 +1413,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could probably support everything
 		 * but WDS here (WDS do_open can fail
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
new file mode 100644
index 0000000..be66273
--- /dev/null
+++ b/net/mac80211/ocb.c
@@ -0,0 +1,115 @@
+/* OCB mode implementation
+ * Copyright 2009, Robert Budde <robert.budde@tu-dortmund.de>
+ * Copyright 2014, Czech Technical University in Prague, Rostislav Lisovy
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
+#define IEEE80211_OCB_HOUSEKEEPING_INTERVAL		(10 * HZ)
+#define IEEE80211_OCB_PEER_INACTIVITY_LIMIT		(60 * HZ)
+
+/**
+ * ieee80211_ocb_housekeeping - Housekeeping function (expires stations)
+ *
+ * @sdata:
+ * @ifocb:
+ *
+ * This function is used for all periodical clean up work.
+ * It expires all stations that have not shown up for a given period of time.
+ * After all cleanups have been done it schedules the next run.
+ */
+static void ieee80211_ocb_housekeeping(struct ieee80211_sub_if_data *sdata,
+			   struct ieee80211_if_ocb *ifocb)
+{
+	ieee80211_sta_expire(sdata, IEEE80211_OCB_PEER_INACTIVITY_LIMIT);
+
+	mod_timer(&ifocb->timer,
+		  round_jiffies(jiffies + IEEE80211_OCB_HOUSEKEEPING_INTERVAL));
+}
+
+/**
+ * ieee80211_ocb_work - Workqueue function
+ *
+ * @work:
+ *
+ * This function is called once the interface is started and periodically
+ * by the timer function when the timer expires.
+ * It checks whether the interface is suspended, running, scanning and of
+ * the right type. After all queued skbs have been processed it checks what
+ * tasks are to be done and calls the corresponding functions.
+ */
+static void ieee80211_ocb_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, u.ocb.work);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+
+
+	if (WARN_ON(local->suspended))
+		return;
+
+	if (!netif_running(sdata->dev))
+		return;
+
+	if (local->scanning)
+		return;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_OCB))
+		return;
+
+	if (test_and_clear_bit(OCB_WORK_HOUSEKEEPING, &ifocb->wrkq_flags))
+		ieee80211_ocb_housekeeping(sdata, ifocb);
+}
+
+/**
+ * ieee80211_ocb_timer - Timer function called when the timer expires
+ *
+ * @data: sdata structure
+ *
+ * This function is called everytime the timer expires (periodically)
+ * To make sure the housekeeping is done it sets the corresponding bit and
+ * then calls the workqueue.
+ */
+static void ieee80211_ocb_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata = (void *)data;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+
+	if (local->quiescing) {
+		ifocb->timer_running = true;
+		return;
+	}
+
+	set_bit(OCB_WORK_HOUSEKEEPING, &ifocb->wrkq_flags);
+	ieee80211_queue_work(&local->hw, &ifocb->work);
+}
+
+void ieee80211_ocb_setup_sdata(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ocb *ifocb = &sdata->u.ocb;
+
+	/* Wildcard BSSID */
+	memset(ifocb->bssid, 0xff, ETH_ALEN);
+
+	INIT_WORK(&ifocb->work, ieee80211_ocb_work);
+	setup_timer(&ifocb->timer, ieee80211_ocb_timer, (unsigned long)sdata);
+	skb_queue_head_init(&ifocb->skb_queue);
+}
+
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7e0dd4b..bf4fd61 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1689,6 +1689,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			ieee80211_bss_info_change_notify(sdata, changed);
 			sdata_unlock(sdata);
 			break;
+		case NL80211_IFTYPE_OCB:
+			changed |= BSS_CHANGED_IBSS |
+				   BSS_CHANGED_BEACON_ENABLED;
+			ieee80211_bss_info_change_notify(sdata, changed);
+			break;
 		case NL80211_IFTYPE_ADHOC:
 			changed |= BSS_CHANGED_IBSS;
 			/* fall through */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index a756429..91f47d2 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -935,6 +935,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			if (dev->ieee80211_ptr->use_4addr)
 				break;
 			/* fall through */
+		case NL80211_IFTYPE_OCB:
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_ADHOC:
 			dev->priv_flags |= IFF_DONT_BRIDGE;
-- 
2.0.0.rc0

