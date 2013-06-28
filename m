Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3F1TGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:06:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41861 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab3F1S5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 086/105] team: move add to port list before port enablement
Date: Fri, 28 Jun 2013 11:51:48 -0700
Message-Id: <1372445527-24414-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit 72df935d985c1575ed44ad2c8c653b28147993fa ]

team_port_enable() adds port to port_hashlist. Reader sees port
in team_get_port_by_index_rcu() and returns it, but
team_get_first_port_txable_rcu() tries to go through port_list, where the
port is not inserted yet -> NULL pointer dereference.
Fix this by reordering port_list and port_hashlist insertion.
Panic is easily triggeable when txing packets and adding/removing port
in a loop.

Introduced by commit 3d249d4c "net: introduce ethernet teaming device"

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/team/team.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8efe47a..3c181ca 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1076,8 +1076,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev)
 	}
 
 	port->index = -1;
-	team_port_enable(team, port);
 	list_add_tail_rcu(&port->list, &team->port_list);
+	team_port_enable(team, port);
 	__team_compute_features(team);
 	__team_port_change_port_added(port, !!netif_carrier_ok(port_dev));
 	__team_options_change_check(team);
-- 
1.8.1.2

