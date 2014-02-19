Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaBSJ7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:59:12 -0500
Received: from mail09.linbit.com ([212.69.161.110]:43618 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaBSJ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:59:08 -0500
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 04:59:08 EST
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [PATCH] drbd: Fix future possible NULL pointer dereference
Date: Wed, 19 Feb 2014 10:49:07 +0100
Message-Id: <1392803347-6075-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392803347-6075-1-git-send-email-philipp.reisner@linbit.com>
References: <20140218202054.GD25515@kernel.dk>
 <1392803347-6075-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Right now every resource has exactly one connection. But we are preparing
for dynamic connections. I.e. in the future thre can be resources without
connections.

However smatch points this out as 'variable dereferenced before check',
which is correct.

This issue was introduced in
drbd: get_one_status(): Iterate over resource->devices instead of connection->peer_devices

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 2086b12..526414b 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2776,7 +2776,7 @@ static int nla_put_drbd_cfg_context(struct sk_buff *skb,
 	if (device &&
 	    nla_put_u32(skb, T_ctx_volume, device->vnr))
 		goto nla_put_failure;
-	if (nla_put_string(skb, T_ctx_resource_name, connection->resource->name))
+	if (nla_put_string(skb, T_ctx_resource_name, resource->name))
 		goto nla_put_failure;
 	if (connection) {
 		if (connection->my_addr_len &&
-- 
1.7.9.5

