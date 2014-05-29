Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbaE2FLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:11:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932712AbaE2Efr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@open-mesh.com>,
        Simon Wunderlich <simon@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <antonio@meshcoding.com>
Subject: [PATCH 3.14 123/140] batman-adv: fix removing neigh_ifinfo
Date: Wed, 28 May 2014 21:34:22 -0700
Message-Id: <20140529043105.241412897@linuxfoundation.org>
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

[ Upstream commit 709de13f0c532fe9c468c094aff069a725ed57fe ]

When an interface is removed separately, all neighbors need to be
checked if they have a neigh_ifinfo structure for that particular
interface. If that is the case, remove that ifinfo so any references to
a hard interface can be freed.

This is a regression introduced by
89652331c00f43574515059ecbf262d26d885717
("batman-adv: split tq information in neigh_node struct")

Reported-by: Antonio Quartulli <antonio@open-mesh.com>
Signed-off-by: Simon Wunderlich <simon@open-mesh.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/originator.c |   46 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -702,6 +702,47 @@ free_orig_node:
 }
 
 /**
+ * batadv_purge_neigh_ifinfo - purge obsolete ifinfo entries from neighbor
+ * @bat_priv: the bat priv with all the soft interface information
+ * @neigh: orig node which is to be checked
+ */
+static void
+batadv_purge_neigh_ifinfo(struct batadv_priv *bat_priv,
+			  struct batadv_neigh_node *neigh)
+{
+	struct batadv_neigh_ifinfo *neigh_ifinfo;
+	struct batadv_hard_iface *if_outgoing;
+	struct hlist_node *node_tmp;
+
+	spin_lock_bh(&neigh->ifinfo_lock);
+
+	/* for all ifinfo objects for this neighinator */
+	hlist_for_each_entry_safe(neigh_ifinfo, node_tmp,
+				  &neigh->ifinfo_list, list) {
+		if_outgoing = neigh_ifinfo->if_outgoing;
+
+		/* always keep the default interface */
+		if (if_outgoing == BATADV_IF_DEFAULT)
+			continue;
+
+		/* don't purge if the interface is not (going) down */
+		if ((if_outgoing->if_status != BATADV_IF_INACTIVE) &&
+		    (if_outgoing->if_status != BATADV_IF_NOT_IN_USE) &&
+		    (if_outgoing->if_status != BATADV_IF_TO_BE_REMOVED))
+			continue;
+
+		batadv_dbg(BATADV_DBG_BATMAN, bat_priv,
+			   "neighbor/ifinfo purge: neighbor %pM, iface: %s\n",
+			   neigh->addr, if_outgoing->net_dev->name);
+
+		hlist_del_rcu(&neigh_ifinfo->list);
+		batadv_neigh_ifinfo_free_ref(neigh_ifinfo);
+	}
+
+	spin_unlock_bh(&neigh->ifinfo_lock);
+}
+
+/**
  * batadv_purge_orig_ifinfo - purge obsolete ifinfo entries from originator
  * @bat_priv: the bat priv with all the soft interface information
  * @orig_node: orig node which is to be checked
@@ -800,6 +841,11 @@ batadv_purge_orig_neighbors(struct batad
 
 			hlist_del_rcu(&neigh_node->list);
 			batadv_neigh_node_free_ref(neigh_node);
+		} else {
+			/* only necessary if not the whole neighbor is to be
+			 * deleted, but some interface has been removed.
+			 */
+			batadv_purge_neigh_ifinfo(bat_priv, neigh_node);
 		}
 	}
 


