Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180AbaEMJ3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:29:44 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60920 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759403AbaEMJ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:29:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Fries <David@Fries.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 045/182] w1: fix w1_send_slave dropping a slave id
Date: Tue, 13 May 2014 11:26:37 +0200
Message-Id: <191b13ad86ff0b0dc55199a65167ee0b5669fc78.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <David@Fries.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6b355b33a64fd6d8ead2b838ec16fb9b551f71e8 upstream.

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
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/w1/w1_netlink.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 40788c925d1c..73705aff53cb 100644
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
1.9.3

