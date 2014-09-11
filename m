Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaIKObx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:31:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61286 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaIKOar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:30:47 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com, lisovy@gmail.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 3/4] cfg80211: Join and Leave handling for OCB mode
Date: Thu, 11 Sep 2014 16:30:21 +0200
Message-Id: <1410445822-6559-4-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h  | 11 +++++++
 net/wireless/Makefile   |  2 +-
 net/wireless/chan.c     |  8 +++++
 net/wireless/core.h     | 10 ++++++
 net/wireless/ocb.c      | 88 +++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h | 21 ++++++++++++
 net/wireless/trace.h    | 21 ++++++++++++
 net/wireless/util.c     |  5 ++-
 8 files changed, 164 insertions(+), 2 deletions(-)
 create mode 100644 net/wireless/ocb.c

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0d17ec9..0897e33 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -375,6 +375,8 @@ static inline enum nl80211_channel_type
 cfg80211_get_chandef_type(const struct cfg80211_chan_def *chandef)
 {
 	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		return NL80211_CHAN_NO_HT;
 	case NL80211_CHAN_WIDTH_20:
@@ -1337,6 +1339,11 @@ struct mesh_setup {
 	u32 basic_rates;
 };
 
+
+struct ocb_setup {
+	struct cfg80211_chan_def chandef;
+};
+
 /**
  * struct ieee80211_txq_params - TX queue parameters
  * @ac: AC identifier
@@ -2396,6 +2403,10 @@ struct cfg80211_ops {
 			     const struct mesh_setup *setup);
 	int	(*leave_mesh)(struct wiphy *wiphy, struct net_device *dev);
 
+	int	(*join_ocb)(struct wiphy *wiphy, struct net_device *dev,
+			    struct ocb_setup *setup);
+	int	(*leave_ocb)(struct wiphy *wiphy, struct net_device *dev);
+
 	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
 			      struct bss_parameters *params);
 
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index a761670..4c9e39f 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_WEXT_SPY) += wext-spy.o
 obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
-cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o trace.o
+cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o trace.o ocb.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 cfg80211-$(CONFIG_CFG80211_INTERNAL_REGDB) += regdb.o
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 72d81e2..6e6829c 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -366,6 +366,7 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 
 		break;
 	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP_VLAN:
@@ -892,6 +893,13 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
+	case NL80211_IFTYPE_OCB:
+		if (wdev->chandef.chan) {
+			*chan = wdev->chandef.chan;
+			*chanmode = CHAN_MODE_EXCLUSIVE;
+			return;
+		}
+		break;
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 7e3a3ce..8230c18 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -290,6 +290,16 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev,
 			      struct cfg80211_chan_def *chandef);
 
+/* OCB */
+int __cfg80211_join_ocb(struct cfg80211_registered_device *rdev,
+			struct net_device *dev,
+			struct ocb_setup *setup);
+int cfg80211_join_ocb(struct cfg80211_registered_device *rdev,
+		      struct net_device *dev,
+		      struct ocb_setup *setup);
+int cfg80211_leave_ocb(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev);
+
 /* AP */
 int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev, bool notify);
diff --git a/net/wireless/ocb.c b/net/wireless/ocb.c
new file mode 100644
index 0000000..d288ae6
--- /dev/null
+++ b/net/wireless/ocb.c
@@ -0,0 +1,88 @@
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
+#include <linux/ieee80211.h>
+#include <net/cfg80211.h>
+#include "nl80211.h"
+#include "core.h"
+#include "rdev-ops.h"
+
+int __cfg80211_join_ocb(struct cfg80211_registered_device *rdev,
+			struct net_device *dev,
+			struct ocb_setup *setup)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_OCB)
+		return -EOPNOTSUPP;
+
+	WARN_ON(!setup->chandef.chan);
+
+	err = rdev_join_ocb(rdev, dev, setup);
+	if (!err)
+		wdev->chandef = setup->chandef;
+
+	return err;
+}
+
+int cfg80211_join_ocb(struct cfg80211_registered_device *rdev,
+		      struct net_device *dev,
+		      struct ocb_setup *setup)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_join_ocb(rdev, dev, setup);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
+static int __cfg80211_leave_ocb(struct cfg80211_registered_device *rdev,
+				struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_OCB)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->leave_ocb)
+		return -EOPNOTSUPP;
+
+	err = rdev_leave_ocb(rdev, dev);
+	if (!err)
+		memset(&wdev->chandef, 0, sizeof(wdev->chandef));
+
+	return err;
+}
+
+int cfg80211_leave_ocb(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_leave_ocb(rdev, dev);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 56c2240..b1f7685 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -322,6 +322,27 @@ static inline int rdev_leave_mesh(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_join_ocb(struct cfg80211_registered_device *rdev,
+				struct net_device *dev,
+				struct ocb_setup *setup)
+{
+	int ret;
+	trace_rdev_join_ocb(&rdev->wiphy, dev, setup);
+	ret = rdev->ops->join_ocb(&rdev->wiphy, dev, setup);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int rdev_leave_ocb(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev)
+{
+	int ret;
+	trace_rdev_leave_ocb(&rdev->wiphy, dev);
+	ret = rdev->ops->leave_ocb(&rdev->wiphy, dev);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_change_bss(struct cfg80211_registered_device *rdev,
 				  struct net_device *dev,
 				  struct bss_parameters *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0c524cd..465530e 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -600,6 +600,11 @@ DEFINE_EVENT(wiphy_netdev_evt, rdev_leave_ibss,
 	TP_ARGS(wiphy, netdev)
 );
 
+DEFINE_EVENT(wiphy_netdev_evt, rdev_leave_ocb,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
 DEFINE_EVENT(wiphy_netdev_evt, rdev_flush_pmksa,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
 	TP_ARGS(wiphy, netdev)
@@ -1246,6 +1251,22 @@ TRACE_EVENT(rdev_join_ibss,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(bssid), __entry->ssid)
 );
 
+TRACE_EVENT(rdev_join_ocb,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const struct ocb_setup *setup),
+	TP_ARGS(wiphy, netdev, setup),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG)
+);
+
 TRACE_EVENT(rdev_set_wiphy_params,
 	TP_PROTO(struct wiphy *wiphy, u32 changed),
 	TP_ARGS(wiphy, changed),
diff --git a/net/wireless/util.c b/net/wireless/util.c
index a8b2816..b253f5f 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -442,7 +442,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		break;
 	case cpu_to_le16(0):
 		if (iftype != NL80211_IFTYPE_ADHOC &&
-		    iftype != NL80211_IFTYPE_STATION)
+		    iftype != NL80211_IFTYPE_STATION &&
+		    iftype != NL80211_IFTYPE_OCB)
 				return -1;
 		break;
 	}
@@ -519,6 +520,7 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		hdrlen = 24;
 		break;
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_ADHOC:
 		/* DA SA BSSID */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -937,6 +939,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			if (dev->ieee80211_ptr->use_4addr)
 				break;
 			/* fall through */
+		case NL80211_IFTYPE_OCB:
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_ADHOC:
 			dev->priv_flags |= IFF_DONT_BRIDGE;
-- 
2.0.0.rc4

