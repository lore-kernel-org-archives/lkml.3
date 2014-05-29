Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbaE2FFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:05:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58197 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932776AbaE2Ef7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Wunderlich <simon@open-mesh.com>,
        Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.14 135/140] batman-adv: fix local TT check for outgoing arp requests in DAT
Date: Wed, 28 May 2014 21:34:34 -0700
Message-Id: <20140529043106.721764222@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -940,8 +940,7 @@ bool batadv_dat_snoop_outgoing_arp_reque
 		 * additional DAT answer may trigger kernel warnings about
 		 * a packet coming from the wrong port.
 		 */
-		if (batadv_is_my_client(bat_priv, dat_entry->mac_addr,
-					BATADV_NO_FLAGS)) {
+		if (batadv_is_my_client(bat_priv, dat_entry->mac_addr, vid)) {
 			ret = true;
 			goto out;
 		}


