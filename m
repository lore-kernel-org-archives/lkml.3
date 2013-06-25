Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3FYTAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:00:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3FYSeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>
Subject: [ 70/95] team: move add to port list before port enablement
Date: Tue, 25 Jun 2013 11:32:57 -0700
Message-Id: <20130625182201.495456651@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1079,8 +1079,8 @@ static int team_port_add(struct team *te
 	}
 
 	port->index = -1;
-	team_port_enable(team, port);
 	list_add_tail_rcu(&port->list, &team->port_list);
+	team_port_enable(team, port);
 	__team_compute_features(team);
 	__team_port_change_port_added(port, !!netif_carrier_ok(port_dev));
 	__team_options_change_check(team);


