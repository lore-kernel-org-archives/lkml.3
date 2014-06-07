Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaFGBh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:37:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36012 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tom Gundersen" <teg@jklm.no>,
        "David S. Miller" <davem@davemloft.net>,
        "Toshiaki Makita" <makita.toshiaki@lab.ntt.co.jp>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.805153570@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 16/92] bridge: Handle IFLA_ADDRESS correctly when
 creating  bridge device
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

[ Upstream commit 30313a3d5794472c3548d7288e306a5492030370 ]

When bridge device is created with IFLA_ADDRESS, we are not calling
br_stp_change_bridge_id(), which leads to incorrect local fdb
management and bridge id calculation, and prevents us from receiving
frames on the bridge device.

Reported-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/bridge/br_netlink.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index cbf9ccd..99a48a3 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -211,11 +211,26 @@ static int br_validate(struct nlattr *tb[], struct nlattr *data[])
 	return 0;
 }
 
+static int br_dev_newlink(struct net *src_net, struct net_device *dev,
+			  struct nlattr *tb[], struct nlattr *data[])
+{
+	struct net_bridge *br = netdev_priv(dev);
+
+	if (tb[IFLA_ADDRESS]) {
+		spin_lock_bh(&br->lock);
+		br_stp_change_bridge_id(br, nla_data(tb[IFLA_ADDRESS]));
+		spin_unlock_bh(&br->lock);
+	}
+
+	return register_netdevice(dev);
+}
+
 struct rtnl_link_ops br_link_ops __read_mostly = {
 	.kind		= "bridge",
 	.priv_size	= sizeof(struct net_bridge),
 	.setup		= br_dev_setup,
 	.validate	= br_validate,
+	.newlink	= br_dev_newlink,
 	.dellink	= br_dev_delete,
 };
 

