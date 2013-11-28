Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab3K1EcB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 23:32:01 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:54731 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758871Ab3K1Eb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 23:31:59 -0500
Message-ID: <5296C7C1.3090408@gmail.com>
Date: Thu, 28 Nov 2013 12:34:09 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: floe@butterbrot.org, rydberg@euromail.se,
        David Herrmann <dh.herrmann@gmail.com>, rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH v2] drivers: input: touchscreen: sur40: remove stack variable
 'packet_id' from sur40_poll()
References: <528AD6B3.1060507@gmail.com> <20131125011908.GA18921@codeaurora.org> <529555C5.7030404@gmail.com> <20131128040741.GD15452@core.coreip.homeip.net>
In-Reply-To: <20131128040741.GD15452@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers process all blobs in one pass, so there is no need to
preserve value of packet_id between calls to sur40_poll().

And the original implementation may cause 'packet_id' uninitialized,
the related warning (with allmodconfig under hexagon):

  drivers/input/touchscreen/sur40.c: In function 'sur40_poll':
  drivers/input/touchscreen/sur40.c:297:6: warning: 'packet_id' may be used uninitialized in this function [-Wuninitialized]


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 drivers/input/touchscreen/sur40.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index cfd1b7e..2ca32cb 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -251,7 +251,6 @@ static void sur40_poll(struct input_polled_dev *polldev)
 	struct sur40_state *sur40 = polldev->private;
 	struct input_dev *input = polldev->input;
 	int result, bulk_read, need_blobs, packet_blobs, i;
-	u32 packet_id;
 
 	struct sur40_header *header = &sur40->bulk_in_buffer->header;
 	struct sur40_blob *inblob = &sur40->bulk_in_buffer->blobs[0];
@@ -286,17 +285,8 @@ static void sur40_poll(struct input_polled_dev *polldev)
 		if (need_blobs == -1) {
 			need_blobs = le16_to_cpu(header->count);
 			dev_dbg(sur40->dev, "need %d blobs\n", need_blobs);
-			packet_id = header->packet_id;
 		}
 
-		/*
-		 * Sanity check. when video data is also being retrieved, the
-		 * packet ID will usually increase in the middle of a series
-		 * instead of at the end.
-		 */
-		if (packet_id != header->packet_id)
-			dev_warn(sur40->dev, "packet ID mismatch\n");
-
 		packet_blobs = result / sizeof(struct sur40_blob);
 		dev_dbg(sur40->dev, "received %d blobs\n", packet_blobs);
 
-- 
1.7.7.6
