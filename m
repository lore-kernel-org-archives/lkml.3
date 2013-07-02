Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3GBLIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36294 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab3GBLI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 33/50] team: move add to port list before port enablement
Date: Tue,  2 Jul 2013 12:07:21 +0100
Message-Id: <1372763258-20664-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

commit 72df935d985c1575ed44ad2c8c653b28147993fa upstream.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/team/team.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index c61ae35..acd3ec3 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -817,8 +817,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev)
 	}
 
 	port->index = -1;
-	team_port_enable(team, port);
 	list_add_tail_rcu(&port->list, &team->port_list);
+	team_port_enable(team, port);
 	team_adjust_ops(team);
 	__team_compute_features(team);
 	__team_port_change_check(port, !!netif_carrier_ok(port_dev));
-- 
1.8.1.2

