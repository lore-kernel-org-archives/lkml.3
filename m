Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaKFXYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:24:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58440 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKFWh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:37:29 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Francesco Ruggeri <fruggeri@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 015/162] net: allow macvlans to move to net namespace
Date: Thu,  6 Nov 2014 14:34:39 -0800
Message-Id: <1415313426-9622-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Ruggeri <fruggeri@arista.com>

[ Upstream commit 0d0162e7a33d3710b9604e7c68c0f31f5c457428 ]

I cannot move a macvlan interface created on top of a bonding interface
to a different namespace:

% ip netns add dummy0
% ip link add link bond0 mac0 type macvlan
% ip link set mac0 netns dummy0
RTNETLINK answers: Invalid argument
%

The problem seems to be that commit f9399814927a ("bonding: Don't allow
bond devices to change network namespaces.") sets NETIF_F_NETNS_LOCAL
on bonding interfaces, and commit 797f87f83b60 ("macvlan: fix netdev
feature propagation from lower device") causes macvlan interfaces
to inherit its features from the lower device.

NETIF_F_NETNS_LOCAL should not be inherited from the lower device
by a macvlan.
Patch tested on 3.16.

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Acked-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index a430b99..0831e2f 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -710,6 +710,7 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 					     features,
 					     mask);
 	features |= ALWAYS_ON_FEATURES;
+	features &= ~NETIF_F_NETNS_LOCAL;
 
 	return features;
 }
-- 
1.9.1

