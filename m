Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3HARl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:41:27 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:7992 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3HARkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:40:25 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 1/6] staging: ozwpan: Use kernel list function for managing interface list.
Date: Thu, 1 Aug 2013 18:40:00 +0100
Message-ID: <1375378806-17948-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Managing interface list, is easier if we use kernel list_* API
than managing it on our own.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozproto.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index ed22729..500800f 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -37,7 +37,7 @@
 struct oz_binding {
 	struct packet_type ptype;
 	char name[OZ_MAX_BINDING_LEN];
-	struct oz_binding *next;
+	struct list_head link;
 };
 
 /*------------------------------------------------------------------------------
@@ -45,7 +45,7 @@ struct oz_binding {
  */
 static DEFINE_SPINLOCK(g_polling_lock);
 static LIST_HEAD(g_pd_list);
-static struct oz_binding *g_binding ;
+static LIST_HEAD(g_binding);
 static DEFINE_SPINLOCK(g_binding_lock);
 static struct sk_buff_head g_rx_queue;
 static u8 g_session_id;
@@ -437,12 +437,13 @@ done:
  */
 void oz_protocol_term(void)
 {
+	struct oz_binding *b, *t;
+
 	/* Walk the list of bindings and remove each one.
 	 */
 	spin_lock_bh(&g_binding_lock);
-	while (g_binding) {
-		struct oz_binding *b = g_binding;
-		g_binding = b->next;
+	list_for_each_entry_safe(b, t, &g_binding, link) {
+		list_del(&b->link);
 		spin_unlock_bh(&g_binding_lock);
 		dev_remove_pack(&b->ptype);
 		if (b->ptype.dev)
@@ -660,8 +661,7 @@ void oz_binding_add(char *net_dev)
 		if (binding) {
 			dev_add_pack(&binding->ptype);
 			spin_lock_bh(&g_binding_lock);
-			binding->next = g_binding;
-			g_binding = binding;
+			list_add_tail(&binding->link, &g_binding);
 			spin_unlock_bh(&g_binding_lock);
 		}
 	}
@@ -710,28 +710,25 @@ static void pd_stop_all_for_device(struct net_device *net_dev)
 void oz_binding_remove(char *net_dev)
 {
 	struct oz_binding *binding;
-	struct oz_binding **link;
+	int found = 0;
+
 	oz_dbg(ON, "Removing binding: %s\n", net_dev);
 	spin_lock_bh(&g_binding_lock);
-	binding = g_binding;
-	link = &g_binding;
-	while (binding) {
+	list_for_each_entry(binding, &g_binding, link) {
 		if (compare_binding_name(binding->name, net_dev)) {
 			oz_dbg(ON, "Binding '%s' found\n", net_dev);
-			*link = binding->next;
+			found = 1;
 			break;
-		} else {
-			link = &binding;
-			binding = binding->next;
 		}
 	}
 	spin_unlock_bh(&g_binding_lock);
-	if (binding) {
+	if (found) {
 		dev_remove_pack(&binding->ptype);
 		if (binding->ptype.dev) {
 			dev_put(binding->ptype.dev);
 			pd_stop_all_for_device(binding->ptype.dev);
 		}
+		list_del(&binding->link);
 		kfree(binding);
 	}
 }
-- 
1.7.9.5

