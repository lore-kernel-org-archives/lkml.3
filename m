Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbaIKOay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:30:54 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59905 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaIKOat (ORCPT
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
Subject: [PATCH 4/4] nl80211: Join and Leave handling for OCB mode
Date: Thu, 11 Sep 2014 16:30:22 +0200
Message-Id: <1410445822-6559-5-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1410445822-6559-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 include/uapi/linux/nl80211.h |  8 ++++++++
 net/wireless/nl80211.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cdf9ba4..4b39455 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -544,6 +544,11 @@
  * @NL80211_CMD_LEAVE_MESH: Leave the mesh network -- no special arguments, the
  *	network is determined by the network interface.
  *
+ * @NL80211_CMD_JOIN_OCB: Join the OCB network. The center frequency and
+ *	bandwidth of a channel must be given.
+ * @NL80211_CMD_LEAVE_OCB: Leave the OCB network -- no special arguments, the
+ *	network is determined by the network interface.
+ *
  * @NL80211_CMD_UNPROT_DEAUTHENTICATE: Unprotected deauthentication frame
  *	notification. This event is used to indicate that an unprotected
  *	deauthentication frame was dropped when MFP is in use.
@@ -833,6 +838,9 @@ enum nl80211_commands {
 	NL80211_CMD_JOIN_MESH,
 	NL80211_CMD_LEAVE_MESH,
 
+	NL80211_CMD_JOIN_OCB,
+	NL80211_CMD_LEAVE_OCB,
+
 	NL80211_CMD_UNPROT_DEAUTHENTICATE,
 	NL80211_CMD_UNPROT_DISASSOCIATE,
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cf178d2..bfbb54d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1876,6 +1876,7 @@ static bool nl80211_can_set_dev_channel(struct wireless_dev *wdev)
 	 * operation to set the monitor channel if possible.
 	 */
 	return !wdev ||
+		wdev->iftype == NL80211_IFTYPE_OCB ||
 		wdev->iftype == NL80211_IFTYPE_AP ||
 		wdev->iftype == NL80211_IFTYPE_MESH_POINT ||
 		wdev->iftype == NL80211_IFTYPE_MONITOR ||
@@ -2307,6 +2308,8 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 			chandef->chan->center_freq))
 		return -ENOBUFS;
 	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
 	case NL80211_CHAN_WIDTH_40:
@@ -8118,6 +8121,34 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 	return -EINVAL;
 }
 
+static int nl80211_join_ocb(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct ocb_setup setup;
+	int err;
+
+	/* start with default */
+	memset(&setup, 0x0, sizeof(setup));
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
@@ -9952,6 +9983,22 @@ static const struct genl_ops nl80211_ops[] = {
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
-- 
2.0.0.rc4

