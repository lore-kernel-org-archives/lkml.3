Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030543AbaGCJoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:44:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030252AbaGCJYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 141/198] team: fix mtu setting
Date: Thu,  3 Jul 2014 10:19:44 +0100
Message-Id: <1404379241-8590-142-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

commit 9d0d68faea6962d62dd501cd6e71ce5cc8ed262b upstream.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/team/team.c | 7 ++++++-
 include/linux/if_team.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8aa35403ca5e..ffa1a399e871 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1562,6 +1562,7 @@ static int team_change_mtu(struct net_device *dev, int new_mtu)
 	 * to traverse list in reverse under rcu_read_lock
 	 */
 	mutex_lock(&team->lock);
+	team->port_mtu_change_allowed = true;
 	list_for_each_entry(port, &team->port_list, list) {
 		err = dev_set_mtu(port->dev, new_mtu);
 		if (err) {
@@ -1570,6 +1571,7 @@ static int team_change_mtu(struct net_device *dev, int new_mtu)
 			goto unwind;
 		}
 	}
+	team->port_mtu_change_allowed = false;
 	mutex_unlock(&team->lock);
 
 	dev->mtu = new_mtu;
@@ -1579,6 +1581,7 @@ static int team_change_mtu(struct net_device *dev, int new_mtu)
 unwind:
 	list_for_each_entry_continue_reverse(port, &team->port_list, list)
 		dev_set_mtu(port->dev, dev->mtu);
+	team->port_mtu_change_allowed = false;
 	mutex_unlock(&team->lock);
 
 	return err;
@@ -2698,7 +2701,9 @@ static int team_device_event(struct notifier_block *unused,
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
index f6156f91eb1c..9023bc1c3a6b 100644
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -194,6 +194,7 @@ struct team {
 	bool user_carrier_enabled;
 	bool queue_override_enabled;
 	struct list_head *qom_lists; /* array of queue override mapping lists */
+	bool port_mtu_change_allowed;
 	long mode_priv[TEAM_MODE_PRIV_LONGS];
 };
 
-- 
1.9.1

