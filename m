Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaJMC0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:26:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaJMC0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:26:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Francesco Ruggeri <fruggeri@arista.com>,
        Cong Wang <cwang@twopensource.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 19/37] net: allow macvlans to move to net namespace
Date: Mon, 13 Oct 2014 04:24:16 +0200
Message-Id: <20141013022401.098488323@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022400.286360067@linuxfoundation.org>
References: <20141013022400.286360067@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -709,6 +709,7 @@ static netdev_features_t macvlan_fix_fea
 					     features,
 					     mask);
 	features |= ALWAYS_ON_FEATURES;
+	features &= ~NETIF_F_NETNS_LOCAL;
 
 	return features;
 }


