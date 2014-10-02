Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbaJBNsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:48:20 -0400
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:57446 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbaJBNsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:48:14 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: davem@davemloft.net, ebiederm@xmission.com, stephen@networkplumber.org,
        akpm@linux-foundation.org, luto@amacapital.net, cwang@twopensource.com,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [RFC PATCH net-next v3 4/4] rtnl: allow to create device with IFLA_LINK_NETNSID set
Date: Thu,  2 Oct 2014 15:48:10 +0200
Message-Id: <1412257690-31253-5-git-send-email-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>
References: <542D5726.8070308@6wind.com>
 <1412257690-31253-1-git-send-email-nicolas.dichtel@6wind.com>
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
index 1b9329512496..57959a85ed2c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1211,6 +1211,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_NUM_RX_QUEUES]	= { .type = NLA_U32 },
 	[IFLA_PHYS_PORT_ID]	= { .type = NLA_BINARY, .len = MAX_PHYS_PORT_ID_LEN },
 	[IFLA_CARRIER_CHANGES]	= { .type = NLA_U32 },  /* ignored */
+	[IFLA_LINK_NETNSID]	= { .type = NLA_S32 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -1983,7 +1984,7 @@ replay:
 		struct nlattr *slave_attr[m_ops ? m_ops->slave_maxtype + 1 : 0];
 		struct nlattr **data = NULL;
 		struct nlattr **slave_data = NULL;
-		struct net *dest_net;
+		struct net *dest_net, *link_net = NULL;
 
 		if (ops) {
 			if (ops->maxtype && linkinfo[IFLA_INFO_DATA]) {
@@ -2089,7 +2090,18 @@ replay:
 		if (IS_ERR(dest_net))
 			return PTR_ERR(dest_net);
 
-		dev = rtnl_create_link(dest_net, ifname, name_assign_type, ops, tb);
+		if (tb[IFLA_LINK_NETNSID]) {
+			int id = nla_get_s32(tb[IFLA_LINK_NETNSID]);
+
+			link_net = get_net_ns_by_id(dest_net, id);
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
@@ -2117,9 +2129,16 @@ replay:
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
+			err = dev_change_net_namespace(dev, dest_net, ifname);
 out:
+		if (link_net)
+			put_net(link_net);
 		put_net(dest_net);
 		return err;
 	}
-- 
2.1.0

