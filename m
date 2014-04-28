Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbaD1Bak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43065 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752851AbaD1B3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:23 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Evgeniy Polyakov" <zbr@ioremap.net>,
        "David Fries" <David@Fries.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.869801152@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 23/94] w1: fix w1_send_slave dropping a slave id
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/w1/w1_netlink.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -54,28 +54,29 @@ static void w1_send_slave(struct w1_mast
 	struct w1_netlink_msg *hdr = (struct w1_netlink_msg *)(msg + 1);
 	struct w1_netlink_cmd *cmd = (struct w1_netlink_cmd *)(hdr + 1);
 	int avail;
+	u64 *data;
 
 	/* update kernel slave list */
 	w1_slave_found(dev, rn);
 
 	avail = dev->priv_size - cmd->len;
 
-	if (avail > 8) {
-		u64 *data = (void *)(cmd + 1) + cmd->len;
-
-		*data = rn;
-		cmd->len += 8;
-		hdr->len += 8;
-		msg->len += 8;
-		return;
+	if (avail < 8) {
+		msg->ack++;
+		cn_netlink_send(msg, 0, GFP_KERNEL);
+
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

