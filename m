Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966388AbaCUBbT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:31:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760188AbaCUADR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Flavio Leitner <fbl@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 009/149] veth: Fix vlan_features so as to be able to use stacked vlan interfaces
Date: Thu, 20 Mar 2014 17:02:52 -0700
Message-Id: <20140321000437.270119678@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

[ Upstream commit 8d0d21f4053c07714802cbe8b1fe26913ec296cc ]

Even if we create a stacked vlan interface such as veth0.10.20, it sends
single tagged frames (tagged with only vid 10).
Because vlan_features of a veth interface has the
NETIF_F_HW_VLAN_[CTAG/STAG]_TX bits, veth0.10 also has that feature, so
dev_hard_start_xmit(veth0.10) doesn't call __vlan_put_tag() and
vlan_dev_hard_start_xmit(veth0.10) overwrites vlan_tci.
This prevents us from using a combination of 802.1ad and 802.1Q
in containers, etc.

Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Acked-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/veth.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -285,7 +285,8 @@ static void veth_setup(struct net_device
 	dev->ethtool_ops = &veth_ethtool_ops;
 	dev->features |= NETIF_F_LLTX;
 	dev->features |= VETH_FEATURES;
-	dev->vlan_features = dev->features;
+	dev->vlan_features = dev->features &
+			     ~(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX);
 	dev->destructor = veth_dev_free;
 
 	dev->hw_features = VETH_FEATURES;


