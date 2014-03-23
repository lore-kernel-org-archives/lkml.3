Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaCWB3K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 21:29:10 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:53169 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaCWB3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 21:29:08 -0400
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 1/3] w1: fix netlink refcnt leak on error path
Date: Sat, 22 Mar 2014 20:27:45 -0500
Message-Id: <1395538067-4029-2-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395538067-4029-1-git-send-email-David@Fries.net>
References: <1395538067-4029-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sat, 22 Mar 2014 20:29:02 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the message type is W1_MASTER_CMD or W1_SLAVE_CMD, then a reference
is taken when searching for the slave or master device.  If there
isn't any following data m->len (mlen is a copy) is 0 and packing up
the message for later execution is skipped leaving nothing to
decrement the reference counts.

Way back when, m->len was checked before the search that increments the
reference count, but W1_LIST_MASTERS has no additional data, the check
was moved in 9be62e0b2fadaf5ff causing this bug.

This change reorders to put the check before the reference count is
incremented avoiding the problem.

Signed-off-by: David Fries <David@Fries.net>
---
 drivers/w1/w1_netlink.c |   44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
index 5234964..a02704a 100644
--- a/drivers/w1/w1_netlink.c
+++ b/drivers/w1/w1_netlink.c
@@ -300,12 +300,6 @@ static int w1_process_command_root(struct cn_msg *msg,
 	struct w1_netlink_msg *w;
 	u32 *id;
 
-	if (mcmd->type != W1_LIST_MASTERS) {
-		printk(KERN_NOTICE "%s: msg: %x.%x, wrong type: %u, len: %u.\n",
-			__func__, msg->id.idx, msg->id.val, mcmd->type, mcmd->len);
-		return -EPROTO;
-	}
-
 	cn = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!cn)
 		return -ENOMEM;
@@ -441,6 +435,9 @@ static void w1_process_cb(struct w1_master *dev, struct w1_async_cmd *async_cmd)
 		w1_netlink_send_error(&node->block->msg, node->m, cmd,
 			node->block->portid, err);
 
+	/* ref taken in w1_search_slave or w1_search_master_id when building
+	 * the block
+	 */
 	if (sl)
 		w1_unref_slave(sl);
 	else
@@ -503,30 +500,42 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 
 	msg_len = msg->len;
 	while (msg_len && !err) {
-		struct w1_reg_num id;
-		u16 mlen = m->len;
 
 		dev = NULL;
 		sl = NULL;
 
-		memcpy(&id, m->id.id, sizeof(id));
-#if 0
-		printk("%s: %02x.%012llx.%02x: type=%02x, len=%u.\n",
-				__func__, id.family, (unsigned long long)id.id, id.crc, m->type, m->len);
-#endif
 		if (m->len + sizeof(struct w1_netlink_msg) > msg_len) {
 			err = -E2BIG;
 			break;
 		}
 
+		/* execute on this thread, no need to process later */
+		if (m->type == W1_LIST_MASTERS) {
+			err = w1_process_command_root(msg, m, nsp->portid);
+			goto out_cont;
+		}
+
+		/* All following message types require additional data,
+		 * check here before references are taken.
+		 */
+		if (!m->len) {
+			err = -EPROTO;
+			goto out_cont;
+		}
+
+		/* both search calls take reference counts */
 		if (m->type == W1_MASTER_CMD) {
 			dev = w1_search_master_id(m->id.mst.id);
 		} else if (m->type == W1_SLAVE_CMD) {
-			sl = w1_search_slave(&id);
+			sl = w1_search_slave((struct w1_reg_num *)m->id.id);
 			if (sl)
 				dev = sl->master;
 		} else {
-			err = w1_process_command_root(msg, m, nsp->portid);
+			printk(KERN_NOTICE
+				"%s: msg: %x.%x, wrong type: %u, len: %u.\n",
+				__func__, msg->id.idx, msg->id.val,
+				m->type, m->len);
+			err = -EPROTO;
 			goto out_cont;
 		}
 
@@ -536,8 +545,6 @@ static void w1_cn_callback(struct cn_msg *msg, struct netlink_skb_parms *nsp)
 		}
 
 		err = 0;
-		if (!mlen)
-			goto out_cont;
 
 		atomic_inc(&block->refcnt);
 		node->async.cb = w1_process_cb;
@@ -557,7 +564,8 @@ out_cont:
 		if (err)
 			w1_netlink_send_error(msg, m, NULL, nsp->portid, err);
 		msg_len -= sizeof(struct w1_netlink_msg) + m->len;
-		m = (struct w1_netlink_msg *)(((u8 *)m) + sizeof(struct w1_netlink_msg) + m->len);
+		m = (struct w1_netlink_msg *)(((u8 *)m) +
+			sizeof(struct w1_netlink_msg) + m->len);
 
 		/*
 		 * Let's allow requests for nonexisting devices.
-- 
1.7.10.4

