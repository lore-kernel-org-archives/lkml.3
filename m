Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbbA2JND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:13:03 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44932 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760627AbbA2JIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:08:36 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jiri Benc <jbenc@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 065/176] team: avoid possible underflow of count_pending value for notify_peers and mcast_rejoin
Date: Wed, 28 Jan 2015 15:28:15 +0100
Message-Id: <c18e1d2c062cf9909d10740f231c786bf7fab029.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/team/team.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 75864dfaa1c2..258f65ba733f 100644
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
2.2.2

