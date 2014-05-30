Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbaE3Q6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:58:00 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47644 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934081AbaE3Q4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:56:38 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [RFC 2/4] cfg80211: Add new interface type for OCB mode
Date: Fri, 30 May 2014 18:56:22 +0200
Message-Id: <1401468984-24575-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1401468984-24575-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new OCB mode (outside the context of the BSS) interface
type as well as functions necessary to configure the interface
when 'joining' such network.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h       |  7 +++++
 include/uapi/linux/nl80211.h |  3 ++
 net/wireless/Makefile        |  2 +-
 net/wireless/chan.c          |  2 ++
 net/wireless/core.h          |  8 +++++
 net/wireless/nl80211.c       |  1 +
 net/wireless/ocb.c           | 75 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 11 +++++++
 net/wireless/trace.h         | 17 ++++++++++
 net/wireless/util.c          |  5 ++-
 10 files changed, 129 insertions(+), 2 deletions(-)
 create mode 100644 net/wireless/ocb.c

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6722ab2..c3879b8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1314,6 +1314,11 @@ struct mesh_setup {
 	u32 basic_rates;
 };
 
+struct ocb_setup {
+	struct cfg80211_chan_def chandef;
+	u32 basic_rates;
+};
+
 /**
  * struct ieee80211_txq_params - TX queue parameters
  * @ac: AC identifier
@@ -2371,6 +2376,8 @@ struct cfg80211_ops {
 			     const struct mesh_setup *setup);
 	int	(*leave_mesh)(struct wiphy *wiphy, struct net_device *dev);
 
+	int	(*join_ocb)(struct wiphy *wiphy, struct net_device *dev,
+			    struct ocb_setup *setup);
 	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
 			      struct bss_parameters *params);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 970c5df..250b8d8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1994,6 +1994,8 @@ enum nl80211_attrs {
  *	and therefore can't be created in the normal ways, use the
  *	%NL80211_CMD_START_P2P_DEVICE and %NL80211_CMD_STOP_P2P_DEVICE
  *	commands to create and destroy one
+ * @NL80211_IF_TYPE_OCB: outside context of a bss
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
index 84d686e..a457085 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -370,6 +370,7 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
 	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_UNSPECIFIED:
 		break;
 	case NUM_NL80211_IFTYPES:
@@ -892,6 +893,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_AP_VLAN:
 	case NL80211_IFTYPE_WDS:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index e9afbf1..3d8fde5 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -290,6 +290,14 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev,
 			      struct cfg80211_chan_def *chandef);
 
+/* OCB */
+int __cfg80211_join_ocb(struct cfg80211_registered_device *rdev,
+			struct net_device *dev,
+			struct ocb_setup *setup);
+int cfg80211_join_ocb(struct cfg80211_registered_device *rdev,
+		      struct net_device *dev,
+		      struct ocb_setup *setup);
+
 /* AP */
 int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev, bool notify);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c766c31..79bae31 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1859,6 +1859,7 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 	 * operation to set the monitor channel if possible.
 	 */
 	return !wdev ||
+		wdev->iftype == NL80211_IFTYPE_OCB ||
 		wdev->iftype == NL80211_IFTYPE_AP ||
 		wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
 		wdev->iftype == NL80211_IFTYPE_MONITOR ||
diff --git a/net/wireless/ocb.c b/net/wireless/ocb.c
new file mode 100644
index 0000000..66da583
--- /dev/null
+++ b/net/wireless/ocb.c
@@ -0,0 +1,75 @@
+/* OCB mode implementation
+ * Copyright 2014, Czech Technical University in Prague, Rostislav Lisovy
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
+	if (!setup->chandef.chan)
+		WARN_ON(!setup->chandef.chan);
+
+	 /* In OCB mode only those channels flagged with 'CHAN_OCB_ONLY'
+	  * may be used
+	  */
+	if (dev->ieee80211_ptr->iftype == NL80211_IFTYPE_OCB &&
+	    !(setup->chandef.chan->flags & IEEE80211_CHAN_OCB_ONLY))
+		return -EINVAL;
+
+	 /* check if basic rates are available otherwise use mandatory
+	  * rates as basic rates
+	  */
+	if (!setup->basic_rates) {
+		enum nl80211_bss_scan_width scan_width;
+		struct ieee80211_supported_band *sband =
+				rdev->wiphy.bands[setup->chandef.chan->band];
+		scan_width = cfg80211_chandef_to_scan_width(&setup->chandef);
+		setup->basic_rates = ieee80211_mandatory_rates(sband,
+							       scan_width);
+	}
+
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   setup->chandef.chan,
+					   CHAN_MODE_EXCLUSIVE, 0);
+	if (err)
+		return err;
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
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 00cdf73..2f2fa14 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -322,6 +322,17 @@ static inline int rdev_leave_mesh(struct cfg80211_registered_device *rdev,
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
 static inline int rdev_change_bss(struct cfg80211_registered_device *rdev,
 				  struct net_device *dev,
 				  struct bss_parameters *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index cdfbb00..f4e2cc3 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1256,6 +1256,23 @@ TRACE_EVENT(rdev_join_ibss,
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
+
 TRACE_EVENT(rdev_set_wiphy_params,
 	TP_PROTO(struct wiphy *wiphy, u32 changed),
 	TP_ARGS(wiphy, changed),
diff --git a/net/wireless/util.c b/net/wireless/util.c
index a756429..019e34c 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -441,7 +441,8 @@ int ieee80211_data_to_8023(struct sk_buff *skb, const u8 *addr,
 		break;
 	case cpu_to_le16(0):
 		if (iftype != NL80211_IFTYPE_ADHOC &&
-		    iftype != NL80211_IFTYPE_STATION)
+		    iftype != NL80211_IFTYPE_STATION &&
+		    iftype != NL80211_IFTYPE_OCB)
 				return -1;
 		break;
 	}
@@ -517,6 +518,7 @@ int ieee80211_data_from_8023(struct sk_buff *skb, const u8 *addr,
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		hdrlen = 24;
 		break;
+	case NL80211_IFTYPE_OCB:
 	case NL80211_IFTYPE_ADHOC:
 		/* DA SA BSSID */
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
@@ -935,6 +937,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			if (dev->ieee80211_ptr->use_4addr)
 				break;
 			/* fall through */
+		case NL80211_IFTYPE_OCB:
 		case NL80211_IFTYPE_P2P_CLIENT:
 		case NL80211_IFTYPE_ADHOC:
 			dev->priv_flags |= IFF_DONT_BRIDGE;
-- 
2.0.0.rc4

