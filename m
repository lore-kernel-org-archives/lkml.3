Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaCWB3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 21:29:33 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:53172 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaCWB3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 21:29:31 -0400
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH 2/3] connector: allow multiple messages to be sent in one packet
Date: Sat, 22 Mar 2014 20:27:46 -0500
Message-Id: <1395538067-4029-3-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1395538067-4029-1-git-send-email-David@Fries.net>
References: <1395538067-4029-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sat, 22 Mar 2014 20:29:27 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This increases the amount of bundling to reduce the number of packets
sent.  For the one wire use there can be multiple struct
w1_netlink_cmd in a struct w1_netlink_msg and multiple of those in
struct cn_msg, and with this change multiple of those in a struct
nlmsghdr, and at each level the len identifies there being multiple of
the next.

Signed-off-by: David Fries <David@Fries.net>
---
 Documentation/connector/connector.txt |   13 ++++++++++---
 drivers/connector/connector.c         |   17 +++++++++++++++--
 include/linux/connector.h             |    1 +
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/Documentation/connector/connector.txt b/Documentation/connector/connector.txt
index e5c5f5e..e56abdb 100644
--- a/Documentation/connector/connector.txt
+++ b/Documentation/connector/connector.txt
@@ -24,7 +24,8 @@ netlink based networking for inter-process communication in a significantly
 easier way:
 
 int cn_add_callback(struct cb_id *id, char *name, void (*callback) (struct cn_msg *, struct netlink_skb_parms *));
-void cn_netlink_send(struct cn_msg *msg, u32 __group, int gfp_mask);
+void cn_netlink_send_multi(struct cn_msg *msg, u16 len, u32 portid, u32 __group, int gfp_mask);
+void cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group, int gfp_mask);
 
 struct cb_id
 {
@@ -71,15 +72,21 @@ void cn_del_callback(struct cb_id *id);
  struct cb_id *id		- unique connector's user identifier.
 
 
-int cn_netlink_send(struct cn_msg *msg, u32 __groups, int gfp_mask);
+int cn_netlink_send_multi(struct cn_msg *msg, u16 len, u32 portid, u32 __groups, int gfp_mask);
+int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __groups, int gfp_mask);
 
  Sends message to the specified groups.  It can be safely called from
  softirq context, but may silently fail under strong memory pressure.
  If there are no listeners for given group -ESRCH can be returned.
 
  struct cn_msg *		- message header(with attached data).
+ u16 len			- for *_multi multiple cn_msg messages can be sent
+ u32 port			- destination port.
+ 				  If non-zero the message will be sent to the
+				  given port, which should be set to the
+				  original sender.
  u32 __group			- destination group.
-				  If __group is zero, then appropriate group will
+				  If port and __group is zero, then appropriate group will
 				  be searched through all registered connector users,
 				  and message will be delivered to the group which was
 				  created for user with the same ID as in msg.
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 77afe74..f4b0cdb 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -43,6 +43,8 @@ static struct cn_dev cdev;
 static int cn_already_initialized;
 
 /*
+ * Sends mult (multiple) cn_msg at a time.
+ *
  * msg->seq and msg->ack are used to determine message genealogy.
  * When someone sends message it puts there locally unique sequence
  * and random acknowledge numbers.  Sequence number may be copied into
@@ -62,10 +64,13 @@ static int cn_already_initialized;
  * the acknowledgement number in the original message + 1, then it is
  * a new message.
  *
+ * If msg->len != len, then additional cn_msg messages are expected following
+ * the first msg.
+ *
  * The message is sent to, the portid if given, the group if given, both if
  * both, or if both are zero then the group is looked up and sent there.
  */
-int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,
+int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 __group,
 	gfp_t gfp_mask)
 {
 	struct cn_callback_entry *__cbq;
@@ -98,7 +103,7 @@ int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,
 	if (!portid && !netlink_has_listeners(dev->nls, group))
 		return -ESRCH;
 
-	size = sizeof(*msg) + msg->len;
+	size = sizeof(*msg) + len;
 
 	skb = nlmsg_new(size, gfp_mask);
 	if (!skb)
@@ -121,6 +126,14 @@ int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,
 					 gfp_mask);
 	return netlink_unicast(dev->nls, skb, portid, !(gfp_mask&__GFP_WAIT));
 }
+EXPORT_SYMBOL_GPL(cn_netlink_send_mult);
+
+/* same as cn_netlink_send_mult except msg->len is used for len */
+int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,
+	gfp_t gfp_mask)
+{
+	return cn_netlink_send_mult(msg, msg->len, portid, __group, gfp_mask);
+}
 EXPORT_SYMBOL_GPL(cn_netlink_send);
 
 /*
diff --git a/include/linux/connector.h b/include/linux/connector.h
index be9c4747..f8fe863 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -71,6 +71,7 @@ struct cn_dev {
 int cn_add_callback(struct cb_id *id, const char *name,
 		    void (*callback)(struct cn_msg *, struct netlink_skb_parms *));
 void cn_del_callback(struct cb_id *);
+int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 group, gfp_t gfp_mask);
 int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 group, gfp_t gfp_mask);
 
 int cn_queue_add_callback(struct cn_queue_dev *dev, const char *name,
-- 
1.7.10.4

