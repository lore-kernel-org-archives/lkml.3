Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbaIWN0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:26:41 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:46047 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaIWN0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:26:39 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 09:26:39 EDT
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: davem@davemloft.net, ebiederm@xmission.com, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [RFC PATCH net-next v2 5/5] rtnl: allow to create device with IFLA_LINK_NETNSID set
Date: Tue, 23 Sep 2014 15:20:30 +0200
Message-Id: <1411478430-4989-6-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the ability to create a netdevice in a specified netns and
then move it into the final netns. In fact, it allows to have a symetry between
get and set rtnl messages.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/rtnetlink.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 99ed83c62685..34b894ae79b4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1220,6 +1220,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_NUM_RX_QUEUES]	= { .type = NLA_U32 },
 	[IFLA_PHYS_PORT_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_PORT_ID_LEN },
 	[IFLA_CARRIER_CHANGES]	= { .type = NLA_U32 },  /* ignored */
+	[IFLA_LINK_NETNSID]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -1992,7 +1993,7 @@ replay:
 		struct nlattr *slave_attr[m_ops ? m_ops->slave_maxtype + 1 : 0];
 		struct nlattr **data = NULL;
 		struct nlattr **slave_data = NULL;
-		struct net *dest_net;
+		struct net *dest_net, *link_net = NULL;
 
 		if (ops) {
 			if (ops->maxtype && linkinfo[IFLA_INFO_DATA]) {
@@ -2098,7 +2099,18 @@ replay:
 		if (IS_ERR(dest_net))
 			return PTR_ERR(dest_net);
 
-		dev = rtnl_create_link(dest_net, ifname, name_assign_type, ops, tb);
+		if (tb[IFLA_LINK_NETNSID]) {
+			int id = nla_get_u32(tb[IFLA_LINK_NETNSID]);
+
+			link_net = get_net_from_netnsid(dest_net, id);
+			if (link_net == NULL) {
+				err =  -EINVAL;
+				goto out;
+			}
+		}
+
+		dev = rtnl_create_link(link_net ? : dest_net, ifname,
+				       name_assign_type, ops, tb);
 		if (IS_ERR(dev)) {
 			err = PTR_ERR(dev);
 			goto out;
@@ -2126,9 +2138,16 @@ replay:
 			}
 		}
 		err = rtnl_configure_link(dev, ifm);
-		if (err < 0)
+		if (err < 0) {
 			unregister_netdevice(dev);
+			goto out;
+		}
+
+		if (link_net)
+			err = dev_change_net_namespace(dev, net, ifname);
 out:
+		if (link_net)
+			put_net(link_net);
 		put_net(dest_net);
 		return err;
 	}
-- 
2.1.0

