Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbaFCLuw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:50:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaFCLmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 114/138] bridge: Handle IFLA_ADDRESS correctly when creating bridge device
Date: Tue,  3 Jun 2014 12:39:20 +0100
Message-Id: <1401795584-22664-115-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

commit 30313a3d5794472c3548d7288e306a5492030370 upstream.

When bridge device is created with IFLA_ADDRESS, we are not calling
br_stp_change_bridge_id(), which leads to incorrect local fdb
management and bridge id calculation, and prevents us from receiving
frames on the bridge device.

Reported-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/bridge/br_netlink.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index e74ddc1c29a8..e7be21fb434f 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -446,6 +446,20 @@ static int br_validate(struct nlattr *tb[], struct nlattr *data[])
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
 static size_t br_get_link_af_size(const struct net_device *dev)
 {
 	struct net_port_vlans *pv;
@@ -474,6 +488,7 @@ struct rtnl_link_ops br_link_ops __read_mostly = {
 	.priv_size	= sizeof(struct net_bridge),
 	.setup		= br_dev_setup,
 	.validate	= br_validate,
+	.newlink	= br_dev_newlink,
 	.dellink	= br_dev_delete,
 };
 
-- 
1.9.1

