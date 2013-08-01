Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab3HARlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:41:03 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:47386 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010Ab3HARk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:40:28 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 4/6] staging: ozwpan: Drop oldest ISOC frame instead of dropping latest.
Date: Thu, 1 Aug 2013 18:40:03 +0100
Message-ID: <1375378806-17948-5-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of ISOC transfer, if TX queue is full then we start
dropping latest frame, instead we should drop oldest frame &
add latest frame to TX queue.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozpd.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 86876bd..17fd7b2 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -844,9 +844,20 @@ int oz_send_isoc_unit(struct oz_pd *pd, u8 ep_num, const u8 *data, int len)
 			struct oz_tx_frame *isoc_unit = NULL;
 			int nb = pd->nb_queued_isoc_frames;
 			if (nb >= pd->isoc_latency) {
+				struct list_head *e;
+				struct oz_tx_frame *f;
 				oz_dbg(TX_FRAMES, "Dropping ISOC Unit nb= %d\n",
 				       nb);
-				goto out;
+				spin_lock(&pd->tx_frame_lock);
+				list_for_each(e, &pd->tx_queue) {
+					f = container_of(e, struct oz_tx_frame,
+									link);
+					if (f->skb != NULL) {
+						oz_tx_isoc_free(pd, f);
+						break;
+					}
+				}
+				spin_unlock(&pd->tx_frame_lock);
 			}
 			isoc_unit = oz_tx_frame_alloc(pd);
 			if (isoc_unit == NULL)
-- 
1.7.9.5

