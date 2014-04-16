Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961AbaDPKnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:43:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51748 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaDPKcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:50 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 29/46] vlan: Set hard_header_len according to available acceleration
Date: Wed, 16 Apr 2014 11:31:45 +0100
Message-Id: <1397644322-13905-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

commit fc0d48b8fb449ca007b2057328abf736cb516168 upstream.

Currently, if the card supports CTAG acceleration we do not
account for the vlan header even if we are configuring an
8021AD vlan.  This may not be best since we'll do software
tagging for 8021AD which will cause data copy on skb head expansion
Configure the length based on available hw offload capabilities and
vlan protocol.

CC: Patrick McHardy <kaber@trash.net>
Signed-off-by: Vlad Yasevich <vyasevic@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/8021q/vlan.c     | 4 +++-
 net/8021q/vlan_dev.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index 2fb2d88..2c3a3b7 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -305,9 +305,11 @@ static void vlan_sync_address(struct net_device *dev,
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
index 48db858..cf35f38 100644
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
1.9.1

