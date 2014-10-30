Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbaJ3Knm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:43:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63221 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbaJ3KnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:43:23 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
X-Google-Original-From: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
To: Johannes Berg <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de, burak.simsek@volkswagen.de,
        Emmanuel Thierry <emmanuel.thierry@yogoko.fr>,
        laszlo.virag@commsignia.com, lisovy@gmail.com,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 1/2] cfg80211: 802.11p OCB mode handling
Date: Thu, 30 Oct 2014 11:42:50 +0100
Message-Id: <1414665771-8371-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1414665771-8371-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1414665771-8371-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new iface type (NL80211_IFTYPE_OCB) representing
the OCB (Outside the Context of a BSS) mode.
When establishing a connection to the network a cfg80211_join_ocb
function is called (particular nl80211_command is added as well).
A mandatory parameters during the ocb_join operation are 'center
frequency' and 'channel width (5/10 MHz)'.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/net/cfg80211.h       | 14 +++++++
 include/net/mac80211.h       |  2 +
 include/uapi/linux/nl80211.h | 10 +++++
 net/wireless/Makefile        |  2 +-
 net/wireless/chan.c          |  8 ++++
 net/wireless/core.h          | 10 +++++
 net/wireless/nl80211.c       | 41 ++++++++++++++++++++
 net/wireless/ocb.c           | 89 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 21 +++++++++++
 net/wireless/trace.h         | 21 +++++++++++
 net/wireless/util.c          |  5 ++-
 11 files changed, 221 insertions(+), 2 deletions(-)
 create mode 100644 net/wireless/ocb.c

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f67948e..490b3d8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1359,6 +1359,16 @@ struct mesh_setup {
 };
 
 /**
+ * struct ocb_setup - 802.11p OCB mode setup configuration
+ * @chandef: defines the channel to use
+ *
+ * These parameters are fixed when connecting to the network
+ */
+struct ocb_setup {
+	struct cfg80211_chan_def chandef;
+};
+
+/**
  * struct ieee80211_txq_params - TX queue parameters
  * @ac: AC identifier
  * @txop: Maximum burst time in units of 32 usecs, 0 meaning disabled
@@ -2433,6 +2443,10 @@ struct cfg80211_ops {
 			     const struct mesh_setup *setup);
 	int	(*leave_mesh)(struct wiphy *wiphy, struct net_device *dev);
 
+	int	(*join_ocb)(struct wiphy *wiphy, struct net_device *dev,
+			    struct ocb_setup *setup);
+	int	(*leave_ocb)(struct wiphy *wiphy, struct net_device *dev);
+
 	int	(*change_bss)(struct wiphy *wiphy, struct net_device *dev,
 			      struct bss_parameters *params);
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1614b2f..047b0d1 100644
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
index f7daae5..b381ba7 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -746,6 +746,11 @@
  *	destination %NL80211_ATTR_MAC on the interface identified by
  *	%NL80211_ATTR_IFINDEX.
  *
+ * @NL80211_CMD_JOIN_OCB: Join the OCB network. The center frequency and
+ *	bandwidth of a channel must be given.
+ * @NL80211_CMD_LEAVE_OCB: Leave the OCB network -- no special arguments, the
+ *	network is determined by the network interface.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -922,6 +927,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_MPP,
 
+	NL80211_CMD_JOIN_OCB,
+	NL80211_CMD_LEAVE_OCB,
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2074,6 +2081,8 @@ enum nl80211_attrs {
  *	and therefore can't be created in the normal ways, use the
  *	%NL80211_CMD_START_P2P_DEVICE and %NL80211_CMD_STOP_P2P_DEVICE
  *	commands to create and destroy one
+ * @NL80211_IF_TYPE_OCB: Outside Context of a BSS
+ *	This mode corresponds to the MIB variable dot11OCBActivated=true
  * @NL80211_IFTYPE_MAX: highest interface type number currently defined
  * @NUM_NL80211_IFTYPES: number of defined interface types
  *
@@ -2093,6 +2102,7 @@ enum nl80211_iftype {
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
index 8f39e33..85506f1d 100644
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
+			*chanmode = CHAN_MODE_SHARED;
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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33aff74..13d6931 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8271,6 +8271,31 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 	return -EINVAL;
 }
 
+static int nl80211_join_ocb(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct ocb_setup setup = {};
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ])
+		return -EINVAL;
+
+	err = nl80211_parse_chandef(rdev, info, &setup.chandef);
+	if (err)
+		return err;
+
+	return cfg80211_join_ocb(rdev, dev, &setup);
+}
+
+static int nl80211_leave_ocb(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+
+	return cfg80211_leave_ocb(rdev, dev);
+}
+
 static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -10214,6 +10239,22 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_JOIN_OCB,
+		.doit = nl80211_join_ocb,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_LEAVE_OCB,
+		.doit = nl80211_leave_ocb,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 #ifdef CONFIG_PM
 	{
 		.cmd = NL80211_CMD_GET_WOWLAN,
diff --git a/net/wireless/ocb.c b/net/wireless/ocb.c
new file mode 100644
index 0000000..dc82e1d
--- /dev/null
+++ b/net/wireless/ocb.c
@@ -0,0 +1,89 @@
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
+	if (WARN_ON(!setup->chandef.chan))
+		return -EINVAL;
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
index 71b1db3..1b3864c 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -348,6 +348,27 @@ static inline int rdev_leave_mesh(struct cfg80211_registered_device *rdev,
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
index cdb2c2e..277a85d 100644
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
@@ -1316,6 +1321,22 @@ TRACE_EVENT(rdev_join_ibss,
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
index 5e233a5..d0ac795 100644
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

