Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaBTUrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:47:37 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:59142 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaBTUok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:44:40 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Geoff Levand <geoff@infradead.org>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH 2/9] ps3-vuart: don't use PREPARE_WORK
Date: Thu, 20 Feb 2014 15:44:24 -0500
Message-Id: <1392929071-16555-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392929071-16555-1-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
and a nasty surprise in terms of reentrancy guarantee as workqueue
considers work items to be different if they don't have the same work
function.

ps3_vuart wasn't overriding the work item with multiple work functions
but was using NULL for INIT_WORK() and then single PREPARE_WORK() to
set the work function.  We can simply invoke INIT_WORK() with the work
function and remove the PREPARE_WORK() usage.

Not tested at all.

It would probably be best to route this with other related updates
through the workqueue tree.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: cbe-oss-dev@lists.ozlabs.org
---
 drivers/ps3/ps3-vuart.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ps3/ps3-vuart.c b/drivers/ps3/ps3-vuart.c
index fb73008..bc1e513 100644
--- a/drivers/ps3/ps3-vuart.c
+++ b/drivers/ps3/ps3-vuart.c
@@ -699,8 +699,6 @@ int ps3_vuart_read_async(struct ps3_system_bus_device *dev, unsigned int bytes)
 
 	BUG_ON(!bytes);
 
-	PREPARE_WORK(&priv->rx_list.work.work, ps3_vuart_work);
-
 	spin_lock_irqsave(&priv->rx_list.lock, flags);
 	if (priv->rx_list.bytes_held >= bytes) {
 		dev_dbg(&dev->core, "%s:%d: schedule_work %xh bytes\n",
@@ -1052,7 +1050,7 @@ static int ps3_vuart_probe(struct ps3_system_bus_device *dev)
 	INIT_LIST_HEAD(&priv->rx_list.head);
 	spin_lock_init(&priv->rx_list.lock);
 
-	INIT_WORK(&priv->rx_list.work.work, NULL);
+	INIT_WORK(&priv->rx_list.work.work, ps3_vuart_work);
 	priv->rx_list.work.trigger = 0;
 	priv->rx_list.work.dev = dev;
 
-- 
1.8.5.3

