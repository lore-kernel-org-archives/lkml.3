Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbbAUOvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:51:00 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58361 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbbAUOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:50:52 -0500
Date: Wed, 21 Jan 2015 18:44:58 +0200
From: Lin Kassem <linsara1@gmail.com>
To: devel@driverdev.osuosl.org
Cc: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6656: fix Prefer ether_addr_copy() over memcpy()
 if the Ethernet addresses are __aligned(2)
Message-ID: <20150121164458.GA10302@lin-535U4C>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:
fix Prefer ether_addr_copy() over memcpy() 
if the Ethernet addresses are __aligned(2)

Pahole showed that the 2 structs are aligned to u16

struct ieee80211_hdr {
	__le16                     frame_control;        /*     0     2 */
	__le16                     duration_id;          /*     2     2 */
	u8                         addr1[6];             /*     4     6 */
	u8                         addr2[6];             /*    10     6 */
	u8                         addr3[6];             /*    16     6 */
	__le16                     seq_ctrl;             /*    22     2 */
	u8                         addr4[6];             /*    24     6 */

	/* size: 30, cachelines: 1, members: 7 */
	/* last cacheline: 30 bytes */
};

struct vnt_mic_hdr {
	u8                         id;                   /*     0     1 */
	u8                         tx_priority;          /*     1     1 */
	u8                         mic_addr2[6];         /*     2     6 */
	u8                         ccmp_pn[6];           /*     8     6 */
	__be16                     payload_len;          /*    14     2 */
	__be16                     hlen;                 /*    16     2 */
	__le16                     frame_control;        /*    18     2 */
	u8                         addr1[6];             /*    20     6 */
	u8                         addr2[6];             /*    26     6 */
	u8                         addr3[6];             /*    32     6 */
	__le16                     seq_ctrl;             /*    38     2 */
	u8                         addr4[6];             /*    40     6 */
	u16                        packing;              /*    46     2 */

	/* size: 48, cachelines: 1, members: 13 */
	/* last cacheline: 48 bytes */
};

Signed-off-by: Lin Kassem <linsara1@gmail.com>
---
 drivers/staging/vt6656/rxtx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index bb6a4d4..c202147 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -749,7 +749,7 @@ static void vnt_fill_txkey(struct vnt_usb_send_context *tx_context,
 		else
 			mic_hdr->hlen = cpu_to_be16(22);
 
-		memcpy(mic_hdr->addr1, hdr->addr1, ETH_ALEN);
+		ether_addr_copy(mic_hdr->addr1, hdr->addr1);
 		memcpy(mic_hdr->addr2, hdr->addr2, ETH_ALEN);
 		memcpy(mic_hdr->addr3, hdr->addr3, ETH_ALEN);
 
-- 
1.7.9.5

