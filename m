Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaDRJnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:43:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45926 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbaDRJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Erik Hugne <erik.hugne@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 29/72] tipc: drop subscriber connection id invalidation
Date: Fri, 18 Apr 2014 11:22:02 +0200
Message-Id: <fa7a24eeb7d49ea81028b1ddb0921a6703fe1424.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erik Hugne <erik.hugne@ericsson.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit edcc0511b5ee7235282a688cd604e3ae7f9e1fc9 ]

When a topology server subscriber is disconnected, the associated
connection id is set to zero. A check vs zero is then done in the
subscription timeout function to see if the subscriber have been
shut down. This is unnecessary, because all subscription timers
will be cancelled when a subscriber terminates. Setting the
connection id to zero is actually harmful because id zero is the
identity of the topology server listening socket, and can cause a
race that leads to this socket being closed instead.

Signed-off-by: Erik Hugne <erik.hugne@ericsson.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Reviewed-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/tipc/subscr.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/net/tipc/subscr.c b/net/tipc/subscr.c
index 13f48bb5e540..78bdf1db4cdf 100644
--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -149,14 +149,6 @@ static void subscr_timeout(struct tipc_subscription *sub)
 	/* The spin lock per subscriber is used to protect its members */
 	spin_lock_bh(&subscriber->lock);
 
-	/* Validate if the connection related to the subscriber is
-	 * closed (in case subscriber is terminating)
-	 */
-	if (subscriber->conid == 0) {
-		spin_unlock_bh(&subscriber->lock);
-		return;
-	}
-
 	/* Validate timeout (in case subscription is being cancelled) */
 	if (sub->timeout == TIPC_WAIT_FOREVER) {
 		spin_unlock_bh(&subscriber->lock);
@@ -211,9 +203,6 @@ static void subscr_release(struct tipc_subscriber *subscriber)
 
 	spin_lock_bh(&subscriber->lock);
 
-	/* Invalidate subscriber reference */
-	subscriber->conid = 0;
-
 	/* Destroy any existing subscriptions for subscriber */
 	list_for_each_entry_safe(sub, sub_temp, &subscriber->subscription_list,
 				 subscription_list) {
-- 
1.9.2

