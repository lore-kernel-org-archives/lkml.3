Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbaFWIu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:50:59 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55550 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 098/111] team: fix mtu setting
Date: Mon, 23 Jun 2014 10:32:13 +0200
Message-Id: <14bf635b2a49a67862fbc3ea2db76a5cef3a8bba.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 9d0d68faea6962d62dd501cd6e71ce5cc8ed262b ]

Now it is not possible to set mtu to team device which has a port
enslaved to it. The reason is that when team_change_mtu() calls
dev_set_mtu() for port device, notificator for NETDEV_PRECHANGEMTU
event is called and team_device_event() returns NOTIFY_BAD forbidding
the change. So fix this by returning NOTIFY_DONE here in case team is
changing mtu in team_change_mtu().

Introduced-by: 3d249d4c "net: introduce ethernet teaming device"
Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Acked-by: Flavio Leitner <fbl@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/team/team.c | 7 ++++++-
 include/linux/if_team.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 6327df255404..5c245d1fc79c 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1725,6 +1725,7 @@ static int team_change_mtu(struct net_device *dev, int new_mtu)
 	 * to traverse list in reverse under rcu_read_lock
 	 */
 	mutex_lock(&team->lock);
+	team->port_mtu_change_allowed = true;
 	list_for_each_entry(port, &team->port_list, list) {
 		err = dev_set_mtu(port->dev, new_mtu);
 		if (err) {
@@ -1733,6 +1734,7 @@ static int team_change_mtu(struct net_device *dev, int new_mtu)
 			goto unwind;
 		}
 	}
+	team->port_mtu_change_allowed = false;
 	mutex_unlock(&team->lock);
 
 	dev->mtu = new_mtu;
@@ -1742,6 +1744,7 @@ static int team_change_mtu(struct net_device *dev, int new_mtu)
 unwind:
 	list_for_each_entry_continue_reverse(port, &team->port_list, list)
 		dev_set_mtu(port->dev, dev->mtu);
+	team->port_mtu_change_allowed = false;
 	mutex_unlock(&team->lock);
 
 	return err;
@@ -2861,7 +2864,9 @@ static int team_device_event(struct notifier_block *unused,
 		break;
 	case NETDEV_CHANGEMTU:
 		/* Forbid to change mtu of underlaying device */
-		return NOTIFY_BAD;
+		if (!port->team->port_mtu_change_allowed)
+			return NOTIFY_BAD;
+		break;
 	case NETDEV_PRE_TYPE_CHANGE:
 		/* Forbid to change type of underlaying device */
 		return NOTIFY_BAD;
diff --git a/include/linux/if_team.h b/include/linux/if_team.h
index a899dc24be15..a6aa970758a2 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -194,6 +194,7 @@ struct team {
 	bool user_carrier_enabled;
 	bool queue_override_enabled;
 	struct list_head *qom_lists; /* array of queue override mapping lists */
+	bool port_mtu_change_allowed;
 	struct {
 		unsigned int count;
 		unsigned int interval; /* in ms */
-- 
2.0.0

