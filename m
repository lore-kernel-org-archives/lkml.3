Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbaDRJjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:39:51 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45957 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dingtianhong <dingtianhong@huawei.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 43/72] bonding: set correct vlan id for alb xmit path
Date: Fri, 18 Apr 2014 11:22:16 +0200
Message-Id: <3f6f4a798fddeb5702de262e708ff7bddadb67fd.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: dingtianhong <dingtianhong@huawei.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit fb00bc2e6cd2046282ba4b03f4fe682aee70b2f8 ]

The commit d3ab3ffd1d728d7ee77340e7e7e2c7cfe6a4013e
(bonding: use rlb_client_info->vlan_id instead of ->tag)
remove the rlb_client_info->tag, but occur some issues,
The vlan_get_tag() will return 0 for success and -EINVAL for
error, so the client_info->vlan_id always be set to 0 if the
vlan_get_tag return 0 for success, so the client_info would
never get a correct vlan id.

We should only set the vlan id to 0 when the vlan_get_tag return error.

Fixes: d3ab3ffd1d7 (bonding: use rlb_client_info->vlan_id instead of ->tag)

CC: Ding Tianhong <dingtianhong@huawei.com>
CC: Jay Vosburgh <fubar@us.ibm.com>
CC: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Acked-by: Veaceslav Falico <vfalico@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/bonding/bond_alb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index f428ef574372..71adb692e457 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -694,7 +694,7 @@ static struct slave *rlb_choose_channel(struct sk_buff *skb, struct bonding *bon
 			client_info->ntt = 0;
 		}
 
-		if (!vlan_get_tag(skb, &client_info->vlan_id))
+		if (vlan_get_tag(skb, &client_info->vlan_id))
 			client_info->vlan_id = 0;
 
 		if (!client_info->assigned) {
-- 
1.9.2

