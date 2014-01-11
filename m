Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaAKLAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 06:00:54 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43878 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbaAKLAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 06:00:51 -0500
From: Monam Agarwal <monamagarwal123@gmail.com>
To: gregkh@linuxfoundation.org, rashika.kheria@gmail.com,
        peter.p.waskiewicz.jr@intel.com, andreas.dilger@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        monamagarwal123@gmail.com
Subject: [PATCH v3 1/2] Staging: lustre: Refactor the function interval_erase_color() in /lustre/ldlm/interval_tree.c
Date: Sat, 11 Jan 2014 16:30:33 +0530
Message-Id: <1389438033-5928-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
References: <52c9bc8b.ca41420a.775b.ffff98ce@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function interval_erase_color() in lustre/ldlm/interval_tree.c is
too long and can be refactored. Most of the statements are same for if
and else conditions. I am passing a new variable n based on which the
differences are recognised.

This fixes the following checkpatch.pl warning in
lustre/ldlm/interval_tree.c
WARNING: line over 80 characters in the file

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---

Changes since version 1:
* Incorrect fixing
* Incorrect Signed-off-by line

Changes since version 2:
* Removed new line character

 drivers/staging/lustre/lustre/ldlm/interval_tree.c |  128 +++++++++++---------
 1 file changed, 69 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/interval_tree.c b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
index 1de1d8e..7c956de 100644
--- a/drivers/staging/lustre/lustre/ldlm/interval_tree.c
+++ b/drivers/staging/lustre/lustre/ldlm/interval_tree.c
@@ -404,75 +404,85 @@ static inline int node_is_black_or_0(struct interval_node *node)
 	return !node || node_is_black(node);
 }
 
+static int interval_set_color(struct interval_node *node,
+			      struct interval_node *parent,
+			      struct interval_node *root,
+			      int n)
+{
+	struct interval_node *tmp;
+	if (n == 0)
+		tmp = parent->in_right;
+	else
+		tmp = parent->in_left;
+	if (node_is_red(tmp)) {
+		tmp->in_color = INTERVAL_BLACK;
+		parent->in_color = INTERVAL_RED;
+		if (n == 0) {
+			__rotate_left(parent, root);
+			tmp = parent->in_right;
+		} else {
+			__rotate_right(parent, root);
+			tmp = parent->in_left;
+		}
+	}
+	if (node_is_black_or_0(tmp->in_left) &&
+	    node_is_black_or_0(tmp->in_right)) {
+		tmp->in_color = INTERVAL_RED;
+		node = parent;
+		parent = node->in_parent;
+	} else {
+		if (n == 0) {
+			if (node_is_black_or_0(tmp->in_right)) {
+				struct interval_node *o_left;
+				o_left = tmp->in_left;
+				if (o_left)
+					o_left->in_color = INTERVAL_BLACK;
+				tmp->in_color = INTERVAL_RED;
+				__rotate_right(tmp, root);
+				tmp = parent->in_right;
+			}
+			tmp->in_color = parent->in_color;
+			parent->in_color = INTERVAL_BLACK;
+			if (tmp->in_right)
+				tmp->in_right->in_color = INTERVAL_BLACK;
+			__rotate_left(parent, root);
+			node = *root;
+			return 1;
+		} else {
+			if (node_is_black_or_0(tmp->in_left)) {
+				struct interval_node *o_right;
+				o_right = tmp->in_right;
+				if (o_right)
+					o_right->in_color = INTERVAL_BLACK;
+				tmp->in_color = INTERVAL_RED;
+				__rotate_left(tmp, root);
+				tmp = parent->in_left;
+			}
+			tmp->in_color = parent->in_color;
+			parent->in_color = INTERVAL_BLACK;
+			if (tmp->in_left)
+				tmp->in_left->in_color = INTERVAL_BLACK;
+			__rotate_right(parent, root);
+			node = *root;
+			return 1;
+		}
+	}
+	return 0;
+}
+
 static void interval_erase_color(struct interval_node *node,
 				 struct interval_node *parent,
 				 struct interval_node **root)
 {
-	struct interval_node *tmp;
 
 	while (node_is_black_or_0(node) && node != *root) {
 		if (parent->in_left == node) {
-			tmp = parent->in_right;
-			if (node_is_red(tmp)) {
-				tmp->in_color = INTERVAL_BLACK;
-				parent->in_color = INTERVAL_RED;
-				__rotate_left(parent, root);
-				tmp = parent->in_right;
-			}
-			if (node_is_black_or_0(tmp->in_left) &&
-			    node_is_black_or_0(tmp->in_right)) {
-				tmp->in_color = INTERVAL_RED;
-				node = parent;
-				parent = node->in_parent;
-			} else {
-				if (node_is_black_or_0(tmp->in_right)) {
-					struct interval_node *o_left;
-					o_left = tmp->in_left;
-					if (o_left)
-						o_left->in_color = INTERVAL_BLACK;
-					tmp->in_color = INTERVAL_RED;
-					__rotate_right(tmp, root);
-					tmp = parent->in_right;
-				}
-				tmp->in_color = parent->in_color;
-				parent->in_color = INTERVAL_BLACK;
-				if (tmp->in_right)
-					tmp->in_right->in_color = INTERVAL_BLACK;
-				__rotate_left(parent, root);
-				node = *root;
+			if (interval_set_color(node, parent, root, 0))
 				break;
-			}
 		} else {
-			tmp = parent->in_left;
-			if (node_is_red(tmp)) {
-				tmp->in_color = INTERVAL_BLACK;
-				parent->in_color = INTERVAL_RED;
-				__rotate_right(parent, root);
-				tmp = parent->in_left;
-			}
-			if (node_is_black_or_0(tmp->in_left) &&
-			    node_is_black_or_0(tmp->in_right)) {
-				tmp->in_color = INTERVAL_RED;
-				node = parent;
-				parent = node->in_parent;
-			} else {
-				if (node_is_black_or_0(tmp->in_left)) {
-					struct interval_node *o_right;
-					o_right = tmp->in_right;
-					if (o_right)
-						o_right->in_color = INTERVAL_BLACK;
-					tmp->in_color = INTERVAL_RED;
-					__rotate_left(tmp, root);
-					tmp = parent->in_left;
-				}
-				tmp->in_color = parent->in_color;
-				parent->in_color = INTERVAL_BLACK;
-				if (tmp->in_left)
-					tmp->in_left->in_color = INTERVAL_BLACK;
-				__rotate_right(parent, root);
-				node = *root;
+
+			if (interval_set_color(node, parent, root, 1))
 				break;
-			}
 		}
 	}
 	if (node)
-- 
1.7.9.5

