Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533AbaE2FPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:15:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbaE2Efi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>,
        Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 091/140] bridge: Handle IFLA_ADDRESS correctly when creating bridge device
Date: Wed, 28 May 2014 21:33:50 -0700
Message-Id: <20140529043101.331750494@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_netlink.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -445,6 +445,20 @@ static int br_validate(struct nlattr *tb
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
@@ -473,6 +487,7 @@ struct rtnl_link_ops br_link_ops __read_
 	.priv_size	= sizeof(struct net_bridge),
 	.setup		= br_dev_setup,
 	.validate	= br_validate,
+	.newlink	= br_dev_newlink,
 	.dellink	= br_dev_delete,
 };
 


