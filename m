Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaCDVU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:20:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbaCDUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:03:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russel Senior <russell@personaltelco.net>,
        Antonio Quartulli <antonio@open-mesh.com>,
        Marek Lindner <mareklindner@neomailbox.ch>
Subject: [PATCH 3.13 069/172] batman-adv: fix TT CRC computation by ensuring byte order
Date: Tue,  4 Mar 2014 12:02:33 -0800
Message-Id: <20140304200301.951360567@linuxfoundation.org>
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

From: Antonio Quartulli <antonio@open-mesh.com>

[ Upstream commit a30e22ca8464c2dc573e0144a972221c2f06c2cd ]

When computing the CRC on a 2byte variable the order of
the bytes obviously alters the final result. This means
that computing the CRC over the same value on two archs
having different endianess leads to different numbers.

The global and local translation table CRC computation
routine makes this mistake while processing the clients
VIDs. The result is a continuous CRC mismatching between
nodes having different endianess.

Fix this by converting the VID to Network Order before
processing it. This guarantees that every node uses the same
byte order.

Introduced by 7ea7b4a142758deaf46c1af0ca9ceca6dd55138b
("batman-adv: make the TT CRC logic VLAN specific")

Reported-by: Russel Senior <russell@personaltelco.net>
Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
Tested-by: Russell Senior <russell@personaltelco.net>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1961,6 +1961,7 @@ static uint32_t batadv_tt_global_crc(str
 	struct hlist_head *head;
 	uint32_t i, crc_tmp, crc = 0;
 	uint8_t flags;
+	__be16 tmp_vid;
 
 	for (i = 0; i < hash->size; i++) {
 		head = &hash->table[i];
@@ -1997,8 +1998,11 @@ static uint32_t batadv_tt_global_crc(str
 							     orig_node))
 				continue;
 
-			crc_tmp = crc32c(0, &tt_common->vid,
-					 sizeof(tt_common->vid));
+			/* use network order to read the VID: this ensures that
+			 * every node reads the bytes in the same order.
+			 */
+			tmp_vid = htons(tt_common->vid);
+			crc_tmp = crc32c(0, &tmp_vid, sizeof(tmp_vid));
 
 			/* compute the CRC on flags that have to be kept in sync
 			 * among nodes
@@ -2032,6 +2036,7 @@ static uint32_t batadv_tt_local_crc(stru
 	struct hlist_head *head;
 	uint32_t i, crc_tmp, crc = 0;
 	uint8_t flags;
+	__be16 tmp_vid;
 
 	for (i = 0; i < hash->size; i++) {
 		head = &hash->table[i];
@@ -2050,8 +2055,11 @@ static uint32_t batadv_tt_local_crc(stru
 			if (tt_common->flags & BATADV_TT_CLIENT_NEW)
 				continue;
 
-			crc_tmp = crc32c(0, &tt_common->vid,
-					 sizeof(tt_common->vid));
+			/* use network order to read the VID: this ensures that
+			 * every node reads the bytes in the same order.
+			 */
+			tmp_vid = htons(tt_common->vid);
+			crc_tmp = crc32c(0, &tmp_vid, sizeof(tmp_vid));
 
 			/* compute the CRC on flags that have to be kept in sync
 			 * among nodes


