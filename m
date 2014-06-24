Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaFXPwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:52:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207AbaFXPwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:52:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Flavio Leitner <fbl@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 14/52] team: fix mtu setting
Date: Tue, 24 Jun 2014 11:50:29 -0400
Message-Id: <20140624154714.361580796@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154713.428945460@linuxfoundation.org>
References: <20140624154713.428945460@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    7 ++++++-
 include/linux/if_team.h |    1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1542,6 +1542,7 @@ static int team_change_mtu(struct net_de
 	 * to traverse list in reverse under rcu_read_lock
 	 */
 	mutex_lock(&team->lock);
+	team->port_mtu_change_allowed = true;
 	list_for_each_entry(port, &team->port_list, list) {
 		err = dev_set_mtu(port->dev, new_mtu);
 		if (err) {
@@ -1550,6 +1551,7 @@ static int team_change_mtu(struct net_de
 			goto unwind;
 		}
 	}
+	team->port_mtu_change_allowed = false;
 	mutex_unlock(&team->lock);
 
 	dev->mtu = new_mtu;
@@ -1559,6 +1561,7 @@ static int team_change_mtu(struct net_de
 unwind:
 	list_for_each_entry_continue_reverse(port, &team->port_list, list)
 		dev_set_mtu(port->dev, dev->mtu);
+	team->port_mtu_change_allowed = false;
 	mutex_unlock(&team->lock);
 
 	return err;
@@ -2678,7 +2681,9 @@ static int team_device_event(struct noti
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
--- a/include/linux/if_team.h
+++ b/include/linux/if_team.h
@@ -193,6 +193,7 @@ struct team {
 	bool user_carrier_enabled;
 	bool queue_override_enabled;
 	struct list_head *qom_lists; /* array of queue override mapping lists */
+	bool port_mtu_change_allowed;
 	long mode_priv[TEAM_MODE_PRIV_LONGS];
 };
 


