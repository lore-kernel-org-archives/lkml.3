Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965195AbbA2ChR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:37:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46989 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965091AbbA2ChO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Cong Wang <cwang@twopensource.com>, Zefan Li <lizefan@huawei.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 015/139] macvlan: unregister net device when netdev_upper_dev_link() fails
Date: Wed, 28 Jan 2015 14:19:18 -0800
Message-Id: <1422483682-15393-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cwang@twopensource.com>

commit da37705cef30841616ed644ff33455bbc7374db0 upstream.

rtnl_newlink() doesn't unregister it for us on failure.

Cc: Patrick McHardy <kaber@trash.net>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Zefan Li <lizefan@huawei.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 0831e2f..b0ae4b2 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -899,14 +899,15 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 	dev->priv_flags |= IFF_MACVLAN;
 	err = netdev_upper_dev_link(lowerdev, dev);
 	if (err)
-		goto destroy_port;
-
+		goto unregister_netdev;
 
 	list_add_tail_rcu(&vlan->list, &port->vlans);
 	netif_stacked_transfer_operstate(lowerdev, dev);
 
 	return 0;
 
+unregister_netdev:
+	unregister_netdevice(dev);
 destroy_port:
 	port->count -= 1;
 	if (!port->count)
-- 
1.9.1

