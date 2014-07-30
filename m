Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaG3Mce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:32:34 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36730 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916AbaG3MPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Loic Prylli <loicp@google.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 45/94] net: Fix NETDEV_CHANGE notifier usage causing spurious arp flush
Date: Wed, 30 Jul 2014 14:14:34 +0200
Message-Id: <4c824ea2e6272f897012dacbced560b9aa11fd46.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Loic Prylli <loicp@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/core/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 704c0c5bed1f..ef2f239cc322 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1202,7 +1202,11 @@ EXPORT_SYMBOL(netdev_features_change);
 void netdev_state_change(struct net_device *dev)
 {
 	if (dev->flags & IFF_UP) {
-		call_netdevice_notifiers(NETDEV_CHANGE, dev);
+		struct netdev_notifier_change_info change_info;
+
+		change_info.flags_changed = 0;
+		call_netdevice_notifiers_info(NETDEV_CHANGE, dev,
+					      &change_info.info);
 		rtmsg_ifinfo(RTM_NEWLINK, dev, 0);
 	}
 }
-- 
2.0.1

