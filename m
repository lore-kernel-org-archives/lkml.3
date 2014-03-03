Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaCCWrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 17:47:22 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39702 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565AbaCCWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 17:47:19 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, mcgrof@suse.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org
Subject: [RFC v3 1/6] bridge: preserve random init MAC address
Date: Mon,  3 Mar 2014 14:47:00 -0800
Message-Id: <1393886825-24323-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
References: <1393886825-24323-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

As it is now if you add create a bridge it gets started
with a random MAC address and if you then add a net_device
as a slave but later kick it out you end up with a zero
MAC address. Instead preserve the original random MAC
address and use it.

If you manually set the bridge address that will always
be respected. This change only takes effect if at the time
of computing the new root port we determine we have found
no candidates.

Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: bridge@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
Cc: kvm@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 net/bridge/br_device.c  | 1 +
 net/bridge/br_private.h | 1 +
 net/bridge/br_stp_if.c  | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index b063050..5f13eac 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -368,6 +368,7 @@ void br_dev_setup(struct net_device *dev)
 	br->bridge_id.prio[1] = 0x00;
 
 	ether_addr_copy(br->group_addr, eth_reserved_addr_base);
+	ether_addr_copy(br->random_init_addr, dev->dev_addr);
 
 	br->stp_enabled = BR_NO_STP;
 	br->group_fwd_mask = BR_GROUPFWD_DEFAULT;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index e1ca1dc..32a06da 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -240,6 +240,7 @@ struct net_bridge
 	unsigned long			bridge_hello_time;
 	unsigned long			bridge_forward_delay;
 
+	u8				random_init_addr[ETH_ALEN];
 	u8				group_addr[ETH_ALEN];
 	u16				root_port;
 
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 189ba1e..4c9ad45 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -239,6 +239,9 @@ bool br_stp_recalculate_bridge_id(struct net_bridge *br)
 	if (ether_addr_equal(br->bridge_id.addr, addr))
 		return false;	/* no change */
 
+	if (ether_addr_equal(addr, br_mac_zero))
+		addr = br->random_init_addr;
+
 	br_stp_change_bridge_id(br, addr);
 	return true;
 }
-- 
1.9.0

