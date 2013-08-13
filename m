Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab3HMQEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:04:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2053 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab3HMP6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:34 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=-i_txRWmc2oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=WDc3ZbYgOXQA:10 a=J1Y8HTJGAAAA:8 a=G3DJUDBH0Epfbv0sdJQA:9 a=qJl0yQZNg3oA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155827.844456604@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [27/88] team: move add to port list before port enablement
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0027-team-move-add-to-port-list-before-port-enablement.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/team/team.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8a11070..adeb533 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -945,8 +945,8 @@ static int team_port_add(struct team *team, struct net_device *port_dev)
 	}
 
 	port->index = -1;
-	team_port_enable(team, port);
 	list_add_tail_rcu(&port->list, &team->port_list);
+	team_port_enable(team, port);
 	__team_compute_features(team);
 	__team_port_change_port_added(port, !!netif_carrier_ok(port_dev));
 	__team_options_change_check(team);
-- 
1.7.10.4


