Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151AbaDRJam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:30:42 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:46017 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752371AbaDRJWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Yasevich <vyasevic@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 59/72] vlan: Set hard_header_len according to available acceleration
Date: Fri, 18 Apr 2014 11:22:32 +0200
Message-Id: <9ef39f43c0380ea34c0f2d8fc669a81cebd91d4e.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vlad Yasevich <vyasevic@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit fc0d48b8fb449ca007b2057328abf736cb516168 ]

Currently, if the card supports CTAG acceleration we do not
account for the vlan header even if we are configuring an
8021AD vlan.  This may not be best since we'll do software
tagging for 8021AD which will cause data copy on skb head expansion
Configure the length based on available hw offload capabilities and
vlan protocol.

CC: Patrick McHardy <kaber@trash.net>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/8021q/vlan.c     | 4 +++-
 net/8021q/vlan_dev.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 61fc573f1142..856499fdb10f 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -307,9 +307,11 @@ static void vlan_sync_address(struct net_device *dev,
 static void vlan_transfer_features(struct net_device *dev,
 				   struct net_device *vlandev)
 {
+	struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
+
 	vlandev->gso_max_size = dev->gso_max_size;
 
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+	if (vlan_hw_offload_capable(dev->features, vlan->vlan_proto))
 		vlandev->hard_header_len = dev->hard_header_len;
 	else
 		vlandev->hard_header_len = dev->hard_header_len + VLAN_HLEN;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index dc7d8da441dd..d1537dcd4df8 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -611,7 +611,8 @@ static int vlan_dev_init(struct net_device *dev)
 #endif
 
 	dev->needed_headroom = real_dev->needed_headroom;
-	if (real_dev->features & NETIF_F_HW_VLAN_CTAG_TX) {
+	if (vlan_hw_offload_capable(real_dev->features,
+				    vlan_dev_priv(dev)->vlan_proto)) {
 		dev->header_ops      = &vlan_passthru_header_ops;
 		dev->hard_header_len = real_dev->hard_header_len;
 	} else {
-- 
1.9.2

