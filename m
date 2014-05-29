Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbaE2FMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:12:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbaE2Efq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@open-mesh.com>,
        Simon Wunderlich <simon@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCH 3.14 121/140] batman-adv: fix neigh reference imbalance
Date: Wed, 28 May 2014 21:34:20 -0700
Message-Id: <20140529043105.106871191@linuxfoundation.org>
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

[ Upstream commit 000c8dff97311357535d64539e58990526e4de70 ]

When an interface is removed from batman-adv, the orig_ifinfo of a
orig_node may be removed without releasing the router first.
This will prevent the reference for the neighbor pointed at by the
orig_ifinfo->router to be released, and this leak may result in
reference leaks for the interface used by this neighbor. Fix that.

This is a regression introduced by
7351a4822d42827ba0110677c0cbad88a3d52585
("batman-adv: split out router from orig_node").

Reported-by: Antonio Quartulli <antonio@open-mesh.com>
Signed-off-by: Simon Wunderlich <simon@open-mesh.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -500,12 +500,17 @@ batadv_neigh_node_get(const struct batad
 static void batadv_orig_ifinfo_free_rcu(struct rcu_head *rcu)
 {
 	struct batadv_orig_ifinfo *orig_ifinfo;
+	struct batadv_neigh_node *router;
 
 	orig_ifinfo = container_of(rcu, struct batadv_orig_ifinfo, rcu);
 
 	if (orig_ifinfo->if_outgoing != BATADV_IF_DEFAULT)
 		batadv_hardif_free_ref_now(orig_ifinfo->if_outgoing);
 
+	/* this is the last reference to this object */
+	router = rcu_dereference_protected(orig_ifinfo->router, true);
+	if (router)
+		batadv_neigh_node_free_ref_now(router);
 	kfree(orig_ifinfo);
 }
 


