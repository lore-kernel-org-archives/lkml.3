Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaHROhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:37:25 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53261 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbaHROhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:37:21 -0400
Date: Mon, 18 Aug 2014 17:37:05 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] drbd: Replace rcu_assign_pointer() with RCU_INIT_POINTER()
Message-ID: <20140818143705.GA13718@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of "rcu_assign_pointer()" is NULLing out the pointer.
According to RCU_INIT_POINTER()'s block comment:
"1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
it is better to use it instead of rcu_assign_pointer() because it has a
smaller overhead.

The following Coccinelle semantic patch was used:
@@
@@

- rcu_assign_pointer
+ RCU_INIT_POINTER
  (..., NULL)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/block/drbd/drbd_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index a5d8aae..73bc23f 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1563,7 +1563,7 @@ static int w_after_conn_state_ch(struct drbd_work *w, int unused)
 		old_conf = connection->net_conf;
 		connection->my_addr_len = 0;
 		connection->peer_addr_len = 0;
-		rcu_assign_pointer(connection->net_conf, NULL);
+		RCU_INIT_POINTER(connection->net_conf, NULL);
 		conn_free_crypto(connection);
 		mutex_unlock(&connection->resource->conf_update);
 
-- 
1.9.1

