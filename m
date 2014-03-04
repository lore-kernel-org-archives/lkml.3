Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbaCDUDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:03:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbaCDUDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antonio Quartulli <antonio@meshcoding.com>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.13 071/172] batman-adv: avoid double free when orig_node initialization fails
Date: Tue,  4 Mar 2014 12:02:35 -0800
Message-Id: <20140304200302.010111461@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@meshcoding.com>

[ Upstream commit a5a5cb8cab526af2f6cbe9715f8ca843192f0d81 ]

In the failure path of the orig_node initialization routine
the orig_node->bat_iv.bcast_own field is free'd twice: first
in batadv_iv_ogm_orig_get() and then later in
batadv_orig_node_free_rcu().

Fix it by removing the kfree in batadv_iv_ogm_orig_get().

Signed-off-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -243,18 +243,16 @@ batadv_iv_ogm_orig_get(struct batadv_pri
 	size = bat_priv->num_ifaces * sizeof(uint8_t);
 	orig_node->bat_iv.bcast_own_sum = kzalloc(size, GFP_ATOMIC);
 	if (!orig_node->bat_iv.bcast_own_sum)
-		goto free_bcast_own;
+		goto free_orig_node;
 
 	hash_added = batadv_hash_add(bat_priv->orig_hash, batadv_compare_orig,
 				     batadv_choose_orig, orig_node,
 				     &orig_node->hash_entry);
 	if (hash_added != 0)
-		goto free_bcast_own;
+		goto free_orig_node;
 
 	return orig_node;
 
-free_bcast_own:
-	kfree(orig_node->bat_iv.bcast_own);
 free_orig_node:
 	/* free twice, as batadv_orig_node_new sets refcount to 2 */
 	batadv_orig_node_free_ref(orig_node);


