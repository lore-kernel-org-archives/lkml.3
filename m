Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3HAKlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab3HAKlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:41:51 -0400
Date: Thu, 1 Aug 2013 13:43:19 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org
Subject: [PATCH] macvlan: better mode validation
Message-ID: <20130801104319.GA7127@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

macvlan passthrough mode is special: it's not possible to switch to or
from it through a netlink command.

But if you try, the command will succeed, which is
confusing.

Validate input and return error to user.

Cc:  Sridhar Samudrala <sri@us.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/macvlan.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 18373b6..13937f9 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -863,6 +863,18 @@ static int macvlan_changelink(struct net_device *dev,
 		struct nlattr *tb[], struct nlattr *data[])
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
+	enum macvlan_mode mode;
+	bool set_mode = false;
+
+	/* Validate mode, but don't set yet: setting flags may fail. */
+	if (data && data[IFLA_MACVLAN_MODE]) {
+		set_mode = true;
+		mode = nla_get_u32(data[IFLA_MACVLAN_MODE]);
+		/* Passthrough mode can't be set or cleared dynamically */
+		if ((mode == MACVLAN_MODE_PASSTHRU) !=
+		    (vlan->mode == MACVLAN_MODE_PASSTHRU))
+			return -EINVAL;
+	}
 
 	if (data && data[IFLA_MACVLAN_FLAGS]) {
 		__u16 flags = nla_get_u16(data[IFLA_MACVLAN_FLAGS]);
@@ -879,8 +891,8 @@ static int macvlan_changelink(struct net_device *dev,
 		}
 		vlan->flags = flags;
 	}
-	if (data && data[IFLA_MACVLAN_MODE])
-		vlan->mode = nla_get_u32(data[IFLA_MACVLAN_MODE]);
+	if (set_mode)
+		vlan->mode = mode;
 	return 0;
 }
 
-- 
MST
