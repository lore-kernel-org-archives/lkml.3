Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbaCCWr1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:47:27 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58086 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbaCCWrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:47:23 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, mcgrof@suse.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org
Subject: [RFC v3 2/6] bridge: trigger a bridge calculation upon port changes
Date: Mon,  3 Mar 2014 14:47:01 -0800
Message-Id: <1393886825-24323-3-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
References: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

If netlink is used to tune a port we currently don't trigger a
new recalculation of the bridge id, ensure that happens just as
if we're adding a new net_device onto the bridge.

Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
Cc: kvm@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 net/bridge/br_netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index e74b6d53..6f1b26d 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -364,6 +364,7 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh)
 	struct net_bridge_port *p;
 	struct nlattr *tb[IFLA_BRPORT_MAX + 1];
 	int err = 0;
+	bool changed;
 
 	protinfo = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_PROTINFO);
 	afspec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
@@ -386,7 +387,12 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh)
 
 			spin_lock_bh(&p->br->lock);
 			err = br_setport(p, tb);
+			changed = br_stp_recalculate_bridge_id(p->br);
 			spin_unlock_bh(&p->br->lock);
+			if (changed)
+				call_netdevice_notifiers(NETDEV_CHANGEADDR,
+							 p->br->dev);
+			netdev_update_features(p->br->dev);
 		} else {
 			/* Binary compatibility with old RSTP */
 			if (nla_len(protinfo) < sizeof(u8))
-- 
1.9.0

