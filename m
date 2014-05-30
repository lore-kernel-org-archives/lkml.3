Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934276AbaE3Q4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:56:55 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57690 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934203AbaE3Q4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:56:40 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [RFC 4/4] mac80211: OCB mode interface configuration
Date: Fri, 30 May 2014 18:56:24 +0200
Message-Id: <1401468984-24575-5-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add functions necessary for OCB mode interface configuration
used in interface bring-up and when 'joining' the network.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 net/mac80211/Makefile      |  3 ++-
 net/mac80211/cfg.c         | 22 ++++++++++++++++++++++
 net/mac80211/chan.c        |  1 +
 net/mac80211/driver-ops.h  |  3 ++-
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/iface.c       | 22 ++++++++++++++++++++++
 net/mac80211/ocb.c         | 22 ++++++++++++++++++++++
 net/mac80211/util.c        |  5 +++++
 8 files changed, 79 insertions(+), 2 deletions(-)
 create mode 100644 net/mac80211/ocb.c

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
index 7c56445..ac15b59 100644
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
@@ -2032,6 +2033,26 @@ static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
 }
 #endif
 
+static int ieee80211_join_ocb(struct wiphy *wiphy, struct net_device *dev,
+			      struct ocb_setup *setup)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
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
+	return ieee80211_start_ocb(sdata);
+}
+
 static int ieee80211_change_bss(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct bss_parameters *params)
@@ -3768,6 +3789,7 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.join_mesh = ieee80211_join_mesh,
 	.leave_mesh = ieee80211_leave_mesh,
 #endif
+	.join_ocb = ieee80211_join_ocb,
 	.change_bss = ieee80211_change_bss,
 	.set_txq_params = ieee80211_set_txq_params,
 	.set_monitor_channel = ieee80211_set_monitor_channel,
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 3702d64..62002de 100644
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
index 4668ce9..002fd8f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1421,6 +1421,9 @@ int ieee80211_ibss_csa_beacon(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_finish_csa(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_stop(struct ieee80211_sub_if_data *sdata);
 
+/* OCB code */
+int ieee80211_start_ocb(struct ieee80211_sub_if_data *sdata);
+
 /* mesh code */
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 79fc988..23e573e 100644
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
@@ -618,6 +628,9 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			ieee80211_configure_filter(local);
 		} else if (sdata->vif.type == NL80211_IFTYPE_ADHOC) {
 			local->fif_probe_req++;
+		} else if (sdata->vif.type == NL80211_IFTYPE_OCB) {
+			local->fif_other_bss++;
+			ieee80211_configure_filter(local);
 		}
 
 		if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
@@ -629,6 +642,7 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_MESH_POINT:
+		case NL80211_IFTYPE_OCB:
 			netif_carrier_off(dev);
 			break;
 		case NL80211_IFTYPE_WDS:
@@ -1274,6 +1288,9 @@ static void ieee80211_recalc_smps_work(struct work_struct *work)
 static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 				  enum nl80211_iftype type)
 {
+	static u8 bssid_wildcard[ETH_ALEN] = { 0xff, 0xff, 0xff,
+					       0xff, 0xff, 0xff };
+
 	/* clear type-dependent union */
 	memset(&sdata->u, 0, sizeof(sdata->u));
 
@@ -1324,6 +1341,9 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = sdata->u.mgd.bssid;
 		ieee80211_sta_setup_sdata(sdata);
 		break;
+	case NL80211_IFTYPE_OCB:
+		sdata->vif.bss_conf.bssid = bssid_wildcard;
+		break;
 	case NL80211_IFTYPE_ADHOC:
 		sdata->vif.bss_conf.bssid = sdata->u.ibss.bssid;
 		ieee80211_ibss_setup_sdata(sdata);
@@ -1371,6 +1391,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could maybe also all others here?
 		 * Just not sure how that interacts
@@ -1386,6 +1407,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_OCB:
 		/*
 		 * Could probably support everything
 		 * but WDS here (WDS do_open can fail
diff --git a/net/mac80211/ocb.c b/net/mac80211/ocb.c
new file mode 100644
index 0000000..2dd9723
--- /dev/null
+++ b/net/mac80211/ocb.c
@@ -0,0 +1,22 @@
+ /* OCB mode implementation
+ * Copyright 2014, Czech Technical University in Prague, Rostislav Lisovy
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "ieee80211_i.h"
+
+int ieee80211_start_ocb(struct ieee80211_sub_if_data *sdata)
+{
+	u32 changed = BSS_CHANGED_BEACON_ENABLED;
+
+	sdata->vif.bss_conf.enable_beacon = false;
+	ieee80211_bss_info_change_notify(sdata, changed);
+
+	/* MORE TO BE DONE ... */
+
+	netif_carrier_on(sdata->dev);
+	return 0;
+}
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
-- 
2.0.0.rc4

