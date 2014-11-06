Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaKFWoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59089 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaKFWoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:07 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Lawrence <joe.lawrence@stratus.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 025/162] team: avoid race condition in scheduling delayed work
Date: Thu,  6 Nov 2014 14:34:49 -0800
Message-Id: <1415313426-9622-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Lawrence <Joe.Lawrence@stratus.com>

[ Upstream commit 47549650abd13d873fd2e5fc218db19e21031074 ]

When team_notify_peers and team_mcast_rejoin are called, they both reset
their respective .count_pending atomic variable. Then when the actual
worker function is executed, the variable is atomically decremented.
This pattern introduces a potential race condition where the
.count_pending rolls over and the worker function keeps rescheduling
until .count_pending decrements to zero again:

THREAD 1                           THREAD 2

========                           ========
team_notify_peers(teamX)
  atomic_set count_pending = 1
  schedule_delayed_work
                                   team_notify_peers(teamX)
                                   atomic_set count_pending = 1
team_notify_peers_work
  atomic_dec_and_test
    count_pending = 0
  (return)
                                   schedule_delayed_work
                                   team_notify_peers_work
                                   atomic_dec_and_test
                                     count_pending = -1
                                   schedule_delayed_work
                                   (repeat until count_pending = 0)

Instead of assigning a new value to .count_pending, use atomic_add to
tack-on the additional desired worker function invocations.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Acked-by: Jiri Pirko <jiri@resnulli.us>
Fixes: fc423ff00df3a19554414ee ("team: add peer notification")
Fixes: 492b200efdd20b8fcfdac87 ("team: add support for sending multicast rejoins")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/team/team.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 99500d1..2898c2a 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -647,7 +647,7 @@ static void team_notify_peers(struct team *team)
 {
 	if (!team->notify_peers.count || !netif_running(team->dev))
 		return;
-	atomic_set(&team->notify_peers.count_pending, team->notify_peers.count);
+	atomic_add(team->notify_peers.count, &team->notify_peers.count_pending);
 	schedule_delayed_work(&team->notify_peers.dw, 0);
 }
 
@@ -687,7 +687,7 @@ static void team_mcast_rejoin(struct team *team)
 {
 	if (!team->mcast_rejoin.count || !netif_running(team->dev))
 		return;
-	atomic_set(&team->mcast_rejoin.count_pending, team->mcast_rejoin.count);
+	atomic_add(team->mcast_rejoin.count, &team->mcast_rejoin.count_pending);
 	schedule_delayed_work(&team->mcast_rejoin.dw, 0);
 }
 
-- 
1.9.1

