Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaEBQ3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:29:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaEBPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Fries <David@Fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 006/151] w1: fix w1_send_slave dropping a slave id
Date: Fri,  2 May 2014 08:36:34 -0700
Message-Id: <1399045139-4531-7-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Fries <David@Fries.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/w1/w1_netlink.c | 25 +++++++++++++------------
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
1.9.1

