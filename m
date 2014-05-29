Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933994AbaE2FLo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:11:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703AbaE2Efq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Wunderlich <simon@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCH 3.14 122/140] batman-adv: always run purge_orig_neighbors
Date: Wed, 28 May 2014 21:34:21 -0700
Message-Id: <20140529043105.169706456@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Wunderlich <simon@open-mesh.com>

[ Upstream commit 7b955a9fc164487d7c51acb9787f6d1b01b35ef6 ]

The current code will not execute batadv_purge_orig_neighbors() when an
orig_ifinfo has already been purged. However we need to run it in any
case. Fix that.

This is a regression introduced by
7351a4822d42827ba0110677c0cbad88a3d52585
("batman-adv: split out router from orig_node")

Signed-off-by: Simon Wunderlich <simon@open-mesh.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -857,7 +857,7 @@ static bool batadv_purge_orig_node(struc
 {
 	struct batadv_neigh_node *best_neigh_node;
 	struct batadv_hard_iface *hard_iface;
-	bool changed;
+	bool changed_ifinfo, changed_neigh;
 
 	if (batadv_has_timed_out(orig_node->last_seen,
 				 2 * BATADV_PURGE_TIMEOUT)) {
@@ -867,10 +867,10 @@ static bool batadv_purge_orig_node(struc
 			   jiffies_to_msecs(orig_node->last_seen));
 		return true;
 	}
-	changed = batadv_purge_orig_ifinfo(bat_priv, orig_node);
-	changed = changed || batadv_purge_orig_neighbors(bat_priv, orig_node);
+	changed_ifinfo = batadv_purge_orig_ifinfo(bat_priv, orig_node);
+	changed_neigh = batadv_purge_orig_neighbors(bat_priv, orig_node);
 
-	if (!changed)
+	if (!changed_ifinfo && !changed_neigh)
 		return false;
 
 	/* first for NULL ... */


