Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbaFQWpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:45:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53840 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965875AbaFQVrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:47:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 060/212] batman-adv: fix local TT check for outgoing arp requests in DAT
Date: Tue, 17 Jun 2014 14:42:34 -0700
Message-Id: <1403041506-13646-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <antonio@open-mesh.com>

[ Upstream commit cc2f33860cea0e48ebec096130bd0f7c4bf6e0bc ]

Change introduced by 88e48d7b3340ef07b108eb8a8b3813dd093cc7f7
("batman-adv: make DAT drop ARP requests targeting local clients")
implements a check that prevents DAT from using the caching
mechanism when the client that is supposed to provide a reply
to an arp request is local.

However change brought by be1db4f6615b5e6156c807ea8985171c215c2d57
("batman-adv: make the Distributed ARP Table vlan aware")
has not converted the above check into its vlan aware version
thus making it useless when the local client is behind a vlan.

Fix the behaviour by properly specifying the vlan when
checking for a client being local or not.

Reported-by: Simon Wunderlich <simon@open-mesh.com>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/batman-adv/distributed-arp-table.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index b316a4c..e086dab 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -941,8 +941,7 @@ bool batadv_dat_snoop_outgoing_arp_request(struct batadv_priv *bat_priv,
 		 * additional DAT answer may trigger kernel warnings about
 		 * a packet coming from the wrong port.
 		 */
-		if (batadv_is_my_client(bat_priv, dat_entry->mac_addr,
-					BATADV_NO_FLAGS)) {
+		if (batadv_is_my_client(bat_priv, dat_entry->mac_addr, vid)) {
 			ret = true;
 			goto out;
 		}
-- 
1.9.1

