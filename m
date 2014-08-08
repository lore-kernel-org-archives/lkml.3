Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbaHHUup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:50:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40852 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758459AbaHHUue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:50:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Loic Prylli <loicp@google.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 246/259] net: Fix NETDEV_CHANGE notifier usage causing spurious arp flush
Date: Fri,  8 Aug 2014 13:41:09 -0700
Message-Id: <1407530482-4483-247-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Prylli <loicp@google.com>

[ Upstream commit 54951194656e4853e441266fd095f880bc0398f3 ]

A bug was introduced in NETDEV_CHANGE notifier sequence causing the
arp table to be sometimes spuriously cleared (including manual arp
entries marked permanent), upon network link carrier changes.

The changed argument for the notifier was applied only to a single
caller of NETDEV_CHANGE, missing among others netdev_state_change().
So upon net_carrier events induced by the network, which are
triggering a call to netdev_state_change(), arp_netdev_event() would
decide whether to clear or not arp cache based on random/junk stack
values (a kind of read buffer overflow).

Fixes: be9efd365328 ("net: pass changed flags along with NETDEV_CHANGE event")
Fixes: 6c8b4e3ff81b ("arp: flush arp cache on IFF_NOARP change")
Signed-off-by: Loic Prylli <loicp@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.13-stable from David's 3.14 port
 (call_netdevice_notifiers_info is not static) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9e8b117..e61bda3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1203,7 +1203,11 @@ EXPORT_SYMBOL(netdev_features_change);
 void netdev_state_change(struct net_device *dev)
 {
 	if (dev->flags & IFF_UP) {
-		call_netdevice_notifiers(NETDEV_CHANGE, dev);
+		struct netdev_notifier_change_info change_info;
+
+		change_info.flags_changed = 0;
+		call_netdevice_notifiers_info(NETDEV_CHANGE, dev,
+					      &change_info.info);
 		rtmsg_ifinfo(RTM_NEWLINK, dev, 0, GFP_KERNEL);
 	}
 }
-- 
1.9.1

