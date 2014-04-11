Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423086AbaDKQiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:38:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759606AbaDKQJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>, Vlad Yasevich <vyasevic@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 45/65] vlan: Set hard_header_len according to available acceleration
Date: Fri, 11 Apr 2014 09:11:17 -0700
Message-Id: <20140411161003.901014749@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevic@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.c     |    4 +++-
 net/8021q/vlan_dev.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -307,9 +307,11 @@ static void vlan_sync_address(struct net
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
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -592,7 +592,8 @@ static int vlan_dev_init(struct net_devi
 #endif
 
 	dev->needed_headroom = real_dev->needed_headroom;
-	if (real_dev->features & NETIF_F_HW_VLAN_CTAG_TX) {
+	if (vlan_hw_offload_capable(real_dev->features,
+				    vlan_dev_priv(dev)->vlan_proto)) {
 		dev->header_ops      = &vlan_passthru_header_ops;
 		dev->hard_header_len = real_dev->hard_header_len;
 	} else {


