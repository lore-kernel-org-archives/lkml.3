Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3L2GxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 01:53:18 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:56779 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3L2GxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 01:53:02 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Dec 2013 01:53:00 EST
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Marcin Jurkowski <marcin1j@gmail.com>,
        Josh Boyer <jwboyer@gmail.com>,
        Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: [PATCH 01/14] w1: fix w1_send_slave dropping a slave id
Date: Sun, 29 Dec 2013 00:45:43 -0600
Message-Id: <1388299556-12669-2-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388299556-12669-1-git-send-email-David@Fries.net>
References: <1388299556-12669-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 29 Dec 2013 00:46:35 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous logic,
if (avail > 8) {
	store slave;
	return;
}
send data; clear;

The logic error is, if there isn't space send the buffer and clear,
but the slave wasn't added to the now empty buffer loosing that slave
id.  It also should have been "if (avail >= 8)" because when it is 8,
there is space.

Instead, if there isn't space send and clear the buffer, then there is
always space for the slave id.

Signed-off-by: David Fries <David@Fries.net>
Cc: stable@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1_netlink.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 40788c9..73705af 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -54,28 +54,29 @@ static void w1_send_slave(struct w1_master *dev, u64 rn)
 	struct w1_netlink_msg *hdr = (struct w1_netlink_msg *)(msg + 1);
 	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
 	int avail;
+	u64 *data;
 
 	/* update kernel slave list */
 	w1_slave_found(dev, rn);
 
 	avail = dev->priv_size - cmd->len;
 
-	if (avail > 8) {
-		u64 *data = (void *)(cmd + 1) + cmd->len;
+	if (avail < 8) {
+		msg->ack++;
+		cn_netlink_send(msg, 0, GFP_KERNEL);
 
-		*data = rn;
-		cmd->len += 8;
-		hdr->len += 8;
-		msg->len += 8;
-		return;
+		msg->len = sizeof(struct w1_netlink_msg) +
+			sizeof(struct w1_netlink_cmd);
+		hdr->len = sizeof(struct w1_netlink_cmd);
+		cmd->len = 0;
 	}
 
-	msg->ack++;
-	cn_netlink_send(msg, 0, GFP_KERNEL);
+	data = (void *)(cmd + 1) + cmd->len;
 
-	msg->len = sizeof(struct w1_netlink_msg) + sizeof(struct w1_netlink_cmd);
-	hdr->len = sizeof(struct w1_netlink_cmd);
-	cmd->len = 0;
+	*data = rn;
+	cmd->len += 8;
+	hdr->len += 8;
+	msg->len += 8;
 }
 
 static int w1_process_search_command(struct w1_master *dev, struct cn_msg *msg,
-- 
1.7.10.4

