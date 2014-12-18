Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaLRL3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:29:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:49033 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaLRL3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:29:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="500851137"
From: "Varlese, Marco" <marco.varlese@intel.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "Fastabend, John R" <john.r.fastabend@intel.com>,
        Thomas Graf <tgraf@suug.ch>, Jiri Pirko <jiri@resnulli.us>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "sfeldma@gmail.com" <sfeldma@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH net-next v2 1/1] net: Support for switch port
 configuration
Thread-Topic: [RFC PATCH net-next v2 1/1] net: Support for switch port
 configuration
Thread-Index: AdAaqPMciB9+ZS56Q6O2uHwvQZyp6A==
Date: Thu, 18 Dec 2014 11:29:28 +0000
Message-ID: <C4896FB061E7DE4AAC93031BDCA044B104AD7B82@IRSMSX108.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Varlese <marco.varlese@intel.com>

Switch hardware offers a list of attributes that are configurable
on a per port basis.
This patch provides a mechanism to configure switch ports by adding
an NDO for setting specific values to specific attributes.
There will be a separate patch that adds the "get" functionality via
another NDO and another patch that extends iproute2 to call the two
new NDOs.

Signed-off-by: Marco Varlese <marco.varlese@intel.com>
---
 include/linux/netdevice.h    |  5 ++++
 include/uapi/linux/if_link.h | 15 ++++++++++++
 net/core/rtnetlink.c         | 54 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 74 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c31f74d..4881c7b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1027,6 +1027,9 @@ typedef u16 (*select_queue_fallback_t)(struct net_device *dev,
  * int (*ndo_switch_port_stp_update)(struct net_device *dev, u8 state);
  *	Called to notify switch device port of bridge port STP
  *	state change.
+ * int (*ndo_switch_port_set_cfg)(struct net_device *dev,
+ *                                u32 attr, u64 value);
+ *	Called to set specific switch ports attributes.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1185,6 +1188,8 @@ struct net_device_ops {
 							    struct netdev_phys_item_id *psid);
 	int			(*ndo_switch_port_stp_update)(struct net_device *dev,
 							      u8 state);
+	int			(*ndo_switch_port_set_cfg)(struct net_device *dev,
+							   u32 attr, u64 value);
 #endif
 };
 
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index f7d0d2d..19cb51a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -146,6 +146,7 @@ enum {
 	IFLA_PHYS_PORT_ID,
 	IFLA_CARRIER_CHANGES,
 	IFLA_PHYS_SWITCH_ID,
+	IFLA_SWITCH_PORT_CFG,
 	__IFLA_MAX
 };
 
@@ -603,4 +604,18 @@ enum {
 
 #define IFLA_HSR_MAX (__IFLA_HSR_MAX - 1)
 
+/* Switch Port Attributes section */
+
+enum {
+	IFLA_ATTR_UNSPEC,
+	IFLA_ATTR_LEARNING,
+	IFLA_ATTR_LOOPBACK,
+	IFLA_ATTR_BCAST_FLOODING,
+	IFLA_ATTR_UCAST_FLOODING,
+	IFLA_ATTR_MCAST_FLOODING,
+	__IFLA_ATTR_MAX
+};
+
+#define IFLA_ATTR_MAX (__IFLA_ATTR_MAX - 1)
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index eaa057f..c0d1c45 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1389,6 +1389,46 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[])
 	return 0;
 }
 
+#ifdef CONFIG_NET_SWITCHDEV
+static int do_setswcfg(struct net_device *dev, struct nlattr *attr)
+{
+	int rem, err = -EINVAL;
+	struct nlattr *v;
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	nla_for_each_nested(v, attr, rem) {
+		u32 op = nla_type(v);
+		u64 value = 0;
+
+		switch (op) {
+		case IFLA_ATTR_LEARNING:
+		case IFLA_ATTR_LOOPBACK:
+		case IFLA_ATTR_BCAST_FLOODING:
+		case IFLA_ATTR_UCAST_FLOODING:
+		case IFLA_ATTR_MCAST_FLOODING: {
+			if (nla_len(v) < sizeof(value)) {
+				err = -EINVAL;
+				break;
+			}
+
+			value = nla_get_u64(v);
+			err = ops->ndo_switch_port_set_cfg(dev,
+							   op,
+							   value);
+			break;
+		}
+		default:
+			err = -EINVAL;
+			break;
+		}
+		if (err)
+			break;
+	}
+	return err;
+}
+
+#endif
+
 static int do_setvfinfo(struct net_device *dev, struct nlattr *attr)
 {
 	int rem, err = -EINVAL;
@@ -1740,6 +1780,20 @@ static int do_setlink(const struct sk_buff *skb,
 			status |= DO_SETLINK_NOTIFY;
 		}
 	}
+#ifdef CONFIG_NET_SWITCHDEV
+	if (tb[IFLA_SWITCH_PORT_CFG]) {
+		err = -EOPNOTSUPP;
+		if (!ops->ndo_switch_port_set_cfg)
+			goto errout;
+		if (!ops->ndo_switch_parent_id_get)
+			goto errout;
+		err = do_setswcfg(dev, tb[IFLA_SWITCH_PORT_CFG]);
+		if (err < 0)
+			goto errout;
+
+		status |= DO_SETLINK_NOTIFY;
+	}
+#endif
 	err = 0;
 
 errout:
-- 
1.8.5.3

