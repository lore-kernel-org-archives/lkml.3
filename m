Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259AbbA2Chb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:37:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46993 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965198AbbA2ChU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:20 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Pirko <jiri@resnulli.us>, Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 012/139] team: avoid possible underflow of count_pending value for notify_peers and mcast_rejoin
Date: Wed, 28 Jan 2015 14:19:15 -0800
Message-Id: <1422483682-15393-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@resnulli.us>

[ Upstream commit b0d11b42785b70e19bc6a3122eead3f7969a7589 ]

This patch is fixing a race condition that may cause setting
count_pending to -1, which results in unwanted big bulk of arp messages
(in case of "notify peers").

Consider following scenario:

count_pending == 2
   CPU0                                           CPU1
					team_notify_peers_work
					  atomic_dec_and_test (dec count_pending to 1)
					  schedule_delayed_work
 team_notify_peers
   atomic_add (adding 1 to count_pending)
					team_notify_peers_work
					  atomic_dec_and_test (dec count_pending to 1)
					  schedule_delayed_work
					team_notify_peers_work
					  atomic_dec_and_test (dec count_pending to 0)
   schedule_delayed_work
					team_notify_peers_work
					  atomic_dec_and_test (dec count_pending to -1)

Fix this race by using atomic_dec_if_positive - that will prevent
count_pending running under 0.

Fixes: fc423ff00df3a1955441 ("team: add peer notification")
Fixes: 492b200efdd20b8fcfd  ("team: add support for sending multicast rejoins")
Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/team/team.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 2898c2a..b4a69a7 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -629,6 +629,7 @@ static int team_change_mode(struct team *team, const char *kind)
 static void team_notify_peers_work(struct work_struct *work)
 {
 	struct team *team;
+	int val;
 
 	team = container_of(work, struct team, notify_peers.dw.work);
 
@@ -636,9 +637,14 @@ static void team_notify_peers_work(struct work_struct *work)
 		schedule_delayed_work(&team->notify_peers.dw, 0);
 		return;
 	}
+	val = atomic_dec_if_positive(&team->notify_peers.count_pending);
+	if (val < 0) {
+		rtnl_unlock();
+		return;
+	}
 	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, team->dev);
 	rtnl_unlock();
-	if (!atomic_dec_and_test(&team->notify_peers.count_pending))
+	if (val)
 		schedule_delayed_work(&team->notify_peers.dw,
 				      msecs_to_jiffies(team->notify_peers.interval));
 }
@@ -669,6 +675,7 @@ static void team_notify_peers_fini(struct team *team)
 static void team_mcast_rejoin_work(struct work_struct *work)
 {
 	struct team *team;
+	int val;
 
 	team = container_of(work, struct team, mcast_rejoin.dw.work);
 
@@ -676,9 +683,14 @@ static void team_mcast_rejoin_work(struct work_struct *work)
 		schedule_delayed_work(&team->mcast_rejoin.dw, 0);
 		return;
 	}
+	val = atomic_dec_if_positive(&team->mcast_rejoin.count_pending);
+	if (val < 0) {
+		rtnl_unlock();
+		return;
+	}
 	call_netdevice_notifiers(NETDEV_RESEND_IGMP, team->dev);
 	rtnl_unlock();
-	if (!atomic_dec_and_test(&team->mcast_rejoin.count_pending))
+	if (val)
 		schedule_delayed_work(&team->mcast_rejoin.dw,
 				      msecs_to_jiffies(team->mcast_rejoin.interval));
 }
-- 
1.9.1

