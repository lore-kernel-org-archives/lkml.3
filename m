Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaJMCew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:34:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbaJMCaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joe Lawrence <joe.lawrence@stratus.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 03/25] team: avoid race condition in scheduling delayed work
Date: Mon, 13 Oct 2014 04:24:56 +0200
Message-Id: <20141013022454.429780782@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/team/team.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -647,7 +647,7 @@ static void team_notify_peers(struct tea
 {
 	if (!team->notify_peers.count || !netif_running(team->dev))
 		return;
-	atomic_set(&team->notify_peers.count_pending, team->notify_peers.count);
+	atomic_add(team->notify_peers.count, &team->notify_peers.count_pending);
 	schedule_delayed_work(&team->notify_peers.dw, 0);
 }
 
@@ -687,7 +687,7 @@ static void team_mcast_rejoin(struct tea
 {
 	if (!team->mcast_rejoin.count || !netif_running(team->dev))
 		return;
-	atomic_set(&team->mcast_rejoin.count_pending, team->mcast_rejoin.count);
+	atomic_add(team->mcast_rejoin.count, &team->mcast_rejoin.count_pending);
 	schedule_delayed_work(&team->mcast_rejoin.dw, 0);
 }
 


