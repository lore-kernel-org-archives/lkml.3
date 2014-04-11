Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423185AbaDKQ6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:58:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422731AbaDKQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:08:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Erik Hugne <erik.hugne@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>, Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 07/65] tipc: drop subscriber connection id invalidation
Date: Fri, 11 Apr 2014 09:10:39 -0700
Message-Id: <20140411160958.742549342@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
References: <20140411160957.714773410@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Hugne <erik.hugne@ericsson.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/subscr.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/net/tipc/subscr.c
+++ b/net/tipc/subscr.c
@@ -149,14 +149,6 @@ static void subscr_timeout(struct tipc_s
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
@@ -211,9 +203,6 @@ static void subscr_release(struct tipc_s
 
 	spin_lock_bh(&subscriber->lock);
 
-	/* Invalidate subscriber reference */
-	subscriber->conid = 0;
-
 	/* Destroy any existing subscriptions for subscriber */
 	list_for_each_entry_safe(sub, sub_temp, &subscriber->subscription_list,
 				 subscription_list) {


