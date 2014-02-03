Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaBCBR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 20:17:27 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:58502 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaBCBR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 20:17:26 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 2/4] w1: only send_error when there is an error
Date: Sun,  2 Feb 2014 19:15:01 -0600
Message-Id: <1391390104-31154-3-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391390104-31154-1-git-send-email-David@Fries.net>
References: <1391390104-31154-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 02 Feb 2014 19:15:22 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise there's an extra reply being sent out for each async
message.  Some commands such as W1_CMD_LIST_SLAVES will be identical
except one message has data and the other doesn't making it difficult
for a program to know if all the slaves just vanished or what happened.

Signed-off-by: David Fries <David@Fries.net>
---
 drivers/w1/w1_netlink.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index a02704a..a6962f5 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -423,9 +423,11 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 			err = w1_process_command_master(dev, &node->block->msg,
 				node->m, cmd);
 
-		w1_netlink_send_error(&node->block->msg, node->m, cmd,
-			node->block->portid, err);
-		err = 0;
+		if (err) {
+			w1_netlink_send_error(&node->block->msg, node->m, cmd,
+				node->block->portid, err);
+			err = 0;
+		}
 
 		cmd_data += cmd->len + sizeof(struct w1_netlink_cmd);
 		mlen -= cmd->len + sizeof(struct w1_netlink_cmd);
-- 
1.7.10.4

