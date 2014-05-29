Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbaE2RMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:12:48 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:56553 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724AbaE2RMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:12:46 -0400
From: Jim Baxter <jim_baxter@mentor.com>
To: Felipe Balbi <balbi@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>, <netdev@vger.kernel.org>
Subject: [PATCH v1 3/3] usb: gadget: NCM: Stop RX TCP Bursts getting dropped.
Date: Thu, 29 May 2014 18:12:23 +0100
Message-ID: <1401383543-10181-4-git-send-email-jim_baxter@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401383543-10181-1-git-send-email-jim_baxter@mentor.com>
References: <Jim Baxter <jim_baxter@mentor.com>
 <1401383543-10181-1-git-send-email-jim_baxter@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.76]
X-OriginalArrivalTime: 29 May 2014 17:12:45.0778 (UTC) FILETIME=[35911B20:01CF7B61]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a problem with dropped packets over 16k CDC-NCM
when the connection is being heavily used.

The issue was that the skb truesize for the unpacked NCM
packets was too high after they were cloned from the 16k
skb, this lead to the potential memory calculated by the
Kernel running out of memory earlier then it should.

Signed-off-by: Jim Baxter <jim_baxter@mentor.com>
---
 drivers/usb/gadget/f_ncm.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index 5452fb6..bcdc882 100644
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -1229,16 +1229,17 @@ static int ncm_unwrap_ntb(struct gether *port,
 			index2 = get_ncm(&tmp, opts->dgram_item_len);
 			dg_len2 = get_ncm(&tmp, opts->dgram_item_len);
 
-			skb2 = skb_clone(skb, GFP_ATOMIC);
+			/*
+			 * Copy the data into a new skb.
+			 * This ensures the truesize is correct
+			 */
+			skb2 = netdev_alloc_skb_ip_align(ncm->netdev,
+							 dg_len - crc_len);
 			if (skb2 == NULL)
 				goto err;
+			memcpy(skb_put(skb2, dg_len - crc_len),
+			       skb->data + index, dg_len - crc_len);
 
-			if (!skb_pull(skb2, index)) {
-				ret = -EOVERFLOW;
-				goto err;
-			}
-
-			skb_trim(skb2, dg_len - crc_len);
 			skb_queue_tail(list, skb2);
 
 			ndp_len -= 2 * (opts->dgram_item_len * 2);
-- 
1.7.9.5

